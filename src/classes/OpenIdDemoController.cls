public class OpenIdDemoController {
    
    //query string
    public String query { get; set; }
    
    public String getAuthToken() {
        //this is the Id of the "Auth Provider" and the name it registers
        return Auth.AuthToken.getAccessToken('<<Auth. Provider SF Record Id Here>>', 'open id connect');
    }
    
    //retrieve Google Drive list from google API
    public String gDriveResponse {
        get {
            String endpoint = 'https://www.googleapis.com/drive/v2/files';
            
            // if a query was entered, add it to the search
            // documented here https://developers.google.com/drive/web/search-parameters
            if(String.isNotEmpty(query)) {
                endpoint += '?q=' + EncodingUtil.UrlEncode('title contains  \''+ query +'\'', 'UTF-8');
            }
            
            //build HTTP Request with auth token
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + getAuthToken());
            HttpResponse res = new Http().send(req);
            return res.getBody();
        }
    }
    
    //deserialise the JSON to the GDriveList class
    public GDriveList getGDriveList() {
        return GDriveList.parse(gDriveResponse);
    }
}