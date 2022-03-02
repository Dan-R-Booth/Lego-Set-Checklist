package lego.checklist.repo;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.SetsOwnedList;

public interface SetsOwnedListRepository extends CrudRepository<SetsOwnedList, Integer> {

}
