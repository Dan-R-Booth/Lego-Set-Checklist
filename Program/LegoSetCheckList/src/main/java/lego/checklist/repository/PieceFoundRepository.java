package lego.checklist.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.PieceFound;
import lego.checklist.domain.SetInProgress;

public interface PieceFoundRepository extends CrudRepository<PieceFound, Integer> {
	public List<PieceFound> findBySetInProgress(SetInProgress setInProgress);
	
	@Transactional
	public void deleteBySetInProgress(SetInProgress setInProgress);
}
