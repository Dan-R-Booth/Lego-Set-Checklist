package lego.checklist.domain;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

/* References:
 * [1]	V. Mihalcea, S. Ebersole, A. Boriero, G. Morling, G. Badner, C. Cranford, E. Bernard, S. Grinovero, B. Meyer, H. Ferentschik, G. King, C. Bauer, M. Andersen, K. Maesen, R.Vansa and L. Jacomet,
 * 		“Hibernate ORM 5.5.9.Final User Guide”,
 * 		Docs.jboss.org. [online]
 * 		Available: https://docs.jboss.org/hibernate/orm/current/userguide/html_single/Hibernate_User_Guide.html. [Accessed: 28- Feb- 2022].
 * [2]	O. Gierke, T. Darimont, C. Strobl, M. Paluch and J. Bryant,
 * 		"Spring Data JPA - Reference Documentation",
 * 		docs.spring.io, 2022. [Online].
 * 		Available: https://docs.spring.io/spring-data/jpa/docs/current/reference/html/. [Accessed: 28- Feb- 2022]
 */

// This class is used to store Lego Set information received from the Rebrickable API.
// It is also uses hibernate [1] and JPA annotations [2] to create the 'SetInfo' table in the database to store information on Lego Set's that are either in a Setlist or is a Set in Progress.
@Entity
@Table(name = "SetInfo")
public class Set {
	@Id	
	@Column(name = "setNumber", nullable = false)
	private String num;
	
	private String name;

	private int year;

	private String theme;

	private int num_pieces;

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
