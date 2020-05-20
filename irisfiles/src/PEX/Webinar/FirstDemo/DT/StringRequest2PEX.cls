Class PEX.Webinar.FirstDemo.DT.StringRequest2PEX Extends Ens.DataTransformDTL [ DependsOn = (Ens.StringRequest, EnsLib.PEX.Message) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Ens.StringRequest' targetClass='EnsLib.PEX.Message' create='new' language='objectscript' >
<annotation>Transforma un Ens.StringRequest al Mensaje PEX.Webinar.FirstDemo.FirstMessage</annotation>
<assign value='"PEX.Webinar.FirstDemo.FirstMessage"' property='target.%classname' action='set' />
<assign value='source.StringValue' property='target.%jsonObject.value' action='set' />
</transform>
}

}
