package lego.checklist.domain;

public class Piece extends Template {

	private String colour_name;
	private int quantity;
	private int quantity_checked;
	
	public Piece(String num, String name, String img_url, String colour_name, int quantity, int quantity_checked) {
		super(num, name, img_url);
		this.colour_name = colour_name;
		this.quantity = quantity;
		this.quantity_checked = quantity_checked;
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

	public void setQuantity_checked(int quantity_checked) {
		this.quantity_checked = quantity_checked;
	}
}
