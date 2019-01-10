package com.cts.controllers;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import com.cts.repository.ProjectRepository;
import com.cts.vo.Project;

@Controller
public class ProjectController {
	@Autowired
	ProjectRepository prepo;
	
	List<Project> projects = new ArrayList<Project>();
	
	@RequestMapping(method = RequestMethod.GET, path = "/getProjects", produces = "application/json")
	@ResponseBody
	public ResponseEntity<List<Project>> getProjects(ModelAndView model)
			throws Exception {
		projects = new ArrayList<Project>();
		projects = prepo.getProjects();
		return new ResponseEntity<List<Project>>(projects, HttpStatus.OK);
	}
	
	@RequestMapping(method = RequestMethod.POST, path = "/addUpdateProject", consumes = "application/json", produces = "application/json")
	@ResponseStatus(HttpStatus.CREATED)
	@ResponseBody
	public ResponseEntity<List<Project>> addUpdateProject(@RequestBody Project project) 
			throws Exception{
		if(project.getProjectId() == 0){
			prepo.addProject(project);
		}else{
			prepo.updateProject(project);
		}
		projects = prepo.getProjects();
		return new ResponseEntity<List<Project>>(projects, HttpStatus.OK); 
	}
	
	@RequestMapping(method = RequestMethod.POST, path = "/suspendProject", consumes = "application/json", produces = "application/json")
	@ResponseBody
	public ResponseEntity<List<Project>> suspendProject(@RequestBody Project project) 
			throws Exception{
		prepo.suspendProject(project);
		projects = prepo.getProjects();
		return new ResponseEntity<List<Project>>(projects, HttpStatus.OK); 
	}
}
