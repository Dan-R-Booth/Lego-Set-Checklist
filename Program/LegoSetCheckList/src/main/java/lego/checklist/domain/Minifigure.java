package lego.checklist.domain;

import java.util.List;

public class Minifigure {

	private String num;
	private int quantity;
	private List<Piece> minifigure_pieces;
	
	public Minifigure(String num, int quantity, List<Piece> minifigure_pieces) {
		this.num = num;
		this.quantity = quantity;
		this.minifigure_pieces = minifigure_pieces;
	}

	public String getNum() {
		return num;
	}

	public int getQuantity() {
		return quantity;
	}
	
	public List<Piece> getMinifigure_pieces() {
		return minifigure_pieces;
	}

	public void setMinifigure_pieces(List<Piece> minifigure_pieces) {
		this.minifigure_pieces = minifigure_pieces;
	}
}
