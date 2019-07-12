public class ExtensionFacturaPDF {
	   
    public List<L_neas_de_factura__c> lineasfactura{get; set;}
    
    public List<L_neas_de_factura__c> lineaslloc{get; set;}
    
	private ApexPages.StandardController stdCtrl;
    
    private Factura__c factura; 
    
    public ExtensionFacturaPDF(ApexPages.StandardController ctr){
        this.stdCtrl = ctr;
		this.factura = (Factura__c)this.stdCtrl.getRecord();
        this.lineasfactura = [SELECT Impuesto_texto__c,Lloc_de_trobada__c,Observaciones_del_producto__c,Producto__r.Name, Producto__r.Reuni_n_Previa__c, Producto__r.Datos_de_encuentros__c , Producto__r.Fecha_de_inicio__c,Producto__r.Fecha_de_fin__c,Precio_unitario_sin_impuestos__c, Cantidad__c, Descripci_n_del_producto__c, Factura__c, Importe__c, Importe_sin_impuestos__c, Impuestos__c, Name, Precio_unitario__c, Producto__c, Tipo_de_impuesto__c, Tipo_de_producto__c, Valores_timpuesto__c, Nombre_alternativo__c FROM L_neas_de_factura__c WHERE Factura__c=:factura.id];

		this.lineaslloc = [SELECT Impuesto_texto__c,Lloc_de_trobada__c,Observaciones_del_producto__c,Producto__r.Name,Precio_unitario_sin_impuestos__c, Cantidad__c, Descripci_n_del_producto__c, Factura__c, Importe__c, Importe_sin_impuestos__c, Impuestos__c, Name, Precio_unitario__c, Producto__c, Tipo_de_impuesto__c, Tipo_de_producto__c, Valores_timpuesto__c FROM L_neas_de_factura__c WHERE Factura__c=:factura.id AND Lloc_de_trobada__c=TRUE LIMIT 1];

    }
    

}