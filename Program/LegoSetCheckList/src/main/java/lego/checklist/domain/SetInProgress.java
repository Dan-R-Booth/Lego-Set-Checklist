package lego.checklist.domain;

import javax.persistence.CascadeType;
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
@Table(name = "SetsInProgress")
public class SetInProgress {
	@Id
	@GeneratedValue
	private int setInProgressId;
	
	@ManyToOne
	@JoinColumn(name = "accountId", referencedColumnName = "accountId", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private Account account;
	
	@ManyToOne(fetch = FetchType.EAGER, cascade = CascadeType.DETACH)
	@JoinColumn(name = "setNumber", referencedColumnName = "setNumber", nullable = false)
	private Set set;

	public SetInProgress() {}

	public SetInProgress(Account account, Set set) {
		this.account = account;
		this.set = set;
	}

	public int getSetInProgressId() {
		return setInProgressId;
	}

	public Set getSet() {
		return set;
	}
}
