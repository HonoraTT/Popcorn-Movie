package com.movietime.service;

import com.movietime.entity.UserOrder;

import java.util.List;

public interface UserOrderService {
    
    /**
     * 根据用户ID获取用户订单列表
     * @param userId 用户ID
     * @return 订单列表
     */
    List<UserOrder> getUserOrders(Long userId);
    
    /**
     * 根据用户ID获取最近的订单
     * @param userId 用户ID
     * @param limit 限制数量
     * @return 订单列表
     */
    List<UserOrder> getRecentOrders(Long userId, Integer limit);
    
    /**
     * 创建新订单
     * @param order 订单信息
     * @return 是否创建成功
     */
    boolean createOrder(UserOrder order);
    
    /**
     * 更新订单状态
     * @param orderId 订单ID
     * @param status 新状态
     * @return 是否更新成功
     */
    boolean updateOrderStatus(Long orderId, String status);
    
    /**
     * 根据订单ID获取订单详情
     * @param orderId 订单ID
     * @return 订单信息
     */
    UserOrder getOrderById(Long orderId);
    
    /**
     * 根据用户ID统计订单数量
     * @param userId 用户ID
     * @return 订单数量
     */
    int countUserOrders(Long userId);
    
    /**
     * 删除订单
     * @param orderId 订单ID
     * @return 是否删除成功
     */
    boolean deleteOrder(Long orderId);
}

