public with sharing class USFederalRegisterAction {
    public class Request{
        @InvocableVariable(
        	label='Search Keyword'
            description ='Topic to search in the Federal Register, such as immigration, H-1B, or visa'
            required=true  
        )
        public String keyword;
    }
    
    public class Response{
        @InvocableVariable(
        	label='US Federal Register Results'
            description = 'Published documents with titles,dates, types and official URLs'
        )
        public String results;
    }
    
    @InvocableMethod(
    	label='Search Federal Register'
    	description='Search official federal regulatory documents'
    	callout=true
    )
    public static List<Response> search(List<Request> requests){
        List<Response> outputs = new List<Response>();
        
        for(Request req: requests){
            String jsonResponse= 
                USFederalRegisterService.searchDocuments(req.keyword);
            Map<String,Object> data = 
                (Map<String,Object>)JSON.deserializeUntyped(jsonResponse);
            
            List<Object> documents = (List<Object>) data.get('results');
            List<String> summaries = new List<String>();
            
            if(documents != null){
                for(Object item:documents){
                    Map<String,Object> doc = 
                        (Map<String,Object>)item;
                    
                    summaries.add(
                    'Title: '+String.valueOf(doc.get('title'))+
                    '\nType: '+String.valueOf(doc.get('type'))+
                    '\nPublished: '+String.valueOf(doc.get('publication_date'))+
                    '\nURL: '+String.valueOf(doc.get('html_url'))+
                    '\nabstract: '+String.valueOf(doc.get('abstract'))+
                     '\neffective_on: '+String.valueOf(doc.get('effective_on'))+
                      '\ndocument_number: '+String.valueOf(doc.get('document_number'))
                    );
                }
            }
            
            Response output = new Response();
            output.results = summaries.isEmpty() ? 'No matching documents found. ' : String.join(summaries, '\n\n');
            outputs.add(output);
                
        }
        return outputs;
    }
}