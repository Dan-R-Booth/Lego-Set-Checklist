package lego.checklist.controller;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

@Controller
public class MainController {
	
	// This creates a RestTemplate JavaBean used to perform HTTP request to a uri
	// I am using the 
	// This is declared here in the main controller and is public so it can be 
//	@Bean
//	public RestTemplate restTemplate(RestTemplateBuilder builder) {
//		return builder.build();
//	}
	
	@RequestMapping("/")
	public String home(Model model) {
		return "index";
	}
}
