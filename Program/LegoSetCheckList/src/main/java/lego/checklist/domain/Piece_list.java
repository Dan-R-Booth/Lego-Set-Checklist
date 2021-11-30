package lego.checklist.domain;

public class Piece_list {
	
	private Piece[] pieces;
	
	public Piece_list(Piece[] pieces) {
		this.pieces = pieces;
	}

	private Piece[] getPieces() {
		return pieces;
	}
}
