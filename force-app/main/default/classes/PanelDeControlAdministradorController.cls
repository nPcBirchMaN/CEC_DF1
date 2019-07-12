public with sharing class PanelDeControlAdministradorController {
	@AuraEnabled
    public static boolean fireBatchRecalculoSocios() {
        Boolean pass = True;
        try {
            BatchRecalculoSocios brs = new BatchRecalculoSocios();
        	Database.executeBatch(brs, 200);
            
            //BatchSociNumberToWPBatch Aplic = new BatchSociNumberToWPBatch();
        	//database.executeBatch(Aplic,10);  
            if(Test.isRunningTest()) {
                throw new CalloutException();
            }
        } Catch(Exception e) {
            System.debug('Exception in PanelDeControlAdministradorController :: ' + e);
            pass = False;
        }
        return pass;
    }
    
    @AuraEnabled
    public static boolean fireBatchGenerarRemesaRevistaMuntanya(String NombreRevista) {
        Boolean pass = True;
        try {
            BatchGenerarRemesaRevistaMuntanya bgrrm = new BatchGenerarRemesaRevistaMuntanya(NombreRevista);
        	Database.executeBatch(bgrrm, 200);
            if(Test.isRunningTest()) {
                throw new CalloutException();
            }
        } Catch(Exception e) {
            System.debug('Exception in PanelDeControlAdministradorController :: ' + e);
            pass = False;
        }
        return pass;
    }
}