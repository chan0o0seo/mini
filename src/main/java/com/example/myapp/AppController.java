package com.example.myapp;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class AppController {
    @GetMapping("/test1")
    public String test1() {
        return "test1";
    }

    @GetMapping("/test2")
    public String test2() {
        return "test2";
    }
    @GetMapping("/test3")
    public String test3() {
        return "test3";
    }
    @GetMapping("/test4")
    public String test4() {
        return "test3";
    }
    @GetMapping("/fuck")
    public String fuck() {
        return "fuck";
    }
}
