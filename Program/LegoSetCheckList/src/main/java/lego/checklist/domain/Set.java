package lego.checklist.domain;

import java.util.List;

public class Set {
	
	private String num;
	
	private String name;
	
	private int year;
	
	private String theme;
	
	private int num_pieces;
	
	private String img_url;
	
	private List<Piece> piece_list;
	
	private List<Minifigure> minifigures;
	
	public Set(String num, String name, int year, String theme, int num_pieces, String img_url) {
		this.num = num;
		this.name = name;
		this.year = year;
		this.theme = theme;
		this.num_pieces = num_pieces;
		this.img_url = img_url;
	}
	
	public Set(String num, String name, int year, String theme, int num_pieces, String img_url, List<Piece> piece_list) {
		this.num = num;
		this.name = name;
		this.year = year;
		this.theme = theme;
		this.num_pieces = num_pieces;
		this.img_url = img_url;
		this.piece_list = piece_list;
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
	
	public List<Piece> getPiece_list() {
		return piece_list;
	}

	public List<Minifigure> getMinifigures() {
		return minifigures;
	}

	public void setPiece_list(List<Piece> piece_list) {
		this.piece_list = piece_list;
	}
	
	public void setMinifigures(List<Minifigure> minifigures) {
		this.minifigures = minifigures;
	}
}
