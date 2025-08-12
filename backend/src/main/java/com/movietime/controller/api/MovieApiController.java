package com.movietime.controller.api;

import com.movietime.entity.Movie;
import com.movietime.service.MovieService;
import com.movietime.vo.BannerVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/movies")
@CrossOrigin(origins = "*")
public class MovieApiController {
    
    @Autowired
    private MovieService movieService;
    
    @GetMapping
    public ResponseEntity<List<Movie>> getAllMovies() {
        List<Movie> movies = movieService.findAll();
        return ResponseEntity.ok(movies);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<?> getMovieById(@PathVariable Long id) {
        Movie movie = movieService.findOne(id);
        if (movie != null) {
            return ResponseEntity.ok(movie);
        }
        return ResponseEntity.notFound().build();
    }
    
    @GetMapping("/tag/{tagName}")
    public ResponseEntity<List<Movie>> getMoviesByTag(@PathVariable String tagName) {
        List<Movie> movies = movieService.findByTagName(tagName);
        return ResponseEntity.ok(movies);
    }
    
    @GetMapping("/banners")
    public ResponseEntity<List<BannerVO>> getBanners() {
        List<Movie> movies = movieService.findAll();
        List<BannerVO> banners = movies.stream()
            .filter(movie -> movie.getBannerPath() != null)
            .map(movie -> new BannerVO((int) movie.getId(), movie.getName(), movie.getBannerPath()))
            .collect(Collectors.toList());
        return ResponseEntity.ok(banners);
    }
} 