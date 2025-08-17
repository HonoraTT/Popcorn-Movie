<template>
  <div class="container">
    <div class="container_wrap">
      <!-- 头部导航 -->
      <div class="header_top">
        <div class="col-sm-3 logo">
          <a href="/"><img src="/templates/images/nav/logo.png" alt=""/></a>
        </div>
        <div class="col-sm-6 nav"></div>
        <div class="col-sm-3 header_right">
          <ul class="header_right_box">
            <li>
              <img v-if="currentUser" :src="currentUser.iconPath || '/templates/images/user_icon/p1.png'" alt="icon"/>
            </li>
            <li>
              <p>
                <a v-if="currentUser" style="cursor:default;" href="/">{{ currentUser.username }}</a>
                <a v-if="currentUser" href="#" @click="handleLogout">
                  <img src="/templates/images/others/logout.png" style="width:20px; margin-left: 3px; height:25px;"/>
                </a>
                <a v-else href="/login">Login</a>
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
        <!-- 轮播指标 -->
        <ol class="carousel-indicators">
          <li v-for="(banner, index) in banners" 
              :key="banner.id"
              data-target="#myCarousel" 
              :data-slide-to="index" 
              :class="{ active: index === 0 }">
          </li>
        </ol>
        <!-- 轮播项目 -->
        <div class="carousel-inner">
          <div v-for="(banner, index) in banners" 
               :key="banner.id"
               class="item"
               :class="{ active: index === 0 }">
            <img :src="getImageUrl(banner.path)" :alt="banner.name"/>
            <div class="button">
              <a :name="banner.name" 
                 :href="`/select-show/${banner.id}`"
                 class="hvr-shutter-out-horizontal">Buy Ticket</a>
            </div>
          </div>
        </div>
        <!-- 轮播导航 -->
        <a class="carousel-control left" href="#myCarousel" data-slide="prev">&lsaquo;</a>
        <a class="carousel-control right" href="#myCarousel" data-slide="next">&rsaquo;</a>
      </div>

      <div class="content">
        <!-- 特色电影 -->
        <div class="general">
          <h4 class="latest-text w3_latest_text">Featured Movies</h4>
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
</style> 