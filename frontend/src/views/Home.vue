<template>
  <div class="container">
    <div class="container_wrap">


      <!-- 头部导航 -->
      <div class="header_top">
        <div class="col-sm-4 logo">
          <a href="/"><div class="logo-container"><img src="/templates/images/nav/logo.png" alt="" class="logo-image"/></div></a>
        </div>
        <div class="col-sm-4 nav"></div>
        <div class="col-sm-4 header_right">
          <ul class="header_right_box">
            <li>
              <img v-if="currentUser" :src="currentUser.iconPath || '/templates/images/user_icon/p1.png'" alt="icon" class="user-avatar"/>
            </li>
            <li>
              <p class="user-info">
                <a v-if="currentUser" style="cursor:default;" href="/">{{ currentUser.username }}</a>
                <a v-if="currentUser" href="#" @click="handleLogout">
                  <img src="/templates/images/others/logout.png" style="width:20px; margin-left: 3px; height:25px;"/>
                </a>
                <a v-else href="/login">登录</a>
              </p>
            </li>
            <li v-if="!currentUser" class="last"><i class="edit"> </i></li>
            <div class="clearfix"> </div>
          </ul>
        </div>
        <div class="clearfix"> </div>
      </div>

      <!-- 轮播图 -->
      <div id="myCarousel" class="carousel slide" v-if="banners.length > 0">
        <!-- 轮播项目 -->
        <div class="carousel-inner">
          <div v-for="(banner, index) in banners" 
               :key="banner.id"
               class="item"
               :class="{ active: index === 0 }">
            <img :src="getImageUrl(banner.path)" :alt="banner.name"/>
            <div class="banner-button">
              <a :name="banner.name" 
                 :href="`/select-show/${banner.id}`"
                 class="hvr-shutter-out-horizontal">购票</a>
            </div>
          </div>
        </div>
        <!-- 轮播导航 - 左右箭头 -->
        <a class="carousel-control left" href="#myCarousel" data-slide="prev">
          <span class="arrow-left">‹</span>
        </a>
        <a class="carousel-control right" href="#myCarousel" data-slide="next">
          <span class="arrow-right">›</span>
        </a>
      </div>

      <div class="content">
        <!-- 特色电影 -->
        <div class="general">
          <h4 class="latest-text w3_latest_text">热映电影</h4>
          <div class="bs-example bs-example-tabs" role="tabpanel" data-example-id="togglable-tabs">
            <ul id="myTab" class="featureMoviesNav featureMoviesNav-tabs" role="tablist" style="padding-left:0px; padding-bottom:10px">
              <li v-for="(tag, index) in tags" 
                  :key="tag.name"
                  role="presentation" 
                  class="tab"
                  @click="activeTab = tag.name"
                  :class="{ active: index === 0 }">
                <a :href="`#${tag.name}`"
                   id="home-tab" 
                   role="tab"
                   data-toggle="tab"
                  :aria-selected="activeTab === tag.name"
                  :class="{ active: activeTab === tag.name }"
                   aria-controls="home"
                   aria-expanded="true"
                   style="color:white">{{ tag.name }}</a>
              </li>
            </ul>
            <div id="myTabContent" class="tab-content">
              <div v-for="tag in tags" 
                   :key="tag.name"
                   role="tabpanel" 
                   class="tab-pane fade in"
             :class="{ active: activeTab === tag.name }"
                   :id="tag.name" 
                   aria-labelledby="home-tab">
                <div class="w3l-movie-gride-agile" 
                    v-for="movie in moviesByTag[tag.name]" 
                     :key="movie.id">
                  <a :name="movie.name"
                     :href="`/select-show/${movie.id}`"
                     class="hvr-shutter-out-horizontal">
                    <img :src="getImageUrl(movie.posterPath)" 
                         title="album-name" 
                         class="img-responsive"
                         :alt="movie.name"/>
                    <div class="w3l-action-icon">
                      <i class="fa fa-play-circle" aria-hidden="true"></i>
                    </div>
                  </a>
                  <div class="w3l-movie-text">
                    <h6>
                      <a :name="movie.name"
                         :href="`/select-show/${movie.id}`">{{ movie.name }}</a>
                    </h6>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { getBanners, getTags, getMoviesByTag } from '@/api/movie'
import { ElMessage } from 'element-plus'

export default {
  name: 'Home',
  setup() {
    const store = useStore()
    const router = useRouter()
    const banners = ref([])
    const tags = ref([])
    const moviesByTag = ref({})
    const loading = ref(false)
    const activeTab = ref(tags.value[0]?.name || '')

    const currentUser = computed(() => store.getters.currentUser)

    const loadData = async () => {
      loading.value = true
      try {
        const [bannersData, tagsData] = await Promise.all([
          getBanners(),
          getTags()
        ])
        banners.value = bannersData
        tags.value = tagsData

        
        if (tags.value.length > 0) {
          activeTab.value = tags.value[0].name
        }

        // 加载每个标签的电影
        for (const tag of tagsData) {
          try {
            const movies = await getMoviesByTag(tag.name)
            moviesByTag.value[tag.name] = movies
          } catch (error) {
            console.error(`加载标签 ${tag.name} 的电影失败:`, error)
            moviesByTag.value[tag.name] = []
          }
        }
      } catch (error) {
        console.error('加载数据失败:', error)
        ElMessage.error('加载数据失败，请稍后重试')
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

    onMounted(() => {
      loadData()
      // 初始化Bootstrap轮播
      if (typeof $ !== 'undefined') {
        $('.carousel').carousel()
      }
      if (typeof $ !== 'undefined') {
        $('[data-toggle="tab"]').on('click', function(e) {
          e.preventDefault()
          activeTab.value = $(this).attr('href').substring(1)
        })
      }
    })

    return {
      banners,
      tags,
      moviesByTag,
      loading,
      currentUser,
      activeTab,
      handleLogout,
      getImageUrl
    }
  }
}
</script>

<style>
/* 引入原有的CSS文件 */
@import url('/templates/css/bootstrap.css');
@import url('/templates/css/homepage/style.css');
@import url('/templates/css/common.css');
@import url('/templates/css/homepage/featureMoviesCSS/style_featureMovies.css');
@import url('/templates/css/homepage/featureMoviesCSS/medile.css');



/* Logo样式 */
.logo-container {
  width: 280px;
  height: 100px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: flex-start;
}

.logo-image {
  height: 140px;
  width: auto;
  object-fit: cover;
  object-position: left center;
  transform: scale(1.2);
  transform-origin: left center;
}

/* 用户信息样式 */
.header_right_box {
  display: flex;
  align-items: center;
  height: 100px;
  margin: 0;
  padding: 0;
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
}

.user-info {
  margin: 0;
  padding: 0;
  display: flex;
  align-items: center;
}

/* 自定义样式：优化电影标题显示 */
.w3l-movie-text h6 {
  margin: 0;
  padding: 8px 5px;
  min-height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.w3l-movie-text h6 a {
  font-size: 0.9em !important;
  line-height: 1.2;
  text-align: center;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  word-break: break-word;
  color: #222;
  text-decoration: none;
  font-weight: 500;
}

.w3l-movie-gride-agile {
  margin-bottom: 20px !important;
}

.w3l-movie-gride-agile img {
  width: 100%;
  height: auto;
  object-fit: cover;
}

/* 响应式优化 */
@media (max-width: 768px) {
  .w3l-movie-text h6 a {
    font-size: 0.8em !important;
  }
  
  .w3l-movie-text h6 {
    min-height: 40px;
    padding: 5px 3px;
  }
}

@media (max-width: 480px) {
  .w3l-movie-text h6 a {
    font-size: 0.75em !important;
  }
  
  .w3l-movie-text h6 {
    min-height: 35px;
    padding: 3px 2px;
  }
}

/* 标题左对齐优化 */
h4.latest-text {
  margin-left: 0 !important;
  text-align: left !important;
}

.w3_latest_text {
  margin-left: 0 !important;
}

/* 星空背景效果 - 强制覆盖 */
html, body {
  background: #1b2735 !important;
  margin: 0 !important;
  padding: 0 !important;
  min-height: 100vh !important;
}



/* 内容区域样式 - 修复间距 */
.container {
  background: transparent !important;
  min-height: 100vh;
  position: relative;
  z-index: 1;
  padding: 0 !important;
}

.container_wrap {
  max-width: 1200px !important;
  margin: 0 auto !important;
  background: #fff !important;
  position: relative;
  z-index: 2;
  min-height: 100vh;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
  padding: 0 !important;
}

/* 确保内容区域内部元素有正确的间距 */
.content {
  padding: 20px !important;
}

.general {
  padding: 0 20px !important;
}

/* 响应式：在小屏幕上让内容区域占满宽度 */
@media (max-width: 1200px) {
  .container_wrap {
    max-width: 100% !important;
    margin: 0 !important;
    box-shadow: none !important;
  }
}

/* 修复电影网格间距 */
.w3l-movie-gride-agile {
  margin-right: 2% !important;
  margin-bottom: 3% !important;
  width: 18% !important;
}

.w3l-movie-gride-agile:nth-child(5n) {
  margin-right: 0 !important;
}

/* 确保星空背景在所有情况下都显示 */
body {
  background: #1b2735 !important;
}

body::before {
  content: '' !important;
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  width: 100% !important;
  height: 100% !important;
  background-image: 
    radial-gradient(2px 2px at 20px 30px, #eee, transparent),
    radial-gradient(2px 2px at 40px 70px, rgba(255,255,255,0.8), transparent),
    radial-gradient(1px 1px at 90px 40px, #fff, transparent),
    radial-gradient(1px 1px at 130px 80px, rgba(255,255,255,0.6), transparent),
    radial-gradient(2px 2px at 160px 30px, #ddd, transparent),
    radial-gradient(1px 1px at 200px 150px, #fff, transparent),
    radial-gradient(2px 2px at 300px 80px, rgba(255,255,255,0.7), transparent),
    radial-gradient(1px 1px at 400px 200px, #ddd, transparent) !important;
  background-repeat: repeat !important;
  background-size: 400px 200px !important;
  animation: twinkle 4s ease-in-out infinite !important;
  z-index: -1 !important;
  pointer-events: none !important;
}

/* 统一首页横幅尺寸为1500*500 */
.carousel {
  width: 100% !important;
  height: 500px !important;
  margin: 0 auto;
  overflow: hidden;
  max-width: 1500px;
}

.carousel-inner {
  width: 100% !important;
  height: 500px !important;
}

.carousel-inner > .item {
  width: 100% !important;
  height: 500px !important;
}

.carousel-inner > .item > img {
  width: 100% !important;
  height: 500px !important;
  object-fit: cover;
  object-position: center;
}

/* 响应式横幅尺寸 */
@media (max-width: 1600px) {
  .carousel,
  .carousel-inner,
  .carousel-inner > .item,
  .carousel-inner > .item > img {
    width: 100% !important;
    height: 400px !important;
  }
}

@media (max-width: 1200px) {
  .carousel,
  .carousel-inner,
  .carousel-inner > .item,
  .carousel-inner > .item > img {
    width: 100% !important;
    height: 350px !important;
  }
}

@media (max-width: 768px) {
  .carousel,
  .carousel-inner,
  .carousel-inner > .item,
  .carousel-inner > .item > img {
    width: 100% !important;
    height: 250px !important;
  }
}

@media (max-width: 480px) {
  .carousel,
  .carousel-inner,
  .carousel-inner > .item,
  .carousel-inner > .item > img {
    width: 100% !important;
    height: 200px !important;
  }
}

/* Banner箭头控制样式 */
.carousel-control {
  background: rgba(0, 0, 0, 0.3) !important;
  border-radius: 50%;
  width: 60px !important;
  height: 60px !important;
  top: 50% !important;
  transform: translateY(-50%);
  display: flex !important;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.carousel-control:hover {
  background: rgba(0, 0, 0, 0.6) !important;
  transform: translateY(-50%) scale(1.1);
}

.carousel-control.left {
  left: 20px !important;
}

.carousel-control.right {
  right: 20px !important;
}

.arrow-left, .arrow-right {
  font-size: 30px;
  color: white;
  font-weight: bold;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
}

/* Banner购票按钮样式 - 覆盖原有样式 */
.banner-button {
  position: absolute !important;
  bottom: 30px !important;
  left: 50% !important;
  transform: translateX(-50%) !important;
  z-index: 10 !important;
}

.banner-button a,
.banner-button a.hvr-shutter-out-horizontal {
  display: inline-block !important;
  padding: 15px 40px !important;
  background: linear-gradient(135deg, #ff4757, #ff3742) !important;
  color: white !important;
  text-decoration: none !important;
  border-radius: 50px !important;
  font-size: 18px !important;
  font-weight: bold !important;
  text-transform: uppercase !important;
  letter-spacing: 1px !important;
  box-shadow: 0 8px 25px rgba(255, 71, 87, 0.4) !important;
  transition: all 0.3s ease !important;
  border: 2px solid transparent !important;
  position: relative !important;
  z-index: 1 !important;
}

.banner-button a:hover,
.banner-button a.hvr-shutter-out-horizontal:hover {
  background: linear-gradient(135deg, #ff3742, #ff4757) !important;
  transform: translateY(-3px) !important;
  box-shadow: 0 12px 35px rgba(255, 71, 87, 0.6) !important;
  color: white !important;
  text-decoration: none !important;
  border-color: transparent !important;
}

/* 覆盖原有的hvr-shutter-out-horizontal效果 */
.banner-button a.hvr-shutter-out-horizontal:before {
  display: none !important;
}

/* 响应式按钮调整 */
@media (max-width: 768px) {
  .carousel-control {
    width: 50px !important;
    height: 50px !important;
  }
  
  .arrow-left, .arrow-right {
    font-size: 24px;
  }
  
  .banner-button a {
    padding: 12px 30px;
    font-size: 16px;
  }
}

@media (max-width: 480px) {
  .carousel-control {
    width: 40px !important;
    height: 40px !important;
  }
  
  .arrow-left, .arrow-right {
    font-size: 20px;
  }
  
  .banner-button a {
    padding: 10px 25px;
    font-size: 14px;
  }
}

@keyframes twinkle {
  0%, 100% { opacity: 0.3; }
  50% { opacity: 1; }
}

/* 电影主题渐变（备用方案） */
/*
html, body {
  background: linear-gradient(135deg, #0c0c0c 0%, #1a1a2e 50%, #16213e 100%) !important;
  min-height: 100vh;
  position: relative;
}

html::before, body::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: 
    radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
    radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.3) 0%, transparent 50%);
  z-index: -1;
}
*/
</style> 