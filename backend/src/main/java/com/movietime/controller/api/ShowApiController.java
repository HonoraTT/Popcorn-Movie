package com.movietime.controller.api;

import com.movietime.entity.Show;
import com.movietime.service.ShowService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shows")
@CrossOrigin(origins = "*")
public class ShowApiController {
    
    @Autowired
    private ShowService showService;
    
    @GetMapping("/movie/{movieId}")
    public ResponseEntity<List<Show>> getShowsByMovie(@PathVariable Long movieId) {
        List<Show> shows = showService.findByMovie(movieId);
        return ResponseEntity.ok(shows);
    }
    
    @GetMapping("/{showId}")
    public ResponseEntity<?> getShowById(@PathVariable Long showId) {
        Show show = showService.findOne(showId);
        if (show != null) {
            return ResponseEntity.ok(show);
        }
        return ResponseEntity.notFound().build();
    }
} 