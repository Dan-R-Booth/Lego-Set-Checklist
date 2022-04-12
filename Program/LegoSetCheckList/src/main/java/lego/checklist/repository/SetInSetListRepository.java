package lego.checklist.repository;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Set;
import lego.checklist.domain.SetInSetList;
import lego.checklist.domain.Set_list;

public interface SetInSetListRepository extends CrudRepository<SetInSetList, Integer> {
	
	public SetInSetList findByListOfSetsAndSet(Set_list set_list, Set set);
}
