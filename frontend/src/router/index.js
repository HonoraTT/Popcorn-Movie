import { createRouter, createWebHistory } from 'vue-router'
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
    component: () => import('@/views/SelectSeat.vue')
  },
  {
    path: '/payment',
    name: 'Payment',
    component: () => import('@/views/Payment.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
