package lego.checklist.domain;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "SetsInSetList")
public class SetInSetList {
	@Id
	@GeneratedValue
	private int setInSetListId;
	
	@ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.DETACH)
	@JoinColumn(name = "setNumber", referencedColumnName = "setNumber", nullable = false)
	private Set set;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "setListId", nullable = false)
	// Called this as if called set_list the repo would look for variable list in type Set
	private Set_list listOfSets;
	
	public SetInSetList() {}
	
	public SetInSetList(Set set, Set_list set_list) {
		this.set = set;
		this.listOfSets = set_list;
	}
	
	public Set getSet() {
		return set;
	}
}