package com.tss.model;

import java.sql.Timestamp;

public class Transaction {
    private int id;
    private String fromAccount;
    private String toAccount;
    private double amount;
    private String type; 
    private Timestamp timestamp;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getFromAccount() {
        return fromAccount;
    }
    public void setFromAccount(String fromAccount) {
        this.fromAccount = fromAccount;
    }

    public String getToAccount() {
        return toAccount;
    }
    public void setToAccount(String toAccount) {
        this.toAccount = toAccount;
    }

    public double getAmount() {
        return amount;
    }
    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }
    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "Transaction [id=" + id + ", from=" + fromAccount + ", to=" + toAccount +
               ", amount=" + amount + ", type=" + type + ", timestamp=" + timestamp + "]";
    }
}
