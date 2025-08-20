<template>
  <div class="container">
    <div class="container_wrap">
      <!-- 头部导航 -->
      <div class="header_top">
        <div class="col-sm-4 logo">
          <a href="/">
            <div class="logo-container"><img src="/templates/images/nav/logo.png" alt="" class="logo-image"/></div>
          </a>
        </div>
        <div class="col-sm-4 nav">
          <ul>
            <li><span class="simptip-position-bottom simptip-movable" data-tooltip="comic"><a href="/"> </a></span></li>
            <li><span class="simptip-position-bottom simptip-movable" data-tooltip="movie"><a href="/"> </a></span></li>
            <li><span class="simptip-position-bottom simptip-movable" data-tooltip="video"><a href="/"> </a></span></li>
            <li><span class="simptip-position-bottom simptip-movable" data-tooltip="game"><a href="/"> </a></span></li>
            <li><span class="simptip-position-bottom simptip-movable" data-tooltip="tv"><a href="/"> </a></span></li>
            <li><span class="simptip-position-bottom simptip-movable" data-tooltip="more"><a href="/"> </a></span></li>
          </ul>
        </div>
        <div class="col-sm-4 header_right">
          <ul class="header_right_box">
            <li v-if="currentUser">
              <UserDropdown />
            </li>
            <li v-if="currentUser">
              <p class="user-info">
                <a style="cursor:default;" href="/">{{ currentUser.username }}</a>
              </p>
            </li>
            <li v-else>
              <p class="user-info">
                <a href="/login">登录</a>
              </p>
            </li>
            <li v-if="!currentUser" class="last"><i class="edit"> </i></li>
            <div class="clearfix"> </div>
          </ul>
        </div>
        <div class="clearfix"> </div>
      </div>

      <div class="content">
        <div class="main">
          <div class="demo">
            <!-- 座位图 -->
            <div id="seat-map">
              <div class="front">银幕</div>
            </div>
            
            <!-- 预订详情 -->
            <div class="booking-details">
              <ul class="book-left">
                <li>电影</li>
                <li>时间</li>
                <li>票数</li>
                <li>总计</li>
                <li>座位：</li>
              </ul>
              <ul class="book-right">
                <li>{{ movieName }}</li>
                <li>{{ showTime }}</li>
                <li><span id="counter">{{ selectedSeats.length }}</span></li>
                <li><b><i>¥</i><span id="total">{{ totalPrice }}</span></b></li>
              </ul>
              <div class="clear"></div>
              <ul id="selected-seats" class="scrollbar scrollbar1">
                <li v-for="seat in selectedSeats" :key="`${seat.row}-${seat.col}`">
                  第{{ seat.row }}排 {{ seat.col }}号
                </li>
              </ul>

              <button class="checkout-button" @click="bookSeats">立即预订</button>
              <div id="legend"></div>
            </div>
            <div style="clear:both"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- 座位已被预订对话框 -->
  <div class="modal video-modal fade" id="seat_taken" tabindex="-1" role="dialog" aria-labelledby="myModal">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <section>
          <div class="modal-body">
            <img class="center" style="width: 30%; height: 30%;" src="/templates/images/selectSeat/cross.png"/>
            <h1 class="bigFont center" style="text-align: center" id="errorMessage">{{ errorMessage }}</h1>
          </div>
        </section>
      </div>
    </div>
  </div>

  <!-- 未选择座位对话框 -->
  <div class="modal video-modal fade" id="no_selected" tabindex="-1" role="dialog" aria-labelledby="myModal">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <section>
          <div class="modal-body">
            <img class="center" style="width: 30%; height: 30%;" src="/templates/images/selectSeat/cross.png"/>
            <h1 class="bigFont center" style="text-align: center">您还没有选择任何座位</h1>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, computed } from 'vue'
import { useStore } from 'vuex'
import { useRouter, useRoute } from 'vue-router'
import { getSeatMap, bookSeats as bookSeatsApi } from '@/api/booking'
import { ElMessage } from 'element-plus'
import UserDropdown from '@/components/UserDropdown.vue'

export default {
  name: 'SelectSeat',
  components: {
    UserDropdown
  },
  setup() {
    const store = useStore()
    const router = useRouter()
    const route = useRoute()
    
    const currentUser = computed(() => store.getters.currentUser)
    const showId = ref(route.params.showId)
    const movieName = ref('')
    const showTime = ref('')
    const price = ref(0)
    const selectedSeats = ref([])
    const seatMap = ref('')
    const soldSeats = ref([])
    const errorMessage = ref('')
    const loading = ref(false)

    const totalPrice = computed(() => {
      return selectedSeats.value.length * price.value
    })

    const loadSeatData = async () => {
      try {
        loading.value = true
        const response = await getSeatMap(showId.value)
        seatMap.value = response.seatMap
        soldSeats.value = response.soldSeats || []
        
        // 从API获取电影和场次信息
        if (response.movieName) {
          movieName.value = response.movieName
        } else {
          movieName.value = '电影名称'
        }
        
        if (response.showTime) {
          showTime.value = response.showTime
        } else {
          showTime.value = '2025-08-09 14:30'
        }
        
        if (response.price) {
          price.value = response.price
        } else {
          price.value = 25
        }
        
        initializeSeatChart()
      } catch (error) {
        console.error('加载座位数据失败:', error)
        ElMessage.error('加载座位数据失败')
      } finally {
        loading.value = false
      }
    }

    const initializeSeatChart = () => {
      // 等待DOM加载完成
      setTimeout(() => {
        if (typeof $ !== 'undefined' && $.fn.seatCharts) {
          const $cart = $('#selected-seats')
          const $counter = $('#counter')
          const $total = $('#total')

          const sc = $('#seat-map').seatCharts({
            map: seatMap.value,
            naming: {
              top: false,
              getLabel: function (character, row, column) {
                return column
              }
            },
            legend: {
              node: $('#legend'),
              items: [
                ['a', 'available', '可选'],
                ['a', 'unavailable', '已售'],
                ['a', 'selected', '已选']
              ]
            },
            click: function () {
              if (this.status() == 'available') {
                const seat = {
                  showId: showId.value,
                  row: this.settings.row + 1,
                  col: this.settings.label,
                  isBooked: true
                }
                selectedSeats.value.push(seat)
                return 'selected'
              } else if (this.status() == 'selected') {
                const seat = {
                  showId: showId.value,
                  row: this.settings.row + 1,
                  col: this.settings.label,
                  isBooked: true
                }
                const index = selectedSeats.value.findIndex(s => s.row === seat.row && s.col === seat.col)
                if (index > -1) {
                  selectedSeats.value.splice(index, 1)
                }
                return 'available'
              } else if (this.status() == 'unavailable') {
                return 'unavailable'
              } else {
                return this.style()
              }
            }
          })

          // 设置已售座位
          if (soldSeats.value.length > 0) {
            sc.get(soldSeats.value).status('unavailable')
          }
        }
      }, 100)
    }

    const bookSeats = async () => {
      if (selectedSeats.value.length === 0) {
        $('#no_selected').modal('show')
        return
      }

      if (!currentUser.value) {
        ElMessage.error('请先登录')
        router.push('/login')
        return
      }

      try {
        loading.value = true
        const response = await bookSeatsApi({
          showId: showId.value,
          seats: selectedSeats.value,
          userId: currentUser.value.id
        })

        if (response.success) {
          ElMessage.success('预订成功！')
          // 触发订单更新事件，通知UserDropdown组件刷新订单数据
          window.dispatchEvent(new CustomEvent('order-updated'))
          router.push('/payment')
        } else {
          errorMessage.value = response.message || '预订失败'
          $('#seat_taken').modal('show')
        }
      } catch (error) {
        console.error('预订失败:', error)
        errorMessage.value = '预订失败，请重试'
        $('#seat_taken').modal('show')
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
      console.log('当前路由参数:', route.params);
      loadSeatData()
    })

    return {
      currentUser,
      showId,
      movieName,
      showTime,
      price,
      selectedSeats,
      totalPrice,
      errorMessage,
      loading,
      bookSeats,
      handleLogout
    }
  }
}
</script>

<style>
/* 引入原有的CSS文件 */
@import url('/templates/css/bootstrap.css');
@import url('/templates/css/nav/style.css');
@import url('/templates/css/common.css');
@import url('/templates/css/selectSeat/googleAPIStylesheet.css');
@import url('/templates/css/selectSeat/style.css');

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
</style>