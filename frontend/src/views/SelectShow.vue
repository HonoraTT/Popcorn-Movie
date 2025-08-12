<template>
  <div class="select-show">
    <h2>选场次（占位） - 电影ID: {{ $route.params.movieId }}</h2>
    <el-button type="primary" @click="$router.push('/select-seat/1')">去选座</el-button>
  </div>
</template>
<script>
export default { name: 'SelectShow' }
</script>
<style scoped>
.select-show { padding: 20px; }
</style>