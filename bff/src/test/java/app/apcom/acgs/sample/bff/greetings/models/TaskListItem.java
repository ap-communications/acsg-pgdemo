package app.apcom.acgs.sample.bff.greetings.models;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class TaskListItem {
    private String name;
    private long createdAt;
    private long updatedAt;
}
