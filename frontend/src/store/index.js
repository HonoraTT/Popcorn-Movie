import { createStore } from 'vuex'
import { login, logout } from '@/api/auth'

export default createStore({
  state: {
    user: null,
    token: localStorage.getItem('token') || null,
    movies: [],
    banners: [],
    tags: []
  },
  mutations: {
    SET_USER(state, user) {
      state.user = user
    },
    SET_TOKEN(state, token) {
      state.token = token
      localStorage.setItem('token', token)
    },
    CLEAR_USER(state) {
      state.user = null
      state.token = null
      localStorage.removeItem('token')
    },
    SET_MOVIES(state, movies) {
      state.movies = movies
    },
    SET_BANNERS(state, banners) {
      state.banners = banners
    },
    SET_TAGS(state, tags) {
      state.tags = tags
    }
  },
  actions: {
    // 登录
    async login({ commit }, loginData) {
      try {
        const response = await login(loginData)
        if (response.success) {
          commit('SET_USER', response.user)
          commit('SET_TOKEN', response.token || 'mock-token')
        }
        return response
      } catch (error) {
        throw error
      }
    },
    
    // 退出
    async logout({ commit }) {
      try {
        await logout()
        commit('CLEAR_USER')
      } catch (error) {
        console.error('退出失败:', error)
        commit('CLEAR_USER')
      }
    },

    // 设置电影数据
    setMovies({ commit }, movies) {
      commit('SET_MOVIES', movies)
    },

    // 设置横幅数据
    setBanners({ commit }, banners) {
      commit('SET_BANNERS', banners)
    },

    // 设置标签数据
    setTags({ commit }, tags) {
      commit('SET_TAGS', tags)
    }
  },
  getters: {
    isLoggedIn: state => !!state.token,
    currentUser: state => state.user,
    movies: state => state.movies,
    banners: state => state.banners,
    tags: state => state.tags
  }
}) 