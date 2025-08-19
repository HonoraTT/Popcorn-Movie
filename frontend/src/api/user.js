import request from '@/utils/request'

// 获取用户订单
export function getUserOrders(userId) {
  return request({
    url: `/api/user/${userId}/orders`,
    method: 'get'
  })
}

// 获取用户想看片单
export function getUserWishlist(userId) {
  return request({
    url: `/api/user/${userId}/wishlist`,
    method: 'get'
  })
}

// 添加电影到想看片单
export function addToWishlist(userId, movieId) {
  return request({
    url: `/api/user/${userId}/wishlist`,
    method: 'post',
    data: { movieId }
  })
}

// 从想看片单移除电影
export function removeFromWishlist(userId, movieId) {
  return request({
    url: `/api/user/${userId}/wishlist/${movieId}`,
    method: 'delete'
  })
}

// 获取用户统计信息
export function getUserStats(userId) {
  return request({
    url: `/api/user/${userId}/stats`,
    method: 'get'
  })
}
