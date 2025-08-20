<template>
  <div class="order-detail-page">
    <div class="content">
      <!-- 页面标题 -->
      <div class="page-header">
        <h1>订单详情</h1>
        <router-link to="/" class="back-link">
          <i class="icon-back"></i>
          返回首页
        </router-link>
      </div>

      <!-- 加载状态 -->
      <div v-if="loading" class="loading-state">
        <div class="loading-spinner"></div>
        <div class="loading-text">正在加载订单详情...</div>
      </div>

      <!-- 订单详情 -->
      <div v-else-if="order" class="order-detail">
        <!-- 订单状态 -->
        <div class="order-status-section">
          <div class="status-card" :class="getStatusClass(order.status)">
            <div class="status-icon">
              <i :class="getStatusIcon(order.status)"></i>
            </div>
            <div class="status-info">
              <div class="status-text">{{ getStatusText(order.status) }}</div>
              <div class="order-time">订单时间：{{ formatOrderTime(order.orderTime) }}</div>
            </div>
          </div>
        </div>

        <!-- 电影信息 -->
        <div class="movie-info-section">
          <div class="movie-card">
            <div class="movie-poster">
              <img 
                :src="getMoviePoster(order.moviePoster)" 
                :alt="order.movieName"
                @error="handleImageError"
              />
            </div>
            <div class="movie-details">
              <h2 class="movie-title">{{ order.movieName }}</h2>
              <div class="movie-meta">
                <div class="meta-item">
                  <span class="label">影院：</span>
                  <span class="value">{{ order.cinemaName }}</span>
                </div>
                <div class="meta-item">
                  <span class="label">场次：</span>
                  <span class="value">{{ order.showTime }}</span>
                </div>
                <div class="meta-item">
                  <span class="label">座位：</span>
                  <span class="value">{{ order.seats }}</span>
                </div>
                <div class="meta-item">
                  <span class="label">总价：</span>
                  <span class="value price">¥{{ order.totalPrice }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 订单信息 -->
        <div class="order-info-section">
          <div class="info-card">
            <h3>订单信息</h3>
            <div class="info-list">
              <div class="info-item">
                <span class="label">订单编号：</span>
                <span class="value">{{ order.id }}</span>
              </div>
              <div class="info-item">
                <span class="label">订单状态：</span>
                <span class="value" :class="getStatusClass(order.status)">
                  {{ getStatusText(order.status) }}
                </span>
              </div>
              <div class="info-item">
                <span class="label">创建时间：</span>
                <span class="value">{{ formatOrderTime(order.orderTime) }}</span>
              </div>
              <div class="info-item">
                <span class="label">支付金额：</span>
                <span class="value price">¥{{ order.totalPrice }}</span>
              </div>
            </div>
          </div>
        </div>

                 <!-- 操作按钮 -->
         <div class="action-section">
           <button 
             v-if="order.status === '已预订'" 
             class="btn-primary"
             @click="handlePayment">
             立即支付
           </button>
           <button 
             v-if="order.status === '已预订'" 
             class="btn-secondary"
             @click="handleCancel">
             取消订单
           </button>
         </div>
      </div>

      <!-- 错误状态 -->
      <div v-else class="error-state">
        <div class="error-icon">❌</div>
        <div class="error-text">订单不存在或已被删除</div>
        <router-link to="/" class="btn-primary">
          返回首页
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getOrderById, cancelOrder } from '@/api/booking'
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: 'OrderDetail',
  setup() {
    const route = useRoute()
    const router = useRouter()
    const order = ref(null)
    const loading = ref(true)

    // 获取订单详情
    const loadOrderDetail = async () => {
      try {
        const orderId = route.params.orderId
        if (!orderId) {
          ElMessage.error('订单ID无效')
          router.push('/')
          return
        }

        const response = await getOrderById(orderId)
        if (response.success) {
          order.value = response.data
        } else {
          ElMessage.error(response.message || '获取订单详情失败')
        }
      } catch (error) {
        console.error('获取订单详情失败:', error)
        ElMessage.error('获取订单详情失败')
      } finally {
        loading.value = false
      }
    }

    // 格式化订单时间
    const formatOrderTime = (orderTime) => {
      if (!orderTime) return ''
      const date = new Date(orderTime)
      return date.toLocaleString('zh-CN')
    }

    // 获取状态文本
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

    // 获取状态样式类
    const getStatusClass = (status) => {
      const statusClassMap = {
        '已预订': 'status-booked',
        '已支付': 'status-paid',
        '已完成': 'status-completed',
        '已取消': 'status-cancelled'
      }
      return statusClassMap[status] || 'status-unknown'
    }

    // 获取状态图标
    const getStatusIcon = (status) => {
      const iconMap = {
        '已预订': 'icon-clock',
        '已支付': 'icon-check',
        '已完成': 'icon-success',
        '已取消': 'icon-cancel'
      }
      return iconMap[status] || 'icon-info'
    }

    // 获取电影海报
    const getMoviePoster = (posterPath) => {
      if (!posterPath) {
        return '/templates/images/others/1.jpg'
      }
      if (!posterPath.startsWith('http') && !posterPath.startsWith('/templates')) {
        return `/templates${posterPath}`
      }
      return posterPath
    }

    // 处理图片加载错误
    const handleImageError = (event) => {
      event.target.src = '/templates/images/others/1.jpg'
    }

    // 处理支付
    const handlePayment = () => {
      ElMessage.info('跳转到支付页面...')
      // 这里可以跳转到支付页面
    }

    // 处理取消订单
    const handleCancel = async () => {
      try {
        // 显示确认对话框
        const confirmed = await ElMessageBox.confirm(
          '确定要取消这个订单吗？取消后无法恢复。',
          '确认取消',
          {
            confirmButtonText: '确定取消',
            cancelButtonText: '保留订单',
            type: 'warning',
          }
        )
        
        if (confirmed) {
          const response = await cancelOrder(order.value.id)
          if (response.success) {
            ElMessage.success('订单取消成功')
            // 更新订单状态
            order.value.status = '已取消'
            // 返回首页
            router.push('/')
          } else {
            ElMessage.error(response.message || '取消订单失败')
          }
        }
      } catch (error) {
        if (error !== 'cancel') { // 用户点击取消按钮时会抛出 'cancel' 错误
          console.error('取消订单失败:', error)
          ElMessage.error('取消订单失败')
        }
      }
    }

    onMounted(() => {
      loadOrderDetail()
    })

         return {
       order,
       loading,
       formatOrderTime,
       getStatusText,
       getStatusClass,
       getStatusIcon,
       getMoviePoster,
       handleImageError,
       handlePayment,
       handleCancel
     }
  }
}
</script>

<style scoped>
.order-detail-page {
  background: #f5f5f5;
  min-height: 100vh;
  padding: 20px 0;
}

.content {
  max-width: 800px;
  margin: 0 auto;
  padding: 0 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 1px solid #e9ecef;
}

.page-header h1 {
  font-size: 28px;
  font-weight: bold;
  color: #333;
  margin: 0;
}

.back-link {
  display: flex;
  align-items: center;
  color: #666;
  text-decoration: none;
  font-size: 16px;
  transition: color 0.3s ease;
}

.back-link:hover {
  color: #ff4757;
}

.loading-state {
  text-align: center;
  padding: 60px 0;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #ff4757;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  color: #666;
  font-size: 16px;
}

.order-detail {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.order-status-section {
  margin-bottom: 20px;
}

.status-card {
  display: flex;
  align-items: center;
  padding: 20px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.status-icon {
  margin-right: 20px;
  font-size: 24px;
}

.status-info {
  flex: 1;
}

.status-text {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 5px;
}

.order-time {
  color: #666;
  font-size: 14px;
}

.movie-info-section {
  margin-bottom: 20px;
}

.movie-card {
  display: flex;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.movie-poster {
  width: 120px;
  height: 180px;
  flex-shrink: 0;
}

.movie-poster img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.movie-details {
  flex: 1;
  padding: 20px;
}

.movie-title {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  margin: 0 0 15px 0;
}

.movie-meta {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.meta-item {
  display: flex;
  align-items: center;
}

.label {
  color: #666;
  width: 60px;
  flex-shrink: 0;
}

.value {
  color: #333;
  font-weight: 500;
}

.value.price {
  color: #ff4757;
  font-weight: bold;
  font-size: 18px;
}

.order-info-section {
  margin-bottom: 20px;
}

.info-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.info-card h3 {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin: 0 0 15px 0;
}

.info-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.info-item:last-child {
  border-bottom: none;
}

.action-section {
  display: flex;
  gap: 15px;
  justify-content: center;
  padding: 20px 0;
}

.btn-primary {
  background: #ff4757;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 25px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-primary:hover {
  background: #ff3742;
  transform: translateY(-2px);
}

.btn-secondary {
  background: #6c757d;
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 25px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-secondary:hover {
  background: #5a6268;
  transform: translateY(-2px);
}

.btn-outline {
  background: transparent;
  color: #ff4757;
  border: 2px solid #ff4757;
  padding: 10px 22px;
  border-radius: 25px;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-outline:hover {
  background: #ff4757;
  color: white;
  transform: translateY(-2px);
}

.error-state {
  text-align: center;
  padding: 60px 0;
}

.error-icon {
  font-size: 48px;
  margin-bottom: 20px;
}

.error-text {
  color: #666;
  font-size: 16px;
  margin-bottom: 30px;
}

/* 状态样式 */
.status-booked {
  color: #ffc107;
}

.status-paid {
  color: #28a745;
}

.status-completed {
  color: #17a2b8;
}

.status-cancelled {
  color: #dc3545;
}

.status-unknown {
  color: #6c757d;
}
</style>
