package lego.checklist.repository;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.SetInSetList;

public interface SetInSetListRepository extends CrudRepository<SetInSetList, Integer> {
	
}
