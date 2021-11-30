package lego.checklist.domain;

abstract class Template {
	
	private int num;
	private String name;
	private String img_url;
	
	public Template(int num, String name, String img_url) {
		this.num = num;
		this.name = name;
		this.img_url = img_url;
	}
	
	protected int getNum() {
		return num;
	}
	protected String getName() {
		return name;
	}
	protected String getImg_url() {
		return img_url;
	}
}
