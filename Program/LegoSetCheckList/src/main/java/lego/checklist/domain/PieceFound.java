package lego.checklist.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

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

// This class is used to link to store indeifiying information on Lego Pieces that are part of a Set in Progress, along with the quantity found of this type of piece.
// (I only ever store a piece when its quantity found is above 0, to save space in the database)
// It is uses hibernate [1] and JPA annotations [2] to create the 'PiecesFound' table in the database to store this information.
@Entity
@Table(name = "PiecesFound")
public class PieceFound {
	@Id
	@GeneratedValue
	private int pieceFoundId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "setInProgressId", referencedColumnName = "setInProgressId", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private SetInProgress setInProgress;
	
	@Column(nullable = false)
	private String pieceNumber;

	@Column(nullable = false)
	private String colourName;
	
	@Column(nullable = false)
	private boolean isSpare;
	
	@Column(nullable = false)
	private int quantityFound;

	public PieceFound() {}
	
	public PieceFound(SetInProgress setInProgress, String pieceNumber, String colourName, boolean isSpare, int quantityFound) {
		this.setInProgress = setInProgress;
		this.pieceNumber = pieceNumber;
		this.colourName = colourName;
		this.isSpare = isSpare;
		this.quantityFound = quantityFound;
	}

	public int getPieceFoundId() {
		return pieceFoundId;
	}

	public SetInProgress getSetInProgress() {
		return setInProgress;
	}

	public String getPieceNumber() {
		return pieceNumber;
	}

	public String getColourName() {
		return colourName;
	}

	public boolean isSpare() {
		return isSpare;
	}

	public int getQuantityFound() {
		return quantityFound;
	}
}
