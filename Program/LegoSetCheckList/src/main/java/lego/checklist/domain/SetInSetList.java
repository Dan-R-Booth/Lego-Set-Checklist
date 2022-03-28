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
	
	public SetInSetList() {}
	
	public SetInSetList(Set set) {
		this.set = set;
	}
	
	public Set getSet() {
		return set;
	}
}
