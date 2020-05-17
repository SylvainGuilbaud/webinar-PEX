using System;
using System.Collections.Generic;
using System.Text;

namespace PEX.Webinar.FirstDemo
{
    class FirstProcess: InterSystems.EnsLib.PEX.BusinessProcess
    {
        //Timeout para las Llamadas
        public string Timeout = "PT10S";
        public string TargetConfigName;

        public override void OnInit()
        {
            //Verificar que las propiedades esten correctamente informadas
            if (TargetConfigName == null)
            {
                LOGWARNING("Falta valor para TargetConfigName; es necesario asignarle un valor en RemoteSettings");
            }
            else
            {
                LOGINFO("TargetConfigname=" + TargetConfigName);
            }
        }

        public override object OnRequest(object request)
        {
            LOGINFO("OnRequest");
            SendRequestAsync(TargetConfigName, (InterSystems.EnsLib.PEX.Message)request, true); //ResponseRequired=true
            SetTimer(Timeout, "HasTimedOut");
            return null;
        }

        public override object OnResponse(object request, object response, object callRequest, object callResponse, string completionKey)
        {
            LOGINFO("OnResponse, CompletionKey=" + completionKey);
            if (completionKey!= "HasTimedOut")
            {
                response = (FirstMessage)callResponse;
            }
            LOGINFO("Response:" + response.ToString());
            return response;
        }

        public override object OnComplete(object request, object response)
        {
            LOGINFO("OnComplete");
            return response;
        }

    }
}
