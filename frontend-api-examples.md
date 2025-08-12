# 前端API调用示例

## 1. 安装依赖

```bash
# 安装axios用于HTTP请求
npm install axios

# 安装Element Plus UI组件库
npm install element-plus

# 安装Vuex状态管理
npm install vuex@next
```

## 2. API配置文件

### 2.1 创建API基础配置 (src/utils/request.js)
```javascript
import axios from 'axios'
import { ElMessage } from 'element-plus'

// 创建axios实例
const service = axios.create({
  baseURL: 'http://localhost:8080', // 后端API地址
  timeout: 5000
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 可以在这里添加token等认证信息
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
      message: error.response?.data || '请求失败',
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service
```

## 3. API模块

### 3.1 电影相关API (src/api/movie.js)
```javascript
import request from '@/utils/request'

// 获取所有电影
export function getMovies() {
  return request({
    url: '/api/movies',
    method: 'get'
  })
}

// 根据ID获取电影
export function getMovieById(id) {
  return request({
    url: `/api/movies/${id}`,
    method: 'get'
  })
}

// 根据标签获取电影
export function getMoviesByTag(tagName) {
  return request({
    url: `/api/movies/tag/${tagName}`,
    method: 'get'
  })
}

// 获取横幅电影
export function getBanners() {
  return request({
    url: '/api/movies/banners',
    method: 'get'
  })
}

// 获取所有标签
export function getTags() {
  return request({
    url: '/api/tags',
    method: 'get'
  })
}
```

### 3.2 用户认证API (src/api/auth.js)
```javascript
import request from '@/utils/request'

// 用户登录
export function login(data) {
  return request({
    url: '/api/auth/login',
    method: 'post',
    data
  })
}

// 用户注册
export function register(data) {
  return request({
    url: '/api/auth/register',
    method: 'post',
    data
  })
}

// 用户退出
export function logout() {
  return request({
    url: '/api/auth/logout',
    method: 'post'
  })
}
```

### 3.3 场次和座位API (src/api/booking.js)
```javascript
import request from '@/utils/request'

// 获取电影的场次
export function getShowsByMovie(movieId) {
  return request({
    url: `/api/shows/movie/${movieId}`,
    method: 'get'
  })
}

// 获取场次详情
export function getShowById(showId) {
  return request({
    url: `/api/shows/${showId}`,
    method: 'get'
  })
}

// 获取座位图
export function getSeatMap(showId) {
  return request({
    url: `/api/seats/show/${showId}`,
    method: 'get'
  })
}

// 预订座位
export function bookSeats(data) {
  return request({
    url: '/api/seats/book',
    method: 'post',
    data
  })
}
```

### 3.4 支付API (src/api/payment.js)
```javascript
import request from '@/utils/request'

// 处理支付
export function processPayment(data) {
  return request({
    url: '/api/payment/process',
    method: 'post',
    data
  })
}
```

## 4. Vuex状态管理

### 4.1 创建store (src/store/index.js)
```javascript
import { createStore } from 'vuex'
import { login, logout } from '@/api/auth'

export default createStore({
  state: {
    user: null,
    token: localStorage.getItem('token') || null
  },
  mutations: {
    SET_USER(state, user) {
      state.user = user
    },
    SET_TOKEN(state, token) {
      state.token = token
      localStorage.setItem('token', token)
    },
    CLEAR_USER(state) {
      state.user = null
      state.token = null
      localStorage.removeItem('token')
    }
  },
  actions: {
    // 登录
    async login({ commit }, loginData) {
      try {
        const response = await login(loginData)
        commit('SET_USER', response.user)
        commit('SET_TOKEN', response.token)
        return response
      } catch (error) {
        throw error
      }
    },
    
    // 退出
    async logout({ commit }) {
      try {
        await logout()
        commit('CLEAR_USER')
      } catch (error) {
        console.error('退出失败:', error)
      }
    }
  },
  getters: {
    isLoggedIn: state => !!state.token,
    currentUser: state => state.user
  }
})
```

## 5. 组件示例

### 5.1 首页组件 (src/views/Home.vue)
```vue
<template>
  <div class="home">
    <!-- 轮播图 -->
    <el-carousel height="400px" v-if="banners.length > 0">
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
            <div 
              v-for="movie in moviesByTag[tag.name]" 
              :key="movie.id"
              class="movie-card"
              @click="selectMovie(movie.id)"
            >
              <img :src="movie.posterPath" :alt="movie.name">
              <h3>{{ movie.name }}</h3>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getBanners, getTags, getMoviesByTag } from '@/api/movie'

export default {
  name: 'Home',
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

    const handleTabClick = (tab) => {
      console.log('切换到标签:', tab.name)
    }

    onMounted(loadData)

    return {
      banners,
      tags,
      moviesByTag,
      activeTab,
      selectMovie,
      handleTabClick
    }
  }
}
</script>

<style scoped>
.banner-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.banner-content {
  position: absolute;
  bottom: 20px;
  left: 20px;
  color: white;
}

.movie-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 20px;
  padding: 20px;
}

.movie-card {
  cursor: pointer;
  transition: transform 0.3s;
}

.movie-card:hover {
  transform: scale(1.05);
}

.movie-card img {
  width: 100%;
  height: 300px;
  object-fit: cover;
}
</style>
```

### 5.2 座位选择组件 (src/components/SeatMap.vue)
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
import { ref, computed, onMounted } from 'vue'
import { getSeatMap, bookSeats } from '@/api/booking'

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

    const loadSeatMap = async () => {
      try {
        const response = await getSeatMap(props.showId)
        seatMap.value = response.seats
      } catch (error) {
        console.error('加载座位图失败:', error)
      }
    }

    const getSeatClass = (seat) => {
      return {
        'seat': true,
        'available': seat.isBooked === 0,
        'selected': isSelected(seat),
        'booked': seat.isBooked === 1
      }
    }

    const isSelected = (seat) => {
      return selectedSeats.value.some(s => 
        s.row === seat.row && s.col === seat.col
      )
    }

    const toggleSeat = (seat) => {
      if (seat.isBooked === 1) return
      
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

    onMounted(loadSeatMap)

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

<style scoped>
.seat-map {
  display: flex;
  gap: 20px;
}

.screen {
  background: #333;
  color: white;
  padding: 10px;
  text-align: center;
  margin-bottom: 20px;
}

.seats-container {
  flex: 1;
}

.seat-row {
  display: flex;
  gap: 5px;
  margin-bottom: 5px;
}

.seat {
  width: 30px;
  height: 30px;
  border: 1px solid #ccc;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 12px;
}

.seat.available {
  background: #fff;
}

.seat.selected {
  background: #409eff;
  color: white;
}

.seat.booked {
  background: #f56c6c;
  color: white;
  cursor: not-allowed;
}

.booking-info {
  width: 300px;
  padding: 20px;
  background: #f5f5f5;
}
</style>
```

## 6. 路由配置

### 6.1 路由文件 (src/router/index.js)
```javascript
import { createRouter, createWebHistory } from 'vue-router'
import Home from '@/views/Home.vue'
import Login from '@/views/Login.vue'
import Register from '@/views/Register.vue'
import MovieDetail from '@/views/MovieDetail.vue'
import SelectShow from '@/views/SelectShow.vue'
import SelectSeat from '@/views/SelectSeat.vue'
import Payment from '@/views/Payment.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  },
  {
    path: '/movie/:id',
    name: 'MovieDetail',
    component: MovieDetail
  },
  {
    path: '/select-show/:movieId',
    name: 'SelectShow',
    component: SelectShow
  },
  {
    path: '/select-seat/:showId',
    name: 'SelectSeat',
    component: SelectSeat
  },
  {
    path: '/payment',
    name: 'Payment',
    component: Payment
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

## 7. 主应用文件

### 7.1 主应用 (src/App.vue)
```vue
<template>
  <div id="app">
    <el-container>
      <el-header>
        <nav-bar />
      </el-header>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<script>
import NavBar from '@/components/NavBar.vue'

export default {
  name: 'App',
  components: {
    NavBar
  }
}
</script>
```

### 7.2 入口文件 (src/main.js)
```javascript
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

const app = createApp(App)

app.use(router)
app.use(store)
app.use(ElementPlus)

app.mount('#app')
``` 