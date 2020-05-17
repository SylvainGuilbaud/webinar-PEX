using Amazon.S3;
using Amazon.S3.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;

namespace PEX.AWS
{
    class S3InboundAdapter : InterSystems.EnsLib.PEX.InboundAdapter
    {
        // awsAccessKeyId & awsSecretAccessKey: the User credentials for the AWS operation
        public string awsAccessKeyId;
        public string awsSecretAccessKey;

        // A Region for the Connection. This is Required
        public string awsRegion;

        // A Default Buycket for the S3 Operations.
        public string awsBucket;

        //a Local Processing+Archiving Directory for the files
        public string archivePath;

        private Amazon.S3.AmazonS3Client s3Client;
        /// <summary>
        /// 
        /// </summary>
        public override void OnInit()
        {
            Amazon.RegionEndpoint region = null;
            if (awsAccessKeyId == null) { LOGERROR("Missing Parameter awsAccessLeyId is required"); }
            if (awsSecretAccessKey == null) { LOGERROR("Missing Parameter awsSecretAccessKey is required"); }
            if (awsBucket == null) { LOGERROR("Missing Parameter awsBucket is required"); }

            if (awsRegion == null)
            {
                LOGERROR("Missing Parameter awsRegion is required");
            }
            else
            {
                region = Amazon.RegionEndpoint.GetBySystemName(awsRegion);
                if (region == null)
                {
                    LOGERROR("awsRegion '" + awsRegion + "' not recognized");
                }
            }
            if (archivePath ==null) { LOGERROR("Missing Parameter archivePath is required"); }

            LOGINFO("Creating AWS S3 Client with given credentials");
            s3Client = new AmazonS3Client(awsAccessKeyId, awsSecretAccessKey, region);
        }
        /// <summary>
        /// The Adapter.OnTask() gets called by the framework every CallInterval.
        /// It finds all the corresponding Objects in the S3 bucket (with a maxCount of MaxKeys per pass)
        /// and Copies each file locally before calling the "OnProcessInput" of the Business Service
        /// </summary>
       
        public override void OnTask()
        {
            LOGINFO("OnTask, awsBucket=" + awsBucket);
            ListObjectsAsync().Wait();
        }

        /// <summary>
        /// https://docs.aws.amazon.com/AmazonS3/latest/dev/ListingObjectKeysUsingNetSDK.html
        /// </summary>
        /// <returns></returns>
        async Task ListObjectsAsync()
        {
            //List Objects in the Bucket
            ListObjectsV2Request listRequest = new ListObjectsV2Request
            {
                BucketName = awsBucket,
                MaxKeys = 3
                
            };
            /// Can also limit Searches with Prefix = searchKeyPrefix
            ///MaxKeys=3 for testing
            
            ListObjectsV2Response listResponse;
            do
            {
                LOGINFO("OnTask, ListObjectsV2Async: "+listRequest.ToString());
                listResponse = await s3Client.ListObjectsV2Async(listRequest);

                //Process the response
                foreach (S3Object entry in listResponse.S3Objects)
                {
                    LOGINFO("Processing Object Key=" + entry.Key + ", Size=" + entry.Size);
                    var fileName = archivePath + "\\" + entry.Key;
                    ReadObjectDataAsync(entry.Key,fileName).Wait();
                    
                    //Send the local Filename to the Business Service
                    BusinessHost.ProcessInput(fileName);

                    //Now delete the Entry in S3
                    DeleteObjectNonVersionedBucketAsync(entry.Key).Wait();

                } 
            } while (listResponse.IsTruncated);
        }
        /// <summary>
        /// https://docs.aws.amazon.com/AmazonS3/latest/dev/RetrievingObjectUsingNetSDK.html
        /// </summary>
        /// <returns></returns>
        async Task ReadObjectDataAsync(string keyName,string fileName)
        {
            string responseBody = "";
            GetObjectRequest request = new GetObjectRequest
            {
                BucketName = awsBucket,
                Key = keyName
            };
            using (GetObjectResponse response = await s3Client.GetObjectAsync(request))
            using (Stream responseStream = response.ResponseStream) {
                var fileStream = File.Create(fileName);
                //responseStream.Seek(0, SeekOrigin.Begin);
                responseStream.CopyTo(fileStream);
                fileStream.Close();
            }
        }
        /// <summary>
        /// https://docs.aws.amazon.com/AmazonS3/latest/dev/DeletingOneObjectUsingNetSDK.html
        /// </summary>
        /// <param name="keyName"></param>
        /// <returns></returns>
        async Task DeleteObjectNonVersionedBucketAsync(string keyName)
        {
            var deleteObjectRequest = new DeleteObjectRequest
            {
                BucketName = awsBucket,
                    Key = keyName
            };
            LOGINFO("Deleting S3 Object, Key="+keyName);
            await s3Client.DeleteObjectAsync(deleteObjectRequest);
        }


    }
}
