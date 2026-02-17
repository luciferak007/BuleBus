package com.bus.model;

public class Bus {
    private int busId;
    private String route;
    private String type;
    private String seatType;
    private int seatsAvailable;
    private double price;
    private String arrivalTime;
    private String departureTime;

    // Getters and Setters
    public int getBusId() {
    	return busId; }
    public void setBusId(int busId) { 
    	this.busId = busId; }
    public String getRoute() { 
    	return route; }
    public void setRoute(String route) { 
    	this.route = route; }
    public String getType() { 
    	return type; }
    public void setType(String type) { 
    	this.type = type; }
    public String getSeatType() {
    	return seatType; }
    public void setSeatType(String seatType) { 
    	this.seatType = seatType; }
    public int getSeatsAvailable() {
    	return seatsAvailable; }
    public void setSeatsAvailable(int seatsAvailable) {
    	this.seatsAvailable = seatsAvailable; }
    public double getPrice() { 
    	return price; }
    public void setPrice(double price) { 
    	this.price = price; }
    public String getArrivalTime() { 
    	return arrivalTime; }
    public void setArrivalTime(String arrivalTime) { 
    	this.arrivalTime = arrivalTime; }
    public String getDepartureTime() {
    	return departureTime; }
    public void setDepartureTime(String departureTime) { 
    	this.departureTime = departureTime; }
}