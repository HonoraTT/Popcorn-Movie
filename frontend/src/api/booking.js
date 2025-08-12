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