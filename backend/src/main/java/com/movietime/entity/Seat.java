package com.movietime.entity;

import java.io.Serializable;

public class Seat implements Serializable {
    private static final long serialVersionUID = 1L;
    private long id;
    private long showId;
    private int rowNum;
    private int colNum;
    private boolean isBooked;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getShowId() {
        return showId;
    }

    public void setShowId(long showId) {
        this.showId = showId;
    }

    public int getRow() {
        return rowNum;
    }

    public void setRow(int row) {
        this.rowNum = row;
    }

    public int getCol() {
        return colNum;
    }

    public void setCol(int col) {
        this.colNum = col;
    }

    public boolean isBooked() {
        return isBooked;
    }

    public void setBooked(boolean booked) {
        isBooked = booked;
    }
}
