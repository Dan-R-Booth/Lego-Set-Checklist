package lego.checklist.domain;

//This class is used to store Lego Set Theme information received from the Rebrickable API.
public class Theme {
	
	private int id;
	
	private String name;
	
	private int parent_id;
	
	public Theme(int id, String name) {
		this.id = id;
		this.name = name;
	}
	
	public Theme(int id, String name, int parent_id) {
		this.id = id;
		this.name = name;
		this.parent_id = parent_id;
	}

	public int getId() {
		return id;
	}
	
	public String getName() {
		return name;
	}
	
	public int getParent_id() {
		return parent_id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setParent_id(int parent_id) {
		this.parent_id = parent_id;
	}
}
