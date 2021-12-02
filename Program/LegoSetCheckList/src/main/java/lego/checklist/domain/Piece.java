package lego.checklist.domain;

public class Piece {
	
	private String num;
	private String name;
	private String img_url;
	private String colour_name;
	private int quantity;
	private int quantity_checked;
	
	public Piece(String num, String name, String img_url, String colour_name, int quantity, int quantity_checked) {
		this.num = num;
		this.name = name;
		this.img_url = img_url;
		this.colour_name = colour_name;
		this.quantity = quantity;
		this.quantity_checked = quantity_checked;
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
