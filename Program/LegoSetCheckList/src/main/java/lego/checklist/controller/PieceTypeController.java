package lego.checklist.controller;

import java.util.HashMap;

import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

//RestTemplate is used to perform HTTP request to a uri [1]

//The Jackson-core [2] and Jackson-databind [3] libraries is used for working with JSON

/* References:
* [1]	"RestTemplate (Spring Framework 5.3.14 API)",
* 		Docs.spring.io, 2021. [Online].
* 		Available: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html.[Accessed: 02- Dec- 2021]
* [2]	"jackson-core 2.13.1 javadoc (com.fasterxml.jackson.core)",
*		Javadoc.io. [Online].
*		Available: https://javadoc.io/doc/com.fasterxml.jackson.core/jackson-core/latest/index.html. [Accessed: 05- Dec- 2021]
* [3]	"jackson-databind 2.13.1 javadoc (com.fasterxml.jackson.core)",
* 		Javadoc.io. [Online].
* 		Available: https://javadoc.io/doc/com.fasterxml.jackson.core/jackson-databind/latest/index.html. [Accessed: 05- Dec- 2021]
*/

public class PieceTypeController {
	// This creates a mapping so that I can get piece categories names without having to call the API each time
	public static HashMap<Integer, String> pieceCategories = new HashMap<Integer, String>();
	
	// This stores the basic uri to the Rebrickable API
	private final static String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
		
	// The api key used to access the Rebrickable api
	private final static String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	
	public static void createPieceTypeMap() {
		// This is the uri to all piece categories in the Rebrickable API
		String pieceType_uri = rebrickable_uri + "part_categories/?ordering=name&key=" + rebrickable_api_key;

		RestTemplate restTemplate = new RestTemplate();
		
		getPieceTypePage(pieceType_uri, restTemplate);
	}
	
	// This gets all the Lego piece categories using the Lego piece category uri, starting with the first page of these piece categories,
	// If there are other pages containing piece categories on the api, this class will then be called recursively to get all of these piece categories
	private static void getPieceTypePage(String pieceType_page_uri, RestTemplate restTemplate) {
		// This uses restTemplate and the piece category uri to call the API and then transforms the returned JSON into a String
		String pieceType_page_JSON = restTemplate.getForObject(pieceType_page_uri, String.class);
		
		// This is wrapped in a try catch in case the string given to readTree() is not a JSON string
        try {
        	// This provides functionality for reading and writing JSON
        	ObjectMapper mapper = new ObjectMapper();
        	
        	// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
        	JsonNode pieceType_pageNode = mapper.readTree(pieceType_page_JSON);
        	
        	// These get and store the uri to the next page containing set pieces
        	JsonNode nextNode = pieceType_pageNode.path("next");
        	String next = nextNode.textValue();
			
        	// This provides the root of the JSON element where the JSON array of Lego piece categories is stored
        	pieceType_pageNode = pieceType_pageNode.path("results");
        	
        	// This iterates through the JSON array of Lego piece categories
            for (JsonNode pieceTypeNode : pieceType_pageNode) {
            	
	        	// The following search search for a path on the themeNode Tree and return the node that matches this
        		
            	// These search for a path on the setNode Tree and return the node that matches this
	        	JsonNode idNode = pieceTypeNode.path("id");
	        	JsonNode nameNode = pieceTypeNode.path("name");
	        	
	        	// These return the data stored in the JsonNodes
	        	int id = idNode.asInt();
	        	String name = nameNode.textValue();
				
				pieceCategories.put(id, name);
        	}
    		
            // If their is another page of piece categories that needed to be collected from the api, then here this page will be called recursively using this class
            if (next != null) {
            	pieceType_page_uri = next + "&key=" + rebrickable_api_key;
            	getPieceTypePage(pieceType_page_uri, restTemplate);
            }

		}
        catch (JsonMappingException e) {
			e.printStackTrace();
		}
        catch (JsonProcessingException e) {
			e.printStackTrace();
		}
	}
}