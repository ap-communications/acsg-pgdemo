package app.apcom.acgs.sample.pgdemo.greetings.repository;

import org.springframework.data.repository.CrudRepository;

import app.apcom.acgs.sample.pgdemo.greetings.dao.TaskDao;

public interface TaskRepository  extends CrudRepository<TaskDao, Long> {
}
