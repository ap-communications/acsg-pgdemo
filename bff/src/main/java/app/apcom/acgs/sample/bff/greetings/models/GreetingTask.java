package app.apcom.acgs.sample.bff.greetings.models;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class GreetingTask {
    private Object greeting;
    private Object taks;
}
