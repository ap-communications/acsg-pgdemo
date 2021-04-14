package app.apcom.acgs.sample.pgdemo.greetings.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import app.apcom.acgs.sample.pgdemo.greetings.models.GreetingResponse;
import app.apcom.acgs.sample.pgdemo.greetings.repository.TaskRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/tasks")
public class TaskController {
    private final TaskRepository taskRepository;
    
    @RequestMapping()
    public GreetingResponse get() {
        log.debug("debug logging");
        var itr = taskRepository.findAll();
        return GreetingResponse.builder().message("Haho").build();
    }
}
