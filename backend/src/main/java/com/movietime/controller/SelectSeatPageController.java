package com.movietime.controller;

import com.movietime.entity.Movie;
import com.movietime.entity.Seat;
import com.movietime.entity.Show;
import com.movietime.entity.User;
import com.movietime.entity.UserOrder;
import com.movietime.service.MovieService;
import com.movietime.service.SeatService;
import com.movietime.service.ShowService;
import com.movietime.service.UserOrderService;
import com.movietime.util.Converter;
import com.movietime.vo.UserVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.LinkedList;
import java.util.List;

@Controller
@RequestMapping(value = "/selectSeat/cinema/{cinema_id}")
public class SelectSeatPageController {
    @Autowired
    MovieService ms;
    @Autowired
    ShowService ss;
    @Autowired
    SeatService ses;
    @Autowired
    UserOrderService userOrderService;

    @RequestMapping(method = RequestMethod.POST)
    @ResponseBody
    public String post_selectSeat(int show_id, String selectedList_JSON, Model model, HttpSession session) {
        System.out.println("POST@'/selectSeat': show_id=" + show_id + ", selectedList_JSON=");
        System.out.println(selectedList_JSON);
        
        // 检查用户登录状态
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "LoginError";
        }
        
        JSONArray jsonArray = JSONArray.fromObject(selectedList_JSON);
        List<Seat> seatList = new LinkedList<Seat>();
        Show show = ss.findOne(show_id);
        Movie movie = ms.findOne(show.getMovieId());
        
        // 构建座位信息字符串
        StringBuilder seatsInfo = new StringBuilder();
        
        for (int i = 0; i < jsonArray.size(); i++) {
            JSONObject jsonObject = JSONObject.fromObject(jsonArray.get(i));
            Seat seat = new Seat();
            seat.setRow((Integer) jsonObject.get("row"));
            seat.setCol((Integer) jsonObject.get("col"));
            seat.setBooked(true);
            seat.setShowId(show.getId());
            seatList.add(seat);
            
            // 添加到座位信息字符串
            if (i > 0) seatsInfo.append(", ");
            seatsInfo.append("第").append(seat.getRow()).append("排").append(seat.getCol()).append("号");
        }
        
        // 预订座位
        boolean bookingSuccess = ses.book(seatList);
        if (!bookingSuccess) {
            return "SeatChosenError";
        }
        
        // 创建用户订单
        try {
            System.out.println("=== 开始创建用户订单 ===");
            System.out.println("用户ID: " + user.getId());
            System.out.println("用户邮箱: " + user.getEmail());
            System.out.println("电影ID: " + movie.getId());
            System.out.println("场次ID: " + show.getId());
            System.out.println("电影名称: " + movie.getName());
            System.out.println("座位数量: " + seatList.size());
            System.out.println("总价格: " + (show.getPrice() * seatList.size()));
            
            UserOrder order = new UserOrder();
            order.setUserId(user.getId());
            order.setMovieId(movie.getId());
            order.setShowId(show.getId()); // 添加showId
            order.setMovieName(movie.getName());
            order.setMoviePoster(movie.getPosterPath());
            order.setCinemaName("PopcornMovie影院"); // 默认影院名称
            order.setShowTime(show.getTime());
            order.setStatus("已预订");
            order.setTotalPrice((double) (show.getPrice() * seatList.size()));
            order.setSeats(seatsInfo.toString());
            order.setOrderTime(LocalDateTime.now());
            
            System.out.println("订单对象创建完成，准备保存到数据库...");
            System.out.println("订单详情: " + order.getMovieName() + " - " + order.getTotalPrice() + "元");
            boolean result = userOrderService.createOrder(order);
            System.out.println("用户订单创建结果: " + result);
            if (result) {
                System.out.println("用户订单创建成功，订单ID: " + order.getId());
                System.out.println("=== 订单创建完成 ===");
            } else {
                System.out.println("用户订单创建失败！");
                System.out.println("=== 订单创建失败 ===");
            }
            
        } catch (Exception e) {
            System.err.println("创建用户订单失败: " + e.getMessage());
            e.printStackTrace();
            // 即使订单创建失败，座位预订仍然有效
        }
        
        return "succeed";
    }

    @RequestMapping(method = RequestMethod.GET)
    public String get_selectSeat(@PathVariable("cinema_id") int theater_id,
                                 @RequestParam("movie_id") int movie_id,
                                 @RequestParam("show_id") int show_id,
                                 Model model,
                                 HttpSession session) {
        System.out.println("GET@'/selectSeat': theater_id='" + theater_id + "', show_id='" + show_id + "'");

        Movie movie = ms.findOne(movie_id);
        Show show = ss.findOne(show_id);
        // 检查参数正确性
        if (movie == null || show == null)
            return "redirect:/";

        // 登录状态
        User user = (User) session.getAttribute("user");
        if (user != null) {
            UserVO userVO = (UserVO) Converter.convert(user);
            model.addAttribute("username", userVO.getUsername());
            model.addAttribute("usericon_path", userVO.getIconPath());
        }

        // 电影&场次信息
        model.addAttribute("movie_name", movie.getName());
        model.addAttribute("show_time", show.getTime());
        model.addAttribute("show_id", show.getId());
        model.addAttribute("price", show.getPrice());
        model.addAttribute("seatMap", ses.getSeatMap(show.getId()));
        model.addAttribute("soldSeat", ses.getSoldSeat(show.getId()));

        return "selectSeat";
    }
}
