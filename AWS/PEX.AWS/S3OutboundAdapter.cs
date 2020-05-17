using System;
using Amazon.Runtime;
using Amazon.S3;
using Amazon.S3.Model;
using System.Threading.Tasks;
using System.Globalization;
using Amazon.S3.Model.Internal.MarshallTransformations;
using Amazon.S3.Transfer;

namespace PEX.AWS
{
    public class S3OutboundAdapter: InterSystems.EnsLib.PEX.OutboundAdapter
    {
        // awsAccessKeyId & awsSecretAccessKey: the User credentials for the AWS operation
        public string awsAccessKeyId;
        public string awsSecretAccessKey;

        // A Region for the Connection. This is Required
        public string awsRegion;
        
        // A Default Bucket for the S3 Operations.
        public string awsBucket;

        private Amazon.S3.AmazonS3Client s3Client;

        /// <summary>
        /// Called when this Adapter is Started. 
        /// Used to Setup the Connection to AWS S3
        /// </summary>
        public override void OnInit()
        {
            Amazon.RegionEndpoint region=null;
           if (awsAccessKeyId==null) { LOGERROR("Missing Parameter awsAccessLeyId is required"); }
           if (awsSecretAccessKey==null) { LOGERROR("Missing Parameter awsSecretAccessKey is required"); }
           if (awsBucket == null) { LOGERROR("Missing Parameter awsBucket is required"); }

           if (awsRegion == null) 
           { 
                LOGERROR("Missing Parameter awsRegion is required"); 
           }else {
                region = Amazon.RegionEndpoint.GetBySystemName(awsRegion);
                if (region==null)
                {
                    LOGERROR("awsRegion '" + awsRegion + "' not recognized");
                }
           }
           LOGINFO("Creating AWS S3 Client with given credentials");
           s3Client = new AmazonS3Client(awsAccessKeyId, awsSecretAccessKey,region);
        }

        /// <summary>
        /// Allows to upload a Text Object to a S3 Bucket. Object Size is limited to IRIS string size. 
        /// https://docs.aws.amazon.com/AmazonS3/latest/dev/UploadingObjects.html
        /// </summary>
        /// <param name="key">The Object name in S3</param>
        /// <param name="content">The String to upload as the Object Content</param>
        /// <returns></returns>
        public string PutText(string key, string content)
        {
            LOGINFO("PutText, key=" + key);
            var putRequest = new Amazon.S3.Model.PutObjectRequest
            {
                BucketName = awsBucket,
                Key = key,
                ContentBody = content
            };

            
            var putResponse = s3Client.PutObjectAsync(putRequest).Result;
            return putResponse.HttpStatusCode.ToString();
        }
        /// <summary>
        /// Uploads a fileStream to S3. This shoudl be used for files smaller than 5MB
        /// For files graeate than 5MB, AWS recommends using Multiparts upload
        /// </summary>
        /// <param name="key"></param>
        /// <param name="filename"></param>
        /// <returns></returns>
        public string PutStream(string key, string filename)
        {
         
            LOGINFO("PutStream, key=" + key);
           
            var putRequest = new Amazon.S3.Model.PutObjectRequest
            {
                BucketName = awsBucket,
                Key = key,
                FilePath = filename,
                ContentType="text/plain"
            };

            // public virtual Task<PutObjectResponse> PutObjectAsync(PutObjectRequest request, CancellationToken cancellationToken = default);
            var putResponse = s3Client.PutObjectAsync(putRequest).Result;
            return putResponse.HttpStatusCode.ToString();

        }
        /// <summary>
        /// https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingTheMPDotNetAPI.html#TestingDotNetApiSamples
        /// </summary>
        /// <param name="key"></param>
        /// <param name="filename"></param>
        public void PutStreamMultiParts(string key, string filename)
        {
            var fileTransferUtility = new TransferUtility(s3Client);

            // Option 2. Specify object key name explicitly.
            fileTransferUtility.UploadAsync(filename, awsBucket, key).Wait();
            //Does not return a Status
                 
        }
    }
}
