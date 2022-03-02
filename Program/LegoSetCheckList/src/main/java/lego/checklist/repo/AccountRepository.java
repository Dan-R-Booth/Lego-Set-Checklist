package lego.checklist.repo;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Account;

public interface AccountRepository extends CrudRepository<Account, String> {
	
}
