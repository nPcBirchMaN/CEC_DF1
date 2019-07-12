/*
* @ Author: Olaia Aramendia (olaia.aramendia@birchmangroup.com)
* @ Date: 27/08/2018
* Crea una tarea que permite callouts desde triggers al ejecutarse en batch
*/
public class UpdateAccountChanges_WebserviceQueueble implements Queueable, Database.AllowsCallouts
{
    public final String modo;
	public final Account cuenta;
	public UpdateAccountChanges_WebserviceQueueble(String modoInput, Account cuentaInput)
    {
        modo=modoInput;
        cuenta = cuentaInput;
    }

	public void execute(QueueableContext context)
    {
        System.debug('Parametro recibido:'+cuenta);
        //System.debug('Parametro recibido:'+tipoSocio);
        //aquí ya si eso lanzamos mierda buena
        //List<String> params = new List<String>();
        //params.add(cuenta);
        //params.add(tipoSocio);
        String test = UserChangesSynchro.UserChangesSynchronization(modo,cuenta);
    }
}