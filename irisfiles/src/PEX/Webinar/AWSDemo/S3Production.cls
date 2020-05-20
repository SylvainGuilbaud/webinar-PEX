Class PEX.Webinar.AWSDemo.S3Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="PEX.Webinar.AWSDemo.S3Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description>Una Production Con Componentes basados en librerias de terceros</Description>
  <ActorPoolSize>0</ActorPoolSize>
  <Setting Target="Adapter" Name="ShutdownTimeout">10</Setting>
  <Item Name="S3Operation" Category="" ClassName="PEX.Webinar.AWSDemo.S3Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="%gatewayExtraClasspaths">C:\webinar\webinar-PEX\AWS\PEX.AWS\bin\Debug\netstandard2.0\PEX.AWS.dll;C:\Users\pyd\.nuget\packages\awssdk.s3\3.5.0-beta\lib\net45\AWSSDK.S3.DLL</Setting>
    <Setting Target="Adapter" Name="%gatewayPort">44445</Setting>
    <Setting Target="Adapter" Name="%remoteClassname">PEX.AWS.S3OutboundAdapter</Setting>
    <Setting Target="Adapter" Name="%remoteSettings">awsAccessKeyId=AKIA6F7BHN5R63AZR3XJ
awsSecretAccessKey=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
awsBucket=iris-webinar
awsRegion=eu-west-1</Setting>
  </Item>
  <Item Name="EnsLib.DotNetGateway.Service" Category="" ClassName="EnsLib.DotNetGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="DotNetVersion">4.5</Setting>
    <Setting Target="Host" Name="Exec64">1</Setting>
    <Setting Target="Host" Name="FilePath">C:\InterSystems\IRIS20201\dev\dotnet\bin\v4.5\</Setting>
    <Setting Target="Host" Name="Port">44445</Setting>
  </Item>
  <Item Name="EnsLib.File.PassthroughService" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">S3Operation</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\webinar\webinar-PEX\files\in</Setting>
  </Item>
  <Item Name="S3Service" Category="" ClassName="PEX.Webinar.AWSDemo.S3Service" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="%gatewayExtraClasspaths">C:\webinar\webinar-PEX\AWS\PEX.AWS\bin\Debug\netstandard2.0\PEX.AWS.dll;C:\Users\pyd\.nuget\packages\awssdk.s3\3.5.0-beta\lib\net45\AWSSDK.S3.DLL</Setting>
    <Setting Target="Adapter" Name="%remoteClassname">PEX.AWS.S3InboundAdapter</Setting>
    <Setting Target="Adapter" Name="%remoteSettings">awsAccessKeyId=AKIA6F7BHN5R63AZR3XJ
awsSecretAccessKey=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
awsBucket=iris-webinar
awsRegion=eu-west-1
archivePath=C:\\webinar\\webinar-PEX\\files\\archive</Setting>
    <Setting Target="Adapter" Name="CallInterval">30</Setting>
    <Setting Target="Adapter" Name="%gatewayPort">44445</Setting>
    <Setting Target="Host" Name="TargetConfigNames">EnsLib.File.PassthroughOperation</Setting>
  </Item>
  <Item Name="EnsLib.File.PassthroughOperation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\webinar\webinar-PEX\files\out\</Setting>
    <Setting Target="Host" Name="Filename">%f</Setting>
  </Item>
</Production>
}

}
