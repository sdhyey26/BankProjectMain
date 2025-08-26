package com.tss.model;

import java.util.ArrayList;
import java.util.List;

public class User {
	public User(int userId, String username, String fullName, String email, String role) {
		this.userId = userId;
		this.username = username;
		this.FullName = fullName;
		this.email = email;
		this.role = role;
	}

	public User() {
		super();
	}

	public User(int id, String username, String fullName, String email) {
		this.userId = id;
		this.username = username;
		this.FullName = fullName;
		this.email = email;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAadhar() {
		return aadhar;
	}

	public void setAadhar(String aadhar) {
		this.aadhar = aadhar;
	}

	public String getAccountType() {
		return accountType;
	}

	public void setAccountType(String accountType) {
		this.accountType = accountType;
	}

	public double getInitialDeposit() {
		return initialDeposit;
	}

	public void setInitialDeposit(double initialDeposit) {
		this.initialDeposit = initialDeposit;
	}

	private int userId;
	private String username;
	private String password;
	private String role;
	private String name;

	public String getFullName() {
		return FullName;
	}

	public void setFullName(String fullName) {
		FullName = fullName;
	}

	private String FullName;
	private String mobile;
	private String email;
	private String aadhar;
	private String accountType;
	private double initialDeposit;

	private List<Account> accounts = new ArrayList<>();

	public List<Account> getAccounts() {
		return accounts;
	}

	public void setAccounts(List<Account> accounts) {
		this.accounts = accounts;
	}
}
