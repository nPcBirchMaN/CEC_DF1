public class EnvioInscritosController {
    public String pageid {get;set;}
        
    public EnvioInscritosController (){
        pageid = ApexPages.currentPage().getParameters().get('id');
        System.debug('pageid || ' + pageid);
    }
    
    public Product2 getProduct(){
        //return [SELECT id, Fecha_de_inicio__c, Fecha_de_fin__c FROM product2 WHERE id = :ApexPages.currentPage().getParameters().get('id')];
        System.debug(' Entra en get product || ' + pageid);
        return [SELECT name, Coordinada_por__c, Datos_de_encuentros__c, Descripci_n_completa__c, Description, Fecha_de_fin__c, Fecha_de_inicio__c,
                toLabel(Categor_a__c), toLabel(Grado_de_dificultad__c), Tipologia__c 
                FROM Product2 
                WHERE id = :ApexPages.currentPage().getParameters().get('id')];
    }
    
    public List<orderitem> getListaInscritos(){
        System.debug(' Entra en get getLisatInscritos || ' + pageid);
        return [SELECT id, order.account.firstname, order.account.LastName, order.account.N_mero_de_Documento__pc, order.account.PersonBirthdate, 
                toLabel(order.account.Categor_a__c) , order.account.Fecha_alta_original__c, order.account.Phone, order.account.PersonEmail, order.account.Licencia__c, order.account.Cesi_n_de_imagenes__c
                FROM orderitem 
                WHERE Product2Id = :ApexPages.currentPage().getParameters().get('id') AND order.Etapa__c = '3.Cerrada' AND L_nea_Anulada__c = false];
    }
    
    public List<orderitem> getListaEspera(){
        System.debug(' Entra en get getLisatEspera || ' + pageid);
        return [SELECT id, order.account.firstname, order.account.LastName, order.account.N_mero_de_Documento__pc, order.account.PersonBirthdate, toLabel(order.account.Categor_a__c),
                order.account.Fecha_alta_original__c, order.account.Phone, order.account.PersonEmail, order.account.Licencia__c, order.account.Cesi_n_de_imagenes__c
                FROM orderitem 
                WHERE Product2Id = :ApexPages.currentPage().getParameters().get('id') AND order.Etapa__c = '0.Inicial'];
    }
    
    public List<orderitem> getListaBajas(){
        System.debug(' Entra en get getLisatBajas || ' + pageid);
        return [SELECT id, order.account.firstname, order.account.LastName, order.account.N_mero_de_Documento__pc, order.account.PersonBirthdate, toLabel(order.account.Categor_a__c),
                order.account.Fecha_alta_original__c, order.account.Phone, order.account.PersonEmail, order.account.Licencia__c, order.account.Cesi_n_de_imagenes__c
                FROM orderitem 
                WHERE Product2Id = :ApexPages.currentPage().getParameters().get('id') AND order.Etapa__c = '3.Cerrada' AND L_nea_Anulada__c = true];
    }
    
    
}