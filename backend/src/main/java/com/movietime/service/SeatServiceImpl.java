package com.movietime.service;

import com.movietime.dao.SeatDao;
import com.movietime.dao.ShowDao;
import com.movietime.entity.Seat;
import com.movietime.entity.Show;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedList;
import java.util.List;

@Service
public class SeatServiceImpl implements SeatService {
    @Autowired
    SeatDao seatDao;
    @Autowired
    ShowDao showDao;

    public String[] getSeatMap(long id) {
        Show show = showDao.findOne(id);
        return show.getSeatMap().split("\\|");
    }

    public String[] getSoldSeat(long id) {
        List<Seat> seatList = seatDao.findAllBooked(id);
        List<String> soldSeatList_str = new LinkedList<String>();
        for (Seat seat : seatList) {
            // findAllBooked已经只查询了status = 'booked'的座位，所以都是已售的
            if (seat != null && seat.getRow() > 0 && seat.getCol() > 0) {
                soldSeatList_str.add(seat.getRow() + "_" + seat.getCol());
            }
        }
        return soldSeatList_str.toArray(new String[0]); // 返回空数组而不是包含null的数组
    }

    @Transactional
    public boolean book(List<Seat> seatList) {
        System.out.println("=== 开始座位预订验证 ===");
        System.out.println("要预订的座位数量: " + seatList.size());
        
        for (Seat seat : seatList) {
            System.out.println("检查座位: ShowID=" + seat.getShowId() + ", Row=" + seat.getRow() + ", Col=" + seat.getCol());
            
            Boolean isOccupied = seatDao.occupied(seat);
            System.out.println("座位占用状态查询结果: " + isOccupied);
            
            // 如果座位不存在或已被预订，返回false
            if (isOccupied == null) {
                // 座位不存在，返回false
                System.out.println("座位不存在，返回false");
                return false;
            }
            if (isOccupied) {
                // 座位已被预订，返回false
                System.out.println("座位已被预订，返回false");
                return false;
            }
            System.out.println("座位可用，继续检查下一个座位");
        }
        
        System.out.println("所有座位都可用，开始更新座位状态");
        for (Seat seat : seatList) {
            System.out.println("更新座位: ShowID=" + seat.getShowId() + ", Row=" + seat.getRow() + ", Col=" + seat.getCol() + ", isBooked=" + seat.isBooked());
            seatDao.update(seat);
        }
        System.out.println("=== 座位预订完成 ===");
        return true;
    }
}
