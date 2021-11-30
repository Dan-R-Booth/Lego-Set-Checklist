package lego.checklist.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

public class SearchController {

	@RequestMapping("/search")
	public String search(Model model) {
		return "search";
	}
	
	@RequestMapping("/showSet")
	public String showSet(Model model) {
		return "showSet";
	}
}
