package app.apcom.acgs.sample.bff.greetings.services;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import app.apcom.acgs.sample.bff.configurations.BackendConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Service
@Slf4j
@RequiredArgsConstructor
public class DemoService {
    private final BackendConfig backendConfig;
    private final @Qualifier("backendWebClient") WebClient demoClient;

    public Mono<Object> greeting() {
        log.info("get greeting");
        return demoClient.get().uri(String.format("%s/%s", backendConfig.getDemoBasePath(), "greetings"))
            .accept(MediaType.APPLICATION_JSON)
            .retrieve()
            .bodyToMono(Object.class);
    }

    public Mono<Object> tasks() {
        log.info("get tasks");
        return demoClient.get().uri(String.format("%s/%s", backendConfig.getDemoBasePath(), "tasks"))
            .accept(MediaType.APPLICATION_JSON)
            .retrieve()
            .bodyToMono(Object.class);
    }
}
