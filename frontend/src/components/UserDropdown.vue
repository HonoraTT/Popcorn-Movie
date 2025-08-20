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
      <div class="orders-section">
        <div class="section-title">
          <i class="icon-ticket"></i>
          <span>最近订单</span>
        </div>
        <div class="order-list">
          <!-- 有订单时显示订单列表 -->
          <div v-if="recentOrders.length > 0">
            <div 
              v-for="order in recentOrders.slice(0, 3)" 
              :key="order.id" 
              class="order-item"
              @click="viewOrder(order)">
              <div class="order-movie">
                <img 
                  :src="getMoviePoster(order.moviePoster)" 
                  :alt="order.movieName" 
                  class="order-poster"
                  @error="handleImageError"
                />
                <div class="order-info">
                  <div class="order-movie-name">{{ order.movieName }}</div>
                  <div class="order-details">
                    {{ order.cinemaName }} · {{ order.showTime }}
                  </div>
                </div>
              </div>
              <div class="order-status" :class="getStatusClass(order.status)">
                {{ getStatusText(order.status) }}
              </div>
            </div>
          </div>
          <!-- 没有订单时显示提示 -->
          <div v-else class="order-empty">
            <div class="empty-icon">🎫</div>
            <div class="empty-text">暂无最近订单</div>
          </div>
        </div>
      </div>

                     <!-- 想看片单 -->
        <div class="wishlist-section">
          <div class="section-title">
            <i class="icon-heart"></i>
            <span>想看片单</span>
          </div>
          <div class="wishlist-container">
            <!-- 有想看片单时显示电影列表 -->
            <div v-if="wishlist.length > 0" class="wishlist-grid">
              <div 
                v-for="movie in wishlist" 
                :key="movie.id" 
                class="wishlist-item"
                @click="viewMovie(movie)">
                <img :src="movie.poster" :alt="movie.name" class="wishlist-poster" />
                <div class="wishlist-movie-name">{{ movie.name }}</div>
              </div>
            </div>
            <!-- 没有想看片单时显示提示 -->
            <div v-else class="wishlist-empty">
              <div class="empty-icon">📽️</div>
              <div class="empty-text">暂未添加想看电影</div>
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
         console.log('loadUserData被调用，当前用户:', currentUser.value)
         if (!currentUser.value?.id) {
           console.warn('当前用户没有ID，无法加载数据')
           return
         }
         
         console.log('开始加载用户数据，用户ID:', currentUser.value.id)
         
         // 尝试从API获取数据
         const [ordersResponse, wishlistResponse] = await Promise.all([
           getUserOrders(currentUser.value.id),
           getUserWishlist(currentUser.value.id)
         ])
         
         console.log('订单API响应:', JSON.stringify(ordersResponse, null, 2))
         console.log('想看片单API响应:', JSON.stringify(wishlistResponse, null, 2))
         
         if (ordersResponse.success) {
           recentOrders.value = ordersResponse.data || []
           console.log('订单数据已设置:', recentOrders.value)
         }
         
         if (wishlistResponse.success) {
           wishlist.value = wishlistResponse.data || []
           console.log('想看片单数据已设置:', wishlist.value)
         }
       } catch (error) {
         console.error('加载用户数据失败:', error)
         // 不加载模拟数据，保持空状态
         recentOrders.value = []
         wishlist.value = []
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

     // 刷新订单数据
     const refreshOrders = async () => {
       console.log('refreshOrders被调用，当前用户:', currentUser.value)
       if (!currentUser.value?.id) {
         console.warn('当前用户没有ID，无法刷新订单数据')
         return
       }
       
       try {
         console.log('正在刷新订单数据，用户ID:', currentUser.value.id)
         const response = await getUserOrders(currentUser.value.id)
         console.log('订单刷新API响应:', JSON.stringify(response, null, 2))
         if (response.success) {
           recentOrders.value = response.data || []
           console.log('订单数据已更新:', recentOrders.value)
         } else {
           console.warn('订单API返回失败:', response)
         }
       } catch (error) {
         console.warn('刷新订单数据失败:', error)
       }
     }

    // 模拟数据作为后备（仅在没有API数据时使用）
    const loadMockData = () => {
      // 初始想看片单为空
      wishlist.value = []
      // 初始订单为空
      recentOrders.value = []
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
        'cancelled': '已取消',
        '已预订': '已预订',
        '已支付': '已支付',
        '已完成': '已完成',
        '已取消': '已取消'
      }
      return statusMap[status] || '未知'
    }
    
    const getStatusClass = (status) => {
      const statusClassMap = {
        '已预订': 'status-booked',
        '已支付': 'status-paid',
        '已完成': 'status-completed',
        '已取消': 'status-cancelled'
      }
      return statusClassMap[status] || 'status-unknown'
    }
    
    const getMoviePoster = (posterPath) => {
      if (!posterPath) {
        return '/templates/images/others/1.jpg' // 默认电影海报
      }
      // 如果路径不是以http开头，添加/templates前缀
      if (!posterPath.startsWith('http') && !posterPath.startsWith('/templates')) {
        return `/templates${posterPath}`
      }
      return posterPath
    }
    
    const handleImageError = (event) => {
      // 图片加载失败时使用默认图片
      event.target.src = '/templates/images/others/1.jpg'
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
       // 监听订单更新事件
       window.addEventListener('order-updated', refreshOrders)
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
       window.removeEventListener('order-updated', refreshOrders)
     })

    return {
      showDropdown,
      currentUser,
      recentOrders,
      wishlist,
      handleContainerMouseEnter,
      handleContainerMouseLeave,
      getStatusText,
      getStatusClass,
      getMoviePoster,
      handleImageError,
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

/* 订单状态样式 */
.status-booked {
  background: #fff3cd;
  color: #856404;
}

.status-paid {
  background: #d1ecf1;
  color: #0c5460;
}

.status-completed {
  background: #d4edda;
  color: #155724;
}

.status-cancelled {
  background: #f8d7da;
  color: #721c24;
}

.status-unknown {
  background: #e2e3e5;
  color: #383d41;
}

/* 空状态样式 */
.order-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 30px 20px;
  color: #6c757d;
}

.order-empty .empty-icon {
  font-size: 32px;
  margin-bottom: 8px;
}

.order-empty .empty-text {
  font-size: 14px;
  color: #6c757d;
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

/* 空状态样式 */
.wishlist-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px 0;
  color: #999;
}

.empty-icon {
  font-size: 24px;
  margin-bottom: 8px;
  opacity: 0.6;
}

.empty-text {
  font-size: 12px;
  color: #999;
  text-align: center;
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
