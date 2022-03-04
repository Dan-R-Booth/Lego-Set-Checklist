package lego.checklist.repository;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Set;

public interface SetInSetListRepository extends CrudRepository<Set, Integer> {
	
}
