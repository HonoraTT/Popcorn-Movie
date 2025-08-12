package com.movietime.controller.api;

import com.movietime.entity.Tag;
import com.movietime.service.TagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/tags")
@CrossOrigin(origins = "*")
public class TagApiController {
    
    @Autowired
    private TagService tagService;
    
    @GetMapping
    public ResponseEntity<List<Tag>> getAllTags() {
        List<String> tagNames = tagService.findAllName();
        List<Tag> tags = tagNames.stream()
            .map(name -> {
                Tag tag = new Tag();
                tag.setName(name);
                return tag;
            })
            .collect(Collectors.toList());
        return ResponseEntity.ok(tags);
    }
} 