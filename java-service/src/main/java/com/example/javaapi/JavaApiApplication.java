package com.example.javaapi;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Duration;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@SpringBootApplication
@RestController
public class JavaApiApplication {

    private final JdbcTemplate jdbc;
    private final StringRedisTemplate redis;
    private final ObjectMapper mapper;
    private final long cacheTtlSeconds;

    public JavaApiApplication(
            JdbcTemplate jdbc,
            StringRedisTemplate redis,
            ObjectMapper mapper,
            @Value("${app.cache.ttl-seconds:30}") long cacheTtlSeconds) {
        this.jdbc = jdbc;
        this.redis = redis;
        this.mapper = mapper;
        this.cacheTtlSeconds = cacheTtlSeconds;
    }

    public static void main(String[] args) {
        SpringApplication.run(JavaApiApplication.class, args);
    }

    @GetMapping("/healthz")
    public Map healthz() {
        return Map.of("status", "alive");
    }

    @GetMapping("/readyz")
    public ResponseEntity readyz() {
        try {
            String pong = redis.getConnectionFactory().getConnection().ping();
            Integer dbCheck = jdbc.queryForObject("SELECT 1", Integer.class);
            if (!"PONG".equalsIgnoreCase(pong) || dbCheck == null || dbCheck != 1) {
                return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                        .body(Map.of("status", "not ready"));
            }
            return ResponseEntity.ok(Map.of("status", "ready"));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                    .body(Map.of("status", "not ready", "error", ex.getMessage()));
        }
    }

    @GetMapping("/items")
    public ResponseEntity listItems() throws Exception {
        String cacheKey = "java:items:all";
        HttpHeaders headers = new HttpHeaders();

        try {
            String cached = redis.opsForValue().get(cacheKey);
            if (cached != null) {
                List items = Arrays.asList(mapper.readValue(cached, Map[].class));
                headers.add("X-Cache", "HIT");
                return new ResponseEntity(items, headers, HttpStatus.OK);
            }
        } catch (Exception ignored) {
        }

        List rows = jdbc.queryForList("SELECT id, name FROM items ORDER BY id");

        try {
            redis.opsForValue().set(cacheKey, mapper.writeValueAsString(rows), Duration.ofSeconds(cacheTtlSeconds));
        } catch (Exception ignored) {
        }

        headers.add("X-Cache", "MISS");
        return new ResponseEntity(rows, headers, HttpStatus.OK);
    }
}
