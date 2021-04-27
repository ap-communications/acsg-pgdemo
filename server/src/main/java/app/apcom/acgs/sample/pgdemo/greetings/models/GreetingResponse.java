package app.apcom.acgs.sample.pgdemo.greetings.models;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class GreetingResponse {
    private String message;
    private String hostname;
    private boolean hasCache;
}
