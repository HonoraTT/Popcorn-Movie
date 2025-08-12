import request from '@/utils/request'

// 用户登录
export function login(data) {
  return request({
    url: '/api/login',
    method: 'post',
    data
  })
}

// 用户注册
export function register(data) {
  return request({
    url: '/api/register',
    method: 'post',
    data
  })
}

// 用户退出
export function logout() {
  return request({
    url: '/api/logout',
    method: 'post'
  })
}

// 获取当前用户信息
export function getCurrentUser() {
  return request({
    url: '/api/user/current',
    method: 'get'
  })
} 