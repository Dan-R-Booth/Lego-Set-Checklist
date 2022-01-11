package lego.checklist.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.opencsv.CSVReader;

import lego.checklist.domain.Piece;
import lego.checklist.domain.Piece_list;
import lego.checklist.domain.Set;

//RestTemplate is used to perform HTTP request to a uri [1]

//The Jackson library is used for working with JSON [2]

/* References:
* [1]	"RestTemplate (Spring Framework 5.3.14 API)",
* 		Docs.spring.io, 2021. [Online].
* 		Available: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html.[Accessed: 02- Dec- 2021]
* [2]
* [3]	Atta, "Uploading and Parsing CSV File using Spring Boot",
* 		Atta-Ur-Rehman Shah, 2020. [Online].
* 		Available: https://attacomsian.com/blog/spring-boot-upload-parse-csv-file. [Accessed: 04- Jan- 2022]
* [4]	Atta, "Reading and writing CSV files using OpenCSV",
* 		Atta-Ur-Rehman Shah, 2019. [Online].
* 		Available: https://attacomsian.com/blog/read-write-csv-files-opencsv. [Accessed: 03- Jan- 2022]
*/ 

@Controller
@SessionAttributes("set")
public class SetController {
	// This stores the basic uri to the Rebrickable API
	public final String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
	
	// The api key used to access the Rebrickable api
	public final String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	@GetMapping("/search")
	public String search(Model model) {
		return "search";
	}
	
	@GetMapping("/set")
	public String showSet(Model model, @RequestParam String set_number, @RequestParam(required = false) String set_variant, RestTemplate restTemplate) {
		
		if (set_variant != null) {
			// As there are different versions of certain sets denoted by '-' and the version number,
			// the standard for all sets is '-1', so i added a second number box to show this with a
			// default value of '1' and the numbers are then combined into a string with the dash in-between.
			set_number += "-" + set_variant;
		}
		
		Set set = getSet(model, set_number, restTemplate);
		
		model.addAttribute("set", set);
		return "showSet";
	}
	
	@GetMapping("/sets")
	public String showSets(Model model, @RequestParam("text") String searchText, @RequestParam(required = false) String sort, RestTemplate restTemplate) {
		// This is the uri to a gets sets in the Rebrickable API that match the text search
		// The page size is set to 12, so that I don't get an error 429 Too Many Requests response from the Rebrickable API
		String set_list_uri = rebrickable_uri + "sets/?key=" + rebrickable_api_key + "&search=" + searchText + "&page_size=12";

		if (sort != null) {
			set_list_uri += "&ordering=" + sort;
			model.addAttribute("sort", sort);
		}
		
		// This calls the getSets class to get all the Lego Sets that match the search condition
		List<Set> sets =  getSets(model, set_list_uri, restTemplate);
		
        model.addAttribute("searchText", searchText);
        model.addAttribute("sets", sets);
		return "showSets";
	}
	
	@GetMapping("sets/page/{text}/sort={sort}/uri/**")
	public String showSetPage(Model model, @PathVariable("text") String searchText, @PathVariable(required = false) String sort, RestTemplate restTemplate, HttpServletRequest request) {
		
		// These are used so I can get the uri to the Rebrickable API for the set page out of the whole page url
		String url = request.getRequestURI().toString();
		String query = request.getQueryString();
		url += "?" + query;
		String set_list_uri = url.split("/uri/")[1];
		
		if (sort != null) {
			model.addAttribute("sort", sort);
		}
		
		// This calls the getSets class to get all the Lego Sets that match the search condition
		List<Set> sets =  getSets(model, set_list_uri, restTemplate);
		
        model.addAttribute("searchText", searchText);
        model.addAttribute("current", set_list_uri);
        model.addAttribute("sets", sets);
		return "showSets";
	}
	
	private Set getSet(Model model, String set_number, RestTemplate restTemplate) {
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
		Piece_list piece_list = null;
		
        // This is wrapped in a try catch in case the string given to readTree() is not a JSON string
        try {
        	// This provides functionality for reading and writing JSON
        	ObjectMapper mapper = new ObjectMapper();
			
        	// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
        	JsonNode setNode = mapper.readTree(set_JSON);
			
        	// The following search search for a path on the setNode Tree and return the node that matches this
        	JsonNode numNode = setNode.path("set_num");
        	JsonNode nameNode = setNode.path("name");
        	JsonNode yearNode = setNode.path("year");
        	JsonNode theme_idNode = setNode.path("theme_id");
        	JsonNode num_piecesNode = setNode.path("num_parts");
        	JsonNode img_urlNode = setNode.path("set_img_url");
        	
        	// These return the data stored in the JsonNodes
        	num = numNode.textValue();
    		name = nameNode.textValue();
    		year = yearNode.intValue();
			
    		// This return the int stored in the JsonNode theme_idNode
        	int theme_id = theme_idNode.asInt();
        	// This calls the getTheme function to retrieve the theme name of a Lego set,
        	// which requires the theme_id to find this
        	theme_name = getTheme(theme_id, restTemplate);
        	
        	// These return the data stored in JsonNodes
        	num_pieces = num_piecesNode.intValue();
        	img_url = img_urlNode.textValue();
        	
        	// This calls the getPieces class to get all the pieces in a Lego Set
        	piece_list = PieceController.getPieces(model, set_number, restTemplate);
        	
		}
        catch (JsonMappingException e) {
			e.printStackTrace();
		}
        catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		Set set = new Set(num, name, year, theme_name, num_pieces, img_url, piece_list);

		return set;
	}
	
	private List<Set> getSets(Model model, String set_list_uri, RestTemplate restTemplate) {
		// The rest template created above is used to fetch the Lego set every time the website is loaded
		// and here it uses the Lego sets uri to call the API and then transforms the returned JSON into a String
		String set_list_JSON = restTemplate.getForObject(set_list_uri, String.class);
		
		// This creates an array list to store all the Lego Sets that match the search condition
		List<Set> sets =  new ArrayList<>();
		
		// These store the next and previous pages of results, declared here in case try statement fails
		String next = "";
		String previous = "";
		
		// This is wrapped in a try catch in case the string given to readTree() is not a JSON string
        try {
        	// This provides functionality for reading and writing JSON
        	ObjectMapper mapper = new ObjectMapper();
        	
        	// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
        	JsonNode set_listNode = mapper.readTree(set_list_JSON);
        	
        	// These get and store the uri to the next and previous pages containing sets
        	JsonNode nextNode = set_listNode.path("next");
        	next = nextNode.textValue();
        	
        	JsonNode previousNode = set_listNode.path("previous");
        	previous = previousNode.textValue();
			
        	// This provides the root of the JSON element where the JSON array of Lego pieces is stored
        	set_listNode = set_listNode.path("results");
        	
        	// This iterates through the JSON array of Lego sets and gets all the data for
        	// each set except Lego Pieces as these will not be needed yet
            for (JsonNode setNode : set_listNode) {
        		
            	// The following search search for a path on the setNode Tree and return the node that matches this
            	JsonNode numNode = setNode.path("set_num");
            	JsonNode nameNode = setNode.path("name");
            	JsonNode yearNode = setNode.path("year");
            	JsonNode theme_idNode = setNode.path("theme_id");
            	JsonNode num_piecesNode = setNode.path("num_parts");
            	JsonNode img_urlNode = setNode.path("set_img_url");
	        	
            	// These return the data stored in the JsonNodes
            	String num = numNode.textValue();
        		String name = nameNode.textValue();
        		int year = yearNode.intValue();
    			
        		// This return the int stored in the JsonNode theme_idNode
            	int theme_id = theme_idNode.asInt();
            	// This calls the getTheme function to retrieve the theme name of a Lego set,
            	// which requires the theme_id to find this
            	String theme_name = getTheme(theme_id, restTemplate);
            	
            	// These return the data stored in JsonNodes
            	int num_pieces = num_piecesNode.intValue();
            	String img_url = img_urlNode.textValue();
            	
            	Set set = new Set(num, name, year, theme_name, num_pieces, img_url);
            	
            	sets.add(set);
            }
        }
        catch (JsonMappingException e) {
			e.printStackTrace();
		}
        catch (JsonProcessingException e) {
			e.printStackTrace();
		}
        
        model.addAttribute("nextPage", next);
        model.addAttribute("previousPage", previous);
        
        return sets;
	}
	
	@GetMapping
	private String getTheme(int theme_id, RestTemplate restTemplate) {
        String theme_name = "";
		
        // This is wrapped in a try catch in case the string given to readTree() is not a JSON string
		try {
			// This is the uri to a specific theme in the Rebrickable API
			String theme_uri = rebrickable_uri + "themes/" + theme_id + "/?key=" + rebrickable_api_key;
			
			// The rest template is used to fetch the Lego set every time the website is loaded
			String theme_JSON = restTemplate.getForObject(theme_uri, String.class);
			
			// This provides functionality for reading and writing JSON
			ObjectMapper mapper = new ObjectMapper();
	        
			// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
	        JsonNode themeNode = mapper.readTree(theme_JSON);
	        
	        // These search search for a path on the setNode Tree and return the node that matches this
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
				// This return the data stored in the JsonNode theme_nameNode
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
	
	@GetMapping("/import")
	public String importPage(Model model) {
		return "importPage";
	}
	
	/*
	 * Here I have combined code from two websites [3] and [4] to import and read a CSV file
	 * for a Lego Set checklist on a clients machine, as this was not vital to the main function of the program
	 */
	@PostMapping("/openImport")
	public String importPage(Model model, @RequestParam("importFile") MultipartFile importFile, RestTemplate restTemplate) {
		
		// validate file
        if (importFile.isEmpty()) {
            model.addAttribute("message", "Please select a CSV file to upload.");
            model.addAttribute("error", true);
        } else {
            // parse CSV file to create a list of `User` objects
            try {
            	
            	Reader reader = new BufferedReader(new InputStreamReader(importFile.getInputStream()));
                
            	// create csv reader
                CSVReader csvReader = new CSVReader(reader);
                
                String set_number = csvReader.readNext()[0];
                
                List<String[]> pieces_checked = new ArrayList<>();
                
                // read one record at a time
                String[] record;
                
                while ((record = csvReader.readNext()) != null) {
                	pieces_checked.add(record);
                }
                
                csvReader.close();
                
                Set set = getSet(model, set_number, restTemplate);
                
                Piece_list set_pieces = set.getSet_pieces();
                
                for (Piece piece : set_pieces.getPieces()) {
                	for (String[] piece_checked : pieces_checked) {
                		if (piece_checked[0].equals(piece.getNum()) && piece_checked[1].equals(piece.getColour_name()) && piece_checked[2].equals(String.valueOf(piece.isSpare()))) {
                			piece.setQuantity_checked(Integer.parseInt(piece_checked[3]));
                		}
                	}
                }
                
                set.setSet_pieces(set_pieces);
                
                model.addAttribute("set", set);
        		return "showSet";
            } catch (Exception ex) {
                model.addAttribute("message", "An error occurred while processing the CSV file.");
                model.addAttribute("error", true);
            }
        }
		
        return "importPage";
	}
}
