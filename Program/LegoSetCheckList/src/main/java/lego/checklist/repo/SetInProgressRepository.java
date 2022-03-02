package lego.checklist.repo;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.SetInProgress;

public interface SetInProgressRepository extends CrudRepository<SetInProgress, Integer> {
	public List<SetInProgress> findByAccount(String email);
}
