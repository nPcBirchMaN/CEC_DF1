trigger NewAccountWooCommerceTrigger on Account (before insert) { 
    System.debug('NewAccountWooCommerceTrigger');
    System.debug('Trigger.New :: '  + Trigger.New);
    System.debug('Trigger.Old :: '  + Trigger.Old);
    System.debug('isBefore :: ' + Trigger.isBefore);
    System.debug('isAfter :: ' + Trigger.isAfter);
    System.debug('isInsert :: ' + Trigger.isInsert);
    System.debug('isUpdate :: ' + Trigger.isUpdate);
    Boolean isActive = Boolean.valueOf(Label.AccountTriggersActive);
    
    if(isActive) {
        List<RecordType> rTypes = [Select id,name from RecordType where SobjectType='Account'];
        String cuentaPersonalId = '';
        for (RecordType rType : rTypes) {
            if (rType.name == 'Cuenta personal') {
                cuentaPersonalId = rType.id;
            }
        }
        System.debug('NewAccountWooCommerceTrigger');
        Boolean sinFuturaModalidad = false;
        Account UltCuentaConId = null;
        //Recuperamos el último número de cliente asignado
        List<Account> accs = [SELECT ID, Name, Id_Cliente__c, RecordTypeId FROM Account ORDER BY Id_Cliente__c DESC NULLS LAST LIMIT 1];
        
        if(!accs.isEmpty())
            UltCuentaConId = accs.get(0);
        
        System.debug('UltCuentaConId :: ' + UltCuentaConId);
        
        for(Account CuentaNueva : Trigger.New){
            if (CuentaNueva.webkul_wws__Woo_Customer_Id__c != null) {
                System.debug('CuentaNueva '+ CuentaNueva.Name);
                CuentaNueva.Tipos_de_Alta__c = 'Web';
            }
            if(CuentaNueva.Categor_a__c == 'Menor' || CuentaNueva.Categor_a__c == 'Ple_dret' || CuentaNueva.Categor_a__c == 'Participatiu') {
                //Si es nueva cuenta personal se le añadirá un ID nuevo
                if(UltCuentaConId != null && UltCuentaConId.Id_Cliente__c != null && CuentaNueva.RecordTypeId == cuentaPersonalId){
                    //Si existe número de socio anterior, se le suma 1
                    CuentaNueva.Id_Cliente__c = UltCuentaConId.Id_Cliente__c + 1;
                }
                else if ((UltCuentaConId == null ||  UltCuentaConId.Id_Cliente__c == null) && CuentaNueva.RecordTypeId == cuentaPersonalId) {
                    CuentaNueva.Id_Cliente__c = 1;
                }
            }
            
            
            if (CuentaNueva.Modalidad__c == 'Vitalicio' || CuentaNueva.Modalidad__c == 'Protector' || CuentaNueva.Modalidad__c == 'Protector federados' ||CuentaNueva.Modalidad__c == 'Colectivo' || CuentaNueva.Modalidad__c == 'Colectivo federado' || CuentaNueva.Modalidad__c == 'Familiar' || CuentaNueva.Modalidad__c == 'Familiar federado') {
                sinFuturaModalidad = true;
            } else {
                sinFuturaModalidad = false;
            }
            if ((CuentaNueva.Categor_a__c == 'Menor' || CuentaNueva.Categor_a__c == 'Ple_dret') && cuentaNueva.PersonBirthdate != null && sinFuturaModalidad == false) {
                Date fechaNacimiento = CuentaNueva.PersonBirthdate;
                Date hoy = Date.today();
                Integer year = hoy.year();
                Integer menorYear = fechaNacimiento.year();
                Integer edad = year - menorYear;
                
                if (edad >= 0 && edad < 6) {
                    CuentaNueva.Futura_modalidad_del_socio__c = 'Niños 6-13';
                    Date fechaAplicacion = Date.newInstance((year+6-edad),fechaNacimiento.month(), fechaNacimiento.day());
                    CuentaNueva.Fecha_aplicaci_n_de_baja__c = fechaAplicacion;
                }
                else if (edad >= 6 && edad < 14) {
                    CuentaNueva.Futura_modalidad_del_socio__c = 'Juniors 14-17';
                    Date fechaAplicacion = Date.newInstance((year+14-edad),fechaNacimiento.month(), fechaNacimiento.day());
                    CuentaNueva.Fecha_aplicaci_n_de_baja__c = fechaAplicacion;
                }
                else if (edad >= 14 && edad < 18) {
                    CuentaNueva.Futura_categor_a_s_cio__c = 'Ple_dret';
                    Date fechaAplicacion = Date.newInstance((year+18-edad),fechaNacimiento.month(), fechaNacimiento.day());
                    CuentaNueva.Fecha_aplicaci_n_de_baja__c = fechaAplicacion;
                    CuentaNueva.Futura_modalidad_del_socio__c = 'Jóvenes 18-25';
                }
                else if (edad >= 18 && edad < 26) {
                    CuentaNueva.Futura_categor_a_s_cio__c = 'Ple_dret';
                    Date fechaAplicacion = Date.newInstance((year+26-edad),fechaNacimiento.month(), fechaNacimiento.day());
                    CuentaNueva.Fecha_aplicaci_n_de_baja__c = fechaAplicacion;
                    if (CuentaNueva.Modalidad__c == 'Jóvenes 18-25 federados') {
                        CuentaNueva.Futura_modalidad_del_socio__c = 'Jóvenes 26-30 federados';
                    } else if (CuentaNueva.Modalidad__c != 'Jóvenes 26-30 federados') {
                        CuentaNueva.Futura_modalidad_del_socio__c = 'Jóvenes 26-30';
                    }
                }
                else if (edad >= 26 && edad < 31) {
                    CuentaNueva.Futura_categor_a_s_cio__c = 'Ple_dret';
                    Date fechaAplicacion = Date.newInstance((year+31-edad),fechaNacimiento.month(), fechaNacimiento.day());
                    CuentaNueva.Fecha_aplicaci_n_de_baja__c = fechaAplicacion;
                    if (CuentaNueva.Modalidad__c == 'Jóvenes 26-30 federados') {
                        CuentaNueva.Futura_modalidad_del_socio__c = 'Seniors federados';
                    } else if (CuentaNueva.Modalidad__c != 'Seniors federados') {
                        CuentaNueva.Futura_modalidad_del_socio__c = 'Seniors';
                    }
                }
                else if (edad >= 31) {
                    CuentaNueva.Futura_categor_a_s_cio__c = 'Ple_dret';
                    Date fechaAplicacion = Date.newInstance((year+65-edad),fechaNacimiento.month(), fechaNacimiento.day());
                    CuentaNueva.Fecha_aplicaci_n_de_baja__c = fechaAplicacion;
                    if (CuentaNueva.Modalidad__c == 'Seniors federados') {
                        CuentaNueva.Futura_modalidad_del_socio__c = 'Veteranos federados';
                    } else if (CuentaNueva.Modalidad__c != 'Seniors federados') {
                        CuentaNueva.Futura_modalidad_del_socio__c = 'Veteranos';
                    }
                }
            } else  {
                CuentaNueva.Fecha_aplicaci_n_de_baja__c = null;
                CuentaNueva.Futura_modalidad_del_socio__c = null;
                CuentaNueva.Futura_categor_a_s_cio__c = null;
            }
            
            ////Si es nueva cuenta y su categoría es de tipo socio, se le añadirá un número de socio
            //if(UltCuentaConId != null && UltCuentaConId.Id_Cliente__c != null && CuentaNueva.Categor_a__c != 'No_soci' && CuentaNueva.Id_Cliente__c == null){
            //Si existe número de socio anterior, se le suma 1
            //    CuentaNueva.Id_Cliente__c = UltCuentaConId.Id_Cliente__c + 1;
            //}
            //else if ((UltCuentaConId == null ||  UltCuentaConId.Id_Cliente__c == null) && CuentaNueva.Categor_a__c != 'No_soci' && CuentaNueva.Id_Cliente__c == null) {
            //    CuentaNueva.Id_Cliente__c = 1;
            //}
        }
        
    }
}