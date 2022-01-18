package lego.checklist.domain;

public class Piece {
	
	private String num;
	private String name;
	private String pieceCategory;
	private String img_url;
	private String colour_name;
	private int quantity;
	private int quantity_checked;
	private boolean spare;
	
	public Piece(String num, String name, String pieceCategory, String img_url, String colour_name, int quantity, int quantity_checked, boolean spare) {
		this.num = num;
		this.name = name;
		this.pieceCategory = pieceCategory;
		this.img_url = img_url;
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
	
	public String getPieceCategory() {
		return pieceCategory;
	}
	
	public String getImg_url() {
		return img_url;
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
