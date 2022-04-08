package lego.checklist.domain;

import java.time.LocalDateTime;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "SetLists")
public class Set_list {
	@Id
	@GeneratedValue
	private int setListId;
	
	@ManyToOne
	@JoinColumn(name = "accountId", referencedColumnName = "accountId", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private Account account;
	
	@Column(nullable = false)
	private String listName;
	
	@OneToMany(mappedBy = "listOfSets", orphanRemoval = true, fetch = FetchType.LAZY)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private List<SetInSetList> setsInSetList;
	
	@Column(nullable = false)
	private int totalSets;
	
	private LocalDateTime lastChangedDateTime;

	public Set_list() {}
	
	public Set_list(Account account, String listName, List<SetInSetList> setsInSetList, int totalSets) {
		this.account = account;
		this.listName = listName;
		this.setsInSetList = setsInSetList;
		this.totalSets = totalSets;
		this.lastChangedDateTime = LocalDateTime.now();
	}

	public int getSetListId() {
		return setListId;
	}

	public Account getAccount() {
		return account;
	}

	public String getListName() {
		return listName;
	}
	
	public List<SetInSetList> getSets() {
		return setsInSetList;
	}

	public int getTotalSets() {
		return totalSets;
	}

	public void setListName(String listName) {
		this.listName = listName;
	}
	
	public void setSetsInSetList(List<SetInSetList> setsInSetList) {
		this.setsInSetList = setsInSetList;
	}

	public void addSet(SetInSetList setInSetList) {
		setsInSetList.add(setInSetList);
		totalSets++;
	}
	
	public void removeSet() {
		totalSets--;
	}
	
	public boolean contains(String set_number) {
		for (SetInSetList setInSetList : setsInSetList) {
			if (set_number.equals(setInSetList.getSet().getNum())) {
				return true;
			}
		}
		return false;
	}
	
	public LocalDateTime getLastChangedDateTime() {
		return lastChangedDateTime;
	}
	
	public void updateDateTime() {
		this.lastChangedDateTime = LocalDateTime.now();
	}
}
