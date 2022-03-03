package lego.checklist.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;

import lego.checklist.domain.Account;
import lego.checklist.repo.AccountRepository;
import lego.checklist.repo.PieceFoundRepository;
import lego.checklist.repo.SetInProgressRepository;
import lego.checklist.repo.SetInSetListRepository;
import lego.checklist.repo.Set_listRepository;
import lego.checklist.repo.SetsOwnedListRepository;

@Controller
public class DatabaseController {
	
	@Autowired
	private AccountRepository accountRepo;

	@Autowired
	private SetsOwnedListRepository setsOwnedListRepo;
	
	@Autowired
	private Set_listRepository set_listRepo;

	@Autowired
	private SetInSetListRepository setRepo;

	@Autowired
	private SetInProgressRepository setInProgessRepo;
	
	@Autowired
	private PieceFoundRepository pieceFoundRepo;
	
	@GetMapping("/SignUp")
	public String signUp(@RequestParam(required = true) String email, @RequestParam(required = true) String password) {
		Account account = new Account(email, password);
		
		accountRepo.save(account);
		
		return "index";
	}
}
