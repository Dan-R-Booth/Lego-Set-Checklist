package lego.checklist.controller;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lego.checklist.domain.Set;

@Controller
public class SetController {
	
	// This stores the basic uri to the Rebrickable API
	public final String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
	
	// The api key used to access the Rebrickable api
	public final String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	// This creates a RestTemplate JavaBean used to transform a JSON file into a class
	// I am using the 
	@Bean
	public RestTemplate restTemplate(RestTemplateBuilder builder) {
		return builder.build();
	}
	
	@RequestMapping("/search")
	public String search(Model model) {
		return "search";
	}
	
	@GetMapping("/set")
	public String showSet(Model model , @RequestParam String set_number, String set_variant, RestTemplate restTemplate) {
		
		// As there are different versions of certain sets denoted by '-' and the version number,
		// the standard for all sets is '-1', so i added a second number box to show this with a
		// default value of '1' and the numbers are then combined into a string with the dash in-between.
		set_number += "-" + set_variant;
		
		// This is the uri to a specific set in the Rebrickable API
		String set_uri = rebrickable_uri + "sets/" + set_number + "/?key=" + rebrickable_api_key;

		// The rest template created above is used to fetch the Lego set every time the website is loaded
		// and here it uses the Lego set uri to call the API and then transforms the returned JSON into a String
		String set_JSON = restTemplate.getForObject(set_uri, String.class);
		
		// Sets default values in case the following try catch statement fails
		String num = "";
		String name = "";
		int year = -1;
		String theme_name = "";
		int num_pieces = -1;
		String img_url = "";
		
        
        try {
        	
        	ObjectMapper mapper = new ObjectMapper();
			
        	JsonNode setNode = mapper.readTree(set_JSON);
			
        	JsonNode numNode = setNode.path("set_num");
        	JsonNode nameNode = setNode.path("name");
        	JsonNode yearNode = setNode.path("year");
        	JsonNode theme_idNode = setNode.path("theme_id");
        	JsonNode num_piecesNode = setNode.path("num_parts");
        	JsonNode img_urlNode = setNode.path("set_img_url");
        	
        	
        	num = numNode.textValue();
    		name = nameNode.textValue();
    		year = yearNode.intValue();
			
        	int theme_id = theme_idNode.asInt();
        	// This calls the getTheme function to retrieve the theme name of a Lego set,
        	// which requires the theme_id to find this
        	theme_name = getTheme(theme_id, restTemplate);
        	
        	num_pieces = num_piecesNode.intValue();
        	img_url = img_urlNode.textValue();
        	
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		Set set = new Set(num, name, year, theme_name, num_pieces, img_url);
		
		model.addAttribute("set", set);
		return "showSet";
	}
	
	@GetMapping
	public String getTheme(int theme_id, RestTemplate restTemplate) {
        String theme_name = "";
		
		// 
		try {
			// This is the uri to a specific theme in the Rebrickable API
			String theme_uri = rebrickable_uri + "themes/" + theme_id + "/?key=" + rebrickable_api_key;
			
			// The rest template is used to fetch the Lego set every time the website is loaded
			String theme_JSON = restTemplate.getForObject(theme_uri, String.class);
			
			
			ObjectMapper mapper = new ObjectMapper();
	        
	        
	        JsonNode themeNode = mapper.readTree(theme_JSON);
	        JsonNode theme_nameNode = themeNode.path("name");
	        JsonNode theme_parent_idNode = themeNode.path("parent_id");

	        
	        // Checks to see if the theme parent is null
			// If it is not null getTheme() recursively calls itself with the theme_parent_id until there are no more parents,
			// and returns each of these parent theme names in front of their child theme name 
			if (!theme_parent_idNode.isNull()) {
				int theme_parent_id = theme_parent_idNode.intValue();
				theme_name += getTheme(theme_parent_id, restTemplate) + ", " +  theme_nameNode.textValue();
			}
			else {
				theme_name = theme_nameNode.textValue();
			}
			
		}
		catch (JsonMappingException e) {
			e.printStackTrace();
		}
		catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return theme_name;
	}
}
