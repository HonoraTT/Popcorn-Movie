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
        // 1. 验证用户名是否已存在
        if (userService.isRegistered(request.getEmail())) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "邮箱已被占用");
            return ResponseEntity.badRequest().body(response);
        }

        // 2. 创建用户
        userService.registerUser(
                request.getEmail(),
                request.getPassword(),
                request.getFirstName(),
                request.getLastName() // lastName留空或移除相关逻辑
        );

        // 3. 返回成功响应
        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("username", request.getFirstName());

        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", true);
        responseMap.put("message", "注册成功");
        responseMap.put("data", dataMap);

        return ResponseEntity.ok(responseMap);
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
        private String firstName;
        private String email;
        private String password;
        private String lastName;

        public String getFirstName() { return firstName; }

        public void setFirstName(String firstName) { this.firstName = firstName; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }

        public String getLastName() { return lastName; }

        public void setLastName(String lastname) { this.lastName = lastname; }
    }
} 