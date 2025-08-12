package com.movietime.controller;

import com.movietime.entity.User;
import com.movietime.service.UserService;
import com.movietime.util.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ApiController {
    
    @Autowired
    private UserService userService;
    
    // 用户注册API
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            System.out.println("注册请求参数: " + request); // 调试日志
            
            String firstName = (String) request.get("firstName");
            String lastName = (String) request.get("lastName");
            String email = (String) request.get("email");
            String password = (String) request.get("password");
            Boolean newsletter = (Boolean) request.get("newsletter");
            
            System.out.println("解析后的参数:"); // 调试日志
            System.out.println("firstName: " + firstName);
            System.out.println("lastName: " + lastName);
            System.out.println("email: " + email);
            System.out.println("password: " + password);
            System.out.println("newsletter: " + newsletter);
            
            // 验证输入
            boolean passwordValid = Validator.checkPassword(password);
            boolean emailValid = Validator.checkEmail(email);
            boolean firstNameValid = Validator.checkName(firstName);
            boolean lastNameValid = Validator.checkName(lastName);
            
            System.out.println("验证结果:"); // 调试日志
            System.out.println("passwordValid: " + passwordValid);
            System.out.println("emailValid: " + emailValid);
            System.out.println("firstNameValid: " + firstNameValid);
            System.out.println("lastNameValid: " + lastNameValid);
            
            if (!passwordValid || !emailValid || !firstNameValid || !lastNameValid) {
                response.put("success", false);
                response.put("message", "输入信息格式不正确");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 检查邮箱是否已注册
            if (userService.isRegistered(email)) {
                response.put("success", false);
                response.put("message", "该邮箱已被注册");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 注册用户
            userService.registerUser(email, password, firstName, lastName);
            
            response.put("success", true);
            response.put("message", "注册成功");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            System.out.println("注册异常: " + e.getMessage()); // 调试日志
            e.printStackTrace(); // 打印完整堆栈
            response.put("success", false);
            response.put("message", "注册失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    // 用户登录API
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, Object> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String email = (String) request.get("email");
            String password = (String) request.get("password");
            
            if (email == null || password == null) {
                response.put("success", false);
                response.put("message", "邮箱和密码不能为空");
                return ResponseEntity.badRequest().body(response);
            }
            
            User user = userService.getUserInstance(email, password);
            if (user != null) {
                response.put("success", true);
                response.put("message", "登录成功");
                response.put("user", user);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "邮箱或密码错误");
                return ResponseEntity.badRequest().body(response);
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "登录失败：" + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    // 用户退出API
    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout() {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "退出成功");
        return ResponseEntity.ok(response);
    }
    
    // 获取当前用户信息API
    @GetMapping("/user/current")
    public ResponseEntity<Map<String, Object>> getCurrentUser() {
        Map<String, Object> response = new HashMap<>();
        // 这里应该从session或token获取当前用户信息
        // 暂时返回空用户
        response.put("success", true);
        response.put("user", null);
        return ResponseEntity.ok(response);
    }
} 