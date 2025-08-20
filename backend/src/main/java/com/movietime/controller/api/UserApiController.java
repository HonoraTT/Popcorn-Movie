package com.movietime.controller.api;

import com.movietime.entity.UserOrder;
import com.movietime.entity.UserWishlist;
import com.movietime.service.UserOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
@CrossOrigin(origins = "*")
public class UserApiController {
    
    @Autowired
    private UserOrderService userOrderService;
    
    // 模拟数据库存储用户想看片单
    private static final Map<Long, List<Map<String, Object>>> userWishlists = new HashMap<>();
    
    // 初始化空的想看片单
    static {
        // 为所有用户设置空的想看片单
        for (long userId = 1; userId <= 10; userId++) {
            userWishlists.put(userId, new ArrayList<>());
        }
    }

    // 获取用户订单
    @GetMapping("/{userId}/orders")
    public ResponseEntity<?> getUserOrders(@PathVariable Long userId) {
        try {
            System.out.println("获取用户订单请求，用户ID: " + userId);
            Map<String, Object> response = new HashMap<>();
            
            // 从数据库获取真实订单数据
            List<UserOrder> orders = userOrderService.getRecentOrders(userId, 10);
            System.out.println("从数据库获取到订单数量: " + orders.size());
            
            // 转换为前端需要的格式
            List<Map<String, Object>> orderList = new ArrayList<>();
            for (UserOrder order : orders) {
                Map<String, Object> orderMap = new HashMap<>();
                orderMap.put("id", order.getId());
                orderMap.put("movieName", order.getMovieName());
                orderMap.put("moviePoster", order.getMoviePoster());
                orderMap.put("cinemaName", order.getCinemaName());
                orderMap.put("showTime", order.getShowTime());
                orderMap.put("status", order.getStatus());
                orderMap.put("totalPrice", order.getTotalPrice());
                orderMap.put("seats", order.getSeats());
                orderList.add(orderMap);
                System.out.println("订单详情: " + order.getMovieName() + " - " + order.getStatus());
            }
            
            response.put("success", true);
            response.put("message", "获取订单成功");
            response.put("data", orderList);
            System.out.println("返回订单数据: " + orderList.size() + " 条");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("获取用户订单失败: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取订单失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
    
    // 根据订单ID获取订单详情
    @GetMapping("/orders/{orderId}")
    public ResponseEntity<?> getOrderById(@PathVariable Long orderId) {
        try {
            System.out.println("获取订单详情请求，订单ID: " + orderId);
            Map<String, Object> response = new HashMap<>();
            
            // 从数据库获取订单详情
            UserOrder order = userOrderService.getOrderById(orderId);
            if (order == null) {
                response.put("success", false);
                response.put("message", "订单不存在");
                return ResponseEntity.notFound().build();
            }
            
            // 转换为前端需要的格式
            Map<String, Object> orderMap = new HashMap<>();
            orderMap.put("id", order.getId());
            orderMap.put("userId", order.getUserId());
            orderMap.put("movieId", order.getMovieId());
            orderMap.put("showId", order.getShowId());
            orderMap.put("movieName", order.getMovieName());
            orderMap.put("moviePoster", order.getMoviePoster());
            orderMap.put("cinemaName", order.getCinemaName());
            orderMap.put("showTime", order.getShowTime());
            orderMap.put("status", order.getStatus());
            orderMap.put("totalPrice", order.getTotalPrice());
            orderMap.put("seats", order.getSeats());
            orderMap.put("orderTime", order.getOrderTime());
            
            response.put("success", true);
            response.put("message", "获取订单详情成功");
            response.put("data", orderMap);
            System.out.println("返回订单详情: " + order.getMovieName() + " - " + order.getStatus());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("获取订单详情失败: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取订单详情失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }

    // 获取用户想看片单
    @GetMapping("/{userId}/wishlist")
    public ResponseEntity<?> getUserWishlist(@PathVariable Long userId) {
        try {
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "获取想看片单成功");
            
            // 从内存存储中获取用户的想看片单
            List<Map<String, Object>> wishlist = userWishlists.getOrDefault(userId, new ArrayList<>());
            
            response.put("data", wishlist);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "获取想看片单失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    // 添加电影到想看片单
    @PostMapping("/{userId}/wishlist")
    public ResponseEntity<?> addToWishlist(@PathVariable Long userId, @RequestBody Map<String, Object> request) {
        try {
            Long movieId = Long.valueOf(request.get("movieId").toString());
            
            // 获取用户的想看片单
            List<Map<String, Object>> wishlist = userWishlists.getOrDefault(userId, new ArrayList<>());
            
            // 检查电影是否已经在想看片单中
            boolean alreadyExists = wishlist.stream()
                .anyMatch(movie -> movie.get("movieId").equals(movieId));
            
            if (!alreadyExists) {
                // 这里应该从数据库获取电影信息，现在使用模拟数据
                Map<String, Object> movieInfo = getMovieInfo(movieId);
                if (movieInfo != null) {
                    wishlist.add(movieInfo);
                    userWishlists.put(userId, wishlist);
                }
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "添加到想看片单成功");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "添加到想看片单失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    // 从想看片单移除电影
    @DeleteMapping("/{userId}/wishlist/{movieId}")
    public ResponseEntity<?> removeFromWishlist(@PathVariable Long userId, @PathVariable Long movieId) {
        try {
            // 获取用户的想看片单
            List<Map<String, Object>> wishlist = userWishlists.getOrDefault(userId, new ArrayList<>());
            
            // 移除指定电影
            wishlist.removeIf(movie -> movie.get("movieId").equals(movieId));
            userWishlists.put(userId, wishlist);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "从想看片单移除成功");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "从想看片单移除失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }

    // 获取用户统计信息
    @GetMapping("/{userId}/stats")
    public ResponseEntity<?> getUserStats(@PathVariable Long userId) {
        try {
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "获取统计信息成功");
            
            // 模拟统计数据
            Map<String, Object> stats = new HashMap<>();
            stats.put("orderCount", 5);
            stats.put("wishlistCount", 8);
            stats.put("favoriteCount", 12);
            
            response.put("data", stats);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "获取统计信息失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    // 获取电影信息的辅助方法
    private Map<String, Object> getMovieInfo(Long movieId) {
        Map<String, Object> movieInfo = new HashMap<>();
        
        // 根据movieId返回对应的电影信息（与数据库中的ID对应）
        switch (movieId.intValue()) {
            case 1:
                movieInfo.put("id", 1L);
                movieInfo.put("movieId", 1L);
                movieInfo.put("name", "黑客帝国");
                movieInfo.put("poster", "/templates/images/The Matrix.jpg");
                break;
            case 2:
                movieInfo.put("id", 2L);
                movieInfo.put("movieId", 2L);
                movieInfo.put("name", "霍比特人：意外之旅");
                movieInfo.put("poster", "/templates/images/The Hobbit.jpg");
                break;
            case 3:
                movieInfo.put("id", 3L);
                movieInfo.put("movieId", 3L);
                movieInfo.put("name", "指环王：护戒使者");
                movieInfo.put("poster", "/templates/images/Lord of the rings.jpg");
                break;
            case 4:
                movieInfo.put("id", 4L);
                movieInfo.put("movieId", 4L);
                movieInfo.put("name", "加勒比海盗：黑珍珠号诅咒");
                movieInfo.put("poster", "/templates/images/Pirates of the Caribbean.jpg");
                break;
            case 5:
                movieInfo.put("id", 5L);
                movieInfo.put("movieId", 5L);
                movieInfo.put("name", "罗小黑战记2");
                movieInfo.put("poster", "/templates/images/The Legend of Hei.jpg");
                break;
            case 6:
                movieInfo.put("id", 6L);
                movieInfo.put("movieId", 6L);
                movieInfo.put("name", "星际穿越");
                movieInfo.put("poster", "/templates/images/Interstellar.jpg");
                break;
            case 7:
                movieInfo.put("id", 7L);
                movieInfo.put("movieId", 7L);
                movieInfo.put("name", "南京照相馆");
                movieInfo.put("poster", "/templates/images/Dead to Rights.jpg");
                break;
            case 8:
                movieInfo.put("id", 8L);
                movieInfo.put("movieId", 8L);
                movieInfo.put("name", "寻梦环游记");
                movieInfo.put("poster", "/templates/images/Coco.jpg");
                break;
            case 9:
                movieInfo.put("id", 9L);
                movieInfo.put("movieId", 9L);
                movieInfo.put("name", "沙丘2");
                movieInfo.put("poster", "/templates/images/Dune.jpg");
                break;
            case 10:
                movieInfo.put("id", 10L);
                movieInfo.put("movieId", 10L);
                movieInfo.put("name", "你想活出怎样的人生");
                movieInfo.put("poster", "/templates/images/The Boy and the Heron.jpg");
                break;
            default:
                return null;
        }
        
        return movieInfo;
    }
    
    // 取消订单
    @PostMapping("/orders/{orderId}/cancel")
    public ResponseEntity<?> cancelOrder(@PathVariable Long orderId) {
        try {
            System.out.println("取消订单请求，订单ID: " + orderId);
            Map<String, Object> response = new HashMap<>();
            
            // 从数据库获取订单详情
            UserOrder order = userOrderService.getOrderById(orderId);
            if (order == null) {
                response.put("success", false);
                response.put("message", "订单不存在");
                return ResponseEntity.notFound().build();
            }
            
            // 检查订单状态是否可以取消
            if (!"已预订".equals(order.getStatus())) {
                response.put("success", false);
                response.put("message", "只有已预订的订单可以取消");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 更新订单状态为已取消
            boolean success = userOrderService.updateOrderStatus(orderId, "已取消");
            if (success) {
                response.put("success", true);
                response.put("message", "订单取消成功");
                System.out.println("订单取消成功，订单ID: " + orderId);
            } else {
                response.put("success", false);
                response.put("message", "订单取消失败");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("取消订单失败: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "取消订单失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
    
    // 删除已取消的订单
    @DeleteMapping("/orders/{orderId}/delete")
    public ResponseEntity<?> deleteCancelledOrder(@PathVariable Long orderId) {
        try {
            System.out.println("删除已取消订单请求，订单ID: " + orderId);
            Map<String, Object> response = new HashMap<>();
            
            // 从数据库获取订单详情
            UserOrder order = userOrderService.getOrderById(orderId);
            if (order == null) {
                response.put("success", false);
                response.put("message", "订单不存在");
                return ResponseEntity.notFound().build();
            }
            
            // 检查订单状态是否为已取消
            if (!"已取消".equals(order.getStatus())) {
                response.put("success", false);
                response.put("message", "只能删除已取消的订单");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 删除订单
            boolean success = userOrderService.deleteOrder(orderId);
            if (success) {
                response.put("success", true);
                response.put("message", "订单删除成功");
                System.out.println("订单删除成功，订单ID: " + orderId);
            } else {
                response.put("success", false);
                response.put("message", "订单删除失败");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("删除订单失败: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "删除订单失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
}
