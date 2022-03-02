package lego.checklist.repo;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Set;

public interface SetInSetListRepository extends CrudRepository<Set, Integer> {
	
}
