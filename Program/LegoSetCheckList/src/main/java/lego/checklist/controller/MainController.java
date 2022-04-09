package lego.checklist.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lego.checklist.domain.Account;
import lego.checklist.domain.Set;
import lego.checklist.domain.SetInProgress;
import lego.checklist.domain.Set_list;
import lego.checklist.repository.SetInProgressRepository;

@Controller
public class MainController {
	
	@Autowired
	private SetInProgressRepository setInProgessRepo;
	
	// This opens the website's home page
	@GetMapping("/")
	public String home(Model model, @SessionAttribute(value = "accountLoggedIn", required = false) Account account, @SessionAttribute(value="set_lists", required=false) List<Set_list> set_lists) {
		// This adds the a new account class that will be used by the forms to login and create an account
		model.addAttribute("account", new Account());
		
		// If the user is logged in this gets the three last edited set lists to display to the user for quick access,
		// along with the 3 last edited sets in progress to be displayed as well
		if (account != null) {
			List<Set_list> lastChangedSet_lists = new ArrayList<>();
			
			// This gets the user's last three edited set lists that will be displayed to the user (set lists are sorted by last changed date time descending)
			for (int i = 0; i < 3; i++) {
				if (i < set_lists.size()) {
					lastChangedSet_lists.add(set_lists.get(i));
				}
			}
			
			model.addAttribute("lastChangedSet_lists", lastChangedSet_lists);
			
			List<SetInProgress> setsInProgress = setInProgessRepo.findByAccount(account);
			
			// This sorts the sets in progress for the user by time and date last changed descending
			Collections.sort(setsInProgress, new Comparator<SetInProgress>() {
				@Override
				public int compare(SetInProgress setInProgress1, SetInProgress setInProgress2) {
					return setInProgress2.getLastChangedDateTime().compareTo(setInProgress1.getLastChangedDateTime());
				}
			});
			
			List<SetInProgress> lastChangedSetsInProgress = new ArrayList<>();
			
			// This gets the user's last three edited sets in progress that will be displayed to the user
			for (int i = 0; i < 3; i++) {
				if (i < setsInProgress.size()) {
					lastChangedSetsInProgress.add(setsInProgress.get(i));
				}
			}
			
			List<Set> sets = new ArrayList<>();
			
			// This gets all the set info for all the sets the user has in progress
			for (SetInProgress setInProgress : lastChangedSetsInProgress) {
				Set set = setInProgress.getSet();
				sets.add(set);
			}
			
			model.addAttribute("sets", sets);
		}
		
		return "index";
	}
	
	// This adds a redirect flash attribute to open the login and sign up modal on the index page and then redirects to that page
	@GetMapping("/openLogin_SignUp_Modal")
	public String openLogin_SignUpModal(RedirectAttributes redirectAttributes) {
		redirectAttributes.addFlashAttribute("openLogin_SignUp_Modal", true);
		
		return "redirect:/";
	}
	
	
	// This calls the createThemeMap method in the theme controller each time the application is started
	// It then calls the createPieceTypeMap method in the PieceType controller
	@EventListener(ApplicationReadyEvent.class)
	public void onStartUp() {
		ThemeController.createThemeMap();
		PieceTypeController.createPieceTypeMap();
	}
}
