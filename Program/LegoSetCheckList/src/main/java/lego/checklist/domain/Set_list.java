package lego.checklist.domain;

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
	@JoinColumn(name = "email", referencedColumnName = "email", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private Account account;
	
	@Column(nullable = false)
	private String listName;
	
	@OneToMany(orphanRemoval = true, fetch = FetchType.LAZY)
	@JoinColumn(name = "setListId", nullable = false)
	private List<Set> sets;
	
	@Column(nullable = false)
	private int totalSets;

	public Set_list() {}
	
	public Set_list(Account account, String listName, List<Set> sets, int totalSets) {
		this.account = account;
		this.listName = listName;
		this.sets = sets;
		this.totalSets = totalSets;
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
	
	public List<Set> getSets() {
		return sets;
	}

	public int getTotalSets() {
		return totalSets;
	}

	public void setListName(String listName) {
		this.listName = listName;
	}
	
	public void addSet(Set set) {
		sets.add(set);
		totalSets++;
	}
	
	public void removeSet(Set set) {
		sets.remove(set);
		totalSets--;
	}
	
	public boolean contains(String set_number) {
		for (Set set : sets) {
			if (set_number.equals(set.getNum())) {
				return true;
			}
		}
		return false;
	}
}
