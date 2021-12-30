package lego.checklist.domain;

public class Minifigure {

	private String num;
	private String name;
	private String img_url;
	private int quantity;
	private int quantity_checked;
	private Piece_list minifigure_pieces;
	
	public Minifigure(String num, String name, String img_url, int quantity, int quantity_checked, Piece_list minifigure_pieces) {
		this.num = num;
		this.name = name;
		this.img_url = img_url;
		this.quantity = quantity;
		this.quantity_checked = quantity_checked;
		this.minifigure_pieces = minifigure_pieces;
	}

	public String getNum() {
		return num;
	}

	public String getName() {
		return name;
	}

	public String getImg_url() {
		return img_url;
	}

	public int getQuantity() {
		return quantity;
	}

	public int getQuantity_checked() {
		return quantity_checked;
	}
	
	public Piece_list getSet_pieces() {
		return minifigure_pieces;
	}

	public void setQuantity_checked(int quantity_checked) {
		this.quantity_checked = quantity_checked;
	}

	public void setSet_pieces(Piece_list minifigure_pieces) {
		this.minifigure_pieces = minifigure_pieces;
	}
}
