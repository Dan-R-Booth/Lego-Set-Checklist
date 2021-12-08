package lego.checklist.domain;

import java.util.List;

public class Piece_list {
	
//	private Piece[] pieces;
	private List<Piece> pieces;
	
	public Piece_list(List<Piece> pieces) {
		this.pieces = pieces;
	}

	public List<Piece> getPieces() {
		return pieces;
	}
}
