public with sharing class USFederalRegisterService {
    public static String searchDocuments(String keyword){
        HttpRequest req = new HttpRequest();
        String searchTerm = EncodingUtil.urlEncode(
            keyword, 'UTF-8'
        );

        req.setEndpoint(
            'callout:USFederalRegister/api/v1/documents.json'
            +'?conditions[term]=' + searchTerm
            + '&per_page=5&order=newest'
        );
        req.setMethod('GET');
        req.setTimeout(10000);
        HttpResponse response = new Http().send(req);
        if(response.getStatusCode() != 200){
            throw new CalloutException(
                'US Federal Register API error: '
                +response.getStatusCode()
            );
        }
        return response.getBody();
    }
}