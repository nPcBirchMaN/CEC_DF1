<aura:application controller="InfoSocisAppController" extends="force:slds">
    <aura:attribute name="id" type="String" default=""/>
    <aura:attribute name="object" type="sObject"/>
	<aura:handler name="init" value="{!this}" action="{!c.onInit}"/>
    
    <aura:handler value="{!this}" name="init" action="{!c.appName}"/>
    
    <div class="bkg">
    <a class="logo-container" href="http://cec.cat/"><img class="logo" src="{!$Resource.CEC_Logo}"/></a>
    
    <lightning:layout horizontalAlign="center">
        <lightning:layoutItem size="6" padding="around-small">
    		<c:InfoCuentaCmp record="{! v.object }" />
        </lightning:layoutItem>
    </lightning:layout>
    <lightning:layout horizontalAlign="center">
            <lightning:layoutItem size="6" padding="around-small">
    		<c:InfoQRCmp recordId="{! v.object.Id }"/>
        </lightning:layoutItem>
    </lightning:layout>
    </div>
</aura:application>