
package lego.checklist.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "SetsOwnedLists")
public class SetsOwnedList {
	@Id
	@GeneratedValue
	private int setsOwnedListId;
	
	@OneToOne
	@JoinColumn(name = "setListId", referencedColumnName = "setListId", nullable = false)
	private Set_list setList;
	
	@OneToOne
	@JoinColumn(name = "email", referencedColumnName = "email", nullable = false)
	private Account account;

	public SetsOwnedList(int setsOwnedListId, Set_list setList, Account account) {
		super();
		this.setsOwnedListId = setsOwnedListId;
		this.setList = setList;
		this.account = account;
	}

	public int getSetsOwnedListId() {
		return setsOwnedListId;
	}

	public Set_list getSetList() {
		return setList;
	}

	public Account getAccount() {
		return account;
	}
}
