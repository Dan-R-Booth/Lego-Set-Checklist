package lego.checklist.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.opencsv.CSVWriterBuilder;
import com.opencsv.ICSVWriter;

import lego.checklist.domain.Account;
import lego.checklist.domain.Minifigure;
import lego.checklist.domain.Piece;
import lego.checklist.domain.PieceFound;
import lego.checklist.domain.Set;
import lego.checklist.domain.SetInProgress;
import lego.checklist.repository.PieceFoundRepository;
import lego.checklist.repository.SetInProgressRepository;

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
@SessionAttributes("set")
public class PieceController {
	// This stores the basic uri to the Rebrickable API
	private final static String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
		
	// The api key used to access the Rebrickable api
	private final static String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	@Autowired
	private SetInProgressRepository setInProgessRepo;
	
	@Autowired
	private PieceFoundRepository pieceFoundRepo;
		
	@GetMapping("set/{set_number}/pieces")
	public String showPieces(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @PathVariable String set_number, @ModelAttribute("set") Set set, @RequestParam(required = false) String sort, @RequestParam(required = false) List<Integer> quantityChecked, @RequestParam(required = false) String colourFilter, @RequestParam(required = false) String pieceTypeFilter, @RequestParam(required = false) Boolean hidePiecesFound, @RequestParam(required = false) Boolean hidePiecesNotFound) {
		
		// This gets all the pieces in a Lego Set
		List<Piece> piece_list = set.getPiece_list();
		
		// When quantityChecked (which holds the current quantities for each piece in the Lego Set)
		// is parsed in this calls the updateQuantityChecked function to update the quantity checked
		// for each piece in the Lego set
		if (quantityChecked != null) {
			updateQuantityChecked(set, quantityChecked, piece_list);
		}
		// Otherwise, if the user is logged in and the sets progress is saved to the database this updates
		// every piece's quantity in the set, to match the quantity that is stored in the database
		else if ((account != null) && (setInProgessRepo.findByAccountAndSet(account, set) != null)) {
    		SetInProgress setInProgress = setInProgessRepo.findByAccountAndSet(account, set);
    		List<PieceFound> piecesFound = pieceFoundRepo.findBySetInProgress(setInProgress);
    		
    		for (Piece piece : piece_list) {
            	for (PieceFound pieceFound : piecesFound) {
            		if (pieceFound.getPieceNumber().equals(piece.getNum()) && pieceFound.getColourName().equals(piece.getColour_name()) && pieceFound.isSpare() == piece.isSpare()) {
            			piece.setQuantity_checked(pieceFound.getQuantityFound());
            		}
            	}
            }
    		
    		set.setPiece_list(piece_list);
    	}
		
		// If their is a sort to be applied to the checklist (sorts not null), then the following is ran to apply this sort
		if (sort != null) {
			
    		// This sorts the list of pieces so they are in alphabetical order by Piece Number
    		Collections.sort(piece_list, new Comparator<Piece>() {
    			@Override
    			public int compare(Piece piece1, Piece piece2) {
    				
    				if (sort.equals("pieceNumber")) {
    					// This compares the pieces by Piece Number ascending
    					return piece1.getNum().compareTo(piece2.getNum());
    		    	}
    				else if (sort.equals("-pieceNumber")) {
    					// This compares the pieces by Piece Number descending
    					return piece2.getNum().compareTo(piece1.getNum());
    		    	}
    				else if (sort.equals("pieceName")) {
    					// This compares the pieces by Piece Name ascending
    					return piece1.getName().toUpperCase().compareTo(piece2.getName().toUpperCase());
    		    	}
    				else if (sort.equals("-pieceName")) {
    					// This compares the pieces by Piece Name descending
    					return piece2.getName().toUpperCase().compareTo(piece1.getName().toUpperCase());
    		    	}
    				else if (sort.equals("colour")) {
    					// This compares the pieces by Colour ascending
    					return piece1.getColour_name().toUpperCase().compareTo(piece2.getColour_name().toUpperCase());
    		    	}
    				else if (sort.equals("-colour")) {
    					// This compares the pieces by Colour descending
    					return piece2.getColour_name().toUpperCase().compareTo(piece1.getColour_name().toUpperCase());
    		    	}
    				else if (sort.equals("type")) {
    					// This compares the pieces by Piece Type ascending
    					return piece1.getColour_name().toUpperCase().compareTo(piece2.getColour_name().toUpperCase());
    		    	}
    				else if (sort.equals("-type")) {
    					// This compares the pieces by Piece Type descending
    					return piece2.getPieceType().toUpperCase().compareTo(piece1.getPieceType().toUpperCase());
    		    	}
    				else if (sort.equals("quantity")) {
    					// This compares the pieces by Quantity ascending
    					return piece1.getQuantity() - piece2.getQuantity();
    		    	}
    				else if (sort.equals("-quantity")) {
    					// This compares the pieces by Quantity Found descending
    					return piece2.getQuantity() - piece1.getQuantity();
    		    	}
    				else if (sort.equals("quantityFound")) {
    					// This compares the pieces by Quantity Found ascending
    					return piece1.getQuantity_checked() - piece2.getQuantity_checked();
    		    	}
    				else {
    					// This compares the pieces by Quantity descending
    					return piece2.getQuantity_checked() - piece1.getQuantity_checked();
    		    	}
    			}
    		});
	    	
	    	model.addAttribute("sort", sort);
		}

		// If there is a colour filters being parsed this will add an array of these to the model
		// Otherwise it will just add the string All_Colours
		if (colourFilter != null) {
			if (colourFilter.equals("none")) {
				model.addAttribute("colourFilter", "none");
			}
			else {
				String[] colourFilterArray = colourFilter.split(">");
				
				model.addAttribute("colourFilter", colourFilterArray);
			}
		}
		else {
			model.addAttribute("colourFilter", "All_Colours");
		}
		
		// If there is a piece type filters being parsed this will add an array of these to the model
		// Otherwise it will just add the string All_PieceTypes
		if (pieceTypeFilter != null) {
			if (pieceTypeFilter.equals("none")) {
				model.addAttribute("pieceTypeFilter", "none");
			}
			else {
				String[] pieceTypeFilterArray = pieceTypeFilter.split(">");
				
				model.addAttribute("pieceTypeFilter", pieceTypeFilterArray);
			}
		}
		else {
			model.addAttribute("pieceTypeFilter", "All_PieceTypes");
		}
		
		// If the boolean hidePiecesFound is parsed into the controller this adds it to the model
		if (hidePiecesFound != null) {
			model.addAttribute("hidePiecesFound", hidePiecesFound);
		}
		
		// If the boolean hidePiecesNotFound is parsed into the controller this adds it to the model
		if (hidePiecesNotFound != null) {
			model.addAttribute("hidePiecesNotFound", hidePiecesNotFound);
		}
		
		// This calls a function that adds all the colours to a list that is used to display options to filter the list by colours
		// This function also adds all the piece types to another list that is used to display options to filter the list by types
		// of Lego pieces
		getColoursAndPieceTypes(model, set);
		
    	model.addAttribute("set_number", set.getNum());
    	model.addAttribute("num_items", piece_list.size());
		return "showPiece_list";
	}
	
	// Updates the quantity of pieces found for a Set object
	public static void updateQuantityChecked(Set set, List<Integer> quantityChecked, List<Piece> piece_list) {
		for (int i = 0; i < piece_list.size(); i++) {
			Piece piece = piece_list.get(i);
			piece.setQuantity_checked(quantityChecked.get(i));
		}
		
		set.setPiece_list(piece_list);
	}
	
	// This adds all the colours to a list that is used to display options to filter the list by colours
	// This also adds all the piece types to another list that is used to display options to filter the list by types of Lego pieces
	public static void getColoursAndPieceTypes(Model model, Set set) {
		List<String> colours = new ArrayList<>();
		List<String> pieceTypes = new ArrayList<>();
		
		for (Piece piece : set.getPiece_list()) {
			String colour = piece.getColour_name();
			
			if (!colours.contains(colour)) {
				colours.add(colour);
			}
			
			String pieceType = piece.getPieceType();
			
			if (!pieceTypes.contains(pieceType)) {
				pieceTypes.add(pieceType);
			}
		}
		
		Collections.sort(colours);
		Collections.sort(pieceTypes);
		
		model.addAttribute("colours", colours);
		model.addAttribute("pieceTypes", pieceTypes);
	}
	
	public static List<Piece> getPieces(Model model, @PathVariable String set_number, RestTemplate restTemplate) {
		// This is the uri to the specific pieces in a set in the Rebrickable API
		String piece_list_uri = rebrickable_uri + "sets/" + set_number + "/parts/?key=" + rebrickable_api_key;
		
		// This creates an array list to store all the Lego pieces needed to build a Lego set
		// This is then passed to the classes getPiece_listPage and getMinifigurePiece_list to
		// Retrieve all the Lego Pieces for the set
		List<Piece> pieces =  new ArrayList<>();
		
		// This calls the getPiece_listPage class that gets all the pieces in the Lego Set
		pieces = getPiece_listPage(piece_list_uri, pieces, restTemplate);
		
		// This is the uri to the specific pieces in a set in the Rebrickable API
		String minifigure_list_uri = rebrickable_uri + "sets/" + set_number + "/minifigs/?key=" + rebrickable_api_key;
		
		// This calls the getMinifigurePiece_list class that gets all the pieces for all the minifigures in the Lego Set
		pieces = getMinifigurePiece_list(minifigure_list_uri, pieces, restTemplate);
		
		// This creates an array list to store all the Lego pieces needed to build a Lego set
		List<String> pieces_added = new ArrayList<>();
		
		// This creates a new array list to store all the pieces needed to build a Lego set, without duplicates
		List<Piece> updated_pieces = new ArrayList<>();
		
		// This goes through each piece in the pieces array and then iterates through the array again to find all the pieces
		// and total up their quantity. This new quantity is then set as the new quantity of the piece and added to the updated piece array
		// Unique identifier string for each piece is also added to a list, that is then used to stop duplicate pieces whose quantity has already
		// been added being added to the unique piece list again
		for (Piece piece : pieces) {
			boolean added = false;
			
			// Checks if the Lego piece has already been added to the updated_piece list
			for (String added_piece : pieces_added) {
				// This adds the number, colour name and if its a spare of the piece,
    			// as these values uniquely identity each Lego piece
				String piece_num_colour = piece.getNum() + piece.getColour_name() + piece.isSpare();
				if (piece_num_colour.equals(added_piece)) {
					added = true;
				}
			}
			
			// This only runs if this piece has not already had duplicates removed and has been added to the updated_piece list
			if (added == false) {

				Piece updated_piece = piece;
			
				pieces_added.add(piece.getNum() + piece.getColour_name() + piece.isSpare());
	
				int new_quantity = 0;
				int new_quantity_checked = 0;
				
				for (Piece other_piece : pieces) {
					// Checks if the pieces are the same using piece number, colour and if they are spare
					// and if they are adds the quantity and quantity_checked to the new quantity and new quantity checked
					if ((updated_piece.getNum()).equals(other_piece.getNum()) && (updated_piece.getColour_name()).equals(other_piece.getColour_name()) && updated_piece.isSpare() == other_piece.isSpare()) {
						new_quantity += other_piece.getQuantity();
						new_quantity_checked += other_piece.getQuantity_checked();
					}
				}
				// These add the total quantity of all pieces that are the same, and total of these found to the updated_piece
				// This updated_piece is then added to the list of all pieces in the Lego Set
				updated_piece.setQuantity(new_quantity);
				updated_piece.setQuantity_checked(new_quantity_checked);
				updated_pieces.add(updated_piece);
			}
		}
    	
    	return updated_pieces;
	}
	
	// This gets all the pieces in the Lego Set using the Lego Set pieces uri, starting with the first page of these Lego piece list,
	// If there are other pages containing pieces on the api, this class will then be called recursively to get all of these pieces
	public static List<Piece> getPiece_listPage(String piece_list_uri, List<Piece> pieces, RestTemplate restTemplate) {
		// This makes the program wait one second before making an API call to stop a Too Many Requests error and timeout from the API
		try {
			Thread.sleep(1000);
		}
		catch (Exception e) {}
		
		// This uses restTemplate and the Lego set piece uri to call the API and then transforms the returned JSON into a String
		String piece_list_JSON = restTemplate.getForObject(piece_list_uri, String.class);
		
		// This is wrapped in a try catch in case the string given to readTree() is not a JSON string
        try {
        	// This provides functionality for reading and writing JSON
        	ObjectMapper mapper = new ObjectMapper();
        	
        	// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
        	JsonNode piece_listNode = mapper.readTree(piece_list_JSON);
        	
        	// These get and store the uri to the next page containing set pieces
        	JsonNode nextNode = piece_listNode.path("next");
        	String next = nextNode.textValue();
			
        	// This provides the root of the JSON element where the JSON array of Lego pieces is stored
        	piece_listNode = piece_listNode.path("results");
        	
        	// This iterates through the JSON array of Lego pieces
            for (JsonNode pieceNode : piece_listNode) {
            	
	        	// The following search search for a path on the pieceNode Tree and return the node that matches this
        		
        		// As the piece number, name, img url and piece url are stored as an element of part, I first have to get the part node to retrieve these
	        	JsonNode partNode = pieceNode.path("part");
	        	JsonNode numNode = partNode.path("part_num");
	        	JsonNode nameNode = partNode.path("name");
	        	JsonNode pieceTypeIdNode = partNode.path("part_cat_id");
	        	JsonNode img_urlNode = partNode.path("part_img_url");
	        	JsonNode piece_urlNode = partNode.path("part_url");
	        	
	        	// As the colour name is stored as an element of color, I first have to get the color node to retrieve this
	        	JsonNode colourNode = pieceNode.path("color");
	        	JsonNode colour_nameNode = colourNode.path("name");
	        	
	        	JsonNode quantityNode = pieceNode.path("quantity");
	        	JsonNode spare_partNode = pieceNode.path("is_spare");
	        	
	        	// These return the data stored in the JsonNodes
	        	String num = numNode.textValue();
	        	String name = nameNode.textValue();
	        	int pieceTypeId = pieceTypeIdNode.asInt();
	        	String pieceType = PieceTypeController.pieceCategories.get(pieceTypeId);
	        	String img_url = img_urlNode.textValue();
	        	String piece_url = piece_urlNode.textValue();
	        	String colour_name = colour_nameNode.textValue();
	    		int quantity = quantityNode.intValue();
	    		boolean spare = spare_partNode.asBoolean();
	        	
	        	// This is set to 0 as the user may not have checked any of these pieces yet
				int quantity_checked = 0;
				
				Piece piece = new Piece(num, name, pieceType, img_url, piece_url, colour_name, quantity, quantity_checked, spare);
				
				pieces.add(piece);
        	}
    		
            // If their is another page of pieces that needed to be collected from the api here this page will be called recursively using this class
            // and the piece list will be sent each time so when it is then returned it will contain all these pieces
            if (next != null) {
            	piece_list_uri = next + "&key=" + rebrickable_api_key;
            	pieces = getPiece_listPage(piece_list_uri, pieces, restTemplate);
            }

		}
        catch (JsonMappingException e) {
			e.printStackTrace();
		}
        catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return pieces;
	}
	
	// This returns a piece_list for pieces needed to build all the minifigures in a Lego set
	public static List<Piece> getMinifigurePiece_list(String minifigure_list_uri, List<Piece> pieces, RestTemplate restTemplate) {
		// This makes the program wait one second before making an API call to stop a Too Many Requests error and timeout from the API
		try {
			Thread.sleep(1000);
		}
		catch (Exception e) {}
		
		// This creates an array list to store all the Lego pieces needed to build a Lego set
		// This is declared here in case the try catch statement, in the getPiece_ListPage Class, fails
		List<Minifigure> minifigures = new ArrayList<>();
		
		// This calls the getMinifigurePieces function that gets all the pieces in the Lego Set
		minifigures = getMinifigure_ListPage(minifigure_list_uri, minifigures, restTemplate);
		
		// This creates an array list to store all the minfigure pieces needed to build all the minifigures in a Lego set
		List<Piece> minifigure_pieces = new ArrayList<>();
		
		for (Minifigure minifigure : minifigures) {
			List<Piece> minifigure_piece_list = minifigure.getMinifigure_pieces();
			for (Piece piece : minifigure_piece_list) {
				pieces.add(piece);
			}
		}
		
		pieces.addAll(minifigure_pieces);
		
		return pieces;
	}
	
	// This gets all the minifigures in the Lego Set using the minifigure list uri, starting with the first page of these Lego minifigures,
	// If there are other pages containing minifigures on the api, this class will then be called recursively to get all of these minifigures
	public static List<Minifigure> getMinifigure_ListPage(String minifigure_list_uri, List<Minifigure> minifigures, RestTemplate restTemplate) {
		// This uses restTemplate and the Lego set uri to call the API and then transforms the returned JSON into a String
		String minifigure_JSON = restTemplate.getForObject(minifigure_list_uri, String.class);
		
		// This is wrapped in a try catch in case the string given to readTree() is not a JSON string
        try {
        	// This provides functionality for reading and writing JSON
        	ObjectMapper mapper = new ObjectMapper();
        	
        	// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
        	JsonNode minifigure_listNode = mapper.readTree(minifigure_JSON);
        	
        	JsonNode nextNode = minifigure_listNode.path("next");
        	String next = nextNode.textValue();
			
        	// This provides the root of the JSON element where the JSON array of Lego pieces is stored
        	minifigure_listNode = minifigure_listNode.path("results");
        	
        	// This iterates through the JSON array of Lego pieces
            for (JsonNode minifigureNode : minifigure_listNode) {
    	        	
            	JsonNode spare_partNode = minifigureNode.path("is_spare");
    	        	
            	// This removes any pieces that are classed as spare pieces for the Lego set and are therefore not needed to build it
            	if (!spare_partNode.asBoolean()) {
            	
            		// These search for a path on the setNode Tree and return the node that matches this
                	JsonNode numNode = minifigureNode.path("set_num");
                	JsonNode nameNode = minifigureNode.path("set_name");
                	JsonNode img_urlNode = minifigureNode.path("set_img_url");
                	JsonNode quantityNode = minifigureNode.path("quantity");
                	
                	// These return the data stored in the JsonNodes
                	String num = numNode.textValue();
            		String name = nameNode.textValue();
                	String img_url = img_urlNode.textValue();
                	int quantity = quantityNode.intValue();
                	
                	// This is set to 0 as the user may not have checked any of these pieces yet
    				int quantity_checked = 0;
                	
                	// This is the uri to the specific pieces in a set in the Rebrickable API
            		String piece_list_uri = rebrickable_uri + "minifigs/" + num + "/parts/?key=" + rebrickable_api_key;
                	
            		// This creates an array list to store all the Lego pieces needed to build a Lego set
            		// This is declared here in case the try catch statement, in the getPiece_listPage Class, fails
            		List<Piece> piece_list = new ArrayList<>();
            		
            		// This calls the getPiece_listPage class that gets all the pieces in the Lego Set
            		piece_list = PieceController.getPiece_listPage(piece_list_uri, piece_list, restTemplate);
            		
            		// This times all the pieces for a single minifigure so they are the total to make the total quantity of minifigures 
            		for (Piece piece : piece_list) {				
        				int piece_quantity = piece.getQuantity();
        				int newPiece_quantity = piece_quantity*quantity;
        				piece.setQuantity(newPiece_quantity);
        				
        				if (quantity_checked > newPiece_quantity) {
        					// Checks the pieces to match number of minifigures checked
        					piece.setQuantity_checked(quantity_checked);
        				}
        			}
                	
                	Minifigure minifigure = new Minifigure(num, name, img_url, quantity, quantity_checked, piece_list);
    				
    				minifigures.add(minifigure);
            	}
        	}
    		
            // If their is another page of pieces that needed to be collected from the api here this page will be called recursively using this class
            // and the piece list will be sent each time so when it is then returned it will contain all these pieces
            if (next != null) {
            	minifigure_list_uri = next + "&key=" + rebrickable_api_key;
            	minifigures = getMinifigure_ListPage(minifigure_list_uri, minifigures, restTemplate);
            }

		}
        catch (JsonMappingException e) {
			e.printStackTrace();
		}
        catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		
		return minifigures;
	}
	
	/*
	 * Here I have combined code from two websites [3] and [4] to create and export a CSV file
	 * for a Lego Set checklist on a clients machine, as this was not vital to the main function of the program
	 * I have labelled where I have started using this code below
	 */
	@GetMapping("/set/{set_number}/pieces/export")
	public void export(@PathVariable String set_number, @ModelAttribute("set") Set set, @RequestParam("quantityChecked") List<Integer> quantityChecked, HttpServletResponse response) throws Exception {
		
		// This gets all the pieces in a Lego Set
		List<Piece> piece_list = set.getPiece_list();
    	
    	// This updates the quantity checked for each piece in the Lego set
    	for (int i = 0; i < piece_list.size(); i++) {
    		Piece piece = piece_list.get(i);
    		piece.setQuantity_checked(quantityChecked.get(i));
    	}
    	
    	String set_name = set.getName();
    	
    	// This stores a proposed name for the file
    	// This also removes spaces from the name and replaces them with underscores (in case this causes issues with saving the file)
    	String fileName = set_name.replace(" ", "_") + "_Checklist.csv";
    	
    	/*
    	 * From here till the end of the method using code bits of code taken from [3] and [4]
    	 */

        response.setContentType("text/csv");
        response.setHeader(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + fileName + "\"");
        
        //create a csv writer
        ICSVWriter writer = new CSVWriterBuilder(response.getWriter()).build();

        //write all users to csv file
		writer.writeNext(new String[] {set_number});
		
		// For each piece in the Lego set if its quantity is above zero, this writes a piece's number, colour name
		// and if its a spare as a line to the new CSV file, as these values uniquely identity each Lego piece
		for (Piece piece : piece_list) {
			if (piece.getQuantity_checked() != 0) {
				String[] csv_data = {piece.getNum(), piece.getColour_name(), String.valueOf(piece.isSpare()), String.valueOf(piece.getQuantity_checked())};
				writer.writeNext(csv_data);
			}
		}
	}
}
