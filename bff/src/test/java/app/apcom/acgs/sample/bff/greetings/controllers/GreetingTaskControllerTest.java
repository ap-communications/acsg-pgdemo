package app.apcom.acgs.sample.bff.greetings.controllers;

import java.util.Arrays;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpStatus;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.reactive.server.WebTestClient;
import org.springframework.web.reactive.function.client.ClientResponse;

import app.apcom.acgs.sample.bff.greetings.models.GreetingResponse;
import app.apcom.acgs.sample.bff.greetings.models.TaskListItem;
import app.apcom.acgs.sample.bff.greetings.models.TaskListResponse;
import app.apcom.acgs.sample.bff.greetings.services.DemoService;
import reactor.core.publisher.Mono;

@ExtendWith(SpringExtension.class)
@WebFluxTest(controllers = GreetingTaskController.class)
@Import(DemoService.class)
public class GreetingTaskControllerTest {
    public static final String GREETING_MESSAGE = "Test Message";
    public static final String GREETING_HOSTNAME = "test.example.com";
    public static final String TASK_MESSAGE = "Task";
    public static final String TASK_HOSTNAME = "task.example.com";
    public static final String TASK_ITEM_NAME = "item";

    @MockBean
    DemoService demoService;

    @Autowired
    private WebTestClient webClient;

    @Nested
    @WebFluxTest
    class GetGreetingAndTasks {
        private GreetingResponse greeting = GreetingResponse.builder().message(GREETING_MESSAGE).hostname(GREETING_HOSTNAME).hasCache(true).build();
        private TaskListItem taskItem = TaskListItem.builder().name(TASK_ITEM_NAME).createdAt(100).updatedAt(1000).build();
        private TaskListResponse task = TaskListResponse.builder().items(Arrays.asList(taskItem)).message(TASK_MESSAGE).hostname(TASK_HOSTNAME).hasCache(true).build();

        @Test
        void succeeded() {
            Mockito.when(demoService.greeting()).thenReturn(Mono.just(greeting));
            Mockito.when(demoService.tasks()).thenReturn(Mono.just(task));
    
            webClient.get()
                .uri("/greeting-tasks")
                .exchange()
                .expectStatus().isOk()
                .expectHeader().contentTypeCompatibleWith("application/json")
                .expectBody()
                .jsonPath("$.greeting.message").isEqualTo(GREETING_MESSAGE)
                .jsonPath("$.tasks.message").isEqualTo(TASK_MESSAGE)
                .jsonPath("$.tasks.items[0].name").isEqualTo(TASK_ITEM_NAME)
                .jsonPath("$.tasks.items[0].updatedAt").isEqualTo(1000);
        }
    
        @Test
        void errorOnGreeting() {
            var resp = ClientResponse.create(HttpStatus.BAD_GATEWAY).build().createException().flatMap(ex -> Mono.error(ex));
            Mockito.when(demoService.greeting()).thenReturn(resp);
            Mockito.when(demoService.tasks()).thenReturn(Mono.just(task));
    
            webClient.get()
                .uri("/greeting-tasks")
                .exchange()
                .expectStatus().is5xxServerError()
                .expectHeader().contentTypeCompatibleWith("application/json");
        }

        @Test
        void errorOnTasks() {
            var resp = ClientResponse.create(HttpStatus.BAD_GATEWAY).build().createException().flatMap(ex -> Mono.error(ex));
            Mockito.when(demoService.greeting()).thenReturn(Mono.just(greeting));
            Mockito.when(demoService.tasks()).thenReturn(resp);
    
            webClient.get()
                .uri("/greeting-tasks")
                .exchange()
                .expectStatus().is5xxServerError()
                .expectHeader().contentTypeCompatibleWith("application/json");
        }
    }

}
