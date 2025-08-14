<template>
  <div class="container">
    <div class="container_wrap">
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
              <img v-if="username" :src="usericon_path" alt="User Icon"/>
            </li>
            <li>
              <p>
                <router-link v-if="username" to="/" style="cursor:default;">{{ username }}</router-link>
                <router-link v-if="username" to="/logout">
                  <img src="/templates/images/others/logout.png" 
                       style="width:20px; margin-left: 3px; height:25px;"/>
                </router-link>
                <router-link v-if="!username" to="/login">Login</router-link>
              </p>
            </li>
            <li v-if="!username" class="last"><i class="edit"></i></li>
            <div class="clearfix"></div>
          </ul>
        </div>
        <div class="clearfix"></div>
      </div>

      <!-- 主要内容 -->
      <div class="content">
        <div class="now-showing-list">
          <!-- 电影详情 -->
          <div class="col-md-4 movies-by-category movie-booking">
            <div class="movie-ticket-book">
              <div class="clearfix"></div>
              <!-- <img :src="movie.posterPath" alt="Movie Poster" /> -->
               <img :src="getImageUrl(movie.posterPath)" 
                         title="album-name" 
                         class="img-responsive"
                         :alt="movie.name"/>
              <div class="bahubali-details">
                <h4>Release Date:</h4>
                <p>{{ movie.releaseDate }}</p>
                <h4>Duration:</h4>
                <p>{{ movie.duration }}</p>
                <h4>Director:</h4>
                <p>{{ movie.director }}</p>
                <h4>Language:</h4>
                <p>{{ movie.language }}</p>
                <h4>Genre:</h4>
                <p>{{ movie.genre }}</p>
                <h4>Cast And Crew:</h4>
                <p>{{ movie.castAndCrew }}</p>
              </div>
            </div>
          </div>

          <!-- 影院和放映时间 -->
          <div class="col-md-8 movies-dates">
            <div class="movie-date-selection" v-for="theater in theaterList" :key="theater.id">
              <ul>
                <li class="location">
                  <span>{{ theater.name }} Theater</span>
                </li>
                <li class="time" v-for="show in theater.showList" :key="show.id">
                  <router-link 
                    :to="`/select-seat/${show.id}?movie_id=${movie.id}&show_id=${show.id}`">
                    {{ show.time }}
                  </router-link>
                </li>
              </ul>
            </div>
          </div>
          <div class="clearfix"></div>
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
</style>