using System;

namespace PEX.Webinar.FirstDemo
{
    public class FirstOperation : InterSystems.EnsLib.PEX.BusinessOperation
    {
        public override void OnInit()
        {
            LOGINFO("PEX.Webinar.FirstDemo.FirstOperation:OnInit()");
        }
        public override void OnTearDown()
        {
            LOGINFO("PEX.Webinar.FirstDemo.FirstOperation:OnTearDown()");
        }
        public override object OnMessage(object request)
        {
            LOGINFO("PEX.Webinar.FirstDemo.FirstOperation:OnMessage()");
            LOGINFO("Type:" + request.GetType());
            ///se Instancia el mensaje de respuesta
            FirstMessage response = new FirstMessage();

            //Se copia el value en "uppercase" de la peticion
            response.value = ((FirstMessage)request).value.ToUpper();

            //Se devuelve la respuesta
            return response;
        }
    }
}
