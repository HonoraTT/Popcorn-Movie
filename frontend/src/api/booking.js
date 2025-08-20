import request from '@/utils/request'

// 获取电影的场次
export function getShowsByMovie(movieId) {
  return request({
    url: `/api/shows/movie/${movieId}`,
    method: 'get'
  })
}

// 获取场次详情
export function getShowById(showId) {
  return request({
    url: `/api/shows/${showId}`,
    method: 'get'
  })
}

// 获取座位图
export function getSeatMap(showId) {
  return request({
    url: `/api/seats/show/${showId}`,
    method: 'get'
  })
}

// 预订座位
export function bookSeats(data) {
  return request({
    url: '/api/seats/book',
    method: 'post',
    data
  })
}

// 获取用户订单
export const getUserOrders = (userId) => {
  return request({
    url: `/api/users/${userId}/orders`,
    method: 'get'
  })
}

// 根据订单ID获取订单详情
export const getOrderById = (orderId) => {
  return request({
    url: `/api/user/orders/${orderId}`,
    method: 'get'
  })
}

// 取消订单
export const cancelOrder = (orderId) => {
  return request({
    url: `/api/user/orders/${orderId}/cancel`,
    method: 'post'
  })
}

// 删除已取消的订单
export const deleteCancelledOrder = (orderId) => {
  return request({
    url: `/api/user/orders/${orderId}/delete`,
    method: 'delete'
  })
} 