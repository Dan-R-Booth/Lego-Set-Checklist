package lego.checklist.controller;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lego.checklist.domain.Account;

@Controller
public class MainController {
	
	// This opens the website home page
	@GetMapping("/")
	public String home(Model model) {
		// This adds the a new account class that will be used by the forms to login and create an account
		model.addAttribute("account", new Account());
		
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
