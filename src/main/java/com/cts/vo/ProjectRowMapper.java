package com.cts.vo;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import org.springframework.jdbc.core.RowMapper;

public class ProjectRowMapper implements RowMapper<Project>{
	public Project mapRow(ResultSet rs,int index) throws SQLException{
		long projectId = rs.getLong("project_id");
		String projectname = rs.getString("project_name");
		Date startDate = rs.getDate("start_date");
		Date endDate = rs.getDate("end_date");
		int priority = rs.getInt("priority");
		boolean ended = rs.getBoolean("project_ended");
		long empId = rs.getLong("employee_id");
		Project project = new Project(projectId, projectname, startDate, endDate, priority, ended, empId);
		return project;
	}
}
