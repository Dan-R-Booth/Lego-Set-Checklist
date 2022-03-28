package lego.checklist.domain;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "SetsInProgress")
public class SetInProgress {
	@Id
	@GeneratedValue
	private int setInProgressId;
	
	@ManyToOne
	@JoinColumn(name = "email", referencedColumnName = "email", nullable = false)
	@OnDelete(action = OnDeleteAction.CASCADE)
	private Account account;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "setNumber", referencedColumnName = "setNumber", nullable = false)
	private Set set;
	
//	@Column(nullable = false)
//	private String setNumber;
//	
//	@Column(nullable = false)
//	private String setName;
//
//	@Column(nullable = false)
//	private int setYear;
//
//	@Column(nullable = false)
//	private String setTheme;
//
//	@Column(nullable = false)
//	private int setNum_pieces;
//
//	@Column(nullable = false)
//	private String setImg_url;

	public SetInProgress() {}

	public SetInProgress(Account account, Set set) {
		this.account = account;
//		this.setNumber = setNumber;
		this.set = set;
	}

//	public SetInProgress(Account account, String setNumber, String setName, int setYear, String setTheme, int setNum_pieces, String setImg_url) {
//		this.account = account;
//		this.setNumber = setNumber;
//		this.setName = setName;
//		this.setYear = setYear;
//		this.setTheme = setTheme;
//		this.setNum_pieces = setNum_pieces;
//		this.setImg_url = setImg_url;
//	}
//
	public int getSetInProgressId() {
		return setInProgressId;
	}

	public Set getSet() {
		return set;
	}
//
//	public Account getAccount() {
//		return account;
//	}
//
//	public String getSetNumber() {
//		return setNumber;
//	}
//
//	public String getSetName() {
//		return setName;
//	}
//
//	public int getSetYear() {
//		return setYear;
//	}
//
//	public String getSetTheme() {
//		return setTheme;
//	}
//
//	public int getSetNum_pieces() {
//		return setNum_pieces;
//	}
//
//	public String getSetImg_url() {
//		return setImg_url;
//	}
}
