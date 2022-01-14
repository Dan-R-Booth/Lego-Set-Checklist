package lego.checklist.domain;

public class Theme {
	private int id;
	
	private int parent_id;
	
	private String name;
	
	public Theme(int id, int parent_id, String name) {
		this.id = id;
		this.parent_id = parent_id;
		this.name = name;
	}

	protected int getId() {
		return id;
	}

	protected int getParent_id() {
		return parent_id;
	}

	protected String getName() {
		return name;
	}
}
