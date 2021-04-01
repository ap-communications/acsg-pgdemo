package app.apcom.acgs.sample.pgdemo.greetings.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import app.apcom.acgs.sample.pgdemo.greetings.models.GreetingResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/greetings")
public class GreetingController {
    @RequestMapping()
    public GreetingResponse get() {
        log.error("error logging", new Exception("this is sample expeption"));
        log.warn("warn logging");
        log.info("info logging");
        log.debug("debug logging");
        return GreetingResponse.builder().message("Haho").build();
    }
}