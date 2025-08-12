<template>
  <div class="movie-detail">
    <h2>电影详情（占位） - ID: {{ $route.params.id }}</h2>
    <el-button type="primary" @click="$router.push(`/select-show/${$route.params.id}`)">选择场次</el-button>
  </div>
</template>
<script>
export default { name: 'MovieDetail' }
</script>
<style scoped>
.movie-detail { padding: 20px; }
</style>