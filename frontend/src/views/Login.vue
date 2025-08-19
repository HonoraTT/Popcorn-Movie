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
              <li v-if="currentUser">
                <UserDropdown />
              </li>
              <li v-if="currentUser">
                <p class="user-info">
                  <router-link to="/" style="cursor:default;">{{ currentUser.username }}</router-link>
                </p>
              </li>
              <li v-else>
                <p class="user-info">
                  <router-link to="/login">登录</router-link>
                </p>
              </li>
              <li v-if="!currentUser" class="last"><i class="edit"></i></li>
              <div class="clearfix"></div>
            </ul>
          </div>
          <div class="clearfix"></div>
        </div>
        
        <div class="content">
          <div class="login-container">
            <div class="login-card">
              <div class="login-header">
                <div class="logo-section">
                  <div class="logo-icon">🎬</div>
                  <h1>欢迎回来</h1>
                  <p>登录您的PopcornMovie账户</p>
                </div>
              </div>
              
              <div class="login-form">
                <el-form 
                  ref="loginFormRef" 
                  :model="loginForm" 
                  :rules="rules"
                  class="form-container"
                >
                  <div class="form-group">
                    <label class="form-label">邮箱地址</label>
                    <div class="input-wrapper">
                      <i class="input-icon">📧</i>
                      <input 
                        v-model="loginForm.email" 
                        name="email" 
                        type="text"
                        class="form-input"
                        placeholder="请输入您的邮箱地址"
                      />
                    </div>
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">密码</label>
                    <div class="input-wrapper">
                      <i class="input-icon">🔒</i>
                      <input 
                        v-model="loginForm.password" 
                        name="password" 
                        type="password"
                        class="form-input"
                        placeholder="请输入您的密码"
                      />
                    </div>
                  </div>
                  
                  <el-button 
                    :loading="loading" 
                    @click="handleLogin"
                    class="login-button"
                    type="primary"
                  >
                    <span v-if="!loading">登录</span>
                    <span v-else>登录中...</span>
                  </el-button>
                </el-form>
                
                <div class="divider">
                  <span>或者</span>
                </div>
                
                <div class="register-section">
                  <p>还没有账户？</p>
                  <router-link to="/register" class="register-link">
                    立即注册
                  </router-link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, computed } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import UserDropdown from '@/components/UserDropdown.vue'

export default {
  name: 'Login',
  components: {
    UserDropdown
  },
  setup() {
    const store = useStore()
    const router = useRouter()
    const loginFormRef = ref(null)
    const loading = ref(false)
    
    const currentUser = computed(() => store.getters.currentUser)
    
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

/* 登录页面容器 */
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 100px);
  padding: 40px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2  100%);
  position: relative;
  overflow: hidden;
}

.login-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="10" cy="60" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="90" cy="40" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
  opacity: 0.3;
  z-index: 1;
}

/* 登录卡片 */
.login-card {
  width: 100%;
  max-width: 450px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
  overflow: hidden;
  position: relative;
  z-index: 2;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* 登录头部 */
.login-header {
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
  padding: 40px 30px;
  text-align: center;
  color: white;
}

.logo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
}

.logo-icon {
  font-size: 48px;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
}

.login-header h1 {
  margin: 0;
  font-size: 28px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.login-header p {
  margin: 0;
  font-size: 16px;
  opacity: 0.9;
  font-weight: 300;
}

/* 登录表单 */
.login-form {
  padding: 40px 30px;
}

.form-container {
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-label {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 5px;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 15px;
  font-size: 18px;
  color: #666;
  z-index: 1;
}

.form-input {
  width: 100%;
  padding: 15px 15px 15px 50px;
  border: 2px solid #e1e5e9;
  border-radius: 12px;
  font-size: 16px;
  background: #f8f9fa;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.form-input:focus {
  outline: none;
  border-color: #ff6b6b;
  background: white;
  box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
}

.form-input::placeholder {
  color: #999;
  font-size: 14px;
}

/* 登录按钮 */
.login-button {
  width: 100%;
  padding: 15px;
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%) !important;
  border: none !important;
  border-radius: 12px !important;
  font-size: 16px !important;
  font-weight: 600 !important;
  color: white !important;
  cursor: pointer;
  transition: all 0.3s ease !important;
  box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3) !important;
}

.login-button:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4) !important;
}

.login-button:active {
  transform: translateY(0) !important;
}

/* 分割线 */
.divider {
  text-align: center;
  margin: 30px 0;
  position: relative;
}

.divider::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  height: 1px;
  background: #e1e5e9;
}

.divider span {
  background: white;
  padding: 0 20px;
  color: #666;
  font-size: 14px;
  position: relative;
  z-index: 1;
}

/* 注册区域 */
.register-section {
  text-align: center;
  padding: 20px 0;
}

.register-section p {
  margin: 0 0 15px 0;
  color: #666;
  font-size: 14px;
}

.register-link {
  display: inline-block;
  padding: 12px 30px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  text-decoration: none;
  border-radius: 25px;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

.register-link:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
  color: white;
  text-decoration: none;
}

/* 响应式设计 */
@media (max-width: 480px) {
  .login-container {
    padding: 20px 15px;
  }
  
  .login-card {
    border-radius: 15px;
  }
  
  .login-header {
    padding: 30px 20px;
  }
  
  .login-form {
    padding: 30px 20px;
  }
  
  .logo-icon {
    font-size: 36px;
  }
  
  .login-header h1 {
    font-size: 24px;
  }
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