package lego.checklist.domain;

import java.util.List;

public class Set {
	
	private String num;
	
	private String name;
	
	private int year;
	
	private String theme;
	
	private int num_pieces;
	
	private String img_url;
	
	private Piece_list set_pieces;
	
	private List<Minifigure> minifigures;
	
	public Set(String num, String name, int year, String theme, int num_pieces, String img_url, Piece_list set_pieces) {
		this.num = num;
		this.name = name;
		this.year = year;
		this.theme = theme;
		this.num_pieces = num_pieces;
		this.img_url = img_url;
		this.set_pieces = set_pieces;
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

	public List<Minifigure> getMinifigures() {
		return minifigures;
	}

	public void setSet_pieces(Piece_list set_pieces) {
		this.set_pieces = set_pieces;
	}
	
	public void setMinifigures(List<Minifigure> minifigures) {
		this.minifigures = minifigures;
	}
}
