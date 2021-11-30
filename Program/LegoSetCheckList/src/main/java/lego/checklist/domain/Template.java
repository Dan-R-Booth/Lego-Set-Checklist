package lego.checklist.domain;

abstract class Template {
	
	private String num;
	
	private String name;
	
	private String img_url;
	
	public Template(String num, String name, String img_url) {
		this.num = num;
		this.name = name;
		this.img_url = img_url;
	}
	
	public String getNum() {
		return num;
	}
	
	public String getName() {
		return name;
	}
	
	public String getImg_url() {
		return img_url;
	}
}
