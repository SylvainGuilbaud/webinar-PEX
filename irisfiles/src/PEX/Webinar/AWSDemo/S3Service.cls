/// A Busines Service that reads and processes files from S3
/// This is a Simplified Version of Enslib.File.PassthroughService and EnsLib.File.InboundAdapter to handle files in S3
/// Note: this adapter deletes the files from S3 after processing them
Class PEX.Webinar.AWSDemo.S3Service Extends Ens.BusinessService [ Language = objectscript ]
{

Parameter ADAPTER = "EnsLib.PEX.InboundAdapter";

/// Configuration item(s) to which to send file stream messages
Property TargetConfigNames As %String(MAXLEN = 1000);

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pFilename As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	
	$$$TRACE("Filename="_pFilename)
	//Get a Stream pointing to the filename. Just Binary here, but we could add options for CharacterStream and charsets selection
	set tStream=##class(%FileBinaryStream).%New()
	do tStream.LinkToFile(pFilename)
	Set tStream.Attributes("Filename")=pFilename
	
	//Build an IRIS Interoperability Message with the Stream
	set pInput=##class(Ens.StreamContainer).%New()	
	set pInput.Stream=tStream
	$$$SyncCommitSet(tSyncCommit)
	
	//And Send the message to all targets in the list of targetConfigname
	For iTarget=1:1:$L(..TargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
		$$$sysTRACE("Sending input Stream "_pInput.Stream_"("_pInput.Stream.Size_") Async to '"_tOneTarget_"'")
	
		#; Since we are archiving locally, we can send the file Async as there is no risk of deleting it before the target has processed it
		Set tSC1=..SendRequestAsync(tOneTarget,pInput)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)
	}
	quit $$$OK
}

/// Return an array of connections for drawing lines on the config diagram
/// Allows to correctly Display the Connections in the portal
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("TargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

}
