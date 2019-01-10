package com.cts.repository;

import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.cts.vo.Project;
import com.cts.vo.ProjectRowMapper;

@Repository
public class ProjectRepository {
	private DataSource dataSource;
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dSource){
		this.dataSource = dSource;
		this.jdbcTemplate = new JdbcTemplate(dSource);
	}
	
	public List<Project> getProjects(){
		String SQL = "select * from Project" ;
		ProjectRowMapper projRow = new ProjectRowMapper();
		List<Project> projList = (List<Project>)jdbcTemplate.query(SQL,projRow);
		return projList;
	}
	
	public void addProject(Project project){
		String SQL = "insert into Project(project_name, start_date, end_date, priority, project_ended, employee_id) values(?, ?, ?, ?, ?, ?)";
		jdbcTemplate.update(SQL, project.getProjectName(), project.getStartDate(), project.getEndDate(), project.getPriority(), project.isEnded(), project.getEmpId());
	}
	
	public void updateProject(Project project){
		String SQL = "update Project set project_name=?, start_date=?, end_date=?, priority=?, project_ended=?, employee_id =? where project_id=?";
		jdbcTemplate.update(SQL, project.getProjectName(), project.getStartDate(), project.getEndDate(), project.getPriority(), project.isEnded(), project.getEmpId(), project.getProjectId());
	}
	
	public void suspendProject(Project project){
		Date today = new Date();
		String SQL = "update Project set end_date=?, project_ended=true where project_id=?";
		jdbcTemplate.update(SQL, today, project.getProjectId());
		String SQL1 = "update ProjectTask set end_date=?, task_ended=true where project_id=?";
		jdbcTemplate.update(SQL1, today, project.getProjectId());
	}
}
