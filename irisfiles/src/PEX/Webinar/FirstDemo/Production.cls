Class PEX.Webinar.FirstDemo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="PEX.Webinar.FirstDemo" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description>Una Proucción de Demo para PEX</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Adapter" Name="ShutdownTimeout">20</Setting>
  <Item Name="DotNetGateway" Category="" ClassName="EnsLib.DotNetGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FilePath">C:\InterSystems\IRIS20201\dev\dotnet\bin\v4.5\</Setting>
    <Setting Target="Host" Name="DotNetVersion">4.5</Setting>
    <Setting Target="Host" Name="Exec64">1</Setting>
    <Setting Target="Host" Name="Port">44444</Setting>
  </Item>
  <Item Name="FirstOperation" Category="" ClassName="EnsLib.PEX.BusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="%gatewayExtraClasspaths">C:\webinar\webinar-PEX\FirstDemo\PEX.Webinar.FirstDemo\bin\Debug\netstandard2.0\PEX.Webinar.FirstDemo.dll</Setting>
    <Setting Target="Host" Name="%gatewayPort">44444</Setting>
    <Setting Target="Host" Name="%remoteClassname">PEX.Webinar.FirstDemo.FirstOperation</Setting>
  </Item>
  <Item Name="MessageRouter" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">PEX.Webinar.FirstDemo.MessageRouterRoutingRule</Setting>
    <Setting Target="Host" Name="ResponseFrom">FirstOperation</Setting>
  </Item>
  <Item Name="FirstService" Category="" ClassName="EnsLib.PEX.BusinessService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
     <Setting Target="Host" Name="%gatewayExtraClasspaths">C:\webinar\webinar-PEX\FirstDemo\PEX.Webinar.FirstDemo\bin\Debug\netstandard2.0\PEX.Webinar.FirstDemo.dll</Setting>
    <Setting Target="Host" Name="%remoteClassname">PEX.Webinar.FirstDemo.FirstService</Setting>
    <Setting Target="Host" Name="%remoteSettings">TargetConfigName=FirstProcess</Setting>
  </Item>
  <Item Name="FirstProcess" Category="" ClassName="EnsLib.PEX.BusinessProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="%gatewayExtraClasspaths">C:\webinar\webinar-PEX\FirstDemo\PEX.Webinar.FirstDemo\bin\Debug\netstandard2.0\PEX.Webinar.FirstDemo.dll</Setting>
    <Setting Target="Host" Name="%remoteClassname">PEX.Webinar.FirstDemo.FirstProcess</Setting>
    <Setting Target="Host" Name="%remoteSettings">Timeout=PT20S
TargetConfigName=FirstOperation</Setting>
  </Item>
</Production>
}

}
