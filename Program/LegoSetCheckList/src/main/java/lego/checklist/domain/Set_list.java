package lego.checklist.domain;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name= "SetLists")
public class Set_list {
	@Id
	@GeneratedValue
	private int setListId;
	
	@ManyToOne
	@JoinColumn(name = "email", referencedColumnName = "email")
	private Account account;
	
	private String listName;
	
	@Transient
	private Set[] sets;
	
	public int getSetListId() {
		return setListId;
	}

	public Account getAccount() {
		return account;
	}

	public String getListName() {
		return listName;
	}
	
	public Set[] getSets() {
		return sets;
	}

	public void setListName(String listName) {
		this.listName = listName;
	}
	
	public void addList() {}
	
	public void removeList() {}
}
