package com.movietime.controller.api;

import com.movietime.entity.UserOrder;
import com.movietime.entity.UserWishlist;
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
    
    // 模拟数据库存储用户想看片单
    private static final Map<Long, List<Map<String, Object>>> userWishlists = new HashMap<>();
    
    // 初始化一些测试数据
    static {
        List<Map<String, Object>> defaultWishlist = new ArrayList<>();
        
        Map<String, Object> movie1 = new HashMap<>();
        movie1.put("id", 1L);
        movie1.put("movieId", 1L);
        movie1.put("name", "黑客帝国");
        movie1.put("poster", "/templates/images/The Matrix.jpg");
        defaultWishlist.add(movie1);
        
        Map<String, Object> movie2 = new HashMap<>();
        movie2.put("id", 2L);
        movie2.put("movieId", 2L);
        movie2.put("name", "霍比特人：意外之旅");
        movie2.put("poster", "/templates/images/The Hobbit.jpg");
        defaultWishlist.add(movie2);
        
        Map<String, Object> movie3 = new HashMap<>();
        movie3.put("id", 3L);
        movie3.put("movieId", 3L);
        movie3.put("name", "指环王：护戒使者");
        movie3.put("poster", "/templates/images/Lord of the rings.jpg");
        defaultWishlist.add(movie3);
        
        Map<String, Object> movie4 = new HashMap<>();
        movie4.put("id", 4L);
        movie4.put("movieId", 4L);
        movie4.put("name", "加勒比海盗：黑珍珠号诅咒");
        movie4.put("poster", "/templates/images/Pirates of the Caribbean.jpg");
        defaultWishlist.add(movie4);
        
        Map<String, Object> movie5 = new HashMap<>();
        movie5.put("id", 5L);
        movie5.put("movieId", 5L);
        movie5.put("name", "罗小黑战记2");
        movie5.put("poster", "/templates/images/The Legend of Hei.jpg");
        defaultWishlist.add(movie5);
        
        Map<String, Object> movie6 = new HashMap<>();
        movie6.put("id", 6L);
        movie6.put("movieId", 6L);
        movie6.put("name", "星际穿越");
        movie6.put("poster", "/templates/images/Interstellar.jpg");
        defaultWishlist.add(movie6);
        
        Map<String, Object> movie7 = new HashMap<>();
        movie7.put("id", 7L);
        movie7.put("movieId", 7L);
        movie7.put("name", "南京照相馆");
        movie7.put("poster", "/templates/images/Dead to Rights.jpg");
        defaultWishlist.add(movie7);
        
        Map<String, Object> movie8 = new HashMap<>();
        movie8.put("id", 8L);
        movie8.put("movieId", 8L);
        movie8.put("name", "寻梦环游记");
        movie8.put("poster", "/templates/images/Coco.jpg");
        defaultWishlist.add(movie8);
        
        // 为所有用户设置默认想看片单
        for (long userId = 1; userId <= 10; userId++) {
            userWishlists.put(userId, new ArrayList<>(defaultWishlist));
        }
    }

    // 获取用户订单
    @GetMapping("/{userId}/orders")
    public ResponseEntity<?> getUserOrders(@PathVariable Long userId) {
        try {
            // 模拟数据 - 实际应该从数据库获取
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "获取订单成功");
            
            // 模拟订单数据
            List<Map<String, Object>> orders = new ArrayList<>();
            
            Map<String, Object> order1 = new HashMap<>();
            order1.put("id", 1L);
            order1.put("movieName", "加勒比海盗：黑珍珠号的诅咒");
            order1.put("moviePoster", "/templates/images/Pirates of the Caribbean.jpg");
            order1.put("cinemaName", "UKnow影院");
            order1.put("showTime", "2024-01-15 19:30");
            order1.put("status", "completed");
            orders.add(order1);
            
            Map<String, Object> order2 = new HashMap<>();
            order2.put("id", 2L);
            order2.put("movieName", "指环王：护戒使者");
            order2.put("moviePoster", "/templates/images/Lord of the rings.jpg");
            order2.put("cinemaName", "BigFeel影院");
            order2.put("showTime", "2024-01-20 20:00");
            order2.put("status", "upcoming");
            orders.add(order2);
            
            response.put("data", orders);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "获取订单失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
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
}
