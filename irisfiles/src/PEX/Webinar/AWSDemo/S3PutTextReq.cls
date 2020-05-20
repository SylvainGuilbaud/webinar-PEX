/// Una Peticion para copia un fichero de texto a AWS
Class PEX.Webinar.AWSDemo.S3PutTextReq Extends Ens.Request [ Language = objectscript ]
{

/// S3 Key (Filename and Path)
Property ObjectName As %String;

/// The Data 
Property Data As %String(MAXLEN = "");

Storage Default
{
<Data name="S3PutTextReqDefaultData">
<Subscript>"S3PutTextReq"</Subscript>
<Value name="1">
<Value>ObjectName</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
</Data>
<DefaultData>S3PutTextReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
