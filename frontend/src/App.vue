<script setup>
import { onMounted } from 'vue'
import { useStore } from 'vuex'
import NavBar from '@/components/NavBar.vue'

const store = useStore()

onMounted(() => {
  // 初始化用户状态
  store.dispatch('initUserState')
})
</script>

<template>
  <div id="app">
    <el-container>
      <el-header>
        <nav-bar />
      </el-header>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<style>
#app {
  font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.el-header {
  padding: 0;
  height: auto;
}

.el-main {
  padding: 20px;
  min-height: calc(100vh - 60px);
}
</style>
