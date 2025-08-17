package com.movietime.controller.api;

import com.movietime.entity.Seat;
import com.movietime.entity.Show;
import com.movietime.entity.Movie;
import com.movietime.service.SeatService;
import com.movietime.service.ShowService;
import com.movietime.service.MovieService;
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
    
    @Autowired
    private ShowService showService;
    
    @Autowired
    private MovieService movieService;
    
    @GetMapping("/show/{showId}")
    public ResponseEntity<?> getSeatMap(@PathVariable Long showId) {
        try {
            String[] seatMap = seatService.getSeatMap(showId);
            String[] soldSeats = seatService.getSoldSeat(showId);
            
            // 获取场次信息
            Show show = showService.findOne(showId);
            if (show == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("error", "场次不存在");
                return ResponseEntity.notFound().build();
            }
            
            // 获取电影信息
            Movie movie = movieService.findOne(show.getMovieId());
            
            Map<String, Object> response = new HashMap<>();
            response.put("showId", showId);
            response.put("seatMap", seatMap);
            response.put("soldSeats", soldSeats);
            response.put("movieName", movie != null ? movie.getName() : "Unknown Movie");
            response.put("showTime", show.getTime());
            response.put("price", show.getPrice());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "获取座位信息失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
    
    @PostMapping("/book")
    public ResponseEntity<?> bookSeats(@RequestBody BookingRequest request) {
        try {
            // 实现真正的座位预订逻辑
            if (request.getShowId() == null || request.getSeats() == null || request.getSeats().isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("message", "请求参数不完整");
                response.put("success", false);
                return ResponseEntity.badRequest().body(response);
            }
            
            // 调用服务层进行预订
            boolean success = seatService.book(request.getSeats());
            
            if (success) {
                Map<String, Object> response = new HashMap<>();
                response.put("message", "预订成功");
                response.put("success", true);
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> response = new HashMap<>();
                response.put("message", "座位已被预订");
                response.put("success", false);
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("message", "预订失败：" + e.getMessage());
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
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