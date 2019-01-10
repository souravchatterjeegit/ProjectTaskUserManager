package com.cts.repository;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.cts.vo.User;
import com.cts.vo.UserRowMapper;

@Repository
public class UserRepository {
	private DataSource dataSource;
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dSource){
		this.dataSource = dSource;
		this.jdbcTemplate = new JdbcTemplate(dSource);
	}
	
	public List<User> getUsers(){
		String SQL = "select * from ProjectUser" ;	
		UserRowMapper userMapper = new UserRowMapper();
		List<User> userList = (List<User>)jdbcTemplate.query(SQL, userMapper);
		return userList;
	}
	
	public void addUser(User user){
		String SQL = "insert into ProjectUser(first_name,last_name,employee_id) values(?,?,?)";
		jdbcTemplate.update(SQL, user.getFirstName(), user.getLastName(), user.getEmpId());
	}
	
	public void updateUser(User user){
		String SQL = "update ProjectUser set first_name = ?,last_name = ? where user_id=?";
		jdbcTemplate.update(SQL, user.getFirstName(), user.getLastName(), user.getUserId());
	}
	
	public void deleteUser(User user){
		String SQL = "delete from ProjectUser where user_id=?";
		jdbcTemplate.update(SQL, user.getUserId());
		String SQL1 = "update Project set employee_id = 0 where employee_id = ?";
		jdbcTemplate.update(SQL1, user.getEmpId());
		String SQL2 = "update ProjectTask set employee_id = 0 where employee_id = ?";
		jdbcTemplate.update(SQL2, user.getEmpId());
	}
}
