package lego.checklist.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import lego.checklist.domain.Account;
import lego.checklist.domain.Piece;
import lego.checklist.domain.PieceFound;
import lego.checklist.domain.Set;
import lego.checklist.domain.SetInProgress;
import lego.checklist.domain.Set_list;
import lego.checklist.domain.Theme;
import lego.checklist.repository.PieceFoundRepository;
import lego.checklist.repository.SetInProgressRepository;
import lego.checklist.repository.SetInSetListRepository;
import lego.checklist.repository.Set_listRepository;

@Controller
@SessionAttributes({"accountLoggedIn", "set_lists"})
public class DatabaseController {
	
	@Autowired
	private Set_listRepository set_listRepo;

	@Autowired
	private SetInSetListRepository setRepo;

	@Autowired
	private SetInProgressRepository setInProgessRepo;
	
	@Autowired
	private PieceFoundRepository pieceFoundRepo;
	
	// This stores the basic uri to the Rebrickable API
	private final String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
	
	// The api key used to access the Rebrickable api
	private final String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	/*
	// This will create an new account for a user, as long as the entered details are valid
	@PostMapping("/signUp")
	public String signUp(@ModelAttribute Account account, BindingResult result, Model model, RedirectAttributes redirectAttributes) {
		// This creates an instance of the AccountValidator and calls the validate function
		// with an Account generated using values entered in the signUp form. This function
		// then checks if there are any errors with the accounts details and if there are
		// adds these to the BindingResult result
		AccountValidator accountValidator = new AccountValidator(accountRepo);
		accountValidator.validate(account, result);
		
		// This function will run if there are any errors returned by the AccountValidator class
		if (result.hasErrors()) {			
			// This are used and added to the model so the JSP knows where the error occurs
			boolean emailValid = true;
			boolean passwordValid = true;
			
			// This loop goes through all the errors comparing their error code with the certain
			// error codes, so that the boolean values can be updated to show there is an error
			// and adding this errors message to the model of that error code type 
			for (ObjectError error : result.getAllErrors()) {
				if (error.getCode().equals("email")) {
					emailValid = false;
					model.addAttribute("emailErrorMessage_SignUp", error.getDefaultMessage());
				}
				else if (error.getCode().equals("password")) {
					passwordValid = false;
					System.out.println(error.getDefaultMessage());
					model.addAttribute("passwordErrorMessage_SignUp", error.getDefaultMessage());
				}
			}
			
			model.addAttribute("emailValid_SignUp", emailValid);
			model.addAttribute("passwordValid_SignUp", passwordValid);
			
			// This is used so that the index page knows that the sign-up returned errors
			model.addAttribute("login_signUpErrors", "signUp");
			
			return "index";
		}
		// This adds the created account to the database table Accounts
		accountRepo.save(account);
		
		// This creates a set_list called setsOwnedList for the new user with
		// an empty list of sets and saves list to the database table SetLists
		List<Set> sets = new ArrayList<>();
		Set_list set_list = new Set_list(account, "Sets Owned List", sets, sets.size());
		set_listRepo.save(set_list);
		
		// This then creates a setsOwnedList with the new set_list
		// and saves this to the database table setsOwnedLists
		SetsOwnedList setsOwnedList = new SetsOwnedList(set_list, account);
		setsOwnedListRepo.save(setsOwnedList);
		
		// This is used so the JSP page knows to inform the user that they have successfully created
		// an account and is added to redirectAttributes so it stays after the page redirect
		redirectAttributes.addFlashAttribute("accountCreated", true);
				
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	// This will sign a user into their account, as long as the entered details are valid
	@PostMapping("/login")
	public String login(@ModelAttribute Account account, BindingResult result, Model model, RedirectAttributes redirectAttributes) {
		// This creates an instance of the AccountValidator and calls the validateLogin function
		// with an Account generated using values entered in the login form. This function
		// then checks if there are any errors with the accounts details and if there are
		// adds these to the BindingResult result
		AccountValidator accountValidator = new AccountValidator(accountRepo);
		accountValidator.validateLogin(account, result);
		
		// This function will run if there are any errors returned by the AccountValidator class
		if (result.hasErrors()) {
			// This are used and added to the model so the JSP knows where the error occurs
			boolean emailValid = true;
			boolean passwordValid = true;
			boolean email_passwordValid = true;
			
			// This loop goes through all the errors comparing their error code with the certain
			// error codes, so that the boolean values can be updated to show there is an error
			// and adding this errors message to the model of that error code type 
			for (ObjectError error : result.getAllErrors()) {
				if (error.getCode().equals("email")) {
					emailValid = false;
					model.addAttribute("emailErrorMessage_Login", error.getDefaultMessage());
				}
				else if (error.getCode().equals("password")) {
					passwordValid = false;
					model.addAttribute("passwordErrorMessage_Login", error.getDefaultMessage());
				}
				else if (error.getCode().equals("email_password")) {
					email_passwordValid = false;
					model.addAttribute("email_passwordErrorMessage", error.getDefaultMessage());
				}
			}
			
			model.addAttribute("emailValid_Login", emailValid);
			model.addAttribute("passwordValid_Login", passwordValid);
			model.addAttribute("email_passwordValid", email_passwordValid);
			
			// This is used so that the index page knows that the login returned errors
			model.addAttribute("login_signUpErrors", "login");
			
			return "index";
		}
		
		// This is used so the JSP page knows to inform the user that they have been
		// logged in and is added to redirectAttributes so it stays after the page redirect
		redirectAttributes.addFlashAttribute("loggedIn", true);
		
		model.addAttribute("accountLoggedIn", account);
		
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(account);
    	model.addAttribute("set_lists", set_lists);
		
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	// This logs the user out of their account and returns them to the index page
	@GetMapping("/logout")
	public String logout(SessionStatus status) {
		// This removes the Session attributes accountLogedIn, and Set_lists thus logging the user out of their account
		status.setComplete();
		
		// This redirects the user back to the index page
		return "redirect:/";
	}

	*/
	// This gets a set list and checks if it contains a Lego Set with the same set number,
	// if the list does contains the set it is added to the set list
	@PostMapping("/addSetToList/previousPage={previousPage}")
	public String addSetToList(Model model, @SessionAttribute(value = "accountLoggedIn", required = true) Account account, @SessionAttribute(value = "searchURL", required = false) String searchURL, @PathVariable("previousPage") String previousPage, @RequestParam(required = true) int setListId, @RequestParam(required = true) String set_number, @RequestParam(required = false) String setListName, RestTemplate restTemplate, RedirectAttributes redirectAttributes) {
		
		// This gets a list of sets belong to the logged in user
		Set_list set_list = set_listRepo.findByAccountAndSetListId(account, setListId);
		
		// These are used so the JSP page knows the set and set list selected
		// and is added to redirectAttributes so it stays after the page redirect
		// so that the user can be informed that their set was added to which list
		// or to display that the set was not found
		redirectAttributes.addFlashAttribute("set_number", set_number);
		redirectAttributes.addFlashAttribute("set_list", set_list);
		
      	// This checks if the Lego set is already in the set list
		if (set_list.contains(set_number)) {
			// This is used so the JSP page knows to inform the user that there was an error adding the
			// Lego Set to a list and is added to redirectAttributes so it stays after the page redirect
			redirectAttributes.addFlashAttribute("setAddedError", true);
		}
		else {
			// This creates a Set that is added to the set_lists List of sets
        	Set set = new Set(set_number);
        	set_list.addSet(set);
        	
        	// This saves the Lego set to the database table SetsInSetList
        	setRepo.save(set);
        	
        	// This then saves the updated set_list to the database table SetLists
        	set_listRepo.save(set_list);
        	
        	// This is used so the JSP page knows to inform the user that they have added the Lego
        	// Set to a list and is added to redirectAttributes so it stays after the page redirect
        	redirectAttributes.addFlashAttribute("setAdded", true);
        }
		
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(account);
    	model.addAttribute("set_lists", set_lists);
		
		// These returns the user back to the page that the user called the controller from
		if (previousPage.equals("search")) {
			return "redirect:" + searchURL;
		}
		else if (previousPage.equals("setsInProgress")) {
			return "redirect:/setsInProgress";
		}
		else if (previousPage.equals("set_list")) {
			return "redirect:/set_list=" + setListName;
		}
		else {
			return "redirect:/set/?set_number=" + set_number;
		}
	}

	// This saves the progress on a set piece checklist to the database
	@PostMapping("/set/{set_number}/pieces/save")
	@ResponseBody
	public void saveChecklist(@SessionAttribute(value = "accountLoggedIn", required = true) Account account, @PathVariable String set_number, @SessionAttribute("set") Set set, @RequestParam("quantityChecked") List<Integer> quantityChecked, RedirectAttributes redirectAttributes) {
		// This gets all the pieces in a Lego Set
		List<Piece> piece_list = set.getPiece_list();
    	
    	// This updates the quantity checked for each piece in the Lego set
    	for (int i = 0; i < piece_list.size(); i++) {
    		Piece piece = piece_list.get(i);
    		piece.setQuantity_checked(quantityChecked.get(i));
    	}
    	
    	// This then creates a setsOwnedList with the new set_list
		// and saves this to the database table setsOwnedLists
    	SetInProgress setInProgress = new SetInProgress(account, set_number, set.getName(), set.getYear(), set.getTheme(), set.getNum_pieces(), set.getImg_url());
    	
    	// If the user already has saved the set to the database, this sets the set saved
    	// in the database table to setInProgress, and then deletes all the pieces saved
    	// in the database so that these can then be replaced with the new updated pieces
    	// Otherwise a new setInProgress is saved to the database
    	if (setInProgessRepo.findByAccountAndSetNumber(account, set_number) != null) {
    		setInProgress = setInProgessRepo.findByAccountAndSetNumber(account, set_number);
    		pieceFoundRepo.deleteBySetInProgress(setInProgress);
    	}
    	else {
	    	setInProgessRepo.save(setInProgress);
    	}
    	
    	// For each piece in the Lego set if its quantity is above zero, this adds a piece's number, colour name
		// and if its a spare as a line to the database with the setInProgress, as these values uniquely identity
    	// each Lego piece and which setInProgress they belong to and thus user
    	for (Piece piece : piece_list) {
    		if (piece.getQuantity_checked() != 0) {
    			PieceFound pieceFound = new PieceFound(setInProgress, piece.getNum(), piece.getColour_name(), piece.isSpare(), piece.getQuantity_checked());
    			pieceFoundRepo.save(pieceFound);
    		}
    	}
	}

	// This gets all the sets in a set list saved to the database, using the set_numbers saved there, and the adds this set_list and set to the model to display these in the showSetList page
	@GetMapping("/set_list={listName}")
	public String showSetList(Model model, @SessionAttribute(value = "accountLoggedIn", required = true) Account account, @PathVariable("listName") String listName, @RequestParam(value = "text", required = false) String searchText, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String sort, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_id", required = false) String filteredTheme_id, RestTemplate restTemplate) {
		Set_list set_list = set_listRepo.findByAccountAndListName(account, listName);
		model.addAttribute("set_list", set_list);
		
		String set_list_uri = "";
		
		// This is used so that if the filter or sort bar was open or no bar was open on the search page
		// otherwise if the user wasn't on the search page and this is empty then the filter bar starts off open
		model.addAttribute("barOpen", barOpen);
		
		// If there is a attribute the user would like to sort by this is added to the uri and the model
		if (sort != null) {
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
		if (minYear != null){
			set_list_uri += "&min_year=" + minYear;
			model.addAttribute("minYear", minYear);
		}
		
		// If there is a max year the user would like to filter by this is added to the uri and the model
		if (maxYear != null) {
			set_list_uri += "&max_year=" + maxYear;
			model.addAttribute("maxYear", maxYear);
		}
		
		// If there is a minimum number of pieces the user would like to filter by this is added to the uri and the model
		if (minPieces != null){
			set_list_uri += "&min_parts=" + minPieces;
			model.addAttribute("minPieces", minPieces);
		}
		
		// If there is a maximum number of pieces the user would like to filter by this is added to the uri and the model
		if (maxPieces != null) {
			set_list_uri += "&max_parts=" + maxPieces;
			model.addAttribute("maxPieces", maxPieces);
		}
		
		// If there is a theme_id the user would like to filter by this is added to the uri and the model
		if (filteredTheme_id != null) {
			set_list_uri += "&theme_id=" + filteredTheme_id;
			model.addAttribute("theme_id", filteredTheme_id);
		}
		
		List<Set> sets = set_list.getSets();
		
		for (int i = 0; i < sets.size(); i++) {
			Set set = sets.get(i);
			
			// This is the uri to a specific set in the Rebrickable API
			String set_uri = rebrickable_uri + "sets/" + set.getNum() + "/?key=" + rebrickable_api_key;
			
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
			}
	        catch (JsonMappingException e) {
				e.printStackTrace();
			}
	        catch (JsonProcessingException e) {
				e.printStackTrace();
			}
			
			set = new Set(num, name, year, theme_name, num_pieces, img_url);
			
			sets.set(i, set);
			
			// This makes the program wait one second before making an API call to stop a Too Many Requests error and timeout from the API
			try {
				Thread.sleep(1000);
			}
			catch (Exception e) {}
		}
		
		model.addAttribute("sets", sets);
		
//		model.addAttribute("current", set_list_uri);
        model.addAttribute("searchText", searchText);
        model.addAttribute("sets", sets);
        model.addAttribute("themeList", ThemeController.themeList);
		
		return "showSetList";
	}

	@PostMapping("/addNewSetList/previousPage={previousPage}")
	public String addNewSetList(Model model, @SessionAttribute(value = "accountLoggedIn", required = true) Account account, @SessionAttribute(value = "searchURL", required = false) String searchURL, @PathVariable("previousPage") String previousPage, @RequestParam(required = true) String setListName, @RequestParam(required = false) String set_number, RestTemplate restTemplate, RedirectAttributes redirectAttributes) {
		
		// This creates a set_list with the name submitted for the new user with
		// an empty list of sets and saves list to the database table SetLists
		List<Set> sets = new ArrayList<>();
		Set_list set_list = new Set_list(account, setListName, sets, sets.size());
		set_listRepo.save(set_list);
    	
    	// This is used so the JSP page knows to inform the user that they have created a new
    	// Set list and is added to redirectAttributes so it stays after the page redirect
    	redirectAttributes.addFlashAttribute("setListCreated", true);
    	redirectAttributes.addFlashAttribute("newSetListname", setListName);
    	
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(account);
    	model.addAttribute("set_lists", set_lists);
		
    	if (previousPage.equals("set_lists")) {
    		return "redirect:/set_lists";
    	}
    	else {
    		// These are used so the JSP page knows the set and set list selected
    		// and is added to redirectAttributes so it stays after the page redirect
    		// so that the model knows which set the user was trying to add to a set
    		// list before they created the new set list
    		redirectAttributes.addFlashAttribute("set_number", set_number);
    		
    		// These returns the user back to the page that the user called the controller from
    		if (previousPage.equals("search")) {
    			return "redirect:" + searchURL;
    		}
    		else {
    			return "redirect:/set/?set_number=" + set_number;
    		}
    	}
	}
	
	// This gets all the sets currently being completed by a user from the database and then opens showSetsInProgress so that they can be displayed to the user
	@GetMapping("/setsInProgress")
	public String showSetsInProgress(Model model, @SessionAttribute(value = "accountLoggedIn", required = true) Account account, @RequestParam(value = "text", required = false) String searchText, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String sort, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_id", required = false) String filteredTheme_id) {
		List<SetInProgress> setsInProgress = setInProgessRepo.findByAccount(account);
		model.addAttribute("setsInProgress", setsInProgress);
		
		model.addAttribute("themeList", ThemeController.themeList);
		
		return "showSetsInProgress";
	}
}
