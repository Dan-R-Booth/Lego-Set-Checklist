package lego.checklist.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "PiecesFound")
public class PieceFound {
	@Id
	@GeneratedValue
	private int pieceFoundId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "setsInProgressId", referencedColumnName = "setsInProgressId", nullable = false)
	private SetInProgress setInProgress;
	
	@Column(nullable = false)
	private String pieceNumber;

	@Column(nullable = false)
	private String colourNumber;
	
	@Column(nullable = false)
	private boolean isSpare;
	
	@Column(nullable = false)
	private int quantityFound;

	public PieceFound(int pieceFoundId, SetInProgress setInProgress, String pieceNumber, String colourNumber, boolean isSpare, int quantityFound) {
		this.pieceFoundId = pieceFoundId;
		this.setInProgress = setInProgress;
		this.pieceNumber = pieceNumber;
		this.colourNumber = colourNumber;
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

	public String getColourNumber() {
		return colourNumber;
	}

	public boolean isSpare() {
		return isSpare;
	}

	public int getQuantityFound() {
		return quantityFound;
	}
}
