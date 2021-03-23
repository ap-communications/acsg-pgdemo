package app.apcom.acgs.sample.pgdemo.greetings.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import app.apcom.acgs.sample.pgdemo.greetings.models.GreetingResponse;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
@RequestMapping("/greetings")
public class GreetingController {
    @RequestMapping()
    public GreetingResponse get() {
        return GreetingResponse.builder().message("Haho").build();
    }
}