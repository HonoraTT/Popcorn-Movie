<template>
  <div class="payment">
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
    <!-- <h2>支付页面</h2> -->
    <el-result icon="success" title="模拟支付成功" sub-title="后续可接入真实支付">
      <template #extra>
        <el-button type="primary" @click="$router.push('/')">返回首页</el-button>
      </template>
    </el-result>
  </div>
</template>
<script>
import { computed } from 'vue'
import { useStore } from 'vuex'
export default { 
  name: 'Payment',
  setup() {
    const store = useStore()
    const currentUser = computed(() => store.getters.currentUser)
    return {
      currentUser
    }
  }
}

    
</script>
<style scoped>
.payment {
    max-width: 1200px !important;
    margin: 0 auto !important;
    background: #fff !important;
    position: relative;
    z-index: 2;
    min-height: 100vh;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
    padding: 0 !important;
}
</style>