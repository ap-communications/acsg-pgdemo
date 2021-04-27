package app.apcom.acgs.sample.bff.greetings.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import app.apcom.acgs.sample.bff.greetings.models.GreetingTask;
import app.apcom.acgs.sample.bff.greetings.services.DemoService;
import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;

@RestController
@RequiredArgsConstructor
@RequestMapping("/greeting-tasks")
public class GreetingTaskController {
    private final DemoService demoService;
    @RequestMapping()
    public Mono<GreetingTask> get() {
        return Mono.zip(demoService.greeting(), demoService.tasks())
        .map(tuple -> {
             final var greeting = tuple.getT1();
             final var tasks = tuple.getT2();
             return GreetingTask.builder().greeting(greeting).tasks(tasks).build();
        });
    }    
}