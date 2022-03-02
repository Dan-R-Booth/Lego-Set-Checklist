package lego.checklist.repo;

import org.springframework.data.repository.CrudRepository;

import lego.checklist.domain.PieceFound;

public interface PieceFoundRepository extends CrudRepository<PieceFound, Integer> {

}
