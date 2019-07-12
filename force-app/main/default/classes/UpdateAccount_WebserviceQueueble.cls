/*
* @ Author: Nacho Pérez (ignacio.perez@birchmangroup.com)
* @ Date: 09/08/2018
* Crea una tarea que permite callouts desde triggers al ejecutarse en batch
*/
public class UpdateAccount_WebserviceQueueble implements Queueable, Database.AllowsCallouts
{
    public final String modo;
	public final String idwoocomerce;
	public final String tipoSocio;
    public UpdateAccount_WebserviceQueueble(String modoInput, String idwoocomerceInput,String tipoSocioInput)
    {
        modo=modoInput;
        idwoocomerce = idwoocomerceInput;
        tipoSocio=tipoSocioInput;
    }

	public void execute(QueueableContext context)
    {
        System.debug('Parametro recibido:'+idwoocomerce);
        System.debug('Parametro recibido:'+tipoSocio);
        //aquí ya si eso lanzamos mierda buena
        List<String> params = new List<String>();
        params.add(idwoocomerce);
        params.add(tipoSocio);
        String test = UserSynchro.UserSynchronization(modo,params);
    }
}