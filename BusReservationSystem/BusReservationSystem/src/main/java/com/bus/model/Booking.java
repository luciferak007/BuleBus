package com.bus.model;
import java.util.Date;

public class Booking {
    private int bookingId;
    private int userId;
    private int busId;
    private int seatsBooked;
    private Date travelDate;
    private double totalFare;

    public int getBookingId() { 
    	return bookingId; }
    public void setBookingId(int bookingId) { 
    	this.bookingId = bookingId; }
    public int getUserId() { 
    	return userId; }
    public void setUserId(int userId) {
    	this.userId = userId; }
    public int getBusId() {
    	return busId; }
    public void setBusId(int busId) { 
    	this.busId = busId; }
    public int getSeatsBooked() {
    	return seatsBooked; }
    public void setSeatsBooked(int seatsBooked) {
    	this.seatsBooked = seatsBooked; }
    public Date getTravelDate() { 
    	return travelDate; }
    public void setTravelDate(Date travelDate) {
    	this.travelDate = travelDate; }
    public double getTotalFare() {
    	return totalFare; }
    public void setTotalFare(double totalFare) { 
    	this.totalFare = totalFare; }
}