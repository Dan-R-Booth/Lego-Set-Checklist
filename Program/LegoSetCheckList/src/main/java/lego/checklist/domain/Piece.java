package lego.checklist.domain;

// This class is used to store Lego Piece information received from the Rebrickable API.
public class Piece {
	
	private String num;
	private String name;
	private String pieceType;
	private String img_url;
	private String piece_url;
	private String colour_name;
	private int quantity;
	private int quantity_checked;
	private boolean spare;
	
	public Piece(String num, String name, String pieceType, String img_url, String piece_url, String colour_name, int quantity, int quantity_checked, boolean spare) {
		this.num = num;
		this.name = name;
		this.pieceType = pieceType;
		this.img_url = img_url;
		this.piece_url = piece_url;
		this.colour_name = colour_name;
		this.quantity = quantity;
		this.quantity_checked = quantity_checked;
		this.spare = spare;
	}

	public String getNum() {
		return num;
	}
	
	public String getName() {
		return name;
	}
	
	public String getPieceType() {
		return pieceType;
	}
	
	public String getImg_url() {
		return img_url;
	}
	
	public String getPiece_url() {
		return piece_url;
	}
	
	public String getColour_name() {
		return colour_name;
	}

	public int getQuantity() {
		return quantity;
	}

	public int getQuantity_checked() {
		return quantity_checked;
	}
	
	public boolean isSpare() {
		return spare;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public void setQuantity_checked(int quantity_checked) {
		this.quantity_checked = quantity_checked;
	}
}
