package lego.checklist.controller;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lego.checklist.domain.Account;

@Controller
public class MainController {
	
	@GetMapping("/")
	public String home(Model model) {
		// This adds the a new account class that will be used by the forms to login and create an account
		model.addAttribute("account", new Account());
		
		return "index";
	}
	
	// This calls the createThemeMap method in the theme controller each time the application is started
	// It then calls the createPieceTypeMap method in the PieceType controller
	@EventListener(ApplicationReadyEvent.class)
	public void onStartUp() {
		ThemeController.createThemeMap();
		PieceTypeController.createPieceTypeMap();
	}
}
