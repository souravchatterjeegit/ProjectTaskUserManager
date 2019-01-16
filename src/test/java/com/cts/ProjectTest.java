package com.cts;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.cts.repository.ProjectRepository;
import com.cts.vo.Project;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring-config-servlet.xml")
@WebAppConfiguration
public class ProjectTest {
	@Autowired
    ProjectRepository projectRepository;
	
	@Test
	public void testGetProjects() throws Exception {
		List<Project> projectList = projectRepository.getProjects();
		Assert.assertNotEquals(null, projectList);
	}
}
