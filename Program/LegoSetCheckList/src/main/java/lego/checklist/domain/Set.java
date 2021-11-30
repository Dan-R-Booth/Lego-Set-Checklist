package lego.checklist.domain;

public class Set extends Template {
	
	private int year;
	
	private String theme;
	
	private int num_pieces;
	
	private Piece_list set_pieces;
	
	public Set(String num, String name, int year, String theme, int num_pieces, String img_url) {
		super(num, name, img_url);
		
		this.year = year;
		this.theme = theme;
		this.num_pieces = num_pieces;
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
	
	public Piece_list getSet_pieces() {
		return set_pieces;
	}
}
