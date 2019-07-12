public class InstallmentException extends Exception {
    private sObject obj;
	private String role;
    private String modality;
    
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getModality() {
        return modality;
    }
    
    public void setModality(String modality) {
        this.modality = modality;
    }
    
    public sObject getSObject() {
        return obj;
    }
    
    public void setSObject(sObject obj) {
        this.obj = obj;
    }
 }