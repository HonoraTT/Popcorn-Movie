package com.movietime.service;

import com.movietime.dao.UserOrderDao;
import com.movietime.entity.UserOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserOrderServiceImpl implements UserOrderService {
    
    @Autowired
    private UserOrderDao userOrderDao;
    
    @Override
    public List<UserOrder> getUserOrders(Long userId) {
        return userOrderDao.getUserOrders(userId);
    }
    
    @Override
    public List<UserOrder> getRecentOrders(Long userId, Integer limit) {
        return userOrderDao.getRecentOrders(userId, limit);
    }
    
    @Override
    public boolean createOrder(UserOrder order) {
        return userOrderDao.createOrder(order) > 0;
    }
    
    @Override
    public boolean updateOrderStatus(Long orderId, String status) {
        return userOrderDao.updateOrderStatus(orderId, status) > 0;
    }
    
    @Override
    public UserOrder getOrderById(Long orderId) {
        return userOrderDao.getOrderById(orderId);
    }
    
    @Override
    public int countUserOrders(Long userId) {
        return userOrderDao.countUserOrders(userId);
    }
    
    @Override
    public boolean deleteOrder(Long orderId) {
        return userOrderDao.deleteOrder(orderId) > 0;
    }
}

