package app.apcom.acgs.sample.pgdemo.greetings.controllers;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;

import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import app.apcom.acgs.sample.pgdemo.greetings.configrations.ServerConfig;
import app.apcom.acgs.sample.pgdemo.greetings.dao.TaskDao;
import app.apcom.acgs.sample.pgdemo.greetings.models.TaskListItem;
import app.apcom.acgs.sample.pgdemo.greetings.models.TaskListResponse;
import app.apcom.acgs.sample.pgdemo.greetings.repository.TaskRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/tasks")
public class TaskController {
    private static final String CACHE_KEY = "Tasks";
    private final TaskRepository taskRepository;
    private final ServerConfig serverConfig;
    private final StringRedisTemplate template;
    
    @RequestMapping()
    public TaskListResponse get() {
        log.debug("debug logging");
        ValueOperations<String, String> ops = template.opsForValue();
        var writeCache = ops.setIfAbsent(CACHE_KEY, LocalDateTime.now().toString(), Duration.ofSeconds(10));
        var itr = taskRepository.findAll().iterator();
        var list = new ArrayList<TaskListItem>();
        while(itr.hasNext()) {
            list.add(convertFrom(itr.next()));
        }
        return TaskListResponse.builder()
            .items(list)
            .hasCache(!writeCache)
            .message("Task at " + ops.get(CACHE_KEY))
            .hostname(serverConfig.getHostname())
            .build();
    }

    private TaskListItem convertFrom(TaskDao task) {
        return TaskListItem.builder()
            .name(task.getName())
            .createdAt(
                task.getCreatedAt()
                    .atZone(ZoneId.systemDefault()).toEpochSecond())
            .updatedAt(task.getUpdatedAt().atZone(ZoneId.systemDefault()).toEpochSecond())
            .build();
    }
}
