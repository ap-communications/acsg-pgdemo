package app.apcom.acgs.sample.pgdemo.greetings.controllers;

import java.time.Duration;
import java.time.LocalDateTime;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import app.apcom.acgs.sample.pgdemo.greetings.configrations.ServerConfig;
import app.apcom.acgs.sample.pgdemo.greetings.models.GreetingResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/greetings")
@CrossOrigin
public class GreetingController {
    private static final String CACHE_KEY = "Greeting";
    private final ServerConfig serverConfig;
    private final StringRedisTemplate template;
    
    @RequestMapping()
    public GreetingResponse get() {
        ValueOperations<String, String> ops = template.opsForValue();
        var writeCache = ops.setIfAbsent(CACHE_KEY, LocalDateTime.now().toString(), Duration.ofSeconds(30));
        // log.error("error logging", new Exception("this is sample expeption"));
        log.warn("warn logging");
        log.info("info logging");
        log.debug("debug logging");
        return GreetingResponse.builder()
            .message("Hola " + ops.get(CACHE_KEY))
            .hasCache(!writeCache)
            .hostname(serverConfig.getHostname())
            .build();
    }
}