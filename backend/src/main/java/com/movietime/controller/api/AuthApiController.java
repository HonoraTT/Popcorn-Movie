package com.movietime.controller.api;

import com.movietime.entity.User;
import com.movietime.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthApiController {
    
    @Autowired
    private UserService userService;
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        if (userService.isRegistered(request.getEmail())) {
            if (userService.checkPassword(request.getEmail(), request.getPassword())) {
                User user = userService.getUserInstance(request.getEmail(), request.getPassword());
                Map<String, Object> response = new HashMap<>();
                response.put("user", user);
                response.put("message", "登录成功");
                response.put("success", true);
                return ResponseEntity.ok(response);
            }
        }
        Map<String, Object> response = new HashMap<>();
        response.put("message", "用户名或密码错误");
        response.put("success", false);
        return ResponseEntity.badRequest().body(response);
    }
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        // 这里需要实现注册逻辑
        Map<String, Object> response = new HashMap<>();
        response.put("message", "注册功能待实现");
        response.put("success", false);
        return ResponseEntity.badRequest().body(response);
    }
    
    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "退出成功");
        response.put("success", true);
        return ResponseEntity.ok(response);
    }
    
    // 请求模型类
    public static class LoginRequest {
        private String email;
        private String password;
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }
    
    public static class RegisterRequest {
        private String username;
        private String email;
        private String password;
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }
} 