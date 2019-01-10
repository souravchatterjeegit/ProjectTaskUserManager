package com.cts.vo;

import java.util.Date;

public class Task {
	private String taskName;
	private long taskId;
	private long parentId;
	private long projectId;
	private long empId;
	private Date startDate;
	private Date endDate;
	private int priority;
	private String parentTask;
	private boolean taskended;
	public String getTaskName() {
		return taskName;
	}
	public void setTaskName(String task) {
		this.taskName = task;
	}
	public long getTaskId() {
		return taskId;
	}
	public void setTaskId(long taskId) {
		this.taskId = taskId;
	}
	public long getParentId() {
		return parentId;
	}
	public void setParentId(long parentId) {
		this.parentId = parentId;
	}
	public long getProjectId() {
		return projectId;
	}
	public void setProjectId(long projectId) {
		this.projectId = projectId;
	}
	public long getEmpId() {
		return empId;
	}
	public void setEmpId(long empId) {
		this.empId = empId;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public String getParentTask() {
		return parentTask;
	}
	public void setParentTask(String parentTask) {
		this.parentTask = parentTask;
	}
	public boolean isTaskended() {
		return taskended;
	}
	public void setTaskended(boolean taskended) {
		this.taskended = taskended;
	}
	public Task(String task, long taskId, long parentId, long projectId,
			long empId, Date startDate, Date endDate, int priority,
			String parentTask, boolean taskended) {
		super();
		this.taskName = task;
		this.taskId = taskId;
		this.parentId = parentId;
		this.projectId = projectId;
		this.empId = empId;
		this.startDate = startDate;
		this.endDate = endDate;
		this.priority = priority;
		this.parentTask = parentTask;
		this.taskended = taskended;
	}
	public Task() {
		super();
	}
	
}
