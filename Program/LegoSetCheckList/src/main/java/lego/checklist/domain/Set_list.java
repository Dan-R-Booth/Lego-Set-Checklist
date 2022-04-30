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

// This class is used to store a user's Setlist that has just been created or retrieved from the database, and store a list of SetInSetList that are part of this setlist.
// It is also uses hibernate [1] and JPA annotations [2] to create the 'SetLists' table in the database to store this information.
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
	
	// This checks if the Setlist contains a certain Lego Set by checking
	// if any of the SetInSetLists have the same Set Number
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
