<template>
  <div class="select-show-page">
    <!-- 头部导航 -->
    <div class="header_top">
      <div class="col-sm-3 logo">
        <router-link to="/">
          <img src="/templates/images/nav/logo.png" alt="Logo"/>
        </router-link>
      </div>
      <div class="col-sm-6 nav"></div>
      <div class="col-sm-3 header_right">
        <ul class="header_right_box">
          <li>
            <img v-if="currentUser" :src="currentUser.iconPath || '/templates/images/user_icon/p1.png'" alt="icon"/>
          </li>
          <li>
            <p>
              <router-link v-if="currentUser" to="/" style="cursor:default;">{{ currentUser.username }}</router-link>
              <router-link v-if="currentUser" to="/logout">
                <img src="/templates/images/others/logout.png" 
                     style="width:20px; margin-left: 3px; height:25px;"/>
              </router-link>
              <router-link v-else to="/login">登录</router-link>
            </p>
          </li>
          <li v-if="!currentUser" class="last"><i class="edit"></i></li>
          <div class="clearfix"></div>
        </ul>
      </div>
      <div class="clearfix"></div>
    </div>

    <!-- 主要内容 -->
    <div class="content">
      <!-- 电影详情区域 -->
      <div class="movie-detail-section">
        <div class="movie-poster">
          <img :src="getImageUrl(movie.posterPath)" 
               :alt="movie.name"
               class="poster-image"/>
          <div class="movie-overlay">
            <div class="overlay-text">超高分动作片 零负担真燃爽</div>
          </div>
        </div>
        
        <div class="movie-info">
          <h1 class="movie-title">{{ movie.name }}</h1>
          <div class="movie-subtitle">THE SHADOW'S EDGE</div>
          
          <div class="movie-meta">
            <span class="genre">{{ movie.genre }}</span>
            <span class="region">{{ movie.language }}</span>
            <span class="duration">{{ movie.duration }}</span>
          </div>
          
          <div class="release-info">
            {{ movie.releaseDate }} 中国大陆上映
          </div>
          
          <div class="action-buttons">
            <button class="btn-want-watch">
              <i class="heart-icon">♥</i>
              想看
            </button>
          </div>
          
          <div class="rating-section">
            <div class="rating-item">
              <div class="rating-label">猫眼口碑</div>
              <div class="rating-score">{{ movie.ratingScore || '9.6' }}</div>
              <div class="rating-count">{{ movie.ratingCount || '63043' }}人评分</div>
            </div>
            
            <div class="box-office">
              <div class="box-office-label">累计票房</div>
              <div class="box-office-amount">{{ movie.boxOffice || '2.27亿' }}</div>
            </div>
          </div>
        </div>
        
        <div class="movie-synopsis">
          <h3>电影简介</h3>
          <div class="synopsis-item">
            <h4>导演：</h4>
            <p>{{ movie.director || '导演信息' }}</p>
          </div>
          <div class="synopsis-item">
            <h4>主演：</h4>
            <p>{{ movie.castAndCrew || '主演阵容' }}</p>
          </div>
          <div class="synopsis-item">
            <h4>剧情简介：</h4>
            <p>{{ movie.synopsis || '电影故事梗概' }}</p>
          </div>
          <div class="synopsis-item">
            <h4>获奖情况：</h4>
            <p>{{ movie.awards || '获奖情况' }}</p>
          </div>
        </div>
      </div>

      <!-- 选座购票区域 -->
      <div class="booking-section">
        <!-- 日期选择 -->
        <div class="date-selection">
          <div class="date-tabs">
            <div class="date-tab" 
                 v-for="(date, index) in dates" 
                 :key="index"
                 :class="{ active: selectedDate === index }"
                 @click="selectDate(index)">
              <div class="date-day">{{ date.day }}</div>
              <div class="date-date">{{ date.date }}</div>
            </div>
          </div>
        </div>

        <!-- 筛选选项 -->
        <div class="filter-options">
          <div class="filter-group">
            <div class="filter-label">品牌</div>
            <div class="filter-tags">
              <span class="filter-tag" 
                    :class="{ active: selectedBrand === '全部' }"
                    @click="selectFilter('brand', '全部')">全部</span>
              <span class="filter-tag" 
                    :class="{ active: selectedBrand === '万达影城' }"
                    @click="selectFilter('brand', '万达影城')">万达影城</span>
              <span class="filter-tag" 
                    :class="{ active: selectedBrand === '金逸影城' }"
                    @click="selectFilter('brand', '金逸影城')">金逸影城</span>
              <span class="filter-tag" 
                    :class="{ active: selectedBrand === 'CGV影城' }"
                    @click="selectFilter('brand', 'CGV影城')">CGV影城</span>
            </div>
          </div>
          
          <div class="filter-group">
            <div class="filter-label">行政区</div>
            <div class="filter-tags">
              <span class="filter-tag" 
                    :class="{ active: selectedDistrict === '全部' }"
                    @click="selectFilter('district', '全部')">全部</span>
              <span class="filter-tag" 
                    :class="{ active: selectedDistrict === '洪山区' }"
                    @click="selectFilter('district', '洪山区')">洪山区</span>
              <span class="filter-tag" 
                    :class="{ active: selectedDistrict === '江夏区' }"
                    @click="selectFilter('district', '江夏区')">江夏区</span>
              <span class="filter-tag" 
                    :class="{ active: selectedDistrict === '江汉区' }"
                    @click="selectFilter('district', '江汉区')">江汉区</span>
            </div>
          </div>
          
          <div class="filter-group">
            <div class="filter-label">影厅类型</div>
            <div class="filter-tags">
              <span class="filter-tag" 
                    :class="{ active: selectedHallType === '全部' }"
                    @click="selectFilter('hallType', '全部')">全部</span>
              <span class="filter-tag" 
                    :class="{ active: selectedHallType === 'IMAX厅' }"
                    @click="selectFilter('hallType', 'IMAX厅')">IMAX厅</span>
              <span class="filter-tag" 
                    :class="{ active: selectedHallType === '杜比全景声厅' }"
                    @click="selectFilter('hallType', '杜比全景声厅')">杜比全景声厅</span>
              <span class="filter-tag" 
                    :class="{ active: selectedHallType === '4D厅' }"
                    @click="selectFilter('hallType', '4D厅')">4D厅</span>
            </div>
          </div>
          
          <div class="filter-group">
            <div class="filter-label">影院服务</div>
            <div class="filter-tags">
              <span class="filter-tag" 
                    :class="{ active: selectedService === '全部' }"
                    @click="selectFilter('service', '全部')">全部</span>
              <span class="filter-tag" 
                    :class="{ active: selectedService === '可改签' }"
                    @click="selectFilter('service', '可改签')">可改签</span>
              <span class="filter-tag" 
                    :class="{ active: selectedService === '可退票' }"
                    @click="selectFilter('service', '可退票')">可退票</span>
            </div>
          </div>
        </div>

        <!-- 影院列表 -->
        <div class="cinema-list" v-if="!loading">
          <div v-if="theaterList.length === 0" class="no-cinemas">
            <div class="no-cinemas-icon">🎬</div>
            <div class="no-cinemas-text">暂无影院信息</div>
            <div class="no-cinemas-subtext">请稍后再试或选择其他日期</div>
          </div>
          
          <div class="cinema-item" v-for="theater in theaterList" :key="theater.id">
            <div class="cinema-info">
              <div class="cinema-name">{{ theater.name }}影院</div>
              <div class="cinema-address">武汉市洪山区光谷广场</div>
              <div class="cinema-services">
                <span class="service-tag">改签</span>
                <span class="service-tag">折扣卡</span>
                <span class="service-tag">激光厅</span>
              </div>
            </div>
            
            <div class="cinema-pricing">
              <div class="price">¥19.9起</div>
              <div class="distance">15km</div>
            </div>
            
            <div class="showtimes">
              <div class="showtime-item" v-for="show in theater.showList" :key="show.id">
                <router-link 
                  :to="`/select-seat/${movie.id}/${show.id}?movie_id=${movie.id}&show_id=${show.id}`"
                  class="showtime-link">
                  {{ show.time }}
                </router-link>
              </div>
            </div>
            
            <button class="btn-select-seats" 
                    @click="router.push(`/select-seat/${movie.id}/${theater.showList[0]?.id || ''}`)">
              选座购票
            </button>
          </div>
        </div>
        
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-state">
          <div class="loading-spinner"></div>
          <div class="loading-text">正在加载影院信息...</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useStore } from 'vuex'
import { useRoute, useRouter } from 'vue-router'
import { getMovieById } from '@/api/movie'
import { getShowsByMovie } from '@/api/booking'
import { ElMessage } from 'element-plus'

export default {
  name: 'SelectShow',
  setup() {
    const store = useStore()
    const route = useRoute()
    const router = useRouter()
    
    const movie = ref({})
    const theaterList = ref([])
    const loading = ref(false)
    const currentUser = computed(() => store.getters.currentUser)
    
    // 新增的状态
    const selectedDate = ref(0) // 0: 今天, 1: 明天, 2: 后天...
    const selectedBrand = ref('全部')
    const selectedDistrict = ref('全部')
    const selectedHallType = ref('全部')
    const selectedService = ref('全部')

    const getImageUrl = (path) => {
      if (!path) return ''
      // 处理数据库中的图片路径格式
      if (path.startsWith('/images/')) {
        return `/templates${path}`
      }
      // 如果是相对路径，添加基础URL
      if (path.startsWith('/')) {
        return `http://localhost:8080${path}`
      }
      // 如果是图片文件名，添加templates路径
      if (path.includes('.jpg') || path.includes('.png') || path.includes('.gif')) {
        return `/templates/images/${path}`
      }
      return path
    }

    // 生成未来7天的日期
    const generateDates = () => {
      const dates = []
      const today = new Date()
      const days = ['今天', '明天', '后天', '周五', '周六', '周日', '下周一']
      
      for (let i = 0; i < 7; i++) {
        const date = new Date(today)
        date.setDate(today.getDate() + i)
        dates.push({
          day: days[i] || `周${['日', '一', '二', '三', '四', '五', '六'][date.getDay()]}`,
          date: `${date.getMonth() + 1}月${date.getDate()}日`,
          fullDate: date
        })
      }
      return dates
    }

    const dates = ref(generateDates())

    // 日期选择
    const selectDate = (index) => {
      selectedDate.value = index
    }

    // 筛选功能
    const selectFilter = (type, value) => {
      switch (type) {
        case 'brand':
          selectedBrand.value = value
          break
        case 'district':
          selectedDistrict.value = value
          break
        case 'hallType':
          selectedHallType.value = value
          break
        case 'service':
          selectedService.value = value
          break
      }
      // 这里可以添加筛选逻辑
      filterTheaters()
    }

    // 筛选影院
    const filterTheaters = () => {
      // 这里可以实现根据筛选条件过滤影院的逻辑
      console.log('筛选条件:', {
        date: selectedDate.value,
        brand: selectedBrand.value,
        district: selectedDistrict.value,
        hallType: selectedHallType.value,
        service: selectedService.value
      })
    }

    const loadMovieData = async () => {
      loading.value = true
      try {
        const movieId = route.params.movieId
        if (!movieId) {
          throw new Error('无效的电影ID')
        }

        const [movieRes, showsRes] = await Promise.all([
          getMovieById(movieId),
          getShowsByMovie(movieId)
        ])
        console.log('API响应数据:', {
          movieRes: movieRes?.data,
          showsRes: showsRes?.data
        })
        movie.value = movieRes
        theaterList.value = showsRes
        // 处理场次数据（按影院分组）
        if (showsRes) {
          const theaterMap = new Map()
          
          showsRes.forEach(show => {
            // 根据theaterName分组
            if (!theaterMap.has(show.theaterName)) {
              theaterMap.set(show.theaterName, {
                id: show.id,
                name: show.theaterName,
                showList: []
              })
            }
            
            theaterMap.get(show.theaterName).showList.push({
              id: show.id,
              time: show.time,
              price: show.price,
              seatMap: show.seatMap
            })
          })
          
          theaterList.value = Array.from(theaterMap.values())
        }
        console.log('处理后的数据:', {
          movie: movie.value,
          theaterList: theaterList.value
        })
      } catch (error) {
        console.error('加载数据失败:', error)
        ElMessage.error('加载电影信息失败，请稍后重试')
      } finally {
        loading.value = false
      }
    }

    const handleLogout = async () => {
      try {
        await store.dispatch('logout')
        ElMessage.success('退出成功')
        router.push('/login')
      } catch (error) {
        console.error('退出失败:', error)
      }
    }

    onMounted(() => {
      loadMovieData()
    })

    return {
      movie,
      theaterList,
      loading,
      currentUser,
      dates,
      selectedDate,
      selectedBrand,
      selectedDistrict,
      selectedHallType,
      selectedService,
      selectDate,
      selectFilter,
      handleLogout,
      getImageUrl
    }
  }
}
</script>

<style>
/* 导入公共样式 */
@import url('/templates/css/bootstrap.css');
@import url('/templates/css/nav/style.css');
@import url('/templates/css/selectShow/style.css');
@import url('/templates/css/common.css');

/* 猫眼电影风格样式 */
.select-show-page {
  background: #f5f5f5;
  min-height: 100vh;
}

.content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

/* 电影详情区域 */
.movie-detail-section {
  display: flex;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  border-radius: 12px;
  padding: 30px;
  margin-bottom: 30px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.movie-poster {
  position: relative;
  margin-right: 30px;
  flex-shrink: 0;
}

.poster-image {
  width: 200px;
  height: 280px;
  border-radius: 8px;
  object-fit: cover;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.movie-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
  padding: 20px 10px 10px;
  border-radius: 0 0 8px 8px;
}

.overlay-text {
  color: white;
  font-size: 12px;
  text-align: center;
  font-weight: 500;
}

.movie-info {
  flex: 1;
  color: white;
  margin-right: 30px;
}

.movie-title {
  font-size: 32px;
  font-weight: bold;
  margin: 0 0 8px 0;
  color: white;
}

.movie-subtitle {
  font-size: 16px;
  color: #b8c5d6;
  margin-bottom: 20px;
  font-weight: 300;
}

.movie-meta {
  margin-bottom: 15px;
}

.movie-meta span {
  background: rgba(255, 255, 255, 0.2);
  padding: 4px 12px;
  border-radius: 20px;
  margin-right: 10px;
  font-size: 14px;
  color: white;
}

.release-info {
  font-size: 16px;
  color: #b8c5d6;
  margin-bottom: 25px;
}

.action-buttons {
  display: flex;
  gap: 15px;
  margin-bottom: 25px;
}

.btn-want-watch {
  background: #ff4757;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 25px;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.btn-want-watch:hover {
  background: #ff3742;
  transform: translateY(-2px);
}

.heart-icon {
  font-size: 18px;
}

/* 电影简介区域 */
.movie-synopsis {
  flex: 1;
  color: white;
  padding-left: 20px;
  border-left: 1px solid rgba(255, 255, 255, 0.2);
}

.movie-synopsis h3 {
  color: #ffffff;
  font-size: 20px;
  font-weight: 600;
  margin-bottom: 20px;
}

.synopsis-item {
  margin-bottom: 15px;
}

.synopsis-item h4 {
  color: #b8c5d6;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 5px;
}

.synopsis-item p {
  color: #e0e0e0;
  font-size: 14px;
  line-height: 1.5;
  margin: 0;
}

/* 电影统计信息区域 */

/* 评分区域 */
.rating-section {
  display: flex;
  gap: 40px;
  margin-bottom: 25px;
}

.rating-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.rating-label {
  font-size: 14px;
  color: #b8c5d6;
  margin-bottom: 8px;
}

.rating-score {
  font-size: 28px;
  font-weight: bold;
  color: #ffd700;
  margin-bottom: 4px;
}

.rating-count {
  font-size: 12px;
  color: #b8c5d6;
}

.box-office {
  text-align: center;
}

.box-office-label {
  font-size: 14px;
  color: #b8c5d6;
  margin-bottom: 8px;
}

.box-office-amount {
  font-size: 24px;
  font-weight: bold;
  color: #ffd700;
}

/* 选座购票区域 */
.booking-section {
  background: white;
  border-radius: 12px;
  padding: 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

/* 日期选择 */
.date-selection {
  margin-bottom: 30px;
}

.date-tabs {
  display: flex;
  gap: 15px;
  overflow-x: auto;
  padding-bottom: 10px;
}

.date-tab {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 15px 20px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 80px;
  border: 2px solid transparent;
}

.date-tab:hover {
  background: #f8f9fa;
}

.date-tab.active {
  background: #ff4757;
  color: white;
}

.date-day {
  font-size: 14px;
  margin-bottom: 4px;
}

.date-date {
  font-size: 16px;
  font-weight: bold;
}

/* 筛选选项 */
.filter-options {
  margin-bottom: 30px;
}

.filter-group {
  margin-bottom: 20px;
}

.filter-label {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 12px;
}

.filter-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.filter-tag {
  padding: 8px 16px;
  border-radius: 20px;
  background: #f8f9fa;
  color: #666;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #e9ecef;
}

.filter-tag:hover {
  background: #e9ecef;
}

.filter-tag.active {
  background: #ff4757;
  color: white;
  border-color: #ff4757;
}

/* 影院列表 */
.cinema-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.cinema-item {
  display: flex;
  align-items: center;
  padding: 20px;
  border: 1px solid #e9ecef;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.cinema-item:hover {
  border-color: #ff4757;
  box-shadow: 0 4px 20px rgba(255, 71, 87, 0.1);
}

.cinema-info {
  flex: 1;
  margin-right: 20px;
}

.cinema-name {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-bottom: 8px;
}

.cinema-address {
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
}

.cinema-services {
  display: flex;
  gap: 8px;
}

.service-tag {
  background: #f0f8ff;
  color: #0066cc;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  border: 1px solid #e6f3ff;
}

.cinema-pricing {
  text-align: center;
  margin-right: 20px;
  min-width: 80px;
}

.price {
  font-size: 20px;
  font-weight: bold;
  color: #ff4757;
  margin-bottom: 4px;
}

.distance {
  font-size: 12px;
  color: #999;
}

.showtimes {
  display: flex;
  gap: 10px;
  margin-right: 20px;
  flex-wrap: wrap;
}

.showtime-item {
  margin-bottom: 5px;
}

.showtime-link {
  display: block;
  padding: 8px 16px;
  background: #f8f9fa;
  color: #333;
  text-decoration: none;
  border-radius: 6px;
  transition: all 0.3s ease;
  border: 1px solid #e9ecef;
}

.showtime-link:hover {
  background: #e9ecef;
  color: #ff4757;
}

.btn-select-seats {
  background: #ff4757;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 25px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
  white-space: nowrap;
}

.btn-select-seats:hover {
  background: #ff3742;
  transform: translateY(-2px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .movie-detail-section {
    flex-direction: column;
    text-align: center;
  }
  
  .movie-poster {
    margin-right: 0;
    margin-bottom: 20px;
  }
  
  .cinema-item {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .cinema-pricing {
    margin-right: 0;
    margin-bottom: 15px;
    text-align: left;
  }
  
  .showtimes {
    margin-right: 0;
    margin-bottom: 15px;
  }
  
  .btn-select-seats {
    align-self: stretch;
  }
}

/* 加载状态 */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #ff4757;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  font-size: 16px;
  color: #666;
}

/* 空数据状态 */
.no-cinemas {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
}

.no-cinemas-icon {
  font-size: 60px;
  margin-bottom: 20px;
}

.no-cinemas-text {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  margin-bottom: 10px;
}

.no-cinemas-subtext {
  font-size: 14px;
  color: #666;
}

/* 筛选标签悬停效果增强 */
.filter-tag:hover {
  background: #e9ecef;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* 影院项目悬停效果增强 */
.cinema-item:hover {
  border-color: #ff4757;
  box-shadow: 0 8px 32px rgba(255, 71, 87, 0.15);
  transform: translateY(-2px);
}

/* 场次链接悬停效果增强 */
.showtime-link:hover {
  background: #ff4757;
  color: white;
  border-color: #ff4757;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(255, 71, 87, 0.2);
}
</style>