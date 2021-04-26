package app.apcom.acgs.sample.bff.configurations;

import javax.validation.constraints.NotEmpty;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
@ConfigurationProperties(prefix = "backend")
public class BackendConfig {
    @NotEmpty
    private String demoHost;
    @NotEmpty
    private String demoBasePath;
}
