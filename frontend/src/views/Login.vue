<template>
  <div class="login-page">
    <div class="container">
      <div class="container_wrap">
        <div class="header_top">
          <div class="col-sm-4 logo">
            <router-link to="/">
              <div class="logo-container"><img src="/templates/images/nav/logo.png" alt="" class="logo-image"/></div>
            </router-link>
          </div>
          <div class="col-sm-4 nav"></div>
          <div class="col-sm-4 header_right">
            <ul class="header_right_box">
              <li>
                <img v-if="username" :src="userIconPath" alt="User Icon" class="user-avatar"/>
              </li>
              <li>
                <p class="user-info">
                  <router-link v-if="username" to="/">{{ username }}</router-link>
                  <router-link v-else to="/login">登录</router-link>
                </p>
              </li>
              <li v-if="!username" class="last"><i class="edit"></i></li>
              <div class="clearfix"></div>
            </ul>
          </div>
          <div class="clearfix"></div>
        </div>
        
        <div class="content">
          <div class="register">
            <div class="col-md-6 login-left">
              <h3>新用户</h3>
              <p>通过在我们的商店创建账户，您将能够更快地完成结账流程，存储多个送货地址，在您的账户中查看和跟踪订单等。</p>
              <router-link class="acount-btn" to="/register">创建账户</router-link>
            </div>
            
            <div class="col-md-6 login-right">
              <h3>已注册用户</h3>
              <p>如果您在我们这里已有账户，请登录。</p>
              <el-form 
                ref="loginFormRef" 
                :model="loginForm" 
                :rules="rules"
  >
                <div>
                  <span>邮箱地址<label>*</label></span>
                  <input v-model="loginForm.email" name="email" type="text" />
                </div>
                <div>
                  <span>密码<label>*</label></span>
                  <input v-model="loginForm.password" name="password" type="password"/>
                </div>
                <el-button 
                  :loading="loading" 
                  @click="handleLogin"
                >
                  登录
                </el-button>
              </el-form>
            </div>
            
            <div class="clearfix"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

export default {
  name: 'Login',
  setup() {
    const store = useStore()
    const router = useRouter()
    const loginFormRef = ref(null)
    const loading = ref(false)
    
    // 表单数据
    const loginForm = reactive({
      email: '',
      password: ''
    })
    
    // 验证规则
    const rules = reactive({
      email: [
        { required: true, message: '请输入邮箱', trigger: 'blur' },
        { type: 'email', message: '请输入正确的邮箱格式', trigger: ['blur', 'change'] }
      ],
      password: [
        { required: true, message: '请输入密码', trigger: 'blur' },
        { min: 6, message: '密码长度不能少于6位', trigger: ['blur', 'change'] }
      ]
    })
    
    // 登录方法
    const handleLogin = async () => {
      try {
        // 表单验证
        await loginFormRef.value.validate()
        loading.value = true
        
        // 调用Vuex action进行登录
        const response = await store.dispatch('login', {
          email: loginForm.email,
          password: loginForm.password
        })
        
        // 处理登录结果
        if (response?.success) {
          ElMessage.success(response.message || '登录成功')
          router.push(response.redirect || '/')
        } else {
          throw new Error(response?.message || '登录失败')
        }
      } catch (error) {
        console.error('登录错误:', error)
        
        // 更精细的错误处理
        if (error.message.includes('Network Error')) {
          ElMessage.error('网络错误，请检查网络连接')
        } else if (error.response?.status === 401) {
          ElMessage.error('邮箱或密码错误')
        } else if (error.response?.status === 404) {
          ElMessage.error('登录接口不存在，请联系管理员')
        } else {
          ElMessage.error(error.message || '登录失败，请重试')
        }
      } finally {
        loading.value = false
      }
    }
    
    return {
      loginFormRef,
      loginForm,
      rules,
      loading,
      handleLogin
    }
  }
}
</script>

<style scoped>
@import url('/templates/css/bootstrap.css');
@import url('/templates/css/homepage/style.css');
@import url('/templates/css/common.css');
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 400px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.login-card :deep(.el-card__header) {
  text-align: center;
  background: #f8f9fa;
}

.login-card h2 {
  margin: 0;
  color: #333;
}

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