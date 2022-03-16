package lego.checklist.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "SetsInProgress")
public class SetInProgress {
	@Id
	@GeneratedValue
	private int setInProgressId;
	
	@ManyToOne
	@JoinColumn(name = "email", referencedColumnName = "email", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private Account account;
	
	@Column(nullable = false)
	private String setNumber;

	public SetInProgress() {}

	public SetInProgress(Account account, String setNumber) {
		this.account = account;
		this.setNumber = setNumber;
	}

	public int getSetInProgressId() {
		return setInProgressId;
	}

	public Account getAccount() {
		return account;
	}

	public String getSetNumber() {
		return setNumber;
	}
}
