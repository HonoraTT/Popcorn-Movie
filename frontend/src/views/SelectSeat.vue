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

      <div class="content">
        <div class="main">
          <div class="demo">
            <!-- 座位图 -->
            <div id="seat-map">
              <div class="front">银幕</div>
            </div>
            
            <!-- 预订详情 -->
            <div class="booking-details">
              <!-- <ul class="book-left">
                <li>电影</li>
                <li>时间</li>
                <li>票数</li>
                <li>总计</li>
                <li>座位：</li>
              </ul> -->
              <ul class="book-right">
                <li class="name">{{ movieName }}</li>
                <li>
                  <span>{{ showTime }} {{ duration }} {{ language }}</span>
                </li>
                <!-- <li><span id="counter">{{ selectedSeats.length }}</span></li> -->
                <!-- <li><b><i>¥</i><span id="total">{{ totalPrice }}</span></b></li> -->
              </ul>
              <div class="clear"></div>
              <!-- <ul id="selected-seats" class="scrollbar scrollbar1">
                <li v-for="seat in selectedSeats" :key="`${seat.row}-${seat.col}`">
                    {{ seat.row }}排 {{ seat.col }}号
                    <span>新人价{{ price }}</span>
                </li>
              </ul> -->
              <ul id="selected-seats" class="selected-seats-wrapper">
                <li v-for="seat in selectedSeats" :key="`${seat.row}-${seat.col}`" class="selected-seat-item">
                  
                  <!-- 座位信息放在右侧 -->
                  <div class="info">
                    <div class="seat-info">
                      {{ seat.row }}排{{ seat.col }}号
                    </div>
                    <div class="price-info">
                      新人价¥{{ price }}
                    </div>
                  </div>
                  <!-- 关闭按钮放在最左侧 -->
                  <div class="close-icon" @click="removeSeat(seat)">×</div>
                </li>
              </ul>


              <button v-if="selectedSeats.length" class="checkout-button" @click="bookSeats">{{ totalPrice }}元 立即预订</button>
              <button v-else class="checkout-button1" @click="bookSeats">请先选座</button>
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
import { getMovieById } from '@/api/movie'

export default {
  name: 'SelectSeat',
  setup() {
    const store = useStore()
    const router = useRouter()
    const route = useRoute()
    
    // 座位图表实例引用
    const seatChart = ref(null)
    // 存储座位ID映射关系，解决索引不匹配问题
    const seatIdMap = ref({})
    
    const currentUser = computed(() => store.getters.currentUser)
    const showId = ref(route.params.showId)
    const movieId = ref(route.params.movieId)
    const movieName = ref('')
    const showTime = ref('')
    const duration = ref('')
    const language = ref('')
    const price = ref(0)
    const selectedSeats = ref([])
    const seatMap = ref('')
    const soldSeats = ref([])
    const errorMessage = ref('')
    const loading = ref(false)

    const totalPrice = computed(() => {
      return selectedSeats.value.length * price.value
    })
    
    const removeSeat = (seatToRemove) => {
      // 1. 从选中列表中移除座位
      const initialLength = selectedSeats.value.length
      selectedSeats.value = selectedSeats.value.filter(
        (seat) => seat.row !== seatToRemove.row || seat.col !== seatToRemove.col
      );
      
      // 2. 只有当确实移除了座位时才更新座位图状态
      if (selectedSeats.value.length < initialLength && seatChart.value) {
        // 使用预存的ID映射关系查找座位
        const seatKey = `${seatToRemove.row}-${seatToRemove.col}`;
        const seatId = seatIdMap.value[seatKey];
        
        if (seatId) {
          const seat = seatChart.value.get(seatId);
          if (seat && seat.status() === 'selected') {
            seat.status('available');
          } else {
            console.log('座位状态不是选中状态', seat?.status());
          }
        } else {
          console.log('未找到座位ID映射', seatKey);
        }
      }
    };

    const loadSeatData = async () => {
      try {
        loading.value = true
        const response = await getSeatMap(showId.value)
        const response1 = await getMovieById(movieId.value)
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

        if (response1.duration) {
          duration.value = response1.duration
        } else {
          duration.value = '2hour'
        }

        if (response1.language) {
          language.value = response1.language
        } else {
          language.value = '国语'
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
          // 重置座位ID映射
          seatIdMap.value = {};
          
          // 创建座位图并保存实例
          seatChart.value = $('#seat-map').seatCharts({
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
              // 记录座位ID与行列的映射关系
              const seatKey = `${this.settings.row + 1}-${this.settings.label}`;
              seatIdMap.value[seatKey] = this.settings.id;
              
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
                  row: this.settings.row + 1,
                  col: this.settings.label,
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
            seatChart.value.get(soldSeats.value).status('unavailable')
          }
          
          // 初始化时建立所有座位的ID映射
          seatChart.value.each(function() {
            const seatKey = `${this.settings.row + 1}-${this.settings.label}`;
            seatIdMap.value[seatKey] = this.settings.id;
          });
        }
      }, 100)
    }

    // 其他方法保持不变...
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
          seats: selectedSeats.value
        })

        if (response.success) {
          ElMessage.success('预订成功！')
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
      duration,
      language,
      price,
      selectedSeats,
      totalPrice,
      errorMessage,
      loading,
      bookSeats,
      removeSeat,
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



.booking-details {
  background-color: #fff;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* .book-left, .book-right {
  list-style: none;
  padding: 0;
  margin: 0;
  display: inline-block;
  vertical-align: top;
}

.book-left li, .book-right li {
  margin-bottom: 8px;
}

.book-left {
  margin-right: 24px;
}

.book-left li {
  font-weight: bold;
  color: #333;
} */

.book-right li {
  color: #666;
}

.clear {
  clear: both;
}

#selected-seats {
  list-style: none;
  padding: 0;
  margin: 16px 0;
  display: flex;
  flex-wrap: wrap;
}

#selected-seats li {
  background-color: #f5f5f5;
  border-radius: 4px;
  padding: 6px 12px;
  margin-right: 8px;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
}

#selected-seats li span {
  margin-left: 6px;
  cursor: pointer;
  color: #999;
}

.checkout-button {
  background: linear-gradient(90deg, #ff3366, #ff0033);
  color: #fff;
  border: none;
  border-radius: 24px;
  padding: 12px 24px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  width: 100%;
}
.checkout-button1 {
  background: linear-gradient(90deg, #fd87a1, #fe5773);
  color: #fff;
  border: none;
  border-radius: 24px;
  padding: 12px 24px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  width: 100%;
}

.checkout-button:hover {
  background: linear-gradient(90deg, #ff6688, #ff3355);
}

#legend {
  margin-top: 16px;
  font-size: 14px;
  color: #999;
}

/* 包裹已选座位的容器 */
.selected-seats-wrapper {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-wrap: wrap;
}

/* 单个已选座位项 - 使用Flex布局 */
.selected-seat-item {
  background-color: #f5f7fa;
  border-radius: 8px;
  padding: 8px 12px;
  display: flex; /* 启用Flex布局 */
  align-items: center; /* 垂直居中对齐 */
  min-width: 120px;
  position: relative;
}

/* 关闭图标 - 放在最左侧 */
.close-icon {
  color: #999;
  font-size: 16px;
  cursor: pointer;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-icon:hover {
  color: #ff4d4f; /*  hover时变红 */
  background-color: rgba(255, 77, 79, 0.1);
  border-radius: 50%;
}

/* 座位信息区域 */
.info {
  flex: 1; /* 占据剩余空间 */
}

.seat-info {
  font-size: 14px;
  color: #333;
  margin-bottom: 2px;
}

.price-info {
  font-size: 12px;
  color: #ff4d4f;
}

</style>