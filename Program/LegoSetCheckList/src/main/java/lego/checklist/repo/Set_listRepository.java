package lego.checklist.repo;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Set;
import lego.checklist.domain.Set_list;

public interface Set_listRepository extends CrudRepository<Set_list, Integer> {
	public Set_list findById(int id);
	
	public List<Set_list> findByAccount(String email);
	
	public Set_list findByAccountAndListName(String email, String listName);
	
	public List<Set> findBySetListId(int setListId);
}
