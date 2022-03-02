package lego.checklist.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "SetsInProgress")
public class SetInProgress {
	@Id
	@GeneratedValue
	private int setsInProgressId;
	
	@ManyToOne
	@JoinColumn(name = "email", referencedColumnName = "email", nullable = false)
	private Account account;
	
	@Column(nullable = false)
	private String setNumber;

	public SetInProgress(int setsInProgressId, Account account, String setNumber) {
		this.setsInProgressId = setsInProgressId;
		this.account = account;
		this.setNumber = setNumber;
	}

	public int getSetsInProgressId() {
		return setsInProgressId;
	}

	public Account getAccount() {
		return account;
	}

	public String getSetNumber() {
		return setNumber;
	}
}
