trigger AutoEtapaSocio on Account (after insert, after update) {
    System.debug('AutoEtapaSocio');
    System.debug('Trigger.New :: '  + Trigger.New);
    System.debug('Trigger.Old :: '  + Trigger.Old);
    System.debug('isBefore :: ' + Trigger.isBefore);
    System.debug('isAfter :: ' + Trigger.isAfter);
    System.debug('isInsert :: ' + Trigger.isInsert);
    System.debug('isUpdate :: ' + Trigger.isUpdate);
    Boolean isActive = Boolean.valueOf(Label.AccountTriggersActive);
    
    if(isActive) {
        
        List<Etapas_socio__c> listaEtapas = new List<Etapas_socio__c>();
        List<Etapas_socio__c> listaEtapasViejas = new List<Etapas_socio__c>();
        List<Account> ModalidadDeCuentas  = [SELECT ID, Name, Modalidad__c,Suscriptor_Revista_Monta_a__c, Fecha_alta_original__c, Fecha_baja__c, Categor_a__c FROM Account];
        
        
        for (Account Cuentas: trigger.new){
            if (Trigger.isUpdate) {
                Account beforeUpdate = Trigger.oldMap.get(Cuentas.id);
                
                //Genera un nuevo registro dentro de etapa de socio cuando se realiza una modificación dentro del campo Modalidad de Socio.
                if((beforeUpdate.Modalidad__c != Cuentas.Modalidad__c | beforeUpdate.Categor_a__c != Cuentas.Categor_a__c) & 
                   (Cuentas.Modalidad__c == 'Colectivo' ||
                    Cuentas.Modalidad__c == 'Colectivo federado' ||
                    Cuentas.Modalidad__c == 'Familiar' ||
                    Cuentas.Modalidad__c == 'Familiar federado' ||
                    Cuentas.Modalidad__c == 'Niños 0-5' ||
                    Cuentas.Modalidad__c == 'Niños 6-13' ||
                    Cuentas.Modalidad__c == 'Juniors 14-17' ||
                    Cuentas.Modalidad__c == 'Jóvenes 18-25' ||
                    Cuentas.Modalidad__c == 'Jóvenes 18-25 federados' || 
                    Cuentas.Modalidad__c == 'Jóvenes 26-30' ||
                    Cuentas.Modalidad__c == 'Jóvenes 26-30 federados' ||
                    Cuentas.Modalidad__c == 'Protector' ||
                    Cuentas.Modalidad__c == 'Protector federados' ||
                    Cuentas.Modalidad__c == 'Veteranos' || 
                    Cuentas.Modalidad__c == 'Veteranos federados' ||
                    Cuentas.Modalidad__c == 'Seniors' || 
                    Cuentas.Modalidad__c == 'Seniors federados' ||
                    Cuentas.Modalidad__c == 'Vitalicio' ||
                    Cuentas.Categor_a__c == 'No_soci' ||
                    Cuentas.Categor_a__c == 'Menor No soci' ||
                    Cuentas.Categor_a__c == 'Participatiu')){
                        
                        Etapas_socio__c nuevaEtapa = new Etapas_socio__c ();
                        nuevaEtapa.Cuenta__c = Cuentas.ID ;
                        nuevaEtapa.Fecha_alta__c = date.today();
                        if(Cuentas.Categor_a__c == 'No_soci'){
                            nuevaEtapa.Modalidad__c =  'No soci';
                        } 
                        else if (Cuentas.Categor_a__c == 'Participatiu') {
                            nuevaEtapa.Modalidad__c =  'Participatiu';
                        } 
                        else if (Cuentas.Categor_a__c == 'Menor No soci') {
                            nuevaEtapa.Modalidad__c =  'Menor No soci';
                        }
                        else{
                            nuevaEtapa.Modalidad__c = Cuentas.Modalidad__c;  
                        }
                        System.debug('nuevaEtapa' + nuevaEtapa);
                        listaEtapas.add(nuevaEtapa);
                        
                        List<Etapas_socio__c> EtapaOld = [SELECT Id, Fecha_baja__c, Cuenta__c, Modalidad__c FROM Etapas_socio__c WHERE Cuenta__c =: Cuentas.Id];    
                        for(Etapas_socio__c Etapavieja : EtapaOld){
                            if(Etapavieja.Fecha_baja__c == Null){
                                Etapavieja.Fecha_baja__c = date.today();
                                
                                listaEtapasViejas.add(Etapavieja);
                            }
                        }
                        //system.debug('listaEtapasViejas = ' + listaEtapasViejas);
                    }
            }
            else {
                if(Cuentas.Modalidad__c == 'Colectivo' ||
                   Cuentas.Modalidad__c == 'Colectivo federado' || 
                   Cuentas.Modalidad__c == 'Familiar' ||
                   Cuentas.Modalidad__c == 'Familiar federado'||
                   Cuentas.Modalidad__c == 'Niños 0-5' ||
                   Cuentas.Modalidad__c == 'Niños 6-13' ||
                   Cuentas.Modalidad__c == 'Juniors 14-17' ||
                   Cuentas.Modalidad__c == 'Jóvenes 18-25'||
                   Cuentas.Modalidad__c == 'Jóvenes 18-25 federados' ||
                   Cuentas.Modalidad__c == 'Jóvenes 26-30' ||
                   Cuentas.Modalidad__c == 'Jóvenes 26-30 federados' ||
                   Cuentas.Modalidad__c == 'Protector' ||
                   Cuentas.Modalidad__c == 'Protector federados' ||
                   Cuentas.Modalidad__c == 'Veteranos' || 
                   Cuentas.Modalidad__c == 'Veteranos federados' ||
                   Cuentas.Modalidad__c == 'Seniors' || 
                   Cuentas.Modalidad__c == 'Seniors federados' ||
                   Cuentas.Modalidad__c == 'Vitalicio' ||
                   Cuentas.Categor_a__c == 'No_soci' ||
                   Cuentas.Categor_a__c == 'Menor No soci' ||
                   Cuentas.Categor_a__c == 'Participatiu'){
                       
                       Etapas_socio__c nuevaEtapa = new Etapas_socio__c ();
                       nuevaEtapa.Cuenta__c = Cuentas.ID ;
                       nuevaEtapa.Fecha_alta__c = date.today();
                       if(Cuentas.Categor_a__c == 'No_soci'){
                           nuevaEtapa.Modalidad__c =  'No soci';
                       } 
                       else if (Cuentas.Categor_a__c == 'Participatiu') {
                           nuevaEtapa.Modalidad__c =  'Participatiu';
                       }
                       else if (Cuentas.Categor_a__c == 'Menor No soci') {
                           nuevaEtapa.Modalidad__c =  'Menor No soci';
                       }
                       else{
                           nuevaEtapa.Modalidad__c = Cuentas.Modalidad__c;  
                       }
                       System.debug('nuevaEtapa' + nuevaEtapa);
                       listaEtapas.add(nuevaEtapa);
                   }
            }
            
            //System.debug('listaEtapas ' + listaEtapas);
            if (listaEtapas.size() > 0) {
                upsert listaEtapas;
            }
            //system.debug('listaEtapasViejas ' + listaEtapasViejas);
            if (listaEtapasViejas.size() > 0) {
                
                database.update(listaEtapasViejas);
                
            }
        }
    }
    
}