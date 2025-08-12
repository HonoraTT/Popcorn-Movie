import { createRouter, createWebHistory } from 'vue-router'
import { useStore } from 'vuex'
import Home from '@/views/Home.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue')
  },
  {
    path: '/movie/:id',
    name: 'MovieDetail',
    component: () => import('@/views/MovieDetail.vue')
  },
  {
    path: '/select-show/:movieId',
    name: 'SelectShow',
    component: () => import('@/views/SelectShow.vue')
  },
  {
    path: '/select-seat/:showId',
    name: 'SelectSeat',
    component: () => import('@/views/SelectSeat.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/payment',
    name: 'Payment',
    component: () => import('@/views/Payment.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const store = useStore()
  
  // 检查是否需要登录
  if (to.meta.requiresAuth) {
    const isLoggedIn = store.getters.isLoggedIn
    if (!isLoggedIn) {
      next('/login')
      return
    }
  }
  
  next()
})

export default router
