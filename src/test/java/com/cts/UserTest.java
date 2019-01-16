package com.cts;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.cts.repository.UserRepository;
import com.cts.vo.User;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring-config-servlet.xml")
@WebAppConfiguration
public class UserTest {
	@Autowired
    UserRepository userRepository;
	
	@Test
	public void testGetUsers() throws Exception {
		List<User> userList = userRepository.getUsers();
		Assert.assertNotEquals(null, userList);
	}
}
