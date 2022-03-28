package lego.checklist.repository;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.Set;

public interface SetInfoRepository extends CrudRepository<Set, Integer> {
	public Set findByNum(String setNumber);
}
