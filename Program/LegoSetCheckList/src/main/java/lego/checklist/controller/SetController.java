package lego.checklist.controller;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import lego.checklist.domain.Set;

@Controller
public class SetController {
	
	// This stores the basic uri to the Rebrickable API
	public final String rebrickable_uri = "https://rebrickable.com/api/v3/lego/";
	
	// The api key used to access the Rebrickable api
	public final String rebrickable_api_key = "15b84a4cfa3259beb72eb08e7ccf55df";
	
	// This creates a RestTemplate JavaBean used to transform a JSON file into a class
	@Bean
	public RestTemplate restTemplate(RestTemplateBuilder builder) {
		return builder.build();
	}
	
	@RequestMapping("/search")
	public String search(Model model) {
		return "search";
	}
	
	@GetMapping("/set")
	public String showSet(Model model , @RequestParam String set_number, String set_variant, RestTemplate restTemplate) {
		
		// As there are different versions of certain sets denoted by '-' and the version number,
		// the standard for all sets is '-1', so if users don't enter a '-' and version it will automatically add this.
		set_number += "-" + set_variant;
//		set_number += "-1";
		
		// This is the uri to a specific set in the Rebrickable API
		String set_uri = rebrickable_uri + "sets/" + set_number + "/?key=" + rebrickable_api_key;

		// The rest template is used to fetch the Lego set every time the website is loaded
		String set_JSON = restTemplate.getForObject(set_uri, String.class);
		
		set_JSON = set_JSON.replace("\"", "");
		set_JSON = set_JSON.replace("{", "");
		set_JSON = set_JSON.replace("}", "");
		
		String[] set_info = set_JSON.split(",");
		
		String num = "";
		String name = "";
		int year = -1;
		String theme_name = "";
		int num_pieces = -1;
		String img_url = "";
		
		
		for (int i = 0; i < 8; i++) {
			String value = set_info[i].split(":", 2)[1];
			
			switch (i) {
			case 0:
				num = value;
				break;
			case 1:
				name = value;
				break;
			case 2:
				year = Integer.parseInt(value);
				break;
			case 3:
				int theme_id = Integer.parseInt(value);
				theme_name = getTheme(theme_id, restTemplate);
				break;
			case 4:
				num_pieces = Integer.parseInt(value);
				break;
			case 5:
				img_url = value;
				break;
			}
		}
		
		Set set = new Set(num, name, year, theme_name, num_pieces, img_url);
		
		model.addAttribute("set", set);
		return "showSet";
	}
	
	@GetMapping
	public String getTheme(int theme_id, RestTemplate restTemplate) {
		// This is the uri to a specific theme in the Rebrickable API
		String theme_uri = rebrickable_uri + "themes/" + theme_id + "/?key=" + rebrickable_api_key;
		
		// The rest template is used to fetch the Lego set every time the website is loaded
		String theme_JSON = restTemplate.getForObject(theme_uri, String.class);
		
		theme_JSON = theme_JSON.replace("\"", "");
		theme_JSON = theme_JSON.replace("{", "");
		theme_JSON = theme_JSON.replace("}", "");
		
		String[] theme_info = theme_JSON.split(",");
		
		// This adds the name of the theme to a string
		String theme_name = theme_info[2].split(":")[1];
		
		String theme_parent_id = theme_info[1].split(":")[1];
		
		// Checks to see if the theme parent is null
		// If it is not null getTheme() recursively calls itself with the theme_parent_id until there are no more parents,
		// and returns each of these parent theme names on to the end of the first theme name 
		if (!theme_parent_id.equals("null")) {		
			theme_name += ", " + getTheme(Integer.parseInt(theme_parent_id), restTemplate);
		}
		return theme_name;
	}
}
