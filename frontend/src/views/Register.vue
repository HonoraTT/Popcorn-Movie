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
        <div class="col-sm-4 nav"></div>
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
        <div class="register-container">
          <div class="register-card">
            <div class="register-header">
              <div class="logo-section">
                <div class="logo-icon">🎬</div>
                <h1>创建账户</h1>
                <p>加入PopcornMovie，开启您的观影之旅</p>
              </div>
            </div>
            
            <div class="register-form">
              <form @submit.prevent="submitForm" class="form-container">
                <div class="form-section">
                  <h3 class="section-title">个人信息</h3>
                  <div class="form-row">
                    <div class="form-group">
                      <label class="form-label">名字</label>
                      <div class="input-wrapper">
                        <i class="input-icon">👤</i>
                        <input 
                          v-model="form.firstName" 
                          name="firstName" 
                          type="text"
                          @blur="checkFirstName"
                          :class="{ 'error': errors.firstName }"
                          class="form-input"
                          placeholder="请输入您的名字"
                        />
                      </div>
                      <span class="error-message" :style="{ visibility: errors.firstName ? 'visible' : 'hidden' }">
                        无效的名字
                      </span>
                    </div>
                    
                    <div class="form-group">
                      <label class="form-label">姓氏</label>
                      <div class="input-wrapper">
                        <i class="input-icon">👤</i>
                        <input 
                          v-model="form.lastName" 
                          name="lastName" 
                          type="text"
                          @blur="checkLastName"
                          :class="{ 'error': errors.lastName }"
                          class="form-input"
                          placeholder="请输入您的姓氏"
                        />
                      </div>
                      <span class="error-message" :style="{ visibility: errors.lastName ? 'visible' : 'hidden' }">
                        无效的姓氏
                      </span>
                    </div>
                  </div>
                  
                  <div class="form-group">
                    <label class="form-label">邮箱地址</label>
                    <div class="input-wrapper">
                      <i class="input-icon">📧</i>
                      <input 
                        v-model="form.email" 
                        name="email" 
                        type="text"
                        @blur="checkEmail"
                        :class="{ 'error': errors.email }"
                        class="form-input"
                        placeholder="请输入您的邮箱地址"
                      />
                    </div>
                    <span class="error-message" :style="{ visibility: errors.email ? 'visible' : 'hidden' }">
                      无效的邮箱
                    </span>
                  </div>
                  
                  <div class="checkbox-group">
                    <label class="checkbox-label">
                      <input type="checkbox" v-model="form.newsletter" class="checkbox-input" />
                      <span class="checkbox-custom"></span>
                      <span class="checkbox-text">订阅新闻通讯</span>
                    </label>
                  </div>
                </div>
                
                <div class="form-section">
                  <h3 class="section-title">登录信息</h3>
                  <div class="form-row">
                    <div class="form-group">
                      <label class="form-label">密码</label>
                      <div class="input-wrapper">
                        <i class="input-icon">🔒</i>
                        <input 
                          v-model="form.password" 
                          name="password" 
                          type="password"
                          @input="checkPassword"
                          @blur="checkPassword"
                          :class="{ 'error': errors.password }"
                          class="form-input"
                          placeholder="请输入密码（至少6位，包含字母和数字）"
                        />
                      </div>
                      <span class="error-message" :style="{ visibility: errors.password ? 'visible' : 'hidden' }">
                        {{ passwordHint || '密码至少需要6个字符，且必须包含字母和数字' }}
                      </span>
                    </div>
                    
                    <div class="form-group">
                      <label class="form-label">确认密码</label>
                      <div class="input-wrapper">
                        <i class="input-icon">🔒</i>
                        <input 
                          v-model="form.confirmPassword" 
                          name="confirmPassword" 
                          type="password"
                          @blur="checkConfirmPassword"
                          :class="{ 'error': errors.confirmPassword }"
                          class="form-input"
                          placeholder="请再次输入密码"
                        />
                      </div>
                      <span class="error-message" :style="{ visibility: errors.confirmPassword ? 'visible' : 'hidden' }">
                        密码不匹配
                      </span>
                    </div>
                  </div>
                </div>
                
                <el-button 
                  :loading="loading" 
                  @click="submitForm"
                  class="submit-button"
                  type="primary"
                >
                  <span v-if="!loading">创建账户</span>
                  <span v-else>创建中...</span>
                </el-button>
              </form>
              
              <div class="divider">
                <span>或者</span>
              </div>
              
              <div class="login-section">
                <p>已有账户？</p>
                <router-link to="/login" class="login-link">
                  立即登录
                </router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { reactive, ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'
import { ElMessage } from 'element-plus'
import { register } from '@/api/auth'
import UserDropdown from '@/components/UserDropdown.vue'

export default {
  name: 'Register',
  components: {
    UserDropdown
  },
  setup() {
    const router = useRouter()
    const store = useStore()
    const loading = ref(false)
    const passwordHint = ref('')
    
    const currentUser = computed(() => store.getters.currentUser)
    
    const form = reactive({
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      confirmPassword: '',
      newsletter: true
    })

    const errors = reactive({
      firstName: false,
      lastName: false,
      email: false,
      password: false,
      confirmPassword: false
    })

    // 验证函数
    const validateName = (name) => {
      // 支持中英文姓名，1-20个字符
      // 中文：1-5个中文字符
      // 英文：1-20个字母，可以包含空格和连字符
      return /^[\u4E00-\u9FA5]{1,5}$|^[a-zA-Z\s\-']{1,20}$/.test(name)
    }

    const validateEmail = (email) => {
      // 支持更常见的邮箱格式，包括数字
      return /^[a-zA-Z0-9_\-\.]+@[a-zA-Z0-9_\-\.]+\.[a-zA-Z]{2,}$/.test(email)
    }

    const checkFirstName = () => {
      errors.firstName = form.firstName !== '' && !validateName(form.firstName)
    }

    const checkLastName = () => {
      errors.lastName = form.lastName !== '' && !validateName(form.lastName)
    }

    const checkEmail = () => {
      errors.email = form.email !== '' && !validateEmail(form.email)
    }

    const checkPassword = () => {
      if (form.password === '') {
        errors.password = false
        return
      }
      
      // 检查密码格式：至少6位，包含字母和数字
      const hasMinLength = form.password.length >= 6
      const hasLetter = /[a-zA-Z]/.test(form.password)
      const hasDigit = /\d/.test(form.password)
      
      errors.password = !(hasMinLength && hasLetter && hasDigit)
      
      // 更新密码提示信息
      if (!hasMinLength) {
        passwordHint.value = '密码至少需要6个字符'
      } else if (!hasLetter) {
        passwordHint.value = '密码必须包含字母'
      } else if (!hasDigit) {
        passwordHint.value = '密码必须包含数字'
      } else {
        passwordHint.value = ''
      }
    }

    const checkConfirmPassword = () => {
      errors.confirmPassword = form.confirmPassword !== '' && form.confirmPassword !== form.password
    }

    const validateForm = () => {
      checkFirstName()
      checkLastName()
      checkEmail()
      checkPassword()
      checkConfirmPassword()
      
      return !Object.values(errors).some(error => error) &&
             form.firstName && form.lastName && form.email && form.password && form.confirmPassword
    }

    const submitForm = async () => {
      if (!validateForm()) {
        ElMessage.error('请检查表单信息')
        return
      }

      try {
        loading.value = true
        
        const response = await register({
          firstName: form.firstName,
          lastName: form.lastName,
          email: form.email,
          password: form.password,
          newsletter: form.newsletter
        })

        if (response.success) {
          ElMessage.success('注册成功！')
          router.push('/login')
        } else {
          ElMessage.error(response.message || '注册失败')
        }
      } catch (error) {
        console.error('注册失败:', error)
        ElMessage.error('注册失败，请重试')
      } finally {
        loading.value = false
      }
    }

    return {
      form,
      errors,
      loading,
      submitForm,
      checkFirstName,
      checkLastName,
      checkEmail,
      checkPassword,
      checkConfirmPassword,
      currentUser,
      passwordHint
    }
  }
}
</script>

<style>
/* 引入原有的CSS文件 */
@import url('/templates/css/bootstrap.css');
@import url('/templates/css/homepage/style.css');
@import url('/templates/css/common.css');

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

/* 注册页面容器 */
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 100px);
  padding: 40px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  overflow: hidden;
}

.register-container::before {
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

/* 注册卡片 */
.register-card {
  width: 100%;
  max-width: 600px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
  overflow: hidden;
  position: relative;
  z-index: 2;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* 注册头部 */
.register-header {
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

.register-header h1 {
  margin: 0;
  font-size: 28px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.register-header p {
  margin: 0;
  font-size: 16px;
  opacity: 0.9;
  font-weight: 300;
}

/* 注册表单 */
.register-form {
  padding: 30px 30px;
}

.form-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-section {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.section-title {
  font-size: 18px;
  font-weight: 600;
  color: #333;
  margin: 0 0 10px 0;
  padding-bottom: 8px;
  border-bottom: 2px solid #f0f0f0;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 15px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.form-label {
  font-size: 13px;
  font-weight: 600;
  color: #333;
  margin-bottom: 3px;
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
  padding: 12px 15px 12px 50px;
  border: 2px solid #e1e5e9;
  border-radius: 12px;
  font-size: 15px;
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

.form-input.error {
  border-color: #ff4949;
  background: #fff5f5;
}

/* 错误消息 */
.error-message {
  color: #ff4949;
  font-size: 11px;
  margin-top: 3px;
  display: block;
}

/* 复选框样式 */
.checkbox-group {
  margin-top: 5px;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  font-size: 14px;
  color: #666;
}

.checkbox-input {
  display: none;
}

.checkbox-custom {
  width: 20px;
  height: 20px;
  border: 2px solid #e1e5e9;
  border-radius: 4px;
  position: relative;
  background: white;
  transition: all 0.3s ease;
}

.checkbox-input:checked + .checkbox-custom {
  background: #ff6b6b;
  border-color: #ff6b6b;
}

.checkbox-input:checked + .checkbox-custom::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 12px;
  font-weight: bold;
}

.checkbox-text {
  font-weight: 500;
}

/* 提交按钮 */
.submit-button {
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

.submit-button:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4) !important;
}

.submit-button:active {
  transform: translateY(0) !important;
}

/* 分割线 */
.divider {
  text-align: center;
  margin: 20px 0;
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

/* 登录区域 */
.login-section {
  text-align: center;
  padding: 15px 0;
}

.login-section p {
  margin: 0 0 15px 0;
  color: #666;
  font-size: 14px;
}

.login-link {
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

.login-link:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
  color: white;
  text-decoration: none;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .form-row {
    grid-template-columns: 1fr;
    gap: 15px;
  }
  
  .register-container {
    padding: 20px 15px;
  }
  
  .register-card {
    border-radius: 15px;
  }
  
  .register-header {
    padding: 30px 20px;
  }
  
  .register-form {
    padding: 30px 20px;
  }
  
  .logo-icon {
    font-size: 36px;
  }
  
  .register-header h1 {
    font-size: 24px;
  }
}

/* 错误样式 */
.error {
  border-color: #ff4949 !important;
}

.invalid_box {
  color: #ff4949;
  font-size: 12px;
  margin-top: 5px;
  display: block;
}
</style>