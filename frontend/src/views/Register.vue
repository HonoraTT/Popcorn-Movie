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
            <li>
              <img v-if="currentUser" :src="currentUser.iconPath || '/templates/images/user_icon/p1.png'" alt="icon" class="user-avatar"/>
            </li>
            <li>
              <p class="user-info">
                <a v-if="currentUser" href="/">{{ currentUser.username }}</a>
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
        <div class="register">
          <form @submit.prevent="submitForm">
            <div class="register-top-grid">
              <h3>个人信息</h3>
              <div>
                <span>名字<label>*</label></span>
                <input 
                  v-model="form.firstName" 
                  name="firstName" 
                  type="text"
                  @blur="checkFirstName"
                  :class="{ 'error': errors.firstName }"
                />
                <span class="invalid_box" :style="{ visibility: errors.firstName ? 'visible' : 'hidden' }">
                  无效的名字
                </span>
              </div>
              <div>
                <span>姓氏<label>*</label></span>
                <input 
                  v-model="form.lastName" 
                  name="lastName" 
                  type="text"
                  @blur="checkLastName"
                  :class="{ 'error': errors.lastName }"
                />
                <span class="invalid_box" :style="{ visibility: errors.lastName ? 'visible' : 'hidden' }">
                  无效的姓氏
                </span>
              </div>
              <div>
                <span>邮箱地址<label>*</label></span>
                <input 
                  v-model="form.email" 
                  name="email" 
                  type="text"
                  @blur="checkEmail"
                  :class="{ 'error': errors.email }"
                />
                <span class="invalid_box" :style="{ visibility: errors.email ? 'visible' : 'hidden' }">
                  无效的邮箱
                </span>
              </div>
              <div class="clearfix"> </div>
              <a class="news-letter" href="#">
                <label class="checkbox">
                  <input type="checkbox" v-model="form.newsletter" />
                  <i> </i>订阅新闻通讯
                </label>
              </a>
            </div>
            <div class="register-bottom-grid">
              <h3>登录信息</h3>
              <div>
                <span>密码<label>*</label></span>
                <input 
                  v-model="form.password" 
                  name="password" 
                  type="password"
                  @blur="checkPassword"
                  :class="{ 'error': errors.password }"
                />
                <span class="invalid_box" :style="{ visibility: errors.password ? 'visible' : 'hidden' }">
                  密码至少需要6个字符
                </span>
              </div>
              <div>
                <span>确认密码<label>*</label></span>
                <input 
                  v-model="form.confirmPassword" 
                  name="confirmPassword" 
                  type="password"
                  @blur="checkConfirmPassword"
                  :class="{ 'error': errors.confirmPassword }"
                />
                <span class="invalid_box" :style="{ visibility: errors.confirmPassword ? 'visible' : 'hidden' }">
                  密码不匹配
                </span>
              </div>
              <div class="clearfix"> </div>
            </div>
            <div class="clearfix"> </div>
            <div class="register-but">
              <input type="submit" value="提交" :disabled="loading" />
              <div class="clearfix"> </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { reactive, ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { register } from '@/api/auth'

export default {
  name: 'Register',
  setup() {
    const router = useRouter()
    const loading = ref(false)
    
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
      errors.password = form.password !== '' && form.password.length < 6
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
      checkConfirmPassword
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