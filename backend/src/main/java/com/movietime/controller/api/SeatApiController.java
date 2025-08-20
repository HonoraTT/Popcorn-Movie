package com.movietime.controller.api;

import com.movietime.entity.Seat;
import com.movietime.entity.Show;
import com.movietime.entity.Movie;
import com.movietime.entity.User;
import com.movietime.entity.UserOrder;
import com.movietime.service.SeatService;
import com.movietime.service.ShowService;
import com.movietime.service.MovieService;
import com.movietime.service.UserOrderService;
import com.movietime.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;

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
    
    @Autowired
    private UserOrderService userOrderService;
    
    @Autowired
    private UserService userService;
    
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
            System.out.println("=== 收到座位预订请求 ===");
            System.out.println("ShowID: " + request.getShowId());
            System.out.println("UserID: " + request.getUserId());
            System.out.println("座位数量: " + (request.getSeats() != null ? request.getSeats().size() : 0));
            
            // 实现真正的座位预订逻辑
            if (request.getShowId() == null || request.getSeats() == null || request.getSeats().isEmpty()) {
                System.out.println("请求参数不完整");
                Map<String, Object> response = new HashMap<>();
                response.put("message", "请求参数不完整");
                response.put("success", false);
                return ResponseEntity.badRequest().body(response);
            }
            
            // 打印座位详情
            for (int i = 0; i < request.getSeats().size(); i++) {
                Seat seat = request.getSeats().get(i);
                System.out.println("座位" + (i+1) + ": ShowID=" + seat.getShowId() + ", Row=" + seat.getRow() + ", Col=" + seat.getCol() + ", isBooked=" + seat.isBooked());
            }
            
            // 调用服务层进行预订
            System.out.println("调用座位服务进行预订...");
            boolean success = seatService.book(request.getSeats());
            System.out.println("座位预订结果: " + success);
            
            if (success) {
                // 创建用户订单
                try {
                    System.out.println("=== 开始创建用户订单 ===");
                    System.out.println("用户ID: " + request.getUserId());
                    System.out.println("场次ID: " + request.getShowId());
                    System.out.println("座位数量: " + request.getSeats().size());
                    
                    // 获取用户信息
                    User user = userService.findById(request.getUserId());
                    if (user == null) {
                        System.out.println("用户不存在，用户ID: " + request.getUserId());
                    } else {
                        System.out.println("用户邮箱: " + user.getEmail());
                    }
                    
                    // 获取场次信息
                    Show show = showService.findOne(request.getShowId());
                    if (show == null) {
                        System.out.println("场次不存在，场次ID: " + request.getShowId());
                    } else {
                        System.out.println("场次时间: " + show.getTime());
                        System.out.println("场次价格: " + show.getPrice());
                    }
                    
                    // 获取电影信息
                    Movie movie = null;
                    if (show != null) {
                        movie = movieService.findOne(show.getMovieId());
                        if (movie == null) {
                            System.out.println("电影不存在，电影ID: " + show.getMovieId());
                        } else {
                            System.out.println("电影名称: " + movie.getName());
                        }
                    }
                    
                    // 构建座位信息字符串
                    StringBuilder seatsInfo = new StringBuilder();
                    for (Seat seat : request.getSeats()) {
                        if (seatsInfo.length() > 0) {
                            seatsInfo.append(", ");
                        }
                        seatsInfo.append(seat.getRow()).append("排").append(seat.getCol()).append("座");
                    }
                    
                    // 创建订单对象
                    UserOrder order = new UserOrder();
                    order.setUserId(request.getUserId());
                    order.setMovieId(show != null ? show.getMovieId() : 0L);
                    order.setShowId(request.getShowId());
                    order.setMovieName(movie != null ? movie.getName() : "未知电影");
                    order.setMoviePoster(movie != null ? movie.getPosterPath() : "");
                    // 从场次数据中获取真实的影院名称
                    String realCinemaName = getCinemaDisplayName(show != null ? show.getTheaterName() : null);
                    order.setCinemaName(realCinemaName);
                    order.setShowTime(show != null ? show.getTime() : "");
                    order.setStatus("已预订");
                    order.setTotalPrice(show != null ? (double) (show.getPrice() * request.getSeats().size()) : 0.0);
                    order.setSeats(seatsInfo.toString());
                    order.setOrderTime(LocalDateTime.now());
                    
                    System.out.println("订单对象创建完成，准备保存到数据库...");
                    System.out.println("订单详情: " + order.getMovieName() + " - " + order.getTotalPrice() + "元");
                    
                    boolean orderResult = userOrderService.createOrder(order);
                    System.out.println("用户订单创建结果: " + orderResult);
                    if (orderResult) {
                        System.out.println("用户订单创建成功，订单ID: " + order.getId());
                        System.out.println("=== 订单创建完成 ===");
                    } else {
                        System.out.println("用户订单创建失败！");
                        System.out.println("=== 订单创建失败 ===");
                    }
                    
                } catch (Exception e) {
                    System.err.println("创建用户订单失败: " + e.getMessage());
                    e.printStackTrace();
                    // 即使订单创建失败，座位预订仍然有效
                }
                
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
        private Long userId; // 添加用户ID
        
        public Long getShowId() { return showId; }
        public void setShowId(Long showId) { this.showId = showId; }
        public List<Seat> getSeats() { return seats; }
        public void setSeats(List<Seat> seats) { this.seats = seats; }
        public Long getUserId() { return userId; }
        public void setUserId(Long userId) { this.userId = userId; }
    }
    
    /**
     * 根据影院代码获取显示名称
     * @param theaterName 影院代码
     * @return 影院显示名称
     */
    private String getCinemaDisplayName(String theaterName) {
        if (theaterName == null) {
            return "未知影院";
        }
        
        switch (theaterName) {
            case "UKnow":
                return "UKnow影院";
            case "BigFeel":
                return "BigFeel影院";
            case "EyeBrand":
                return "万达影城";
            case "Happy":
                return "金逸影城";
            case "ABC":
                return "CGV影城";
            default:
                return theaterName + "影院";
        }
    }
} 