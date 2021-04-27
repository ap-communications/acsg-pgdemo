package app.apcom.acgs.sample.pgdemo.greetings.models;

import java.util.List;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class TaskListResponse {
    private List<TaskListItem> items;
    private String message;
    private String hostname;
    private boolean hasCache;
}
