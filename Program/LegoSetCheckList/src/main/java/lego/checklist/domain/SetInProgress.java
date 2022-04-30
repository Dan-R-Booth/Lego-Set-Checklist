package lego.checklist.domain;

import java.time.LocalDateTime;

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

// This class is used to link to a Set class that the user has saved a piece checklist for, and is used for the database so that information on a Lego set
// does not have to be duplicated if in several Sets in Progress or Setlists.
// It is uses hibernate [1] and JPA annotations [2] to create the 'SetsInProgress' table in the database to store this information.
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
	
	private LocalDateTime lastChangedDateTime;

	public SetInProgress() {}

	public SetInProgress(Account account, Set set) {
		this.account = account;
		this.set = set;
		this.lastChangedDateTime = LocalDateTime.now();
	}

	public int getSetInProgressId() {
		return setInProgressId;
	}

	public Set getSet() {
		return set;
	}
	
	public LocalDateTime getLastChangedDateTime() {
		return lastChangedDateTime;
	}

	public void updateDateTime() {
		this.lastChangedDateTime = LocalDateTime.now();
	}
}
