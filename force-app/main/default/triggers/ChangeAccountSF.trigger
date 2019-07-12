trigger ChangeAccountSF on Account (before insert, before update) {
    System.debug('ChangeAccountSF');
    System.debug('Trigger.New :: '  + Trigger.New);
    System.debug('Trigger.Old :: '  + Trigger.Old);
    System.debug('isBefore :: ' + Trigger.isBefore);
    System.debug('isAfter :: ' + Trigger.isAfter);
    System.debug('isInsert :: ' + Trigger.isInsert);
    System.debug('isUpdate :: ' + Trigger.isUpdate);
    Boolean isActive = Boolean.valueOf(Label.AccountTriggersActive);
    
    if(isActive) {
        
        System.debug('ChangeAccountSF');
        Boolean sinFuturaModalidad = false;
        Account UltCuentaConId = null;
        //Recuperamos el último número de cliente asignado
        List<Account> accs = [SELECT ID, Name, Id_Cliente__c, RecordTypeId FROM Account ORDER BY Id_Cliente__c DESC NULLS LAST LIMIT 1];
        if(!accs.isEmpty())
            UltCuentaConId = accs.get(0);
        
        System.debug('UltCuentaConId :: ' + UltCuentaConId);
        
        for(Account CuentaNueva : Trigger.New){
            if (Trigger.isUpdate) {
                System.debug('Es un update');
                if (CuentaNueva.Cambios_WooCommerce__c != null) {
                    CuentaNueva.Cambios_WooCommerce__c = null;
                    CuentaNueva.cambiosSF__c = false;
                }
                else {
                    CuentaNueva.cambiosSF__c = true;
                }
                Account beforeUpdate = Trigger.oldMap.get(CuentaNueva.id);
                if(CuentaNueva.Categor_a__c!=beforeUpdate.Categor_a__c) {
                    //Actualizamos las fechas al dar de alta a un socio
                    if (CuentaNueva.Categor_a__c!='No_soci' && CuentaNueva.Categor_a__c!='Menor No soci') {
                        if (CuentaNueva.Fecha_alta_original__c == null) {
                            CuentaNueva.Fecha_alta_original__c = Date.today();
                            if(UltCuentaConId <> null && UltCuentaConId.Id_Cliente__c <> null)
                                CuentaNueva.Id_Cliente__c = UltCuentaConId.Id_Cliente__c + 1;
                        }else{
                            CuentaNueva.Fecha_alta_original__c=beforeUpdate.Fecha_alta_original__c;
                            if(UltCuentaConId <> null && UltCuentaConId.Id_Cliente__c <> null)
                                CuentaNueva.Id_Cliente__c = UltCuentaConId.Id_Cliente__c + 1;
                        }
                        if (CuentaNueva.Fecha_de_alta_de_actividad__c == null) {
                            CuentaNueva.Fecha_de_alta_de_actividad__c = Date.today(); 
                        } else {
                            CuentaNueva.Fecha_de_alta_de_actividad__c = beforeUpdate.Fecha_de_alta_de_actividad__c;
                        }
                    } 
                    CuentaNueva.Fecha_de_ltima_actualizaci_n__c = Date.today();
                    
                    System.debug('CuentaNueva :: ' + CuentaNueva);
                }
                if (CuentaNueva.Modalidad__c == 'Vitalicio' || CuentaNueva.Modalidad__c == 'Protector' || CuentaNueva.Modalidad__c == 'Protector federados' ||
                    CuentaNueva.Modalidad__c == 'Colectivo' || CuentaNueva.Modalidad__c == 'Colectivo federado' || CuentaNueva.Modalidad__c == 'Familiar' || CuentaNueva.Modalidad__c == 'Familiar federado') {
                        sinFuturaModalidad = true;
                    } else {
                        sinFuturaModalidad = false;
                    }
                if ((((CuentaNueva.Categor_a__c!=beforeUpdate.Categor_a__c || CuentaNueva.Modalidad__c!=beforeUpdate.Modalidad__c) 
                      && (CuentaNueva.Categor_a__c == 'Menor' || CuentaNueva.Categor_a__c == 'Ple_dret') && CuentaNueva.PersonBirthdate != null) || 
                     (CuentaNueva.PersonBirthdate != beforeUpdate.PersonBirthdate && CuentaNueva.PersonBirthdate != null && (CuentaNueva.Categor_a__c == 'Menor' || CuentaNueva.Categor_a__c == 'Ple_dret')))
                    && sinFuturaModalidad == false) {
                        Date fechaNacimiento = CuentaNueva.PersonBirthdate;
                        Date hoy = Date.today();
                        Integer year = hoy.year();
                        Integer menorYear = fechaNacimiento.year();
                        Integer edad = year - menorYear;
                        System.debug('Cambiamos las categorías futuras');
                        if (edad < 6) {
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
                            CuentaNueva.Futura_modalidad_del_socio__c = 'Jóvenes 18-25';
                            Date fechaAplicacion = Date.newInstance((year+18-edad),fechaNacimiento.month(), fechaNacimiento.day());
                            CuentaNueva.Fecha_aplicaci_n_de_baja__c = fechaAplicacion;
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
                        System.debug('Futura categoría '+CuentaNueva.Futura_categor_a_s_cio__c + ' futura modalidad ' +CuentaNueva.Futura_modalidad_del_socio__c);
                    } /*else  {
CuentaNueva.Fecha_aplicaci_n_de_baja__c = null;
CuentaNueva.Futura_modalidad_del_socio__c = null;
CuentaNueva.Futura_categor_a_s_cio__c = null;
}*/
                if (CuentaNueva.IBAN__c != beforeUpdate.IBAN__c) {
                    //Si se rellena el IBAN, hay que conseguir el código BIC/SWIFT
                    if (CuentaNueva.IBAN__c != null && CuentaNueva.IBAN__c != '') {
                        String iban = CuentaNueva.IBAN__c;
                        iban = iban.replaceAll(' ', '');
                        if (iban.length() == 24) {
                            String oficina = iban.substring(4, 8);
                            oficina = oficina.removeStart('0');
                            oficina = oficina.removeStart('0');
                            Maestro_Bancos__c[] banco = [SELECT Id, BIC__c, Name, Entidad__c From Maestro_Bancos__c Where Name =: oficina LIMIT 1];
                            CuentaNueva.BIC_SWIFT__c = (banco.size() > 0)?banco[0].BIC__c:'';
                        }
                    }
                }
            }
            
            if (Trigger.isInsert) {
                System.debug('Es un insert');
                //Actualizamos las fechas al dar de alta a un socio
                if (CuentaNueva.Categor_a__c!='No_soci' && CuentaNueva.Categor_a__c!='Menor No soci') {
                    if (CuentaNueva.Fecha_alta_original__c == null) {
                        CuentaNueva.Fecha_alta_original__c = Date.today();
                    }
                    if (CuentaNueva.Fecha_de_alta_de_actividad__c == null) {
                        CuentaNueva.Fecha_de_alta_de_actividad__c = Date.today(); 
                    }
                }
                CuentaNueva.Fecha_de_ltima_actualizaci_n__c = Date.today();
                //Si se rellena el IBAN, hay que conseguir el código BIC/SWIFT
                if (CuentaNueva.IBAN__c != null && CuentaNueva.IBAN__c != '') {
                    String iban = CuentaNueva.IBAN__c;
                    iban = iban.replaceAll(' ', '');
                    if (iban.length() == 24) {
                        String oficina = iban.substring(4, 7);
                        oficina = oficina.removeStart('0');
                        oficina = oficina.removeStart('0');
                        Maestro_Bancos__c[] banco = [SELECT Id, BIC__c, Name, Entidad__c From Maestro_Bancos__c Where Name =: oficina LIMIT 1];    
                        CuentaNueva.BIC_SWIFT__c = (banco.size() > 0)?banco[0].BIC__c:'';
                    }
                }
            }
        }
        
    }
}