package lego.checklist.repository;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.SetsOwnedList;

public interface SetsOwnedListRepository extends CrudRepository<SetsOwnedList, Integer> {
	public SetsOwnedList findByAccount(String email);
}
