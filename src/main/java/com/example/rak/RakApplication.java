package com.example.rak;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class RakApplication {

    public static void main(String[] args) {
        SpringApplication.run(RakApplication.class, args);
    }

}

@RestController
@RequestMapping("/api")
class MyController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, Spring Boot!";
    }
}

/* package com.example.rak;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class RakApplication {

	public static void main(String[] args) {
		SpringApplication.run(RakApplication.class, args);
	}

}
*/
