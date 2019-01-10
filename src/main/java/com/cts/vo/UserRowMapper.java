package com.cts.vo;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

public class UserRowMapper implements RowMapper<User>{
	public User mapRow(ResultSet rs,int index) throws SQLException{
		long userId = rs.getLong("user_id");
		String firstName = rs.getString("first_name");
		String lastName = rs.getString("last_name");
		long empId = rs.getLong("employee_id");
		
		User user = new User(userId, firstName, lastName, empId);
		return user;
	}
	
}
