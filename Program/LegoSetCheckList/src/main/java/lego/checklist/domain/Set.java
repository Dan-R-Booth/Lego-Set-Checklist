package lego.checklist.domain;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "SetsInSetList")
public class Set {
	@Id
	@GeneratedValue
	private int setInSetListId;
	
	@Column(name = "setNumber", nullable = false)
	private String num;
	
	@Transient
	private String name;

	@Transient
	private int year;

	@Transient
	private String theme;

	@Transient
	private int num_pieces;

	@Transient
	private String img_url;

	@Transient
	private List<Piece> piece_list;
	
	public Set() {}
	
	public Set(String num) {
		this.num = num;
	}
	
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

	public void setPiece_list(List<Piece> piece_list) {
		this.piece_list = piece_list;
	}
}
