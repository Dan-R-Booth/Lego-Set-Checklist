package lego.checklist.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lego.checklist.domain.Theme;

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

public class ThemeController {
	// This creates a mapping so that I can get theme names and parent ids without having to call the API each time
	public static HashMap<Integer, Theme> themes = new HashMap<Integer, Theme>();
	
	// This list is used to store all the themes and is added to the model when searching for a Lego Set
	public static List<Theme> themeList = new ArrayList<>();
	
	// This stores the basic uri to the Rebrickable API
	private final static String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
		
	// The api key used to access the Rebrickable api
	private final static String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	
	public static void createThemeMap() {
		// This is the uri to all Lego themes in the Rebrickable API
		String themes_uri = rebrickable_uri + "themes/?key=" + rebrickable_api_key;

		RestTemplate restTemplate = new RestTemplate();
		
		getThemesPage(themes_uri, restTemplate);
		
		// This goes through every theme and sets the themes name to be the whole theme name including the parent theme name
		// It then also adds the theme to themeList
		for (int id : themes.keySet()) {
			// This calls the getTheme function to retrieve the full theme name of a theme,
        	// which requires the theme_id to find this
			String fullThemeName = getTheme(id);
			
			Theme theme = themes.get(id);
			
			theme.setName(fullThemeName);
			
			themeList.add(theme);
		}
		
		// This sorts the list of themes so they are in alphabetical order by name
		Collections.sort(themeList, new Comparator<Theme>() {
			@Override
			public int compare(Theme theme1, Theme theme2) {
				return theme1.getName().compareTo(theme2.getName());
			}
		});
		
		// This reverses the alphabetically sorted list adds a new theme to the end
		// and then reverse back, so this theme is at the start of the list.
		// This theme is a theme called "All Themes" that will be used when a user is
		// filtering by theme on the search page, and is give an id of -1 so that it
		// does not clash with any of the other theme ids which are all positive
		
		Collections.reverse(themeList);
		Theme allThemes = new Theme(-1, "All Themes");
		themeList.add(allThemes);
		
		Collections.reverse(themeList);
	}
	
	public static String getTheme(int theme_id) {
        Theme theme = themes.get(theme_id);

        String theme_name = "";
        
        // Checks to see if the theme's parent_id is 0, meaning their is no parent
		// If it is not 0 getTheme() recursively calls itself with the parent_id until there are no more parents,
		// and returns each of these parent theme names in front of child theme name 
		if (theme.getParent_id() != 0) {
			theme_name += getTheme(theme.getParent_id()) + " > " +  theme.getName();
		}
		else {
			// This return the name of the theme stored in the theme object
			theme_name = theme.getName();
		}
		
		// This sets the parent id to 0 as the parent theme name is now part of the entire theme name
		theme.setParent_id(0);
		
		return theme_name;
	}
	
	// This gets all the Lego set themes using the Lego Set themes uri, starting with the first page of these Lego themes,
	// If there are other pages containing themes on the api, this class will then be called recursively to get all of these themes
	private static void getThemesPage(String theme_page_uri, RestTemplate restTemplate) {
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
			
        	// This provides the root of the JSON element where the JSON array of Lego themes is stored
        	theme_pageNode = theme_pageNode.path("results");
        	
        	// This iterates through the JSON array of Lego themes
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
				
				Theme theme = new Theme(id, name, parent_id);
				
				themes.put(id, theme);
        	}
    		
            // If their is another page of themes that needed to be collected from the api, then here this page will be called recursively using this class
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
