<template>
  <div class="payment">
    <h2>支付页面</h2>
    <el-result icon="success" title="模拟支付成功" sub-title="后续可接入真实支付">
      <template #extra>
        <el-button type="primary" @click="$router.push('/')">返回首页</el-button>
      </template>
    </el-result>
  </div>
</template>
<script>
export default { name: 'Payment' }
</script>
<style scoped>
.payment { padding: 20px; }
</style>