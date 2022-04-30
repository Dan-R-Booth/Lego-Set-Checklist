package lego.checklist.domain;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

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

// This class is used to link the Set_list and Set classes and is used for the database so that information on a Lego set does not have to be duplicated if in several Sets in Progress or Setlists.
// It is uses hibernate [1] and JPA annotations [2] to create the 'SetsInSetList' table in the database to store this information.
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
	// Called this as if called set_list the repository would look for variable list in type Set
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