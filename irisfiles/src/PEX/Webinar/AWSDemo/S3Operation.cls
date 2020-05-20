/// Operacion que se conecta a AWS S3
Class PEX.Webinar.AWSDemo.S3Operation Extends Ens.BusinessOperation [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.PEX.OutboundAdapter";

Property Adapter As EnsLib.PEX.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// Puts the text as text/plain object in S3 and returns the HttpStatus code as System.Net.HttpStatusCode
Method PutText(pRequest As PEX.Webinar.AWSDemo.S3PutTextReq, Output pResponse As Ens.StringResponse) As %Status
{

	#DIM tSC as %Status=$$$OK
	#DIM errObj as %Exception.AbstractException
	try {
		set tHttpResponseCode=..Adapter.PutText(pRequest.ObjectName,pRequest.Data)
		set pResponse=##class(Ens.StringResponse).%New()
		set pResponse.StringValue=tHttpResponseCode
	}catch (errObj) {
		set tSC=errObj.AsStatus()
	}
	quit tSC
}

/// Oututs the Stream to S3
Method PutStream(pRequest As Ens.StreamContainer, Output pResponse As Ens.StringResponse) As %Status
{

	#DIM tSC as %Status=$$$OK
	#DIM errObj as %Exception.AbstractException
	#DIM tNameIn,tFileName,tHttpResponseCode
	try {
		///Get the Original Filename, and use it as Key on AWS S3
		Set tNameIn=##class(%File).GetFilename(pRequest.OriginalFilename)
		//Save it to a temporary FileStream to use from the .NET code
		If ( pRequest.Stream.%Extends("%Library.GlobalStreamAdaptor")||
		     pRequest.Stream.%Extends("%Stream.GlobalCharacter")
		   )
		   {
			#; copy to a global stream in a new container
			Set tStream=##class(%FileBinaryStream).%New()
			Merge tStream.Attributes=pRequest.Stream.Attributes
			Set tSC=tStream.CopyFrom(pRequest.Stream)
			$$$THROWONERROR(tSC,tStream.SaveStream())
			set tFileName=tStream.Filename
		} Else {
			set tFileName=pRequest.OriginalFilename
			
		}
		$$$TRACE("Calling PutStream with key="+tNameIn+", filename="+tFileName)
		
		///Use MultiParts Upload for files >5MB as per AWS Recomendations
		
		if (pRequest.Stream.Size>5*1204*1024){
			do ..Adapter.PutStreamMultiParts(tNameIn,tFileName)
			set tHttpResponseCode="OK" 
		}else {
			set tHttpResponseCode=..Adapter.PutStream(tNameIn,tFileName)
		}
		
		set pResponse=##class(Ens.StringResponse).%New()
		set pResponse.StringValue=tHttpResponseCode
	}catch (errObj) {
		set tSC=errObj.AsStatus()
	}
	quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="PEX.Webinar.AWSDemo.S3PutTextReq"> 
		<Method>PutText</Method>
	</MapItem>
	<MapItem MessageType="Ens.StreamContainer"> 
		<Method>PutStream</Method>
	</MapItem>
	
</MapItems>
}

}
