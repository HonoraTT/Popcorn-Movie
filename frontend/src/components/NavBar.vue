<template>
  <div class="nav-bar">
    <!-- <el-menu 
      :default-active="activeIndex" 
      mode="horizontal" 
      router
      background-color="#409eff"
      text-color="#fff"
      active-text-color="#ffd04b"
    >
      <el-menu-item index="/">
        <el-icon><Film /></el-icon>
        <span>MovieTime</span>
      </el-menu-item>
      
      <div class="flex-grow" />
      
      <template v-if="isLoggedIn">
        <el-menu-item index="/profile">
          <el-icon><User /></el-icon>
          <span>{{ currentUser?.username || '用户' }}</span>
        </el-menu-item>
        <el-menu-item @click="handleLogout">
          <el-icon><SwitchButton /></el-icon>
          <span>退出</span>
        </el-menu-item>
      </template>
      
      <template v-else>
        <el-menu-item index="/login">
          <el-icon><User /></el-icon>
          <span>登录</span>
        </el-menu-item>
        <el-menu-item index="/register">
          <el-icon><Edit /></el-icon>
          <span>注册</span>
        </el-menu-item>
      </template>
    </el-menu> -->
  </div>
</template>

<!-- <script>
import { computed } from 'vue'
import { useStore } from 'vuex'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Film, User, SwitchButton, Edit } from '@element-plus/icons-vue'

export default {
  name: 'NavBar',
  components: {
    Film,
    User,
    SwitchButton,
    Edit
  },
  setup() {
    const store = useStore()
    const route = useRoute()
    
    const isLoggedIn = computed(() => store.getters.isLoggedIn)
    const currentUser = computed(() => store.getters.currentUser)
    const activeIndex = computed(() => route.path)
    
    const handleLogout = async () => {
      try {
        await store.dispatch('logout')
        ElMessage.success('退出成功')
      } catch (error) {
        console.error('退出失败:', error)
      }
    }
    
    return {
      isLoggedIn,
      currentUser,
      activeIndex,
      handleLogout
    }
  }
}
</script>

<style scoped>
.nav-bar {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.flex-grow {
  flex-grow: 1;
}

.el-menu {
  display: flex;
  align-items: center;
}

.el-menu-item {
  display: flex;
  align-items: center;
  gap: 4px;
}
</style>  -->