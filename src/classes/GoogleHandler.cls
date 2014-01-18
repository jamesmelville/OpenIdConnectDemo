public class GoogleHandler implements Auth.RegistrationHandler{
    
    public User createUser(Id portalId, Auth.UserData data){
        
        // TODO: Provision user where user does not exist
        
        // TODO: Update user's name when initially matched to an existing user

        // TODO: Retrieve Google+ profile picture and set as chatter profile pic
        
        // TODO : Validate that the login is from the google Apps domain of my company
        
        //this query selects the user with the same email address as that of the validated Open Id user
        User u = [SELECT Id FROM User WHERE Email = :data.email];
        
        //set the profile pic
        setImage(u.Id,data.attributeMap.get('picture'));
        
        //retrun the user to login as
        return u;
    }
    
    public void updateUser(Id userId, Id portalId, Auth.UserData data){
        
        //set profile pic
        setImage(userId,data.attributeMap.get('picture'));
        
        //TODO: Update user's name when it has changed on login to an existing user
    }
    
    public void setImage(Id userId, String url) {
        
        try {
            //check user's existing photo
            ConnectApi.Photo p = ConnectApi.ChatterUsers.getPhoto(null, userId);
            
            // if they don't have a photo and we get a link to one
            if((p == null || p.photoVersionId == null) &&  url != null ) {
            
                //retrieve the photo from google
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + Auth.AuthToken.getAccessToken('0SOb0000000PAsw', 'open id connect'));
                HttpResponse res = new Http().send(req);
                Blob b = res.getBodyAsBlob();
                
                //set the photo on the user's profile
                ConnectApi.ChatterUsers.setPhoto(null, userId, new ConnectApi.BinaryInput(b,'image/jpg','user.jpg'));
            }
        }
        catch(Exception e){
            //don't block the user login by throwing an exception
        }
    }
}