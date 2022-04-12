package lego.checklist.repository;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Account;

public interface AccountRepository extends CrudRepository<Account, String> {
	public Account findByEmail(String email);
}
