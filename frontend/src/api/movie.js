import request from '@/utils/request'

// 获取所有电影
export function getMovies() {
  return request({
    url: '/api/movies',
    method: 'get'
  })
}

// 根据ID获取电影
export function getMovieById(id) {
  return request({
    url: `/api/movies/${id}`,
    method: 'get'
  })
}

// 根据标签获取电影
export function getMoviesByTag(tagName) {
  return request({
    url: `/api/movies/tag/${tagName}`,
    method: 'get'
  })
}

// 获取横幅电影
export function getBanners() {
  return request({
    url: '/api/movies/banners',
    method: 'get'
  })
}

// 获取所有标签
export function getTags() {
  return request({
    url: '/api/tags',
    method: 'get'
  })
} 