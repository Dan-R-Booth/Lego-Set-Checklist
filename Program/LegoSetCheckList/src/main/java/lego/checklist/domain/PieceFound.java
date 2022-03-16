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
