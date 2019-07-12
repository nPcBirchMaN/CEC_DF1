public class EnrolmentException extends Exception {
    private sObject obj;
    
    public sObject getSObject() {
        return obj;
    }
    
    public void setSObject(sObject obj) {
        this.obj = obj;
    }
}