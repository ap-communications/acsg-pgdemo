package app.apcom.acgs.sample.bff.configurations;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {

    @Bean("backendWebClient")
    public WebClient backendClient(BackendConfig backendConfig) {
        return WebClient.create(backendConfig.getDemoHost());
    }
}
