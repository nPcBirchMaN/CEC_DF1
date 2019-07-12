public class NotifyUserTemplateController {
    public String username {get; set;}
    public String password {get; set;}
    
	public NotifyUserTemplateController() {
        username = ApexPages.currentPage().getParameters().get('username');
        password = ApexPages.currentPage().getParameters().get('password');
    }
}