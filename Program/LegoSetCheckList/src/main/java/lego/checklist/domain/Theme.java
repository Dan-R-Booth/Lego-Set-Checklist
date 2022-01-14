package lego.checklist.domain;

public class Theme {
	
	private String name;
	
	private int parent_id;
	
	public Theme(String name, int parent_id) {
		this.name = name;
		this.parent_id = parent_id;
	}

	public int getParent_id() {
		return parent_id;
	}

	public String getName() {
		return name;
	}
}
