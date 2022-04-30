package lego.checklist.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
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

// This class is used to store information on a user's Account which has just been created or retrieved from the database.
// It is also uses hibernate [1] and JPA annotations [2] to create the 'Accounts' table in the database to store this information.
@Entity
@Table(name = "Accounts")
public class Account {
	@Id
	@GeneratedValue
	private int accountId;
	
	@Column(unique = true, nullable = false)
	private String email;
	
	@Column(nullable = false)
	private String password;
	
	public Account() {}
	
	public Account(String email, String password) {
		this.email = email;
		this.password = password;
	}
	
	public int getAccountId() {
		return accountId;
	}

	public String getEmail() {
		return email;
	}

	public String getPassword() {
		return password;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
