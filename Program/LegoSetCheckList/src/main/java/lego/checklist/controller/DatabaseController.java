package lego.checklist.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
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
import lego.checklist.domain.SetInSetList;
import lego.checklist.domain.Set_list;
import lego.checklist.domain.Theme;
import lego.checklist.repository.AccountRepository;
import lego.checklist.repository.PieceFoundRepository;
import lego.checklist.repository.SetInProgressRepository;
import lego.checklist.repository.SetInSetListRepository;
import lego.checklist.repository.SetInfoRepository;
import lego.checklist.repository.Set_listRepository;
import lego.checklist.validator.AccountValidator;

@Controller
@SessionAttributes({"accountLoggedIn", "set_lists"})
public class DatabaseController {
	
	@Autowired
	private AccountRepository accountRepo;
	
	@Autowired
	private Set_listRepository set_listRepo;

	@Autowired
	private SetInSetListRepository setInSetListRepo;

	@Autowired
	private SetInProgressRepository setInProgessRepo;
	
	@Autowired
	private SetInfoRepository setInfoRepo;
	
	@Autowired
	private PieceFoundRepository pieceFoundRepo;
	
	// This stores the basic uri to the Rebrickable API
	private final String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
	
	// The api key used to access the Rebrickable api
	private final String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	// This will create an new account for a user, as long as the entered details are valid
	@PostMapping("/signUp")
	public String signUp(@ModelAttribute Account account, BindingResult result, RedirectAttributes redirectAttributes) {
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
			// and adding this errors message to the redirectAttributes so they stays after the
			// page redirect
			for (ObjectError error : result.getAllErrors()) {
				if (error.getCode().equals("email")) {
					emailValid = false;
					redirectAttributes.addFlashAttribute("emailErrorMessage_SignUp", error.getDefaultMessage());
				}
				else if (error.getCode().equals("password")) {
					passwordValid = false;
					System.out.println(error.getDefaultMessage());
					redirectAttributes.addFlashAttribute("passwordErrorMessage_SignUp", error.getDefaultMessage());
				}
			}
			
			// These added to redirectAttributes so it stays after the page redirect
			redirectAttributes.addFlashAttribute("emailValid_SignUp", emailValid);
			redirectAttributes.addFlashAttribute("passwordValid_SignUp", passwordValid);
			
			// This is used so that the index page knows that the sign-up returned errors
			redirectAttributes.addFlashAttribute("login_signUpErrors", "signUp");
			
			// This adds the email entered so it can be put back in the form
			redirectAttributes.addFlashAttribute("emailEntered_signUpErrors", account.getEmail());
			
			// This redirects the user back to the index page
			return "redirect:/";
		}
		// This adds the created account to the database table Accounts
		accountRepo.save(account);
		
		// This creates an initial set_list called setsOwnedList for the new user with
		// an empty list of sets and saves list to the database table SetLists
		List<SetInSetList> setsInSetList = new ArrayList<>();
		Set_list set_list = new Set_list(account, "Sets Owned List", setsInSetList, setsInSetList.size());
		set_listRepo.save(set_list);
		
		// This is used so the JSP page knows to inform the user that they have successfully created
		// an account and is added to redirectAttributes so it stays after the page redirect
		redirectAttributes.addFlashAttribute("accountCreated", true);
		
		redirectAttributes.addFlashAttribute("emailAccountCreated", account.getEmail());
		
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
			// and adding this errors message to the redirectAttributes so they stays after the
			// page redirect
			for (ObjectError error : result.getAllErrors()) {
				if (error.getCode().equals("email")) {
					emailValid = false;
					redirectAttributes.addFlashAttribute("emailErrorMessage_Login", error.getDefaultMessage());
				}
				else if (error.getCode().equals("password")) {
					passwordValid = false;
					redirectAttributes.addFlashAttribute("passwordErrorMessage_Login", error.getDefaultMessage());
				}
				else if (error.getCode().equals("email_password")) {
					email_passwordValid = false;
					redirectAttributes.addFlashAttribute("email_passwordErrorMessage", error.getDefaultMessage());
				}
			}
			
			// These added to redirectAttributes so it stays after the page redirect
			redirectAttributes.addFlashAttribute("emailValid_Login", emailValid);
			redirectAttributes.addFlashAttribute("passwordValid_Login", passwordValid);
			redirectAttributes.addFlashAttribute("email_passwordValid", email_passwordValid);
			
			// This is used so that the index page knows that the login returned errors
			redirectAttributes.addFlashAttribute("login_signUpErrors", "login");
			
			// This adds the email entered so it can be put back in the form
			redirectAttributes.addFlashAttribute("emailEntered_loginErrors", account.getEmail());
			
			// This redirects the user back to the index page
			return "redirect:/";
		}
		
		// This is used so the JSP page knows to inform the user that they have been
		// logged in and is added to redirectAttributes so it stays after the page redirect
		redirectAttributes.addFlashAttribute("loggedIn", true);
		
		// This is called to get the account stored in the database to get the accounts accountId
		// which is required as it is used a foreign key in other tables, so is needed to access
		// the users data in these tables
		Account usersAccount = accountRepo.findByEmail(account.getEmail());
		
		model.addAttribute("accountLoggedIn", usersAccount);
		
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(usersAccount);
    	model.addAttribute("set_lists", set_lists);
		
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	// This deletes a users account, as long as the password entered matches the saved password
	@PostMapping("/deleteAccount")
	public String deleteAccount(@SessionAttribute(value = "accountLoggedIn", required = true) Account accountLoggedIn, @ModelAttribute Account account, BindingResult result, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "edit your account");
			return "redirect:/accessDenied";
		}
		
		// This creates an instance of the AccountValidator and calls the validateLogin function with
		// an Account generated using email parsed and password entered in the delete account form.
		// This function then checks if there are any errors with the accounts details and if there are
		// adds these to the BindingResult result
		AccountValidator accountValidator = new AccountValidator(accountRepo);
		// I reuse the login validate because this checks the password is correct or blank
		accountValidator.validateLogin(account, result);
		
		// This function will run if there are any errors returned by the AccountValidator class
		if (result.hasErrors()) {
			
			// This loop goes through all the errors comparing their error code with the certain
			// error codes, so that the boolean values can be updated to show there is an error
			// and adding this errors message to the model of that error code type 
			for (ObjectError error : result.getAllErrors()) {
				if (error.getCode().equals("password")) {
					redirectAttributes.addFlashAttribute("passwordErrorMessage", error.getDefaultMessage());
				}
				else if (error.getCode().equals("email_password")) {
					// This is only password incorrect as email is added automatically
					redirectAttributes.addFlashAttribute("passwordErrorMessage", "Password incorrect");
				}
			}
			// This is used so that the user knows that the password entered was incorrect
			redirectAttributes.addFlashAttribute("passwordIncorrect", true);
			
			return "redirect:/profile";
		}
		
		accountRepo.delete(accountLoggedIn);
		
		removeUnneededSetInfo();
		
		// This redirects the user to the logout page
		return "redirect:/logout";
	}
	
	// This deletes a users account, as long as the password entered matches the saved password
	@GetMapping("/changePassword")
	public String changePassword(@SessionAttribute(value = "accountLoggedIn", required = true) Account accountLoggedIn, @RequestParam(required = true) String email, @RequestParam(required = true) String oldPassword, @RequestParam(required = true) String newPassword, @ModelAttribute Account account, BindingResult result, Model model, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "edit your account");
			return "redirect:/accessDenied";
		}
		
		// This creates an instance of the AccountValidator and calls the validateLogin function with
		// an Account generated using email parsed and password entered in the delete account form.
		// This function then checks if there are any errors with the accounts details and if there are
		// adds these to the BindingResult result
		AccountValidator accountValidator = new AccountValidator(accountRepo);
		
		account = new Account(email, oldPassword);
		
		// I reuse the login validate because this checks the password is correct or blank
		accountValidator.validateLogin(account, result);
		
		Boolean errors = false;
		
		// This function will run if there are any errors returned by the AccountValidator class
		if (result.hasErrors()) {
			errors = true;
			
			// This loop goes through all the errors comparing their error code with the certain
			// error codes, so that the boolean values can be updated to show there is an error
			// and adding this errors message to the model of that error code type 
			for (ObjectError error : result.getAllErrors()) {
				if (error.getCode().equals("password")) {
					redirectAttributes.addFlashAttribute("oldPasswordErrorMessage", error.getDefaultMessage());
				}
				else if (error.getCode().equals("email_password")) {
					// This is only password incorrect as email is added automatically
					redirectAttributes.addFlashAttribute("oldPasswordErrorMessage", "Password incorrect");
				}
				System.out.println("\ncode: " + error.getCode() + "\nmessage: " + error.getDefaultMessage() + "\n");
			}
			// This is used so that the user knows that the password entered was incorrect
			redirectAttributes.addFlashAttribute("oldPasswordIncorrect", true);
		}
		
		// This checks that the password is not empty or contains no spaces, and if it is not empty
		// or has spaces an error message is added reflecting this to the redirect
		if (newPassword.isEmpty()) {
			errors = true;
			redirectAttributes.addFlashAttribute("newPasswordErrorMessage", "Password cannot be blank");
			
			// This is used so that the user knows that the new password entered was invalid
			redirectAttributes.addFlashAttribute("newPasswordIncorrect", true);
		}
		else if (newPassword.contains(" ")) {
			errors = true;
			redirectAttributes.addFlashAttribute("newPasswordErrorMessage", "Password cannot contain spaces");

			// This is used so that the user knows that the new password entered was invalid
			redirectAttributes.addFlashAttribute("newPasswordIncorrect", true);
		}
		
		if (errors == false) {
			// This sets the new password and updates the account
			// logged in and then saves the updated account to the
			// database
			account.setPassword(newPassword);
			model.addAttribute("accountLoggedIn", account);
			
			accountRepo.save(account);
			
			// This is used so that the user knows that the password was changed
			redirectAttributes.addFlashAttribute("passwordChanged", true);
		}
		else {
			// This is used so that the user knows that the password was not changed
			redirectAttributes.addFlashAttribute("passwordChangeFailed", true);
		}
		
		// This redirects the user to the logout page
		return "redirect:/profile";
	}
	
	// This logs the user out of their account and returns them to the index page
	@GetMapping("/logout")
	public String logout(SessionStatus status) {
		// This removes the Session attributes accountLogedIn, and Set_lists thus logging the user out of their account
		status.setComplete();
		
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	// This displays opens the profile page showing the users information
	@GetMapping("/profile")
	public String viewProfile(Model model, @SessionAttribute(value = "accountLoggedIn", required = true) Account accountLoggedIn, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (accountLoggedIn == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "access the 'Profile' page");
			return "redirect:/accessDenied";
		}
		
		// This adds the a new account class that will be used by the form to delete an account
		model.addAttribute("account", new Account());
		
		return "profile";
	}
	
	// This saves the progress on a set piece checklist to the database
	@PostMapping("/set/{set_number}/pieces/save")
	@ResponseBody
	public void saveChecklist(@SessionAttribute(value = "accountLoggedIn", required = true) Account account, @PathVariable String set_number, @SessionAttribute("set") Set set, @RequestParam("quantityChecked") List<Integer> quantityChecked) {
		// This gets all the pieces in a Lego Set
		List<Piece> piece_list = set.getPiece_list();
		
		// This updates the quantity checked for each piece in the Lego set
		for (int i = 0; i < piece_list.size(); i++) {
			Piece piece = piece_list.get(i);
			piece.setQuantity_checked(quantityChecked.get(i));
		}
    	
    	// This then creates a setsOwnedList with the new set_list
		// and saves this to the database table setsOwnedLists
    	SetInProgress setInProgress = new SetInProgress(account, set);
    	
    	// This checks if the set being added to a list already has its info saved to the database,
		// and if it does not this adds that sets information to the database table SetInfo
    	if (setInfoRepo.findByNum(set_number) == null) {
    		setInfoRepo.save(set);
    	}
    	
		// If the user already has saved the set to the database, this sets the set saved
		// in the database table to setInProgress, and then deletes all the pieces saved
		// in the database so that these can then be replaced with the new updated pieces
		// Otherwise a new setInProgress is saved to the database
		if (setInProgessRepo.findByAccountAndSet(account, set) != null) {
			setInProgress = setInProgessRepo.findByAccountAndSet(account, set);
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
	
	// This gets all the sets currently being completed by a user from the database and then opens showSetsInProgress so that they can be displayed to the user
	@GetMapping("/setsInProgress")
	public String showSetsInProgress(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @RequestParam(required = false) String sort, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String searchText, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_name", required = false) String filteredTheme_name, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "access the 'Sets In Progress' page");
			return "redirect:/accessDenied";
		}
		
		List<SetInProgress> setsInProgress = setInProgessRepo.findByAccount(account);
		
		// This is used so that if the filter or sort bar was open or no bar was open on the search page
		// otherwise if the user wasn't on the search page and this is empty then the filter bar starts off open
		model.addAttribute("barOpen", barOpen);
		
		// If their is a sort to be applied to the Sets in Progress, then the following is ran to apply this sort
		// (by default if no sort entered will be sorted by set_number ascending)
		// -- Start of Sort --
		if (sort == null) {
			sort = "set_num";
		}
		
		String[] sorts = sort.split(",");
		
		model.addAttribute("sort1", sorts[0]);
		if (sorts.length >= 2) {
			model.addAttribute("sort2", sorts[1]);
		}
		
		if (sorts.length == 3) {
			model.addAttribute("sort3", sorts[2]);
		}
		
		// This sorts the sets in progress by the sorts selected, it compares each set in the list
		// to one another while sorting, comparing by sort 1 and if they match sort 2 (if exists)
		// and if they match again sort 3 (if exists). This calls a function to do the comparison
		// of each Set and the sort in use too
		Collections.sort(setsInProgress, new Comparator<SetInProgress>() {
			@Override
			public int compare(SetInProgress setInProgress1, SetInProgress setInProgress2) {
				int sortValue = getSortValue(sorts[0], setInProgress1.getSet(), setInProgress2.getSet());
				
				if (sortValue == 0 && sorts.length >= 2) {
					sortValue = getSortValue(sorts[1], setInProgress1.getSet(), setInProgress2.getSet());
				}
				
				if (sortValue == 0 && sorts.length == 3) {
					sortValue = getSortValue(sorts[2], setInProgress1.getSet(), setInProgress2.getSet());
				}
				
				return sortValue;
			}
		});
		// -- End of Sort --
		
		// If there is a text search being parsed this will add it to the model
		if (searchText != null) {
			model.addAttribute("searchText", searchText);
		}
		
		// If there is a min year being parsed this will add it to the model
		if (minYear != null) {
			model.addAttribute("minYear", minYear);
		}
		
		// If there is a max year being parsed this will add it to the model
		if (maxYear != null) {
			model.addAttribute("maxYear", maxYear);
		}
		
		// If there is a minimum number of pieces being parsed this will add it to the model
		if (minPieces != null){
			model.addAttribute("minPieces", minPieces);
		}
		
		// If there is a maximum number of pieces being parsed this will add it to the model
		if (maxPieces != null) {
			model.addAttribute("maxPieces", maxPieces);
		}
		
		// If there is a theme_id being parsed this will add it to the model
		if (filteredTheme_name != null) {
			model.addAttribute("theme_name", filteredTheme_name);
		}
		
		List<Set> sets = new ArrayList<>();
		
		// This gets all the set info for all the sets the user has in progress
		for (SetInProgress setInProgress : setsInProgress) {
			Set set = setInProgress.getSet();
			sets.add(set);
		}
		
		model.addAttribute("sets", sets);
		model.addAttribute("themeList", ThemeController.themeList);
		model.addAttribute("num_sets", sets.size());
		
		return "showSetsInProgress";
	}
	
	// This gets all the sets in a set list saved to the database, using the set_numbers saved there, and the adds this set_list and set to the model to display these in the showSetList page
	@GetMapping("/set_list={listName}")
	public String showSetList(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @PathVariable("listName") String listName, @RequestParam(required = false) String sort, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String searchText, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_name", required = false) String filteredTheme_name, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "view Set Lists");
			return "redirect:/accessDenied";
		}
		
		Set_list set_list = set_listRepo.findByAccountAndListName(account, listName);
		List<SetInSetList> setsInSetList = set_list.getSets();
		
		// This is used so that if the filter or sort bar was open or no bar was open on the search page
		// otherwise if the user wasn't on the search page and this is empty then the filter bar starts off open
		model.addAttribute("barOpen", barOpen);
		
		// If their is a sort to be applied to the Set List, then the following is ran to apply this sort
		// (by default if no sort entered will be sorted by set_number ascending)
		// -- Start of Sort --
		if (sort == null) {
			sort = "set_num";
		}
		String[] sorts = sort.split(",");
		
		model.addAttribute("sort1", sorts[0]);
		if (sorts.length >= 2) {
			model.addAttribute("sort2", sorts[1]);
		}
		
		if (sorts.length == 3) {
			model.addAttribute("sort3", sorts[2]);
		}
		
		// This sorts the list of sets by the sorts selected, it compares each set in the list
		// to one another while sorting, comparing by sort 1 and if they match sort 2 (if exists)
		// and if they match again sort 3 (if exists). This calls a function to do the comparison
		// of each Set and ther sort in use too
		Collections.sort(setsInSetList, new Comparator<SetInSetList>() {
			@Override
			public int compare(SetInSetList setInSetList1, SetInSetList setInSetList2) {
				int sortValue = getSortValue(sorts[0], setInSetList1.getSet(), setInSetList2.getSet());
				
				if (sortValue == 0 && sorts.length >= 2) {
					sortValue = getSortValue(sorts[1], setInSetList1.getSet(), setInSetList2.getSet());
				}
				
				if (sortValue == 0 && sorts.length == 3) {
					sortValue = getSortValue(sorts[2], setInSetList1.getSet(), setInSetList2.getSet());
				}
				
				return sortValue;
			}
		});
		// -- End of Sort --
		
		// If there is a text search being parsed this will add it to the model
		if (searchText != null) {
			model.addAttribute("searchText", searchText);
		}
		
		// If there is a min year being parsed this will add it to the model
		if (minYear != null) {
			model.addAttribute("minYear", minYear);
		}
		
		// If there is a max year being parsed this will add it to the model
		if (maxYear != null) {
			model.addAttribute("maxYear", maxYear);
		}
		
		// If there is a minimum number of pieces being parsed this will add it to the model
		if (minPieces != null){
			model.addAttribute("minPieces", minPieces);
		}
		
		// If there is a maximum number of pieces being parsed this will add it to the model
		if (maxPieces != null) {
			model.addAttribute("maxPieces", maxPieces);
		}
		
		// If there is a theme_id being parsed this will add it to the model
		if (filteredTheme_name != null) {
			model.addAttribute("theme_name", filteredTheme_name);
		}
		
		List<Set> sets = new ArrayList<>();
		
		// This gets all the set info for all the sets the user has in progress
		// and adds these to a list of sets that are then added to the model
		for (SetInSetList setInSetList : setsInSetList) {
			Set set = setInSetList.getSet();
			sets.add(set);
		}
		
		model.addAttribute("sets", sets);
		
        model.addAttribute("searchText", searchText);
        model.addAttribute("sets", sets);
        model.addAttribute("themeList", ThemeController.themeList);
        model.addAttribute("num_sets", sets.size());
        
        set_list.setSetsInSetList(setsInSetList);
        model.addAttribute("set_list", set_list);
		return "showSetList";
	}
	
	// This gets a set list and checks if it contains a Lego Set with the same set number,
	// if the list does contains the set it is added to the set list
	@RequestMapping("/addSetToList/previousPage={previousPage}")
	public String addSetToList(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @SessionAttribute(value = "searchURL", required = false) String searchURL, @PathVariable("previousPage") String previousPage, @RequestParam(required = true) int setListId, @RequestParam(required = true) String set_number, @RequestParam(required = false) String setListName, @RequestParam(required = false) String sort, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String searchText, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_name", required = false) String filteredTheme_name, RestTemplate restTemplate, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "add a Lego Set to a Set List");
			return "redirect:/accessDenied";
		}
		
		// This gets a list of sets belong to the logged in user
		Set_list set_list = set_listRepo.findByAccountAndSetListId(account, setListId);
		
		// These are used so the JSP page knows the set and set list selected
		// and is added to redirectAttributes so it stays after the page redirect
		// so that the user can be informed that their set was added to which list
		// or to display that the set was not found
		redirectAttributes.addFlashAttribute("set_number", set_number);
		redirectAttributes.addFlashAttribute("set_listSelected", set_list);
		
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
		
		Set set = new Set(num, name, year, theme_name, num_pieces, img_url);
		
      	// This checks if the Lego set is already in the set list
		if (set_list.contains(set_number)) {
			// This is used so the JSP page knows to inform the user that there was an error adding the
			// Lego Set to a list and is added to redirectAttributes so it stays after the page redirect
			redirectAttributes.addFlashAttribute("setAddedError", true);
		}
		else {
			// This checks if the set being added to a list already has its info saved to the database,
			// and if it does not this adds that sets information to the database table SetInfo
	    	if (setInfoRepo.findByNum(set_number) == null) {
	    		setInfoRepo.save(set);
	    	}
			
	    	// This creates a SetInSetList that is added to the set_lists List of sets
	    	SetInSetList setInSetList = new SetInSetList(set, set_list);	    	
        	set_list.addSet(setInSetList);
        	
        	// This saves the Lego set to the database table SetsInSetList
        	setInSetListRepo.save(setInSetList);
        	
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
			addFilters(searchText, minYear, maxYear, minPieces, maxPieces, filteredTheme_name, redirectAttributes);
			
			return "redirect:/setsInProgress" + "/?sort=" + sort + "&barOpen=" + barOpen;
		}
		else if (previousPage.equals("set_list")) {
			addFilters(searchText, minYear, maxYear, minPieces, maxPieces, filteredTheme_name, redirectAttributes);
			
			return "redirect:/set_list=" + setListName + "/?sort=" + sort + "&barOpen=" + barOpen;
		}
		else {
			return "redirect:/set/?set_number=" + set_number;
		}
	}

	// This create a new set list for a logged in user, using the entered list name
	@RequestMapping("/addNewSetList/previousPage={previousPage}")
	public String addNewSetList(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @SessionAttribute(value = "searchURL", required = false) String searchURL, @PathVariable("previousPage") String previousPage, @RequestParam(required = true) String setListName, @RequestParam(required = false) String set_number, @RequestParam(required = false) String currentSetListName, @RequestParam(required = false) String sort, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String searchText, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_name", required = false) String filteredTheme_name, @RequestParam(required = false) String minSets, @RequestParam(required = false) String maxSets, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "create a new Set List");
			return "redirect:/accessDenied";
		}
		
		// This creates a set_list with the name submitted for the new user with
		// an empty list of sets and saves list to the database table SetLists
		List<SetInSetList> setsInSetList = new ArrayList<>();
		Set_list set_list = new Set_list(account, setListName, setsInSetList, setsInSetList.size());
		set_listRepo.save(set_list);
    	
    	// These are used so the JSP page knows to inform the user that they have created a new
    	// Set list and the new set list, and are both added to redirectAttributes so they
		// stay after the page redirect
    	redirectAttributes.addFlashAttribute("setListCreated", true);
    	redirectAttributes.addFlashAttribute("newSetList", set_list);
    	
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(account);
    	model.addAttribute("set_lists", set_lists);
		
    	if (previousPage.equals("set_lists")) {
    		addSetListsFilters(searchText, minSets, maxSets, redirectAttributes);
    		
    		return "redirect:/set_lists/?sort=" + sort + "&barOpen=" + barOpen;
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
    		else if (previousPage.equals("setsInProgress")) {
    			addFilters(searchText, minYear, maxYear, minPieces, maxPieces, filteredTheme_name, redirectAttributes);
    			
    			return "redirect:/setsInProgress" + "/?sort=" + sort + "&barOpen=" + barOpen;
    		}
    		else if (previousPage.equals("set_list")) {
    			addFilters(searchText, minYear, maxYear, minPieces, maxPieces, filteredTheme_name, redirectAttributes);
    			
    			return "redirect:/set_list=" + currentSetListName + "/?sort=" + sort + "&barOpen=" + barOpen;
    		}
    		else {
    			return "redirect:/set/?set_number=" + set_number;
    		}
    	}
	}
	
	// This deletes a Lego Set in a users sets in progress from the database
	@GetMapping("/setsInProgress/delete/set={set_num}/{set_name}")
	public String deleteSetFromSetsInProgress(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @PathVariable("set_num") String set_num, @PathVariable("set_name") String set_name, @RequestParam(required = false) String sort, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String searchText, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_name", required = false) String filteredTheme_name, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "delete a Lego Set from Sets In Progress");
			return "redirect:/accessDenied";
		}
		
		Set set = new Set(set_num);
		
		SetInProgress setInProgress = setInProgessRepo.findByAccountAndSet(account, set);
		setInProgessRepo.delete(setInProgress);
		
    	removeUnneededSetInfo();
    	
    	// These are used so the JSP page knows to inform the user that they have created a new
    	// Set list and what its name is and are both added to redirectAttributes so they stay
		// after the page redirect
    	redirectAttributes.addFlashAttribute("setDeleted", true);
    	redirectAttributes.addFlashAttribute("deletedSetName", set_name);
    	redirectAttributes.addFlashAttribute("deletedSetNumber", set_num);
    	
    	// This adds the request query containing the which bar was open, sorts and filters parsed so these are added to the model in the showSetList class
		return "redirect:/setsInProgress/?" + request.getQueryString();
	}
	
	// This deletes a Lego Set List and all the sets in that list from the database
	@GetMapping("/set_list={listName}/delete/{setListId}")
	public String deleteSetList(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @PathVariable("listName") String listName, @PathVariable("setListId") int setListId, @RequestParam(required = false) String sort, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String searchText, @RequestParam(required = false) String minSets, @RequestParam(required = false) String maxSets, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "delete a Set List");
			return "redirect:/accessDenied";
		}
		
		Set_list set_list = set_listRepo.findByAccountAndSetListId(account, setListId);
		set_listRepo.delete(set_list);
		
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(account);
    	model.addAttribute("set_lists", set_lists);
		
    	removeUnneededSetInfo();
    	
    	// These are used so the JSP page knows to inform the user that they have created a new
    	// Set list and what its name is and are both added to redirectAttributes so they stay
		// after the page redirect
    	redirectAttributes.addFlashAttribute("setListDeleted", true);
    	redirectAttributes.addFlashAttribute("deletedSetListName", listName);
    	
    	addSetListsFilters(searchText, minSets, maxSets, redirectAttributes);
		
		return "redirect:/set_lists/?sort=" + sort + "&barOpen=" + barOpen;
	}

	// This deletes a Lego Set in a set list from the database
	@GetMapping("/set_list={listName}/delete/{setListId}/set={set_num}/{set_name}")
	public String deleteSetFromSetList(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @PathVariable("listName") String listName, @PathVariable("setListId") int setListId, @PathVariable("set_num") String set_num, @PathVariable("set_name") String set_name, @RequestParam(required = false) String sort, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String searchText, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_name", required = false) String filteredTheme_name, RedirectAttributes redirectAttributes, HttpServletRequest request) {		
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "delete a Lego Set from a Set List");
			return "redirect:/accessDenied";
		}
		
		Set_list set_list = set_listRepo.findByAccountAndSetListId(account, setListId);
		Set set = new Set(set_num);
		
		SetInSetList setInSetList = setInSetListRepo.findByListOfSetsAndSet(set_list, set);
		setInSetListRepo.delete(setInSetList);
		
		// This decreases the total number of sets in the set_list and saves this to the db
		set_list.removeSet();
		set_listRepo.save(set_list);
		
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(account);
    	model.addAttribute("set_lists", set_lists);
		
    	removeUnneededSetInfo();
    	
    	// These are used so the JSP page knows to inform the user that they have created a new
    	// Set list and what its name is and are both added to redirectAttributes so they stay
		// after the page redirect
    	redirectAttributes.addFlashAttribute("setDeleted", true);
    	redirectAttributes.addFlashAttribute("deletedSetName", set_name);
    	redirectAttributes.addFlashAttribute("deletedSetNumber", set_num);
    	
    	// This adds the request query containing the which bar was open, sorts and filters parsed so these are added to the model in the showSetList class
		return "redirect:/set_list={listName}/?" + request.getQueryString();
	}
	
	// This creates a new set list for a logged in user, using the entered list name
	@RequestMapping("/editSetList/previousPage={previousPage}")
	public String editSetList(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @PathVariable("previousPage") String previousPage, @RequestParam(required = true) int setListId, @RequestParam(required = true) String newSetListName, @RequestParam(required = false) String sort, @RequestParam(required = false) String barOpen, @RequestParam(required = false) String searchText, @RequestParam(required = false) String minYear, @RequestParam(required = false) String maxYear, @RequestParam(required = false) String minPieces, @RequestParam(required = false) String maxPieces, @RequestParam(value = "theme_name", required = false) String filteredTheme_name, @RequestParam(required = false) String minSets, @RequestParam(required = false) String maxSets, RedirectAttributes redirectAttributes) {
		// If a user is not logged in this redirects the user to the access denied page
		if (account == null) {
			redirectAttributes.addFlashAttribute("pageInfo", "edit a Set List");
			return "redirect:/accessDenied";
		}
		
		Set_list set_list = set_listRepo.findByAccountAndSetListId(account, setListId);
		set_list.setListName(newSetListName);
		set_listRepo.save(set_list);
    	
    	// These are used so the JSP page knows to inform the user that they have created a new
    	// Set list and what its name is and are both added to redirectAttributes so they stay
		// after the page redirect
    	redirectAttributes.addFlashAttribute("setListEdited", true);
    	redirectAttributes.addFlashAttribute("newSetListName", newSetListName);
    	
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(account);
    	model.addAttribute("set_lists", set_lists);
		
    	// These returns the user back to the page that the user called the controller from
    	if (previousPage.equals("set_lists")) {
    		addSetListsFilters(searchText, minSets, maxSets, redirectAttributes);
    		
    		return "redirect:/set_lists/?sort=" + sort + "&barOpen=" + barOpen;
    	}
    	else {
			addFilters(searchText, minYear, maxYear, minPieces, maxPieces, filteredTheme_name, redirectAttributes);
			
			return "redirect:/set_list=" + newSetListName + "/?sort=" + sort + "&barOpen=" + barOpen;
    	}
	}

	// This displays the access denied page when user who arn't logged in try to access pages only for logged in users
	@GetMapping("/accessDenied")
	public String accessDenied(@SessionAttribute(value = "accountLoggedIn", required = false) Account account) {
		// This is so if signed in user try to access this page they are redirected to the home page
		if (account != null) {
			return "redirect:/";
		}
		
		return "accessDenied";
	}
	
	// This adds the filters applied to a list of set lists to the redirect URL as request attributes
	private void addSetListsFilters(String searchText, String minSets, String maxSets, RedirectAttributes redirectAttributes) {
		// If there is a text search being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (searchText != null) {
			redirectAttributes.addAttribute("searchText", searchText);
		}
		
		// If there is a min number of sets being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (minSets != null) {
			redirectAttributes.addAttribute("minSets", minSets);
		}
		
		// If there is a max number of sets being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (maxSets != null) {
			redirectAttributes.addAttribute("maxSets", maxSets);
		}
	}

	// This adds the filters applied to a list of sets to the redirect URL as request attributes
	private void addFilters(String searchText, String minYear, String maxYear, String minPieces, String maxPieces, String filteredTheme_name, RedirectAttributes redirectAttributes) {
		// If there is a text search being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (searchText != null) {
			redirectAttributes.addAttribute("searchText", searchText);
		}
		
		// If there is a min year being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (minYear != null) {
			redirectAttributes.addAttribute("minYear", minYear);
		}
		
		// If there is a max year being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (maxYear != null) {
			redirectAttributes.addAttribute("maxYear", maxYear);
		}
		
		// If there is a minimum number of pieces being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (minPieces != null){
			redirectAttributes.addAttribute("minPieces", minPieces);
		}
		
		// If there is a maximum number of pieces being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (maxPieces != null) {
			redirectAttributes.addAttribute("maxPieces", maxPieces);
		}
		
		// If there is a theme_id being parsed this will add it to redirectAttributes so it stays after the page redirect
		if (filteredTheme_name != null) {
			redirectAttributes.addAttribute("theme_name", filteredTheme_name);
		}
	}

	// Gets the value of a sort between two sets
	private int getSortValue(String sort, Set set1, Set set2) {
		if (sort.equals("name")) {
			// This compares the sets by Set Name ascending
			return set1.getName().toUpperCase().compareTo(set2.getName().toUpperCase());
    	}
		else if (sort.equals("-name")) {
			// This compares the sets by Set Name descending
			return set2.getName().toUpperCase().compareTo(set1.getName().toUpperCase());
    	}
		else if (sort.equals("year")) {
			// This compares the sets by Year ascending
			return set1.getYear() - set2.getYear();
    	}
		else if (sort.equals("-year")) {
			// This compares the sets by Year descending
			return set2.getYear() - set1.getYear();
    	}
    	else if (sort.equals("theme")) {
    		// This compares the sets by Theme ascending
			return set1.getTheme().toUpperCase().compareTo(set2.getTheme().toUpperCase());
    	}
    	else if (sort.equals("-theme")) {
    		// This compares the sets by Theme descending
			return set2.getTheme().toUpperCase().compareTo(set1.getTheme().toUpperCase());
    	}
    	else if (sort.equals("numPieces")) {
    		// This compares the sets by Number of Pieces ascending
			return set1.getNum_pieces() - set2.getNum_pieces();
    	}
    	else if (sort.equals("-numPieces")) {
    		// This compares the sets by Number of Pieces descending
			return set2.getNum_pieces() - set1.getNum_pieces();
    	}
    	else if (sort.equals("-set_num")) {
    		// This compares the sets by Set Number descending
    		return set2.getNum().compareTo(set1.getNum());
    	}
    	else {
			// This compares the sets by Set Number ascending
			return set1.getNum().compareTo(set2.getNum());
		}
	}
	
	// This function goes through all rows in the SetInfo table and checking if that set number is in any
	// row of either SetsInProgress or SetsInSetList, if it is in neither it is removed from the database 
	private void removeUnneededSetInfo() {
		List<Set> setsInDB = (List<Set>) setInfoRepo.findAll();;
    	List<SetInProgress> setsInProgress = (List<SetInProgress>) setInProgessRepo.findAll();
    	List<SetInSetList> setsInSetLists = (List<SetInSetList>) setInSetListRepo.findAll();

    	for (Set set : setsInDB) {
    		boolean inSetsInProgress = false;
    		
    		for (SetInProgress setInProgress : setsInProgress) {
    			if (setInProgress.getSet() == set) {
    				inSetsInProgress = true;
    				break;
    			}
    		}

			boolean inSetsInSetLists = false;
    		
    		for (SetInSetList setInSetList : setsInSetLists) {
    			if (setInSetList.getSet() == set) {
    				inSetsInSetLists = true;
    				break;
    			}
    		}
    		
    		if (!inSetsInProgress && !inSetsInSetLists) {
    			setInfoRepo.delete(set);
    		}
    	}
	}
}
