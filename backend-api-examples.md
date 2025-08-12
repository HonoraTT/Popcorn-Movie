# 后端API改造示例

## 1. 电影相关API

### 1.1 获取所有电影
```java
@RestController
@RequestMapping("/api/movies")
@CrossOrigin(origins = "*")
public class MovieController {
    
    @Autowired
    private MovieService movieService;
    
    @GetMapping
    public ResponseEntity<List<Movie>> getAllMovies() {
        List<Movie> movies = movieService.findAll();
        return ResponseEntity.ok(movies);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Movie> getMovieById(@PathVariable Long id) {
        Movie movie = movieService.findOne(id);
        if (movie != null) {
            return ResponseEntity.ok(movie);
        }
        return ResponseEntity.notFound().build();
    }
    
    @GetMapping("/tag/{tagName}")
    public ResponseEntity<List<Movie>> getMoviesByTag(@PathVariable String tagName) {
        List<Movie> movies = movieService.findByTagName(tagName);
        return ResponseEntity.ok(movies);
    }
    
    @GetMapping("/banners")
    public ResponseEntity<List<BannerVO>> getBanners() {
        List<Movie> movies = movieService.findAll();
        List<BannerVO> banners = movies.stream()
            .filter(movie -> movie.getBannerPath() != null)
            .map(movie -> new BannerVO((int) movie.getId(), movie.getName(), movie.getBannerPath()))
            .collect(Collectors.toList());
        return ResponseEntity.ok(banners);
    }
}
```

### 1.2 标签相关API
```java
@RestController
@RequestMapping("/api/tags")
@CrossOrigin(origins = "*")
public class TagController {
    
    @Autowired
    private TagService tagService;
    
    @GetMapping
    public ResponseEntity<List<Tag>> getAllTags() {
        List<String> tagNames = tagService.findAllName();
        List<Tag> tags = tagNames.stream()
            .map(name -> new Tag(name))
            .collect(Collectors.toList());
        return ResponseEntity.ok(tags);
    }
}
```

## 2. 用户认证API

### 2.1 登录API
```java
@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        if (userService.isRegistered(request.getEmail())) {
            if (userService.checkPassword(request.getEmail(), request.getPassword())) {
                User user = userService.getUserInstance(request.getEmail(), request.getPassword());
                return ResponseEntity.ok(new LoginResponse(user, "登录成功"));
            }
        }
        return ResponseEntity.badRequest().body("用户名或密码错误");
    }
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        // 实现注册逻辑
        boolean success = userService.register(request);
        if (success) {
            return ResponseEntity.ok("注册成功");
        }
        return ResponseEntity.badRequest().body("注册失败");
    }
    
    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        return ResponseEntity.ok("退出成功");
    }
}
```

## 3. 场次和座位API

### 3.1 场次API
```java
@RestController
@RequestMapping("/api/shows")
@CrossOrigin(origins = "*")
public class ShowController {
    
    @Autowired
    private ShowService showService;
    
    @GetMapping("/movie/{movieId}")
    public ResponseEntity<List<Show>> getShowsByMovie(@PathVariable Long movieId) {
        List<Show> shows = showService.findByMovieId(movieId);
        return ResponseEntity.ok(shows);
    }
    
    @GetMapping("/{showId}")
    public ResponseEntity<Show> getShowById(@PathVariable Long showId) {
        Show show = showService.findOne(showId);
        if (show != null) {
            return ResponseEntity.ok(show);
        }
        return ResponseEntity.notFound().build();
    }
}
```

### 3.2 座位API
```java
@RestController
@RequestMapping("/api/seats")
@CrossOrigin(origins = "*")
public class SeatController {
    
    @Autowired
    private SeatService seatService;
    
    @GetMapping("/show/{showId}")
    public ResponseEntity<SeatMapResponse> getSeatMap(@PathVariable Long showId) {
        List<Seat> seats = seatService.findByShowId(showId);
        SeatMapResponse response = new SeatMapResponse();
        response.setShowId(showId);
        response.setSeats(seats);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/book")
    public ResponseEntity<?> bookSeats(@RequestBody BookingRequest request) {
        try {
            boolean success = seatService.bookSeats(request.getShowId(), request.getSeats());
            if (success) {
                return ResponseEntity.ok("预订成功");
            }
            return ResponseEntity.badRequest().body("预订失败");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("座位已被预订");
        }
    }
}
```

## 4. 支付API

```java
@RestController
@RequestMapping("/api/payment")
@CrossOrigin(origins = "*")
public class PaymentController {
    
    @PostMapping("/process")
    public ResponseEntity<?> processPayment(@RequestBody PaymentRequest request) {
        // 模拟支付处理
        boolean success = processPaymentLogic(request);
        if (success) {
            return ResponseEntity.ok("支付成功");
        }
        return ResponseEntity.badRequest().body("支付失败");
    }
}
```

## 5. 请求/响应模型

### 5.1 登录请求
```java
public class LoginRequest {
    private String email;
    private String password;
    
    // getters and setters
}
```

### 5.2 登录响应
```java
public class LoginResponse {
    private User user;
    private String message;
    private String token; // JWT token
    
    // constructor and getters
}
```

### 5.3 预订请求
```java
public class BookingRequest {
    private Long showId;
    private List<Seat> seats;
    
    // getters and setters
}
```

### 5.4 座位地图响应
```java
public class SeatMapResponse {
    private Long showId;
    private List<Seat> seats;
    
    // getters and setters
}
```

## 6. 跨域配置

在Spring配置中添加：
```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*");
    }
}
```

## 7. 修改pom.xml

移除Thymeleaf依赖，添加Spring Boot Web：
```xml
<!-- 移除这个依赖 -->
<!--
<dependency>
    <groupId>org.thymeleaf</groupId>
    <artifactId>thymeleaf</artifactId>
    <version>3.0.2.RELEASE</version>
</dependency>
-->

<!-- 确保有这个依赖 -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>4.3.3.RELEASE</version>
</dependency>
``` 