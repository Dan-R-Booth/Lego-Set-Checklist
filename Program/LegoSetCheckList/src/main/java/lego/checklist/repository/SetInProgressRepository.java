package lego.checklist.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Account;
import lego.checklist.domain.Set;
import lego.checklist.domain.SetInProgress;

public interface SetInProgressRepository extends CrudRepository<SetInProgress, Integer> {
	public List<SetInProgress> findByAccount(Account account);
	
	public SetInProgress findByAccountAndSet(Account account, Set set);
}
