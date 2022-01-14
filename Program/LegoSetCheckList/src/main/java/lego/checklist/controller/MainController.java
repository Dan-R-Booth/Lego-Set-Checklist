package lego.checklist.controller;

import java.util.Dictionary;
import java.util.Hashtable;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lego.checklist.domain.Theme;

//RestTemplate is used to perform HTTP request to a uri [1]

//The Jackson library is used for working with JSON [2]

/* References:
* [1]	"RestTemplate (Spring Framework 5.3.14 API)",
* 		Docs.spring.io, 2021. [Online].
* 		Available: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html.[Accessed: 02- Dec- 2021]
* [2]
*/

@Controller
public class MainController {
	public Dictionary<Integer, Theme> themes = new Hashtable<Integer, Theme>();
	
//	// This creates a RestTemplate JavaBean used to perform HTTP request to a uri
//	// I am using the 
//	// This is declared here in the main controller and is public so it can be 
//	@Bean
//	public RestTemplate restTemplate(RestTemplateBuilder builder) {
//		return builder.build();
//	}
	
	// This stores the basic uri to the Rebrickable API
	public final static String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
		
	// The api key used to access the Rebrickable api
	public final static String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	@RequestMapping("/")
	public String home(Model model) {
		return "index";
	}
	
	@EventListener(ApplicationReadyEvent.class)
	public void getThemes() {
		// This is the uri to all Lego themes in the Rebrickable API
		String themes_uri = rebrickable_uri + "themes/?key=" + rebrickable_api_key;

		RestTemplate restTemplate = new RestTemplate();
		
		getThemesPage(themes_uri, restTemplate);
	}
	
	// This gets all the Lego set themes using the Lego Set themes uri, starting with the first page of these Lego themes,
	// If there are other pages containing themes on the api, this class will then be called recursively to get all of these themes
	private void getThemesPage(String theme_page_uri, RestTemplate restTemplate) {
		// This uses restTemplate and the Lego theme uri to call the API and then transforms the returned JSON into a String
		String theme_page_JSON = restTemplate.getForObject(theme_page_uri, String.class);
		
		// This is wrapped in a try catch in case the string given to readTree() is not a JSON string
        try {
        	// This provides functionality for reading and writing JSON
        	ObjectMapper mapper = new ObjectMapper();
        	
        	// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
        	JsonNode theme_pageNode = mapper.readTree(theme_page_JSON);
        	
        	// These get and store the uri to the next page containing set pieces
        	JsonNode nextNode = theme_pageNode.path("next");
        	String next = nextNode.textValue();
			
        	// This provides the root of the JSON element where the JSON array of Lego pieces is stored
        	theme_pageNode = theme_pageNode.path("results");
        	
        	// This iterates through the JSON array of Lego pieces
            for (JsonNode themeNode : theme_pageNode) {
            	
	        	// The following search search for a path on the themeNode Tree and return the node that matches this
        		
            	// These search for a path on the setNode Tree and return the node that matches this
	        	JsonNode idNode = themeNode.path("id");
	        	JsonNode parent_idNode = themeNode.path("parent_id");
	        	JsonNode nameNode = themeNode.path("name");
	        	
	        	// These return the data stored in the JsonNodes
	        	int id = idNode.asInt();
	        	int parent_id = parent_idNode.asInt();
	        	String name = nameNode.textValue();
				
				Theme theme = new Theme(id, parent_id, name);
				
				themes.put(id, theme);
        	}
    		
            // If their is another page of pieces that needed to be collected from the api here this page will be called recursively using this class
            // and the piece list will be sent each time so when it is then returned it will contain all these pieces
            if (next != null) {
            	theme_page_uri = next + "&key=" + rebrickable_api_key;
            	getThemesPage(theme_page_uri, restTemplate);
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
