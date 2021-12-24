package lego.checklist.domain;

public class Set {
	
	private String num;
	
	private String name;
	
	private int year;
	
	private String theme;
	
	private int num_pieces;
	
	private String img_url;
	
	private Piece_list set_pieces;
	
	public Set(String num, String name, int year, String theme, int num_pieces, String img_url) {
		this.num = num;
		this.name = name;
		this.year = year;
		this.theme = theme;
		this.num_pieces = num_pieces;
		this.img_url = img_url;
	}
	
	public String getNum() {
		return num;
	}
	
	public String getName() {
		return name;
	}
	
	public int getYear() {
		return year;
	}
	
	public String getTheme() {
		return theme;
	}
	
	public int getNum_pieces() {
		return num_pieces;
	}
	
	public String getImg_url() {
		return img_url;
	}
	
	public Piece_list getSet_pieces() {
		return set_pieces;
	}

	public void setSet_pieces(Piece_list set_pieces) {
		this.set_pieces = set_pieces;
	}
}
