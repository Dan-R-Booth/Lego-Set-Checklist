package lego.checklist.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Account;
import lego.checklist.domain.Set_list;

public interface Set_listRepository extends CrudRepository<Set_list, Integer> {
	public Set_list findBySetListId(int setListId);
	
	public List<Set_list> findByAccount(Account account);
	
	public Set_list findByAccountAndSetListId(Account account, int setListId);
	
	public Set_list findByAccountAndListName(Account account, String listName);
}