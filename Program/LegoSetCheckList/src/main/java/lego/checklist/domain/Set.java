package lego.checklist.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Set extends Template {
	
	private int year;
	private String theme;
	private int num_pieces;
	
	public Set(int num, String name, String img_url, int year, String theme, int num_pieces) {
		super(num, name, img_url);
		
		this.year = year;
		this.theme = theme;
		this.num_pieces = num_pieces;
	}
	
	private int getYear() {
		return year;
	}
	private String getTheme() {
		return theme;
	}
	private int getNum_pieces() {
		return num_pieces;
	}
}
