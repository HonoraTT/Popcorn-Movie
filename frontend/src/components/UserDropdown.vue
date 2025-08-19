<template>
  <div 
    class="user-dropdown-container"
    @mouseenter="handleContainerMouseEnter"
    @mouseleave="handleContainerMouseLeave">
    <!-- 触发区域 -->
    <div class="user-avatar-trigger">
      <img 
        :src="currentUser?.iconPath || '/templates/images/user_icon/p1.png'" 
        :alt="currentUser?.username || '用户头像'"
        class="user-avatar"
      />
    </div>

    <!-- 悬浮窗 -->
    <div 
      v-if="showDropdown"
      class="user-dropdown">
      
      <!-- 用户信息区域 -->
      <div class="user-info-section">
        <div class="user-avatar-large">
          <img 
            :src="currentUser?.iconPath || '/templates/images/user_icon/p1.png'" 
            :alt="currentUser?.username || '用户头像'"
          />
        </div>
        <div class="user-details">
          <div class="username">{{ currentUser?.username || '用户' }}</div>
          <div class="user-level">
            <span class="level-badge">LV.1</span>
            <span class="member-badge">普通会员</span>
          </div>
        </div>
      </div>

      

      <!-- 订单信息 -->
      <div class="orders-section" v-if="recentOrders.length > 0">
        <div class="section-title">
          <i class="icon-ticket"></i>
          <span>最近订单</span>
        </div>
        <div class="order-list">
          <div 
            v-for="order in recentOrders.slice(0, 3)" 
            :key="order.id" 
            class="order-item"
            @click="viewOrder(order)">
            <div class="order-movie">
              <img :src="order.moviePoster" :alt="order.movieName" class="order-poster" />
              <div class="order-info">
                <div class="order-movie-name">{{ order.movieName }}</div>
                <div class="order-details">
                  {{ order.cinemaName }} · {{ order.showTime }}
                </div>
              </div>
            </div>
            <div class="order-status" :class="order.status">
              {{ getStatusText(order.status) }}
            </div>
          </div>
        </div>
      </div>

                     <!-- 想看片单 -->
        <div class="wishlist-section" v-if="wishlist.length > 0">
          <div class="section-title">
            <i class="icon-heart"></i>
            <span>想看片单</span>
          </div>
          <div class="wishlist-container">
            <div class="wishlist-grid">
              <div 
                v-for="movie in wishlist" 
                :key="movie.id" 
                class="wishlist-item"
                @click="viewMovie(movie)">
                <img :src="movie.poster" :alt="movie.name" class="wishlist-poster" />
                <div class="wishlist-movie-name">{{ movie.name }}</div>
              </div>
            </div>
          </div>
        </div>

       <!-- 退出登录 -->
       <div class="logout-section">
         <div class="logout-button" @click="handleLogout">
           <i class="icon-logout"></i>
           <span>退出登录</span>
         </div>
       </div>

             
    </div>
  </div>
</template>

<script>
 import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getUserOrders, getUserWishlist, getUserStats } from '@/api/user'

export default {
  name: 'UserDropdown',
  setup() {
    const store = useStore()
    const router = useRouter()
    
         const showDropdown = ref(false)
     const recentOrders = ref([])
     const wishlist = ref([])

    const currentUser = computed(() => store.getters.currentUser)

         // 加载用户数据
     const loadUserData = async () => {
       try {
         if (!currentUser.value?.id) return
         
         // 尝试从API获取数据，如果失败则使用模拟数据
         try {
           const [ordersResponse, wishlistResponse] = await Promise.all([
             getUserOrders(currentUser.value.id),
             getUserWishlist(currentUser.value.id)
           ])
           
           if (ordersResponse.success) {
             recentOrders.value = ordersResponse.data || []
           }
           
           if (wishlistResponse.success) {
             wishlist.value = wishlistResponse.data || []
           }
           
         } catch (apiError) {
           console.warn('API调用失败，使用模拟数据:', apiError)
           // 使用模拟数据作为后备
           loadMockData()
         }
       } catch (error) {
         console.error('加载用户数据失败:', error)
         loadMockData()
       }
     }

     // 刷新想看片单数据
     const refreshWishlist = async () => {
       if (!currentUser.value?.id) return
       
       try {
         console.log('正在刷新想看片单...')
         const response = await getUserWishlist(currentUser.value.id)
         if (response.success) {
           wishlist.value = response.data || []
           console.log('想看片单已更新:', wishlist.value)
         }
       } catch (error) {
         console.warn('刷新想看片单失败:', error)
       }
     }

    // 模拟数据作为后备
    const loadMockData = () => {
      recentOrders.value = [
        {
          id: 1,
          movieName: '加勒比海盗：黑珍珠号的诅咒',
          moviePoster: '/templates/images/Pirates of the Caribbean.jpg',
          cinemaName: 'UKnow影院',
          showTime: '2024-01-15 19:30',
          status: 'completed'
        },
        {
          id: 2,
          movieName: '指环王：护戒使者',
          moviePoster: '/templates/images/Lord of the rings.jpg',
          cinemaName: 'BigFeel影院',
          showTime: '2024-01-20 20:00',
          status: 'upcoming'
        }
      ]

             wishlist.value = [
         {
           id: 1,
           movieId: 1,
           name: '黑客帝国',
           poster: '/templates/images/The Matrix.jpg'
         },
         {
           id: 2,
           movieId: 2,
           name: '霍比特人：意外之旅',
           poster: '/templates/images/The Hobbit.jpg'
         },
         {
           id: 3,
           movieId: 3,
           name: '指环王：护戒使者',
           poster: '/templates/images/Lord of the rings.jpg'
         },
         {
           id: 4,
           movieId: 4,
           name: '加勒比海盗：黑珍珠号诅咒',
           poster: '/templates/images/Pirates of the Caribbean.jpg'
         },
         {
           id: 5,
           movieId: 5,
           name: '罗小黑战记2',
           poster: '/templates/images/The Legend of Hei.jpg'
         },
         {
           id: 6,
           movieId: 6,
           name: '星际穿越',
           poster: '/templates/images/Interstellar.jpg'
         },
         {
           id: 7,
           movieId: 7,
           name: '南京照相馆',
           poster: '/templates/images/Dead to Rights.jpg'
         },
         {
           id: 8,
           movieId: 8,
           name: '寻梦环游记',
           poster: '/templates/images/Coco.jpg'
         }
       ]

      
    }

    const handleContainerMouseEnter = () => {
      showDropdown.value = true
    }

    const handleContainerMouseLeave = () => {
      // 整个容器离开时隐藏悬浮窗
      setTimeout(() => {
        showDropdown.value = false
      }, 100)
    }

    const getStatusText = (status) => {
      const statusMap = {
        'completed': '已完成',
        'upcoming': '即将观看',
        'cancelled': '已取消'
      }
      return statusMap[status] || '未知'
    }

    const viewOrder = (order) => {
      // 跳转到订单详情页
      console.log('查看订单:', order)
      showDropdown.value = false
    }

         const viewMovie = (movie) => {
       // 跳转到电影详情页，使用movieId而不是id
       const movieId = movie.movieId || movie.id
       router.push(`/select-show/${movieId}`)
       showDropdown.value = false
     }

     const handleLogout = async () => {
       try {
         await store.dispatch('logout')
         ElMessage.success('退出成功')
         router.push('/login')
         showDropdown.value = false
       } catch (error) {
         console.error('退出失败:', error)
         ElMessage.error('退出失败')
       }
     }

         

         onMounted(() => {
       if (currentUser.value) {
         loadUserData()
       }
       
       // 监听想看片单变化事件
       window.addEventListener('wishlist-updated', refreshWishlist)
       console.log('UserDropdown组件已挂载，事件监听器已设置')
     })

     // 监听用户状态变化
     watch(currentUser, (newUser) => {
       if (newUser) {
         loadUserData()
       } else {
         // 用户退出登录时清空数据
         recentOrders.value = []
         wishlist.value = []
       }
     })

     // 组件卸载时移除事件监听器
     onUnmounted(() => {
       window.removeEventListener('wishlist-updated', refreshWishlist)
     })

    return {
      showDropdown,
      currentUser,
      recentOrders,
      wishlist,
             handleContainerMouseEnter,
       handleContainerMouseLeave,
       getStatusText,
       viewOrder,
       viewMovie,
       handleLogout
    }
  }
}
</script>

<style scoped>
.user-dropdown-container {
  position: relative;
  display: inline-block;
}

.user-dropdown-container::after {
  content: '';
  position: absolute;
  top: 100%;
  right: 0;
  width: 320px;
  height: 10px;
  background: transparent;
  z-index: 999;
}



.user-avatar-trigger {
  cursor: pointer;
  padding: 5px;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.user-avatar-trigger:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.user-avatar {
  width: 35px;
  height: 35px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid transparent;
  transition: all 0.3s ease;
}

 .user-dropdown {
   position: absolute;
   top: 100%;
   right: -140px;
   width: 320px;
   background: white;
   border-radius: 12px;
   box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
   backdrop-filter: blur(20px);
   border: 1px solid rgba(255, 255, 255, 0.2);
   z-index: 1000;
   margin-top: 0;
   overflow: hidden;
   animation: dropdownFadeIn 0.3s ease;
 }

@keyframes dropdownFadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 用户信息区域 */
.user-info-section {
  display: flex;
  align-items: center;
  padding: 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.user-avatar-large {
  margin-right: 15px;
}

.user-avatar-large img {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid rgba(255, 255, 255, 0.3);
}

.user-details {
  flex: 1;
}

.username {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 5px;
}

.user-level {
  display: flex;
  gap: 8px;
  align-items: center;
}

.level-badge {
  background: rgba(255, 255, 255, 0.2);
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 500;
}

.member-badge {
  background: #ff6b6b;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 500;
}



/* 订单信息 */
.orders-section {
  padding: 15px 20px;
  border-bottom: 1px solid #e9ecef;
}

.section-title {
  display: flex;
  align-items: center;
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 12px;
}

.section-title i {
  margin-right: 8px;
  font-size: 16px;
  color: #667eea;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.order-item {
  display: flex;
  align-items: center;
  padding: 10px;
  border-radius: 8px;
  background: #f8f9fa;
  cursor: pointer;
  transition: all 0.3s ease;
}

.order-item:hover {
  background: #e9ecef;
}

.order-movie {
  display: flex;
  align-items: center;
  flex: 1;
}

.order-poster {
  width: 40px;
  height: 55px;
  border-radius: 6px;
  object-fit: cover;
  margin-right: 10px;
}

.order-info {
  flex: 1;
}

.order-movie-name {
  font-size: 13px;
  font-weight: 500;
  color: #333;
  margin-bottom: 3px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.order-details {
  font-size: 11px;
  color: #666;
}

.order-status {
  font-size: 11px;
  padding: 3px 8px;
  border-radius: 10px;
  font-weight: 500;
}

.order-status.completed {
  background: #d4edda;
  color: #155724;
}

.order-status.upcoming {
  background: #fff3cd;
  color: #856404;
}

.order-status.cancelled {
  background: #f8d7da;
  color: #721c24;
}

/* 想看片单 */
.wishlist-section {
  padding: 15px 20px;
  border-bottom: 1px solid #e9ecef;
}

.wishlist-container {
  overflow-x: auto;
  overflow-y: hidden;
  white-space: nowrap;
  padding-bottom: 5px;
}

.wishlist-grid {
  display: inline-flex;
  gap: 12px;
  min-width: 100%;
}

.wishlist-item {
  flex: 0 0 auto;
  width: 60px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.wishlist-item:hover {
  transform: translateY(-2px);
}

.wishlist-poster {
  width: 60px;
  height: 80px;
  border-radius: 6px;
  object-fit: cover;
  margin-bottom: 5px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.wishlist-movie-name {
  font-size: 10px;
  color: #333;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  line-height: 1.2;
  max-width: 60px;
}

 /* 退出登录 */
 .logout-section {
   padding: 15px 20px;
   border-top: 1px solid #e9ecef;
 }

 .logout-button {
   display: flex;
   align-items: center;
   justify-content: center;
   padding: 12px;
   background: #f8f9fa;
   border: 1px solid #e9ecef;
   border-radius: 8px;
   cursor: pointer;
   transition: all 0.3s ease;
   font-size: 14px;
   color: #666;
   gap: 8px;
 }

 .logout-button:hover {
   background: #e9ecef;
   color: #333;
   transform: translateY(-1px);
 }

 .logout-button i {
   font-size: 16px;
 }



  /* 图标样式 */
  .icon-ticket::before { content: "🎫"; }
  .icon-heart::before { content: "❤️"; }
  .icon-logout::before { content: "🚪"; }

 /* 响应式设计 */
 @media (max-width: 768px) {
   .user-dropdown {
     width: 280px;
     right: -120px;
   }
   
   .wishlist-grid {
     grid-template-columns: repeat(3, 1fr);
   }
 }
</style>
