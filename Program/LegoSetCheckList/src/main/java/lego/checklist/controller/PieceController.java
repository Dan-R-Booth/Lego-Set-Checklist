package lego.checklist.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lego.checklist.domain.Minifigure;
import lego.checklist.domain.Piece;
import lego.checklist.domain.Piece_list;

//RestTemplate is used to perform HTTP request to a uri
/* Reference:
* "RestTemplate (Spring Framework 5.3.14 API)",
* Docs.spring.io, 2021. [Online].
* Available: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html.[Accessed: 02- Dec- 2021]
*/

// 

@Controller
public class PieceController {
	// This stores the basic uri to the Rebrickable API
	public final String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
		
	// The api key used to access the Rebrickable api
	public final static String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
		
	@GetMapping("set/{set_number}/pieces")
	public String showPieces(Model model, @PathVariable String set_number, RestTemplate restTemplate) {
		
		// This call the getPieces class to get all the pieces in a Lego Set
    	Piece_list piece_list = getPieces(model, set_number, restTemplate);
    	
    	model.addAttribute("num_items", piece_list.getPieces().size());
    	model.addAttribute("set_number", set_number);
    	model.addAttribute("piece_list", piece_list);
		return "showPiece_list";
	}
	
	public Piece_list getPieces(Model model, @PathVariable String set_number, RestTemplate restTemplate) {
		// This is the uri to the specific pieces in a set in the Rebrickable API
		String piece_list_uri = rebrickable_uri + "sets/" + set_number + "/parts/?key=" + rebrickable_api_key;
		
		// This creates an array list to store all the Lego pieces needed to build a Lego set
		// This is declared here in case the try catch statement, in the getPiece_listPage Class, fails
		List<Piece> pieces =  new ArrayList<>();
		
		// This calls the getPiece_listPage class that gets all the pieces in the Lego Set
		pieces = getPiece_listPage(piece_list_uri, pieces, restTemplate);
		
		// This is the uri to the specific pieces in a set in the Rebrickable API
		String minifigure_list_uri = rebrickable_uri + "sets/" + set_number + "/minifigs/?key=" + rebrickable_api_key;
		
		// This calls the getMinifigurePiece_list class that gets all the pieces for all the minifigures in the Lego Set
		pieces = getMinifigurePiece_list(minifigure_list_uri, pieces, restTemplate);
		
		// This creates an array list to store all the Lego pieces needed to build a Lego set
		// This is declared here in case the try catch statement, in the getPiece_ListPage Class, fails
		// This creates an array list to store all the Lego pieces needed to build a Lego set
		List<String> pieces_added = new ArrayList<>();
		
		// This creates a new array list to store all the pieces needed to build a Lego set, without duplicates
		List<Piece> updated_pieces = new ArrayList<>();
		
		for (Piece piece : pieces) {
			boolean removed = false;
			
			for (String remove_piece_num_colour : pieces_added) {
				String piece_num_colour = piece.getNum() + piece.getColour_name() + piece.isSpare();
				if (piece_num_colour.equals(remove_piece_num_colour)) {
					removed = true;
				}
			}
			
			if (removed == false) {

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
		
		// This adds all the pieces in the Lego Set into the piece list class 
    	Piece_list piece_list = new Piece_list(updated_pieces);
    	
    	return piece_list;
	}
	
	// This gets all the pieces in the Lego Set using the Lego Set pieces uri, starting with the first page of these Lego piece list,
	// If there are other pages containg pieces on the api, this class will then be called recursively to get all of these pieces
	public static List<Piece> getPiece_listPage(String piece_list_uri, List<Piece> pieces, RestTemplate restTemplate) {
		// The rest template created above is used to fetch the Lego set every time the website is loaded
		// and here it uses the Lego set piece uri to call the API and then transforms the returned JSON into a String
		String piece_list_JSON = restTemplate.getForObject(piece_list_uri, String.class);
		
		// This is wrapped in a try catch in case the string given to readTree() is not a JSON string
        try {
        	// This provides functionality for reading and writing JSON
        	ObjectMapper mapper = new ObjectMapper();
        	
        	// This provides the root node of the JSON string as a Tree and stores it in the class JsonNode
        	JsonNode piece_listNode = mapper.readTree(piece_list_JSON);
        	
        	JsonNode nextNode = piece_listNode.path("next");
        	String next = nextNode.textValue();
			
        	// This provides the root of the JSON element where the JSON array of Lego pieces is stored
        	piece_listNode = piece_listNode.path("results");
        	
        	// This iterates through the JSON array of Lego pieces
            for (JsonNode pieceNode : piece_listNode) {
            	
	        	// These search search for a path on the pieceNode Tree and return the node that matches this
        		
        		// As the piece number, name and img url are stored as an element of part, I first have to get the part node to retrieve these
	        	JsonNode partNode = pieceNode.path("part");
	        	JsonNode numNode = partNode.path("part_num");
	        	JsonNode nameNode = partNode.path("name");
	        	JsonNode img_urlNode = partNode.path("part_img_url");
	        	
	        	// As the colour name is stored as an element of color, I first have to get the color node to retrieve this
	        	JsonNode colourNode = pieceNode.path("color");
	        	JsonNode colour_nameNode = colourNode.path("name");
	        	
	        	JsonNode quantityNode = pieceNode.path("quantity");
	        	JsonNode spare_partNode = pieceNode.path("is_spare");
	        	
	        	// These return the data stored in the JsonNodes
	        	String num = numNode.textValue();
	        	String name = nameNode.textValue();
	        	String img_url = img_urlNode.textValue();
	        	String colour_name = colour_nameNode.textValue();
	    		int quantity = quantityNode.intValue();
	    		boolean spare = spare_partNode.asBoolean();
	        	
	        	// This is set to 0 as the user may not have checked any of these pieces yet
				int quantity_checked = 0;
				
				Piece piece = new Piece(num, name, img_url, colour_name, quantity, quantity_checked, spare);
				
				pieces.add(piece);
        	}
    		
            // If their is another page of pieces that needed to be collected from the api here this page will be called recursively using this class
            // and the piece list will be sent each time so when it is then returned it will contain all these pieces
            if (next != null) {
            	System.out.println("if");
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
	
	// 
	public List<Piece> getMinifigurePiece_list(String minifigure_list_uri, List<Piece> pieces, RestTemplate restTemplate) {
		// This creates an array list to store all the Lego pieces needed to build a Lego set
		// This is declared here in case the try catch statement, in the getPiece_ListPage Class, fails
		List<Minifigure> minifigures = new ArrayList<>();
		
		// This calls the getMinifigurePieces class that gets all the pieces in the Lego Set
		minifigures = MinifigureController.getMinifigure_ListPage(minifigure_list_uri, minifigures, restTemplate);
		
		// This creates an array list to store all the minfigure pieces needed to build all the minifigures in a Lego set
		List<Piece> minifigure_pieces = new ArrayList<>();
		
		for (Minifigure minifigure : minifigures) {
			Piece_list minifigure_piece_list = minifigure.getSet_pieces();
			for (Piece piece : minifigure_piece_list.getPieces()) {
				pieces.add(piece);
			}
		}
		
		pieces.addAll(minifigure_pieces);
		
		return pieces;
	}
}
