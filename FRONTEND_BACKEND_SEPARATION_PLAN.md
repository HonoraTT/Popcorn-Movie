# MovieTime 前后端分离改造方案

## 🎯 改造目标

将现有的服务器端渲染（SSR）架构改造成前后端分离架构：
- **后端**：Spring Boot + REST API
- **前端**：Vue.js + Element UI

## 🏗️ 整体架构设计

```
┌─────────────────────────────────────────────────────────────┐
│                        前端 (Vue.js)                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Vue 3     │  │ Element UI  │  │   Axios     │         │
│  │   框架       │  │  组件库     │  │   HTTP客户端 │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP/JSON
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        后端 (Spring Boot)                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ Spring Boot │  │  MyBatis    │  │   MySQL     │         │
│  │   REST API  │  │   ORM       │  │   数据库     │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## 📋 改造步骤

### 第一步：后端改造（Spring Boot REST API）

#### 1.1 修改pom.xml
```xml
<!-- 移除Thymeleaf依赖，添加Spring Boot Web -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- 添加跨域支持 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cors</artifactId>
</dependency>
```

#### 1.2 创建REST控制器
```java
@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class MovieController {
    
    @Autowired
    private MovieService movieService;
    
    @GetMapping("/movies")
    public ResponseEntity<List<Movie>> getAllMovies() {
        List<Movie> movies = movieService.findAll();
        return ResponseEntity.ok(movies);
    }
    
    @GetMapping("/movies/{id}")
    public ResponseEntity<Movie> getMovieById(@PathVariable Long id) {
        Movie movie = movieService.findOne(id);
        return ResponseEntity.ok(movie);
    }
    
    @GetMapping("/movies/tag/{tagName}")
    public ResponseEntity<List<Movie>> getMoviesByTag(@PathVariable String tagName) {
        List<Movie> movies = movieService.findByTagName(tagName);
        return ResponseEntity.ok(movies);
    }
}
```

#### 1.3 用户认证API
```java
@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        // 验证用户登录
        User user = userService.login(request.getEmail(), request.getPassword());
        if (user != null) {
            return ResponseEntity.ok(new LoginResponse(user, "登录成功"));
        }
        return ResponseEntity.badRequest().body("用户名或密码错误");
    }
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        // 用户注册
        boolean success = userService.register(request);
        if (success) {
            return ResponseEntity.ok("注册成功");
        }
        return ResponseEntity.badRequest().body("注册失败");
    }
}
```

#### 1.4 座位预订API
```java
@RestController
@RequestMapping("/api/booking")
@CrossOrigin(origins = "*")
public class BookingController {
    
    @GetMapping("/shows/{movieId}")
    public ResponseEntity<List<Show>> getShowsByMovie(@PathVariable Long movieId) {
        List<Show> shows = showService.findByMovieId(movieId);
        return ResponseEntity.ok(shows);
    }
    
    @GetMapping("/seats/{showId}")
    public ResponseEntity<SeatMap> getSeatMap(@PathVariable Long showId) {
        SeatMap seatMap = seatService.getSeatMap(showId);
        return ResponseEntity.ok(seatMap);
    }
    
    @PostMapping("/book")
    public ResponseEntity<?> bookSeats(@RequestBody BookingRequest request) {
        boolean success = bookingService.bookSeats(request);
        if (success) {
            return ResponseEntity.ok("预订成功");
        }
        return ResponseEntity.badRequest().body("预订失败");
    }
}
```

### 第二步：前端开发（Vue.js）

#### 2.1 项目结构
```
frontend/
├── public/
│   └── index.html
├── src/
│   ├── components/
│   │   ├── MovieCard.vue
│   │   ├── SeatMap.vue
│   │   ├── LoginForm.vue
│   │   └── RegisterForm.vue
│   ├── views/
│   │   ├── Home.vue
│   │   ├── MovieDetail.vue
│   │   ├── SelectShow.vue
│   │   ├── SelectSeat.vue
│   │   ├── Payment.vue
│   │   ├── Login.vue
│   │   └── Register.vue
│   ├── router/
│   │   └── index.js
│   ├── store/
│   │   └── index.js
│   ├── api/
│   │   ├── movie.js
│   │   ├── auth.js
│   │   └── booking.js
│   ├── utils/
│   │   └── request.js
│   ├── App.vue
│   └── main.js
├── package.json
└── vue.config.js
```

#### 2.2 主要依赖
```json
{
  "dependencies": {
    "vue": "^3.3.0",
    "vue-router": "^4.2.0",
    "vuex": "^4.1.0",
    "element-plus": "^2.3.0",
    "axios": "^1.4.0"
  }
}
```

#### 2.3 首页组件 (Home.vue)
```vue
<template>
  <div class="home">
    <!-- 轮播图 -->
    <el-carousel height="400px">
      <el-carousel-item v-for="banner in banners" :key="banner.id">
        <img :src="banner.path" :alt="banner.name" class="banner-image">
        <div class="banner-content">
          <h2>{{ banner.name }}</h2>
          <el-button type="primary" @click="selectMovie(banner.id)">
            购票
          </el-button>
        </div>
      </el-carousel-item>
    </el-carousel>

    <!-- 电影分类 -->
    <div class="movie-categories">
      <el-tabs v-model="activeTab" @tab-click="handleTabClick">
        <el-tab-pane 
          v-for="tag in tags" 
          :key="tag.id" 
          :label="tag.name" 
          :name="tag.name"
        >
          <div class="movie-grid">
            <movie-card
              v-for="movie in moviesByTag[tag.name]"
              :key="movie.id"
              :movie="movie"
              @click="selectMovie(movie.id)"
            />
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import MovieCard from '@/components/MovieCard.vue'
import { getMovies, getBanners, getTags } from '@/api/movie'

export default {
  name: 'Home',
  components: { MovieCard },
  setup() {
    const router = useRouter()
    const banners = ref([])
    const tags = ref([])
    const moviesByTag = ref({})
    const activeTab = ref('')

    const loadData = async () => {
      try {
        const [bannersData, tagsData] = await Promise.all([
          getBanners(),
          getTags()
        ])
        banners.value = bannersData
        tags.value = tagsData
        activeTab.value = tagsData[0]?.name || ''

        // 加载每个标签的电影
        for (const tag of tagsData) {
          const movies = await getMoviesByTag(tag.name)
          moviesByTag.value[tag.name] = movies
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      }
    }

    const selectMovie = (movieId) => {
      router.push(`/movie/${movieId}`)
    }

    onMounted(loadData)

    return {
      banners,
      tags,
      moviesByTag,
      activeTab,
      selectMovie
    }
  }
}
</script>
```

#### 2.4 座位选择组件 (SeatMap.vue)
```vue
<template>
  <div class="seat-map">
    <div class="screen">银幕</div>
    
    <div class="seats-container">
      <div 
        v-for="row in seatMap" 
        :key="row.row" 
        class="seat-row"
      >
        <div 
          v-for="seat in row.seats" 
          :key="`${row.row}-${seat.col}`"
          :class="getSeatClass(seat)"
          @click="toggleSeat(seat)"
        >
          {{ seat.col }}
        </div>
      </div>
    </div>

    <div class="booking-info">
      <h3>预订信息</h3>
      <p>电影：{{ movieName }}</p>
      <p>场次：{{ showTime }}</p>
      <p>已选座位：{{ selectedSeats.length }}个</p>
      <p>总价：¥{{ totalPrice }}</p>
      
      <el-button 
        type="primary" 
        :disabled="selectedSeats.length === 0"
        @click="confirmBooking"
      >
        确认预订
      </el-button>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import { bookSeats } from '@/api/booking'

export default {
  name: 'SeatMap',
  props: {
    showId: {
      type: Number,
      required: true
    },
    movieName: String,
    showTime: String,
    price: Number
  },
  setup(props, { emit }) {
    const seatMap = ref([])
    const selectedSeats = ref([])

    const totalPrice = computed(() => {
      return selectedSeats.value.length * props.price
    })

    const getSeatClass = (seat) => {
      return {
        'seat': true,
        'available': seat.status === 'available',
        'selected': isSelected(seat),
        'booked': seat.status === 'booked'
      }
    }

    const isSelected = (seat) => {
      return selectedSeats.value.some(s => 
        s.row === seat.row && s.col === seat.col
      )
    }

    const toggleSeat = (seat) => {
      if (seat.status === 'booked') return
      
      const index = selectedSeats.value.findIndex(s => 
        s.row === seat.row && s.col === seat.col
      )
      
      if (index > -1) {
        selectedSeats.value.splice(index, 1)
      } else {
        selectedSeats.value.push(seat)
      }
    }

    const confirmBooking = async () => {
      try {
        await bookSeats({
          showId: props.showId,
          seats: selectedSeats.value
        })
        emit('booking-success')
      } catch (error) {
        console.error('预订失败:', error)
      }
    }

    return {
      seatMap,
      selectedSeats,
      totalPrice,
      getSeatClass,
      toggleSeat,
      confirmBooking
    }
  }
}
</script>
```

#### 2.5 API封装 (api/movie.js)
```javascript
import request from '@/utils/request'

export function getMovies() {
  return request({
    url: '/api/movies',
    method: 'get'
  })
}

export function getMovieById(id) {
  return request({
    url: `/api/movies/${id}`,
    method: 'get'
  })
}

export function getMoviesByTag(tagName) {
  return request({
    url: `/api/movies/tag/${tagName}`,
    method: 'get'
  })
}

export function getBanners() {
  return request({
    url: '/api/movies/banners',
    method: 'get'
  })
}

export function getTags() {
  return request({
    url: '/api/tags',
    method: 'get'
  })
}
```

#### 2.6 HTTP请求封装 (utils/request.js)
```javascript
import axios from 'axios'
import { ElMessage } from 'element-plus'

const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API || 'http://localhost:8080',
  timeout: 5000
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    return config
  },
  error => {
    console.log(error)
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    return response.data
  },
  error => {
    console.log('err' + error)
    ElMessage({
      message: error.message,
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service
```

## 🔄 数据流对比

### 改造前（SSR）：
```
用户请求 → 服务器渲染HTML → 返回完整页面
```

### 改造后（前后端分离）：
```
用户请求 → Vue路由 → API请求 → 服务器返回JSON → Vue渲染页面
```

## 📊 改造优势

### 1. 开发效率
- 前后端可以并行开发
- 前端组件化，代码复用性高
- 热重载，开发体验更好

### 2. 用户体验
- 单页应用，页面切换流畅
- 局部更新，减少页面刷新
- 更好的交互体验

### 3. 技术栈现代化
- Vue 3 + Composition API
- Element Plus 组件库
- 现代化的开发工具链

### 4. 部署灵活性
- 前后端独立部署
- 可以部署到不同的服务器
- 支持CDN加速

## 🚀 实施计划

### 阶段一：后端API改造（1-2周）
1. 创建Spring Boot项目
2. 实现REST API
3. 添加跨域支持
4. 测试API接口

### 阶段二：前端开发（2-3周）
1. 搭建Vue项目
2. 实现核心页面
3. 集成Element Plus
4. 实现路由和状态管理

### 阶段三：集成测试（1周）
1. 前后端联调
2. 功能测试
3. 性能优化
4. 部署上线

## 💡 注意事项

1. **跨域问题**：后端需要配置CORS
2. **认证机制**：使用JWT Token替代Session
3. **状态管理**：使用Vuex管理全局状态
4. **路由守卫**：实现登录状态检查
5. **错误处理**：统一的错误处理机制

这个改造方案可以让您的项目更加现代化，提升开发效率和用户体验！ 