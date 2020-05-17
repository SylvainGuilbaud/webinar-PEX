using System;
using System.Collections.Generic;
using System.Text;

namespace PEX.Webinar.FirstDemo
{
    class FirstService : InterSystems.EnsLib.PEX.BusinessService
    {
        /// <summary>
        /// Un parametro que se puede cambiar desde el Portal
        /// </summary>
        public string TargetConfigName;
        public override void OnInit()
        {
           //Verificar que las propiedades esten correctamente informadas
           if (TargetConfigName==null )
            {
                LOGWARNING("Falta valor para TargetConfigName; es necesario asignarle un valor en RemoteSettings");
            }else
            {
                LOGINFO("TargetConfigname=" + TargetConfigName);
            }
        }
        public override object OnProcessInput(object messageInput)
        {
            //crear un nuevo Objeto de Petición
            FirstMessage myRequest = new FirstMessage();
            myRequest.value = "La Hora de envio es: " + System.DateTime.Now.ToString();

            //Para Enviar Sin esperar una respuesta:
            //SendRequestAsync("PEX.Webinar.FirstOperation", myRequest);

            //Para Enviar y Esperar la respuesta con un timeout de 20 segundos:
            FirstMessage myResponse=(FirstMessage) SendRequestSync(TargetConfigName, myRequest, 20);

            return null;
        }
    }
}
