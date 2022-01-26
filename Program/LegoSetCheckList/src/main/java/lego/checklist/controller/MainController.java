package lego.checklist.controller;

import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
	
//	// This creates a RestTemplate JavaBean used to perform HTTP request to a uri
//	// I am using the 
//	// This is declared here in the main controller and is public so it can be 
//	@Bean
//	public RestTemplate restTemplate(RestTemplateBuilder builder) {
//		return builder.build();
//	}
	
	@RequestMapping("/")
	public String home(Model model) {
		return "index";
	}
	
	// This calls the createThemeMap method in the theme controller each time the application is started
	@EventListener(ApplicationReadyEvent.class)
	public void onStartUp() {
		ThemeController.createThemeMap();
		PieceTypeController.createPieceTypeMap();
	}
}
