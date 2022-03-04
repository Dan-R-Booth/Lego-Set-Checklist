package lego.checklist.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.PieceFound;

public interface PieceFoundRepository extends CrudRepository<PieceFound, Integer> {
	public List<PieceFound> findBySetInProgress(int setInProgressId);
}
