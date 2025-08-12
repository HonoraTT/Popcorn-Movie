package com.movietime;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@MapperScan("com.movietime.dao")
@EnableCaching
public class MovieTimeApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(MovieTimeApplication.class, args);
        System.out.println("🎬 MovieTime 电影购票系统启动成功！");
        System.out.println("🌐 访问地址: http://localhost:8080");
        System.out.println("📱 API文档: http://localhost:8080/api/movies");
    }
} 