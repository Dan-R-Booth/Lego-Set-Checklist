package lego.checklist.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.opencsv.CSVReader;

import lego.checklist.domain.Account;
import lego.checklist.domain.Piece;
import lego.checklist.domain.Set;
import lego.checklist.domain.Set_list;
import lego.checklist.domain.Theme;

// RestTemplate is used to perform HTTP request to a uri [1]

// The Jackson-core [2] and Jackson-databind [5] libraries is used for working with JSON

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

// The Set Controller handles the retrieval of Lego Set information, and views that involve Lego Sets.
@Controller
@SessionAttributes({"set", "searchURL"})
public class SetController {
	// This stores the basic uri to the Rebrickable API
	private final String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
	
	// The api key used to access the Rebrickable api
	private final String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	@GetMapping("/set")
	public String showSet(Model model, @RequestParam String set_number, @RequestParam(required = false) String set_variant, RestTemplate restTemplate, @SessionAttribute(value = "accountLoggedIn", required = false) Account account) {
		
		if (set_variant != null) {
			// As there are different versions of certain sets denoted by '-' and the version number,
			// the standard for all sets is '-1', so i added a second number box to show this with a
			// default value of '1' and the numbers are then combined into a string with the dash in-between.
			set_number += "-" + set_variant;
		}
		
		// This calls a function to get the Lego Set and if this fails it is caught here and then displayed to the user,
		// so the user knows that a Set with that particular set number could not be found
		try {
			Set set = getSet(model, set_number, restTemplate);
			
			// This gets a list of strings with each list containing a description and web link to an Lego instruction booklet for the Lego Set
			List<String[]> instructions = getInstructions(set_number, restTemplate);
			model.addAttribute("instructions", instructions);
			
			model.addAttribute("notFound", false);
			
			model.addAttribute("set", set);
		}
		catch (HttpClientErrorException e) {
			
			if (e.getRawStatusCode() == 404) {
				model.addAttribute("notFound", true);
			}
			else {
				System.out.println("Error: " + e);
			}
		}
		model.addAttribute("set_number", set_number);
		
		return "showSet";
	}
	
	@GetMapping("/search/text={text}/barOpen={barOpen}/sort={sort}/minYear={minYear}/maxYear={maxYear}/minPieces={minPieces}/maxPieces={maxPieces}/theme_id={theme_id}/uri/**")
	public String showSetPage(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @PathVariable("text") String searchText, @PathVariable("barOpen") String barOpen, @PathVariable("sort") String sort, @PathVariable("minYear") String minYear, @PathVariable("maxYear") String maxYear, @PathVariable("minPieces") String minPieces, @PathVariable("maxPieces") String maxPieces, @PathVariable("theme_id") String filteredTheme_id, RestTemplate restTemplate, HttpServletRequest request) {
		
		// These are used so I can get the uri to the Rebrickable API for the set page out of the whole page url
		String url = request.getRequestURI().toString() + "?" + request.getQueryString();
		String set_list_uri = url.split("/uri/")[1];
		
		model.addAttribute("searchURL", url);
		
		if (set_list_uri.equals("?null")) {
			// This is the uri to a gets sets in the Rebrickable API that match the text search
			set_list_uri = rebrickable_uri + "sets/?key=" + rebrickable_api_key + "&search=" + searchText;
		}
		
		// This is used so that if the filter or sort bar was open or no bar was open on the search page
		// otherwise if the user wasn't on the search page and this is empty then the filter bar starts off open
		model.addAttribute("barOpen", barOpen);
		
		// If there is a attribute the user would like to sort by this is added to the uri and the model
		if (!sort.equals("")) {
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
		if (!minYear.equals("")) {
			set_list_uri += "&min_year=" + minYear;
			model.addAttribute("minYear", minYear);
		}
		
		// If there is a max year the user would like to filter by this is added to the uri and the model
		if (!maxYear.equals("")) {
			set_list_uri += "&max_year=" + maxYear;
			model.addAttribute("maxYear", maxYear);
		}
		
		// If there is a minimum number of pieces the user would like to filter by this is added to the uri and the model
		if (!minPieces.equals("")) {
			set_list_uri += "&min_parts=" + minPieces;
			model.addAttribute("minPieces", minPieces);
		}
		
		// If there is a maximum number of pieces the user would like to filter by this is added to the uri and the model
		if (!maxPieces.equals("")) {
			set_list_uri += "&max_parts=" + maxPieces;
			model.addAttribute("maxPieces", maxPieces);
		}
		
		// If there is a theme_id the user would like to filter by this is added to the uri and the model
		if (!filteredTheme_id.equals("-1")) {
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
        model.addAttribute("themeList", ThemeController.themeList);
		return "search";
	}
	
	// This gets all the information and Lego pieces for a Lego Set that is received from the Rebrickable API via the Set Number
	private Set getSet(Model model, String set_number, RestTemplate restTemplate) {
		// This is the uri to a specific set in the Rebrickable API
		String set_uri = rebrickable_uri + "sets/" + set_number + "/?key=" + rebrickable_api_key;
		
		// The rest template created above is used to fetch the Lego set every time the website is loaded
		// and here it uses the Lego set uri to call the API and then transforms the returned JSON into a String
		String set_JSON = restTemplate.getForObject(set_uri, String.class);
		
		// Set's default values in case the following try catch statement fails
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
	
	/*
	 * Here I have combined code from two websites [3] and [4] to import and read a CSV file
	 * for a Lego Set checklist on a clients machine, as this was not vital to the main function of the program
	 */
	// This also takes values for filter and sort for the showPieceList page as if the import popup is on this page
	// it needs these values to return to the exact some page if the import fails
	@PostMapping("/openImport/previousPage={previousPage}")
	public String importPage(Model model, @RequestParam("importFile") MultipartFile importFile, RestTemplate restTemplate, @PathVariable("previousPage") String previousPage, @SessionAttribute(value = "set", required = false) Set previousSet, @RequestParam(required = false) String previous_set_number, @RequestParam(required = false) String sort, @RequestParam(required = false) List<Integer> quantityChecked, @RequestParam(required = false) String colourFilter, @RequestParam(required = false) String pieceTypeFilter, @RequestParam(required = false) Boolean hidePiecesFound, @RequestParam(required = false) Boolean hidePiecesNotFound, RedirectAttributes redirectAttributes) {
		// validate file
        if (importFile.isEmpty()) {
        		// This is used so the JSP page knows to inform the user that the import failed
        		// and why and is added to redirectAttributes so it stays after the page redirect
        		redirectAttributes.addFlashAttribute("message", "The file '" + importFile.getOriginalFilename() + "' is empty, please select a valid CSV file.");
        		redirectAttributes.addFlashAttribute("importError", true);
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
                
                // This updates every piece's quantity in the set, to match the quantity that is stored in the CSV file
                for (Piece piece : piece_list) {
                	for (String[] piece_checked : pieces_checked) {
                		if (piece_checked[0].equals(piece.getNum()) && piece_checked[1].equals(piece.getColour_name()) && piece_checked[2].equals(String.valueOf(piece.isSpare()))) {
                			piece.setQuantity_checked(Integer.parseInt(piece_checked[3]));
                		}
                	}
                }
                
                set.setPiece_list(piece_list);
                
                model.addAttribute("set", set);
                
                model.addAttribute("notFound", false);
                model.addAttribute("set_number", set_number);
                
                // This the displays the Set Page for the import Lego set the imported checklist is for
        		return "showSet";
            }
            catch (Exception ex) {
				// This is used so the JSP page knows to inform the user that the import failed
        		// and why and is added to redirectAttributes so it stays after the page redirect
				redirectAttributes.addFlashAttribute("message", "An error occurred while processing the file: '" + importFile.getOriginalFilename() + "'");
				redirectAttributes.addFlashAttribute("importError", true);
            }
        }
        
        // If the import fails and was called from the showPiece_list page this adds the values
        // inputed from that page so that the user is returned to the exact same page
        if (previousPage.equals("Set_Pieces")) {
        	// When quantityChecked (which holds the current quantities for each piece in the Lego Set)
    		// is parsed in this calls the updateQuantityChecked function in the PieceController class
        	// to update the quantity checked for each piece in the Lego set
    		if (quantityChecked != null) {
    			PieceController.updateQuantityChecked(previousSet, quantityChecked, previousSet.getPiece_list());
    		}
        	
	        // If their is a sort to be applied to the checklist (sort not null), then it is added to string
        	// thats added to the redirect as a requestParam
	 		if (sort != null) {
	 	    	redirectAttributes.addFlashAttribute("sort", sort);
	 		}
	    	
			String colourFilterRequestParam = "";

			// If the string colourFilter is parsed into the controller it is added to redirectAttributes as an addAttribute so can
			// be added to the string below as a URI variable and then this String can be added to the redirect as a requestParam.
			// If this value is added directly to the String and then to the redirect, the redirect will not work properly.
			// This is because any space will not be converted properly as "%20" but as added as a "+", however adding the string
			// as an attribute of redirectAttributes and then using this attribute converts these spaces properly.
			if (colourFilter != null) {
				redirectAttributes.addAttribute("colourFilter", colourFilter);
				colourFilterRequestParam = "&colourFilter={colourFilter}";
			}

			String pieceTypeFilterRequestParam = "";

			// If the string pieceTypeFilter is parsed into the controller it is added to redirectAttributes as an addAttribute so can
			// be added to the string below as a URI variable and then this String can be added to the redirect as a requestParam.
			// If this value is added directly to the String and then to the redirect, the redirect will not work properly.
			// This is because any space will not be converted properly as "%20" but as added as a "+", however adding the string
			// as an attribute of redirectAttributes and then using this attribute converts these spaces properly.
			if (pieceTypeFilter != null) {
				redirectAttributes.addAttribute("pieceTypeFilter", pieceTypeFilter);
				pieceTypeFilterRequestParam = "&pieceTypeFilter={pieceTypeFilter}";
			}

			String hidePiecesFoundRequestParam = "";

			// If the boolean hidePiecesFound is parsed into the controller, it is added to string
			// thats added to the redirect as a requestParam
			if (hidePiecesFound != null) {
				hidePiecesFoundRequestParam = "&hidePiecesFound=" + hidePiecesFound;
			}
			
			String hidePiecesNotFoundRequestParam = "";
			
			// If the boolean hidePiecesFound is parsed into the controller this adds it to the model
			if (hidePiecesNotFound != null) {
				hidePiecesNotFoundRequestParam = "&hidePiecesNotFound=" + hidePiecesNotFound;
			}
			
			// This redirects the user back to the set pieces page and will display the errors with the import
	    	return "redirect:/set/" + previous_set_number + "/pieces/?" + colourFilterRequestParam + pieceTypeFilterRequestParam + hidePiecesFoundRequestParam + hidePiecesNotFoundRequestParam;
        }
        else {
        	// This redirects the user back to the index page and will display the errors with the import
    		return "redirect:/";
        }
	}
	
	// This gets a list of strings with each list containing a description and web link to an Lego instruction booklet for the Lego Set
	@GetMapping("set/{set_number}/instructions")
	public List<String[]> getInstructions(@PathVariable String set_number, RestTemplate restTemplate) {
		// The api key used to access the Rebrickable api
		String brickset_api_key = "3-nRBM-AJHe-tAcxx";
		
		// This is the uri to a specific set in the Rebrickable API
		String setInstructions_uri = "https://brickset.com/api/v3.asmx/getInstructions2?apiKey=" + brickset_api_key + "&setNumber=" + set_number;

		// The rest template created above is used to fetch the Lego set instructions every time the website is loaded
		// and here it uses the Lego set instructions uri to call the Bricklink API and then transforms the returned JSON into a String
		String setInstructions_JSON = restTemplate.getForObject(setInstructions_uri, String.class);
		
		// This list holds all the instruction booklets returned by the API
		List<String[]> instructions = new ArrayList<>();
		
		// This is wrapped in a try catch in case the string given to readTree() is not a JSON string
        try {
        	// This provides functionality for reading and writing JSON
        	ObjectMapper mapper = new ObjectMapper();
        	
        	// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
        	JsonNode setInstructionBooksNode = mapper.readTree(setInstructions_JSON);
			
        	// This provides the root of the JSON element where the JSON array of Lego pieces is stored
        	setInstructionBooksNode = setInstructionBooksNode.path("instructions");
        	
        	// This iterates through the JSON array of Lego pieces
            for (JsonNode setInsructionBookNode : setInstructionBooksNode) {
            	
	        	// The following search searches for a path on the setInsructionBookNode Tree and return the node that matches this
	        	JsonNode urlNode = setInsructionBookNode.path("URL");
	        	JsonNode descriptionNode = setInsructionBookNode.path("description");
	        	
	        	// These return the data stored in the JsonNodes
	        	String url = urlNode.textValue();
	        	String description = descriptionNode.textValue();
	        	
	        	String[] instruction = {url, description};
	        	
	        	instructions.add(instruction);
        	}
		}
        catch (JsonMappingException e) {
			e.printStackTrace();
		}
        catch (JsonProcessingException e) {
			e.printStackTrace();
		}
        
        return instructions;
	}
	
	// This displays the page to display a logged in users set lists
	@GetMapping("/set_lists")
	public String showSetLists(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @SessionAttribute(value = "set_lists", required = false) List<Set_list> set_lists, @RequestParam(required = false) String searchText, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String sort, @RequestParam(required = false) String minSets, @RequestParam(required = false) String maxSets, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "access the 'Set Lists' page");
			return "redirect:/accessDenied";
		}
		
		// This is used so that if the filter or sort bar was open or no bar was open on the search page
		// otherwise if the user wasn't on the search page and this is empty then the filter bar starts off open
		model.addAttribute("barOpen", barOpen);
		
		// If their is a sort to be applied to the Sets in Progress, then the following is ran to apply this sort
		// (by default if no sort entered will be sorted by set_number ascending)
		// -- Start of Sort --
		if (sort == null) {
			sort = "listName";
		}
		
		String[] sorts = sort.split(",");
		
		model.addAttribute("sort1", sorts[0]);
		if (sorts.length == 2) {
			model.addAttribute("sort2", sorts[1]);
		}
		
		// This sorts the sets in progress by the sorts selected, it compares each set in the list
		// to one another while sorting, comparing by sort 1 and if they match sort 2 (if exists).
		// This calls a function to do the comparison of each Set and the sort in use too
		Collections.sort(set_lists, new Comparator<Set_list>() {
			@Override
			public int compare(Set_list setList1, Set_list setList2) {
				int sortValue = getSortValue(sorts[0], setList1, setList2);
				
				if (sortValue == 0 && sorts.length == 2) {
					sortValue = getSortValue(sorts[1], setList1, setList2);
				}
				
				return sortValue;
			}
		});
		// -- End of Sort --
		
		// If there is a text search being parsed this will add it to the model
		if (searchText != null) {
			model.addAttribute("searchText", searchText);
		}
		
		// If there is a min sets being parsed this will add it to the model
		if (minSets != null) {
			model.addAttribute("minYear", minSets);
		}
		
		// If there is a max sets being parsed this will add it to the model
		if (maxSets != null) {
			model.addAttribute("maxSets", maxSets);
		}
		
		model.addAttribute("num_setLists", set_lists.size());
		
		return "showSetLists";
	}
	
	// Compares two set lists by a sort and returns the value of the comparison
	private int getSortValue(String sort, Set_list setList1, Set_list setList2) {
		if (sort.equals("numSets")) {
    		// This compares the sets by Number of Sets ascending
			return setList1.getTotalSets() - setList2.getTotalSets();
    	}
    	else if (sort.equals("-numSets")) {
    		// This compares the sets by Number of Sets descending
			return setList2.getTotalSets() - setList1.getTotalSets();
    	}
    	else if (sort.equals("-listName")) {
    		// This compares the sets by List Name descending
    		return setList2.getListName().toUpperCase().compareTo(setList1.getListName().toUpperCase());
    	}
    	else {
			// This compares the sets by List Name ascending
			return setList1.getListName().toUpperCase().compareTo(setList2.getListName().toUpperCase());
		}
	}
}
