package com.cts.repository;

import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.cts.vo.Project;
import com.cts.vo.Task;
import com.cts.vo.TaskRowMapper;

@Repository
public class TaskRepository {
	private DataSource dataSource;
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dSource){
		this.dataSource = dSource;
		this.jdbcTemplate = new JdbcTemplate(dSource);
	}
	
	public List<Task> getTasks(){
		String SQL = "select * from ProjectTask t left join ProjectParentTask pt on t.parent_id = pt.parent_id";
		TaskRowMapper taskMapper = new TaskRowMapper();
		List<Task> projectList = (List<Task>)jdbcTemplate.query(SQL, taskMapper);
		return projectList;
	}
	
	public void addTask(Task task){
		String SQL = "insert into ProjectTask(parent_id,project_id,task_name,start_date,end_date,priority,task_ended,employee_id) values(?,?,?,?,?,?,?,?)";
		jdbcTemplate.update(SQL, task.getParentId(), task.getProjectId(), task.getTaskName(), task.getStartDate(), task.getEndDate(), task.getPriority(), task.isTaskended(), task.getEmpId());
		String SQL2 = "insert into ProjectParentTask(parent_task) values(?)";
		jdbcTemplate.update(SQL2,task.getTaskName());
	}
	
	public void updateTask(Task task){
		String SQL = "update ProjectTask set parent_id=?,project_id=?,task_name=?,start_date=?,end_date=?,priority=?,task_ended=?,employee_id=? where task_id=?";
		jdbcTemplate.update(SQL, task.getParentId(), task.getProjectId(), task.getTaskName(), task.getStartDate(), task.getEndDate(), task.getPriority(), task.isTaskended(), task.getEmpId(), task.getTaskId());
	}
	
	public void endTask(Task task){
		Date today = new Date();
		String SQL = "update ProjectTask set end_date=?, task_ended=true where task_id=?";
		jdbcTemplate.update(SQL, today, task.getTaskId());
	}
}
