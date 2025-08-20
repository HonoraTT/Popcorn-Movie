package com.movietime.dao;

import com.movietime.entity.UserOrder;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserOrderDao {
    
    /**
     * 根据用户ID获取用户订单列表
     * @param userId 用户ID
     * @return 订单列表
     */
    List<UserOrder> getUserOrders(@Param("userId") Long userId);
    
    /**
     * 根据用户ID获取最近的订单（限制数量）
     * @param userId 用户ID
     * @param limit 限制数量
     * @return 订单列表
     */
    List<UserOrder> getRecentOrders(@Param("userId") Long userId, @Param("limit") Integer limit);
    
    /**
     * 创建新订单
     * @param order 订单信息
     * @return 影响行数
     */
    int createOrder(UserOrder order);
    
    /**
     * 更新订单状态
     * @param orderId 订单ID
     * @param status 新状态
     * @return 影响行数
     */
    int updateOrderStatus(@Param("orderId") Long orderId, @Param("status") String status);
    
    /**
     * 根据订单ID获取订单详情
     * @param orderId 订单ID
     * @return 订单信息
     */
    UserOrder getOrderById(@Param("orderId") Long orderId);
    
    /**
     * 根据用户ID统计订单数量
     * @param userId 用户ID
     * @return 订单数量
     */
    int countUserOrders(@Param("userId") Long userId);
    
    /**
     * 删除订单
     * @param orderId 订单ID
     * @return 影响行数
     */
    int deleteOrder(@Param("orderId") Long orderId);
}

