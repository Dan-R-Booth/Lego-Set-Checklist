package lego.checklist.controller;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lego.checklist.domain.Account;
import lego.checklist.repository.AccountRepository;
import lego.checklist.repository.PieceFoundRepository;
import lego.checklist.repository.SetInProgressRepository;
import lego.checklist.repository.SetInSetListRepository;
import lego.checklist.repository.Set_listRepository;
import lego.checklist.repository.SetsOwnedListRepository;
import lego.checklist.validator.AccountValidator;

@Controller
public class DatabaseController {
	
	@Autowired
	private AccountRepository accountRepo;
	
	@InitBinder
	protected void initBinder(WebDataBinder binder) {
		binder.addValidators(new AccountValidator(accountRepo));
	}

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
	
	@PostMapping("/SignUp")
	public String signUp(@Valid @ModelAttribute Account account, BindingResult result, Model model) {
		if (result.hasErrors()) {
			List<ObjectError> allErrors = result.getAllErrors();
			
			boolean emailValid = true;
			boolean passwordValid = true;
			
			for (ObjectError error : allErrors) {
				
				if (error.getCode().equals("email")) {
					emailValid = false;
					model.addAttribute("emailErrorMessage", error.getDefaultMessage());
				}
				
				if (error.getCode().equals("password")) {
					passwordValid = false;
					model.addAttribute("passwordErrorMessage", error.getDefaultMessage());
				}
			}
			
			model.addAttribute("emailValid", emailValid);
			model.addAttribute("passwordValid", passwordValid);
			
			return "index";
		}
		
		accountRepo.save(account);
		
		return "index";
	}
}
