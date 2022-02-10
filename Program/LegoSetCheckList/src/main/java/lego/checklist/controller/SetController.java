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
import lego.checklist.domain.Set;
import lego.checklist.domain.Theme;

//RestTemplate is used to perform HTTP request to a uri [1]

//The Jackson-core [2] and Jackson-databind [5] libraries is used for working with JSON

/* References:
* [1]	"RestTemplate (Spring Framework 5.3.14 API)",
* 		Docs.spring.io, 2021. [Online].
* 		Available: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html.[Accessed: 02- Dec- 2021]
* [2]	"jackson-core 2.13.1 javadoc (com.fasterxml.jackson.core)",
*		Javadoc.io. [Online].
*		Available: https://javadoc.io/doc/com.fasterxml.jackson.core/jackson-core/latest/index.html. [Accessed: 05- Dec- 2021]
* [3]	Atta, "Uploading and Parsing CSV File using Spring Boot",
* 		Atta-Ur-Rehman Shah, 2020. [Online].
* 		Available: https://attacomsian.com/blog/spring-boot-upload-parse-csv-file. [Accessed: 04- Jan- 2022]
* [4]	Atta, "Reading and writing CSV files using OpenCSV",
* 		Atta-Ur-Rehman Shah, 2019. [Online].
* 		Available: https://attacomsian.com/blog/read-write-csv-files-opencsv. [Accessed: 03- Jan- 2022]
* [5]	"jackson-databind 2.13.1 javadoc (com.fasterxml.jackson.core)",
* 		Javadoc.io. [Online].
* 		Available: https://javadoc.io/doc/com.fasterxml.jackson.core/jackson-databind/latest/index.html. [Accessed: 05- Dec- 2021]
*/

@Controller
@SessionAttributes({"set", "searchURL"})
public class SetController {
	// This stores the basic uri to the Rebrickable API
	public final String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
	
	// The api key used to access the Rebrickable api
	public final String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
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
	
	@GetMapping("/search/text={text}/sort={sort}/minYear={minYear}/maxYear={maxYear}/minPieces={minPieces}/maxPieces={maxPieces}/theme_id={theme_id}/uri/**")
	public String showSetPage(Model model, @PathVariable("text") String searchText, @PathVariable("sort") String sort, @PathVariable("minYear") String minYear, @PathVariable("maxYear") String maxYear, @PathVariable("minPieces") String minPieces, @PathVariable("maxPieces") String maxPieces, @PathVariable("theme_id") String filteredTheme_id, RestTemplate restTemplate, HttpServletRequest request) {
		
		// These are used so I can get the uri to the Rebrickable API for the set page out of the whole page url
		String url = request.getRequestURI().toString() + "?" + request.getQueryString();
		String set_list_uri = url.split("/uri/")[1];
		
		model.addAttribute("searchURL", url);
		
		if (set_list_uri.equals("?null")) {
			// This is the uri to a gets sets in the Rebrickable API that match the text search
			set_list_uri = rebrickable_uri + "sets/?key=" + rebrickable_api_key + "&search=" + searchText;
		}
		
		// If there is a attribute the user would like to sort by this is added to the uri and the model
		if (sort != "") {
			String[] sorts = sort.split(",");
			
			set_list_uri += "&ordering=" + sort;
			
			model.addAttribute("sort1", sorts[0]);
			if (sorts.length >= 2) {
				model.addAttribute("sort2", sorts[1]);
			}
			
			if (sorts.length == 3) {
				model.addAttribute("sort3", sorts[2]);
			}
		}
		
		// If there is a min year the user would like to filter by this is added to the uri and the model
		if (minYear != "") {
			set_list_uri += "&min_year=" + minYear;
			model.addAttribute("minYear", minYear);
		}
		
		// If there is a max year the user would like to filter by this is added to the uri and the model
		if (maxYear != "") {
			set_list_uri += "&max_year=" + maxYear;
			model.addAttribute("maxYear", maxYear);
		}
		
		// If there is a minimum number of pieces the user would like to filter by this is added to the uri and the model
		if (minPieces != "") {
			set_list_uri += "&min_parts=" + minPieces;
			model.addAttribute("minPieces", minPieces);
		}
		
		// If there is a maximum number of pieces the user would like to filter by this is added to the uri and the model
		if (maxPieces != "") {
			set_list_uri += "&max_parts=" + maxPieces;
			model.addAttribute("maxPieces", maxPieces);
		}
		
		// If there is a theme_id the user would like to filter by this is added to the uri and the model
		if (filteredTheme_id != "") {
			set_list_uri += "&theme_id=" + filteredTheme_id;
			model.addAttribute("theme_id", filteredTheme_id);
		}
		
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
            	
            	// This gets the Theme relating to the theme_id from the HashMap themes set on start up in the theme_controller
            	// and then uses this theme to display the theme name to the user
            	Theme theme = ThemeController.themes.get(theme_id);
            	String theme_name = theme.getName();
            	
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
        
        model.addAttribute("previousPage", previous);
        model.addAttribute("nextPage", next);
        model.addAttribute("current", set_list_uri);
        model.addAttribute("searchText", searchText);
        model.addAttribute("sets", sets);
        model.addAttribute("themes", ThemeController.themes);
        model.addAttribute("themeList", ThemeController.themeList);
		return "search";
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
		List<Piece> piece_list = new ArrayList<>();
		
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
        	
        	// This gets the Theme relating to the theme_id from the HashMap themes set on start up in the theme_controller
        	// and then uses this theme to display the theme name to the user
        	Theme theme = ThemeController.themes.get(theme_id);
        	theme_name = theme.getName();
        	
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
	
	@GetMapping("/import")
	public String importPage(Model model) {
		return "importPage";
	}
	
	/*
	 * Here I have combined code from two websites [3] and [4] to import and read a CSV file
	 * for a Lego Set checklist on a clients machine, as this was not vital to the main function of the program
	 */
	@PostMapping("/openImport/url/**")
	public String importPage(Model model, @RequestParam("importFile") MultipartFile importFile, RestTemplate restTemplate, HttpServletRequest request) {
		
		// These are used so I can get the uri to the Rebrickable API for the set page out of the whole page url
		String url = request.getRequestURI().toString() + "?" + request.getQueryString();
		String previous_page_url = url.split("/url/")[1];
		
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
                
                List<Piece> piece_list = set.getPiece_list();
                
                for (Piece piece : piece_list) {
                	for (String[] piece_checked : pieces_checked) {
                		if (piece_checked[0].equals(piece.getNum()) && piece_checked[1].equals(piece.getColour_name()) && piece_checked[2].equals(String.valueOf(piece.isSpare()))) {
                			piece.setQuantity_checked(Integer.parseInt(piece_checked[3]));
                		}
                	}
                }
                
                set.setPiece_list(piece_list);
                
                model.addAttribute("set", set);
        		return "showSet";
            } catch (Exception ex) {
                model.addAttribute("message", "An error occurred while processing the file.");
                model.addAttribute("error", true);
            }
        }
		
        return previous_page_url;
	}
}
