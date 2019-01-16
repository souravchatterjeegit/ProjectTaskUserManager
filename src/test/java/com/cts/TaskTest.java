package com.cts;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.cts.repository.TaskRepository;
import com.cts.vo.Task;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring-config-servlet.xml")
@WebAppConfiguration
public class TaskTest {
	@Autowired
    TaskRepository taskRepository;
	
	@Test
	public void testGetTasks() throws Exception {
		List<Task> taskList = taskRepository.getTasks();
		Assert.assertNotEquals(null, taskList);
	}
}
