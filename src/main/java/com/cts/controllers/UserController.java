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

import com.cts.repository.UserRepository;
import com.cts.vo.User;

@Controller
public class UserController {
	@Autowired
	UserRepository urepo;
	
	List<User> users = new ArrayList<User>();
	
	@RequestMapping(method = RequestMethod.GET, path = "/getUsers", produces = "application/json")
	@ResponseBody
	public ResponseEntity<List<User>> getUsers(ModelAndView model)
			throws Exception {
		users = new ArrayList<User>();
		users = urepo.getUsers();
		return new ResponseEntity<List<User>>(users, HttpStatus.OK);
	}
	
	@RequestMapping(method = RequestMethod.POST, path = "/addUpdateUser", consumes = "application/json", produces = "application/json")
	@ResponseStatus(HttpStatus.CREATED)
	@ResponseBody
	public ResponseEntity<List<User>> addUpdateUser(@RequestBody User user) 
			throws Exception{
		if(user.getUserId() == 0){
			urepo.addUser(user);
		}else{
			urepo.updateUser(user);
		}
		users = urepo.getUsers();
		return new ResponseEntity<List<User>>(users, HttpStatus.OK); 
	}
	
	@RequestMapping(method = RequestMethod.POST, path = "/deleteUser", consumes = "application/json", produces = "application/json")
	@ResponseBody
	public ResponseEntity<List<User>> deleteUser(@RequestBody User user) 
			throws Exception{
		urepo.deleteUser(user);
		users = urepo.getUsers();
		return new ResponseEntity<List<User>>(users, HttpStatus.OK); 
	}
}
