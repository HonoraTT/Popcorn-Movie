package com.movietime.controller.api;

import com.movietime.entity.Seat;
import com.movietime.service.SeatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/seats")
@CrossOrigin(origins = "*")
public class SeatApiController {
    
    @Autowired
    private SeatService seatService;
    
    @GetMapping("/show/{showId}")
    public ResponseEntity<?> getSeatMap(@PathVariable Long showId) {
        String[] seatMap = seatService.getSeatMap(showId);
        String[] soldSeats = seatService.getSoldSeat(showId);
        Map<String, Object> response = new HashMap<>();
        response.put("showId", showId);
        response.put("seatMap", seatMap);
        response.put("soldSeats", soldSeats);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/book")
    public ResponseEntity<?> bookSeats(@RequestBody BookingRequest request) {
        try {
            // 这里需要实现座位预订逻辑
            Map<String, Object> response = new HashMap<>();
            response.put("message", "预订成功");
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "座位已被预订");
            response.put("success", false);
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    public static class BookingRequest {
        private Long showId;
        private List<Seat> seats;
        
        public Long getShowId() { return showId; }
        public void setShowId(Long showId) { this.showId = showId; }
        public List<Seat> getSeats() { return seats; }
        public void setSeats(List<Seat> seats) { this.seats = seats; }
    }
} 