package com.project.crm.workbench.domain;

public class Customer {
	
	private String id;//客户表id
	private String owner;//客户拥有者？
	private String name; //姓名
	private String website;//网站？工作地点？
	private String phone;//手机号
	private String createBy;//创建人
	private String createTime;//创建时间
	private String editBy;//编辑人
	private String editTime;//编辑时间
	private String contactSummary;//练习概述
	private String nextContactTime;//预计下次联系时间
	private String description;//描述
	private String address;//地址


	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOwner() {
		return owner;
	}
	public void setOwner(String owner) {
		this.owner = owner;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getWebsite() {
		return website;
	}
	public void setWebsite(String website) {
		this.website = website;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getCreateBy() {
		return createBy;
	}
	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getEditBy() {
		return editBy;
	}
	public void setEditBy(String editBy) {
		this.editBy = editBy;
	}
	public String getEditTime() {
		return editTime;
	}
	public void setEditTime(String editTime) {
		this.editTime = editTime;
	}
	public String getContactSummary() {
		return contactSummary;
	}
	public void setContactSummary(String contactSummary) {
		this.contactSummary = contactSummary;
	}
	public String getNextContactTime() {
		return nextContactTime;
	}
	public void setNextContactTime(String nextContactTime) {
		this.nextContactTime = nextContactTime;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}

	@Override
	public String toString() {
		return "Customer{" +
				"id='" + id + '\'' +
				", owner='" + owner + '\'' +
				", name='" + name + '\'' +
				", website='" + website + '\'' +
				", phone='" + phone + '\'' +
				", createBy='" + createBy + '\'' +
				", createTime='" + createTime + '\'' +
				", editBy='" + editBy + '\'' +
				", editTime='" + editTime + '\'' +
				", contactSummary='" + contactSummary + '\'' +
				", nextContactTime='" + nextContactTime + '\'' +
				", description='" + description + '\'' +
				", address='" + address + '\'' +
				'}';
	}
}
