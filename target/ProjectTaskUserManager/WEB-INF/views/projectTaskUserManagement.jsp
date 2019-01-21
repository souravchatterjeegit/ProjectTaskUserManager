<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>

<head>
    <script src = "https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    <script>
        var taskArray = [{ "taskId": 1, "taskName": "parent task", "priority": 2, "startDate": "2019-01-01", "endDate": "2019-12-31", "parentTask": "", "projectId": 1, "empId": "100001", "taskended": false },
        { "taskId": 2, "taskName": "parent task1", "priority": 2, "startDate": "2019-01-03", "endDate": "2019-12-31", "parentTask": "", "projectId": 2, "empId": "100002", "taskended": false }];
        var userArray = [{ "userId": 1, "firstName": "sourav", "lastName": "chatterjee", "empId": 100001, "projectId": 0, "taskId": 0 },
        { "userId": 2, "firstName": "madan", "lastName": "kumar", "empId": 100002, "projectId": 0, "taskId": 0 }];
        var projectArray = [{ "projectId": 1, "projectName": "Mellon", "startDate": '2019-01-01', "endDate": '2019-12-31', "priority": 7, "empId": "100001", "ended": false },
        { "projectId": 2, "projectName": "Liberty", "startDate": '2019-01-03', "endDate": '2019-12-31', "priority": 20, "empId": "100002", "ended": false }]

        function formatDateForOutput(date) {
            var d = new Date(date),
                month = '' + (d.getMonth() + 1),
                day = '' + d.getDate(),
                year = d.getFullYear();
            if (month.length < 2) month = '0' + month;
            if (day.length < 2) day = '0' + day;
            return [year, month, day].join('-');
        }
        var taskApp = angular.module("taskApp", []);
        taskApp.directive("formatDate", function () {
            return {
                require: 'ngModel',
                link: function (scope, elem, attr, modelCtrl) {
                    modelCtrl.$formatters.push(function (modelValue) {
                        return new Date(modelValue);
                    })
                }
            }
        });
        taskApp.controller("taskController", function ($scope, $http) {
            $scope.showViewPage = false;
            $scope.showAddEditPage = false;
            $scope.showUserPage = false;
            $scope.showProjectPage = true;
            $scope.updateAddTest = "Add Task";
            $scope.updateAddUserTest = "Add User";
            $scope.projectForTask = 0;
            $scope.projectForViewTask = "";
            //$scope.users = userArray;
            $scope.taskToBeUpdated = 0;
            $scope.alertmessage = "";
            $scope.priority = 0;
            //$scope.tasks = taskArray;
            $scope.taskName = "";
            $scope.parentTask = "";
            //$scope.projects = projectArray;
            $scope.updateProjectTest = "Add Project";
            $scope.projectStartDate = new Date();
            $scope.projectEndDate = new Date();
            $scope.projectEndDate.setDate($scope.projectStartDate.getDate() + 1);
            $scope.projectManager = 0;
            $scope.userId = 0;
            $scope.startDate = new Date();
            $scope.endDate = new Date();
            $scope.endDate.setDate($scope.startDate.getDate() + 1);
            $scope.populateList = function(){
            	$http.get("/ProjectTaskUserManager/getTasks")
  					.then(function(response) {
      				$scope.tasks = response.data;            
  				});
  				$http.get("/ProjectTaskUserManager/getProjects")
  					.then(function(response) {
      				$scope.projects = response.data;            
  				});
  				$http.get("/ProjectTaskUserManager/getUsers")
  					.then(function(response) {
      				$scope.users = response.data;            
  				});
            }
            $scope.populateList();
            $scope.viewAddEdit = function () {
                $scope.showViewPage = false;
                $scope.showAddEditPage = true;
                $scope.showUserPage = false;
                $scope.showProjectPage = false;
                $scope.resetTaskForm();
            }
            $scope.viewList = function () {
                $scope.showViewPage = true;
                $scope.showAddEditPage = false;
                $scope.showUserPage = false;
                $scope.showProjectPage = false;
            }

            /* view and edit task - BEGIN */
            $scope.parentTaskFilter = function (item) {
                if (item.projectId == $scope.projectForTask)
                    return true;
                else
                    return false;
            }
            $scope.taskFilter = function (item) {
                if(item.projectId == $scope.projectForViewTask)
                    return true;
                else
                    return false;
            }
            $scope.taskSubmitted = function () {
                if($scope.endDate == null || $scope.endDate == undefined)
            		$scope.endDate = '2019-12-31';
                $scope.alertMessageTask = "";
                var startDate = new Date($scope.startDate);
                var endDate = new Date($scope.endDate);
                if ((startDate - endDate) > 0) {
                    $scope.alertMessageTask = "Startdate cannot succeed enddate, task not added/updated";
                }
                else if ($scope.updateAddTest == "Add Task") {
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/addUpdateTask',
                		dataType: "json",//optional
                		data: {"taskName": $scope.taskName, "priority": $scope.priority, "startDate": $scope.startDate, "endDate": $scope.endDate, "parentId": $scope.parentTask, "projectId": $scope.projectForTask, "empId": $scope.taskManager, "taskended": false }
                	}
                	$http(req).then(function(response){
                		var alertString = "Task " + $scope.taskName + " is successfully created ";
                    	$scope.resetTaskForm();
                    	$scope.alertMessageTask = alertString;
                    	$scope.tasks = response.data;
                	}, function(){
                		$scope.alertMessageTask = "task creation error ";
                	});
               } else if ($scope.updateAddTest == "Update Task") {
               		var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/addUpdateTask',
                		dataType: "json",//optional
                		data: {"taskName": $scope.taskName, "taskId": $scope.taskToBeUpdated, "priority": $scope.priority, "startDate": $scope.startDate, "endDate": $scope.endDate, "parentId": $scope.parentTask, "projectId": $scope.projectForTask, "empId": $scope.taskManager, "taskended": false }
                	}
                	$http(req).then(function(response){
                		var alertString = "Task " + $scope.taskName + " is successfully updated ";
                    	$scope.resetTaskForm();
                    	$scope.alertMessageTask = alertString;
                    	$scope.tasks = response.data;
                	}, function(){
                		$scope.alertMessageTask = "task updation error ";
                	});
                }
            }
            $scope.resetTaskForm = function () {
                $scope.alertMessageTask = "";
                $scope.updateAddTest = "Add Task";
                $scope.taskName = "";
                $scope.startDate = new Date();
                $scope.endDate = new Date();
                $scope.endDate.setDate($scope.startDate.getDate() + 1);
                $scope.parentTask = "";
                $scope.projectForTask = 0;
                $scope.taskToBeUpdated = 0;
                $scope.priority = 0;
                $scope.taskManager = "";
                $scope.settingDateNeeded = false;
            }
            $scope.updateTask = function (taskID) {
                $scope.alertMessageTask = "";
                for (var i = 0; i < $scope.tasks.length; i++) {
                    if ($scope.tasks[i]["taskId"] == taskID) {
                        $scope.taskToBeUpdated = taskID;
                        $scope.taskName = $scope.tasks[i]["taskName"];
                        $scope.priority = $scope.tasks[i]["priority"];
                        $scope.startDate = $scope.tasks[i]["startDate"];
                        $scope.endDate = $scope.tasks[i]["endDate"];
                        $scope.parentTask = $scope.tasks[i]["parentId"].toString();
                        $scope.projectForTask = $scope.tasks[i]["projectId"].toString();
                        $scope.taskManager = $scope.tasks[i]["empId"].toString();
                        $scope.updateAddTest = "Update Task";
                        $scope.showViewPage = false;
                        $scope.showAddEditPage = true;
                        $scope.showUserPage = false;
                        $scope.showProjectPage = false;
                        break;
                    }
                }
            };
            $scope.endTask = function (taskID) {
                $scope.alertMessageTask = "";
                $scope.alertMessageTask = "";
                $('#exampleModalHeader').html("End Task");
                $('#exampleModalBody').html("Are you sure you want to end the task?");
                $scope.yesNoModalOperationType = "task_ended";
                $scope.yesNoModalOperationId = taskID;
                $('#exampleModalLong').modal('show');
                
                /*var intention = confirm("Are you sure you want to end the task?");
                if(intention == true){
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/endTask',
                		dataType: "json",
                		data: { "taskId": taskID }
                	}
                	$http(req).then(function(response){
                		$scope.tasks = response.data;
                	}, function(){
                		$scope.alertMessageTask = "task updation error ";
                	});
                }else{
                    ;
                }*/  
            };
            $scope.openProjectPopup = function(pageName){
                $scope.projectPopupOpenedFrom = pageName;
                $('#exampleModalProjectList').modal('show');
            }
            $scope.setProject = function(projectID){
                if($scope.projectPopupOpenedFrom == 'edit_task'){
                    $scope.projectForTask = projectID.toString();
                }else if($scope.projectPopupOpenedFrom == 'view_task'){
                    $scope.projectForViewTask = projectID.toString();
                }
                $('#exampleModalProjectList').modal('hide');
            }
            $scope.clearProjectSelection = function(){
                $scope.projectForTask = 0;
            }
            $scope.clearProjectViewSelection = function(){
                $scope.projectForViewTask = 0;
            }
            $scope.openTaskPopup = function(){
                $('#exampleModalTaskList').modal('show');
            }
            $scope.setParentTask = function(taskID){
                $scope.parentTask = taskID.toString();
                $('#exampleModalTaskList').modal('hide');
            }
            $scope.clearParentTaskSelection = function(){
                $scope.parentTask = 0;
            }
            $scope.taskPropertyName = 'taskName';
            $scope.reverse = true;
            $scope.sortTaskBy = function (propertyName) { 
                $scope.reverse = ($scope.taskPropertyName === propertyName) ? !$scope.reverse : false;
                $scope.taskPropertyName = propertyName;
            }
            /* view and edit task - END */

            /* user operations - BEGIN */
            $scope.showUserPageFunc = function () {
                $scope.showViewPage = false;
                $scope.showAddEditPage = false;
                $scope.showUserPage = true;
                $scope.showProjectPage = false;
                $scope.resetUserForm();
            }
            $scope.userSubmitted = function () {
            	$scope.alertmessageUser = "";
                if ($scope.updateAddUserTest == "Add User") {
                	var userFound = false;
                	for(var i=0; i<$scope.users.length; i++){
                		if ($scope.users[i]["empId"] == $scope.empID) {
                			$scope.alertmessageUser = "The empid '" + $scope.empID + "'is already taken, please choose a different employee id";
                			userFound = true;
                			break;
                		}
                	}
                	if(userFound == false){
	                	var req={
	                		contentType: "application/json; charset=utf-8",//required
	                		method: 'POST',
	                		url: '/ProjectTaskUserManager/addUpdateUser',
	                		dataType: "json",//optional
	                		data: { "userId": 0 ,"firstName": $scope.firstName, "lastName": $scope.lastName, "empId": $scope.empID}
	                	}
	                	$http(req).then(function(response){
	                		var alertString = "User " + $scope.firstName + " " + $scope.lastName + " is successfully created ";
	                    	$scope.resetUserForm();
	                    	$scope.alertmessageUser = alertString;
	                    	$scope.users = response.data;
	                	}, function(){
	                		$scope.alertmessageUser = "task creation error ";
	                	});
	                }
                } else if ($scope.updateAddUserTest == "Update User") { /* need to get userid */
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/addUpdateUser',
                		dataType: "json",//optional
                		data: { "userId": $scope.userId ,"firstName": $scope.firstName, "lastName": $scope.lastName, "empId": $scope.empID}
                	}
                	$http(req).then(function(response){
                		var alertString = "User " + $scope.firstName + " " + $scope.lastName + " is successfully updated ";
                    	$scope.resetUserForm();
                    	$scope.alertmessageUser = alertString;
                    	$scope.users = response.data;
                	}, function(){
                		$scope.alertmessageUser = "task creation error ";
                	});
                }
            }
            $scope.resetUserForm = function () {
                $scope.updateAddUserTest = "Add User";
                $scope.alertmessageUser = "";
                $scope.firstName = "";
                $scope.lastName = "";
                $scope.empID = "";
                $scope.userId = "";
                $scope.UserPropertyName = 'firstName';
                $scope.reverse = true;
            }
            $scope.updateUser = function (userId) {
                $scope.alertmessageUser = "";
                for (var i = 0; i < $scope.users.length; i++) {
                    if ($scope.users[i]["userId"] == userId) {
                        $scope.firstName = $scope.users[i]["firstName"];
                        $scope.lastName = $scope.users[i]["lastName"];
                        $scope.empID = $scope.users[i]["empId"];
                        $scope.userId = $scope.users[i]["userId"];
                        $scope.updateAddUserTest = "Update User";
                        break;
                    }
                }
            }
            $scope.deleteUser = function (userId, empId) {
                $scope.alertmessageUser = "";
                $scope.alertmessageUser = "";
                $('#exampleModalHeader').html("Delete Employee");
                $('#exampleModalBody').html("Are you sure you want to delete the employee " + empId + " ?");
                $scope.yesNoModalOperationType = "delete_employee";
                $scope.yesNoModalOperationId = userId;
                $scope.yesNoModalOperationId2 = empId;
                $('#exampleModalLong').modal('show');
                
                /*var intention = confirm("Are you sure you want to delete the user?");
                if(intention == true){
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/deleteUser',
                		dataType: "json",//optional
                		data: { "userId": userId, "empId": empId }
                	}
                	$http(req).then(function(response){
                		var alertString = "User is successfully deleted ";
                    	$scope.resetUserForm();
                    	$scope.alertmessageUser = alertString;
                    	$scope.users = response.data;
                    	$http.get("/ProjectTaskUserManager/getTasks")
		  					.then(function(response1) {
		      				$scope.tasks = response1.data;            
		  				});
		  				$http.get("/ProjectTaskUserManager/getProjects")
		  					.then(function(response2) {
		      				$scope.projects = response2.data;            
		  				});
                	}, function(){
                		$scope.alertmessageUser = "task creation error ";
                	});
                }else{
                    ;
                }*/  
            }
            $scope.UserPropertyName = 'firstName';
            $scope.reverse = true;
            $scope.sortUserBy = function (propertyName) {
                $scope.reverse = ($scope.UserPropertyName === propertyName) ? !$scope.reverse : false;
                $scope.UserPropertyName = propertyName;
            };
            /* user operations - END */

            /* project operations - BEGIN */
            $scope.showProjectPageFunc = function () {
                $scope.showViewPage = false;
                $scope.showAddEditPage = false;
                $scope.showUserPage = false;
                $scope.showProjectPage = true;
                $scope.resetProjectForm();
            }
            $scope.projectSubmitted = function () { 
            	$scope.alertmessageProject = "";
            	if($scope.projectEndDate == null || $scope.projectEndDate == undefined)
            		$scope.projectEndDate = '2019-12-31';
            	var startDate = new Date($scope.projectStartDate);
                var endDate = new Date($scope.projectEndDate);
                if ((startDate - endDate) > 0) {
                    $scope.alertmessageProject = "Startdate cannot succeed enddate, task not added/updated";
                }
                else if ($scope.updateProjectTest == "Add Project") {
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/addUpdateProject',
                		dataType: "json",//optional
                		data: { "projectName": $scope.projectName, "startDate": $scope.projectStartDate, "endDate": $scope.projectEndDate, "priority": $scope.projectPriority, "empId": $scope.projectManager, "ended": false }
                	}
                	$http(req).then(function(response){
                		var alertString = "Project " + $scope.projectName + " is successfully created ";
                    	$scope.resetProjectForm();
                    	$scope.alertmessageProject = alertString;
                    	$scope.projects = response.data;
                	}, function(){
                		$scope.alertmessageProject = "task creation error ";
                	});
                } else if ($scope.updateProjectTest == "Update Project") {
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/addUpdateProject',
                		dataType: "json",//optional
                		data: { "projectId": $scope.projectToBeUpdated ,"projectName": $scope.projectName, "startDate": $scope.projectStartDate, "endDate": $scope.projectEndDate, "priority": $scope.projectPriority, "empId": $scope.projectManager, "ended": false }
                	}
                	$http(req).then(function(response){
                		var alertString = "Project " + $scope.projectName + " is successfully updated ";
                    	$scope.resetProjectForm();
                    	$scope.alertmessageProject = alertString;
                    	$scope.projects = response.data;
                	}, function(){
                		$scope.alertmessageProject = "task creation error ";
                	});
                }
            };
            $scope.resetProjectForm = function () {
                $scope.updateProjectTest = "Add Project";
                $scope.alertmessageProject = "";
                $scope.projectName = "";
                $scope.settingDateNeeded = false;
                $scope.projectStartDate = new Date();
                $scope.projectEndDate = new Date();
                $scope.projectEndDate.setDate($scope.projectStartDate.getDate() + 1);
                $scope.projectPriority = 0;
                $scope.projectManager = 0;
                $scope.projectToBeUpdated = 0;
            };
            $scope.openManagerPopup = function (fromPage) {
                $scope.pageToSetManagerId = fromPage;
                $('#exampleModalManagerList').modal('show');
            };
            $scope.setManager = function (empId) {
                if ($scope.pageToSetManagerId == 'from_project')
                    $scope.projectManager = empId.toString();
                else if ($scope.pageToSetManagerId == 'from_task')
                    $scope.taskManager = empId.toString();
                $('#exampleModalManagerList').modal('hide');
            };
            $scope.clearManagerSelection = function () {
                $scope.projectManager = 0;
            };
            $scope.clearTaskManagerSelection = function () {
                $scope.taskManager = 0;
            };
            $scope.updateProject = function (projectId) {
                $scope.alertmessageProject = "";
                for (var i = 0; i < $scope.projects.length; i++) {
                    if ($scope.projects[i]["projectId"] == projectId) {
                        $scope.projectToBeUpdated = projectId;
                        $scope.projectName = $scope.projects[i]["projectName"];
                        $scope.projectStartDate = $scope.projects[i]["startDate"];
                        $scope.projectEndDate = $scope.projects[i]["endDate"];
                        $scope.projectPriority = $scope.projects[i]["priority"];
                        $scope.projectManager = $scope.projects[i]["empId"].toString();
                        $scope.updateProjectTest = "Update Project";
                        break;
                    }
                }
            };
            $scope.suspendProject = function (projectId) {
            	$scope.alertmessageProject = "";
                $('#exampleModalHeader').html("Suspend Project");
                $('#exampleModalBody').html("Are you sure you want to suspend the project?");
                $scope.yesNoModalOperationType = "project_suspend";
                $scope.yesNoModalOperationId = projectId;
                $('#exampleModalLong').modal('show');
                
                /*var intention = confirm("Are you sure you want to suspend the project?");
                if(intention == true){
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/suspendProject',
                		dataType: "json",//optional
                		data: { "projectId": projectId }
                	}
                	$http(req).then(function(response){
                		var alertString = "Project is successfully suspended ";
                    	$scope.resetProjectForm();
                    	$scope.alertmessageProject = alertString;
                    	$scope.projects = response.data;
                    	$http.get("/ProjectTaskUserManager/getTasks")
		  					.then(function(response1) {
		      				$scope.tasks = response1.data;            
		  				});
                	}, function(){
                		$scope.alertmessageProject = "task creation error ";
                	});
                }else{
                    ;
                }*/     
            };
            $scope.projectToBeUpdated = 0;
            $scope.projectPropertyName = 'projectName';
            $scope.reverse = true;
            $scope.sortProjectBy = function (propertyName) {
                $scope.reverse = ($scope.projectPropertyName === propertyName) ? !$scope.reverse : false;
                $scope.projectPropertyName = propertyName;
            };
            /* project operations - END */
            
            /* modal manipulation - BEGIN */
            $scope.yesNoModalOperationType = "";
            $scope.yesNoModalOperationId = "";
            $scope.yesNoModalOperationId2 = "";
            $scope.yesClickedInModal = function () {
                if ($scope.yesNoModalOperationType == "project_suspend") {
                    var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/suspendProject',
                		dataType: "json",//optional
                		data: { "projectId": $scope.yesNoModalOperationId }
                	}
                	$http(req).then(function(response){
                		var alertString = "Project is successfully suspended ";
                    	$scope.resetProjectForm();
                    	$scope.alertmessageProject = alertString;
                    	$scope.projects = response.data;
                    	$http.get("/ProjectTaskUserManager/getTasks")
		  					.then(function(response1) {
		      				$scope.tasks = response1.data;            
		  				});
                	}, function(){
                		$scope.alertmessageProject = "Error in project operation ";
                	});
                } else if ($scope.yesNoModalOperationType == "delete_employee") {
                    var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/deleteUser',
                		dataType: "json",//optional
                		data: { "userId": $scope.yesNoModalOperationId, "empId": $scope.yesNoModalOperationId2 }
                	}
                	$http(req).then(function(response){
                		var alertString = "User is successfully deleted ";
                    	$scope.resetUserForm();
                    	$scope.alertmessageUser = alertString;
                    	$scope.users = response.data;
                    	$http.get("/ProjectTaskUserManager/getTasks")
		  					.then(function(response1) {
		      				$scope.tasks = response1.data;            
		  				});
		  				$http.get("/ProjectTaskUserManager/getProjects")
		  					.then(function(response2) {
		      				$scope.projects = response2.data;            
		  				});
                	}, function(){
                		$scope.alertmessageUser = "Error in user operation ";
                	});
                } else if ($scope.yesNoModalOperationType == "task_ended") {
                    var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/ProjectTaskUserManager/endTask',
                		dataType: "json",
                		data: { "taskId": $scope.yesNoModalOperationId }
                	}
                	$http(req).then(function(response){
                		$scope.tasks = response.data;
                	}, function(){
                		$scope.alertMessageTask = "Error in task operation ";
                	});
                }
                $scope.yesNoModalOperationType = "";
                $scope.yesNoModalOperationId = "";
                $scope.yesNoModalOperationId2 = "";
                $('#exampleModalLong').modal('hide');
            }
            /* modal manipulation - END */
        })
    </script>

    <style>
        .slider {
            -webkit-appearance: none;
            width: 95%;
            height: 15px;
            border-radius: 5px;
            background: #d3d3d3;
            outline: none;
            opacity: 0.7;
            -webkit-transition: .2s;
            transition: opacity .2s;
        }
        .slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            background: #4CAF50;
            cursor: pointer;
        }
        .slider::-moz-range-thumb {
            width: 25px;
            height: 25px;
            border-radius: 50%;
            background: #4CAF50;
            cursor: pointer;
        }
    </style>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO"
        crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut"
        crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k"
        crossorigin="anonymous"></script>
</head>
<body ng-app="taskApp" ng-controller="taskController">
    <div class="row form-group"></div>
    <div class="row justify-content-center form-group">
        <div id="navDiv" class="col-md-8 col-sm-8 col-xs-8 col-xs-offset-2 col-md-offset-2 col-sm-offset-2 bg-white border rounded">
            <button class="btn btn-link" ng-click="showProjectPageFunc()">Manage Project</button>
            <button class="btn btn-link" ng-click="viewAddEdit()">Add/Update Task</button>
            <button class="btn btn-link" ng-click="showUserPageFunc()">Manage User</button>
            <button class="btn btn-link" ng-click="viewList()">View Task</button>
        </div>
    </div>
    <div class="row justify-content-center form-group">
    	<!-- Modal -->
        <div class="modal fade" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalHeader"></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="exampleModalBody">
                        ...
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                        <button type="button" class="btn btn-danger" ng-click="yesClickedInModal()">YES</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal for manager list -->
        <div class="modal fade" id="exampleModalManagerList" tabindex="-1" role="dialog" aria-labelledby="exampleModalManagerListTitle"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalManagerListHeader">Select Manager/User</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="exampleModalManagerListBody">
                        <div class="row form-group">
                            <label class="col-md-3 control-lable" style="text-align:right" for="searchUser">Search:</label>
                            <div class="col-md-8">
                                <input type="text" name="searchUserInPopup" ng-model="searchUserInPopup" class="input-sm"></input>
                            </div>
                        </div>
                        <table class='table table-bordered'>
                            <tr ng-repeat="user in users | filter:searchUserInPopup">
                                <td class="col-xs-5">
                                    <button class="btn btn-link" ng-click="setManager(user.empId)">{{user.empId}}</button>
                                </td>
                                <td class="col-xs-5">{{user.firstName}} {{user.lastName}}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal for project list -->
        <div class="modal fade" id="exampleModalProjectList" tabindex="-1" role="dialog" aria-labelledby="exampleModalProjectListTitle"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalProjectListHeader">Select Project</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="exampleModalProjectListBody">
                        <div class="row form-group">
                            <label class="col-md-3 control-lable" style="text-align:right" for="searchUser">Search:</label>
                            <div class="col-md-8">
                                <input type="text" name="searchProjectInPopup" ng-model="searchProjectInPopup" class="input-sm"></input>
                            </div>
                        </div>
                        <table class='table table-bordered'>
                            <tr ng-repeat="project in projects | filter:searchProjectInPopup">
                                <td class="col-xs-5">
                                    <button class="btn btn-link" ng-click="setProject(project.projectId)">{{project.projectName}}</button>
                                </td>
                                <td class="col-xs-5">{{project.startDate}} - {{project.endDate}}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal for Task list -->
        <div class="modal fade" id="exampleModalTaskList" tabindex="-1" role="dialog" aria-labelledby="exampleModalTaskListTitle"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalTaskListHeader">Select Parent Task</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="exampleModalTaskListBody">
                        <table class='table table-bordered'>
                            <tr ng-repeat="task in tasks|filter:parentTaskFilter">
                                <td class="col-xs-5">
                                    <button class="btn btn-link" ng-click="setParentTask(task.taskId)">{{task.taskName}}</button>
                                </td>
                                <td class="col-xs-5">{{task.startDate}} - {{task.endDate}}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- This is for add/edit tasks page -->
        <div class="col-md-8 col-sm-8 col-xs-8 col-xs-offset-2 col-md-offset-2 col-sm-offset-2 bg-white border rounded" ng-show="showAddEditPage">
            <form name="taskForm" novalidate>
                <div class="alert alert-success mt-3" role="alert" ng-show="alertMessageTask" id="alertDiv">
                    {{alertMessageTask}}
                </div>
                <div class="row form-group mt-3">
                    <label class="col-md-12 control-lable" style="text-align:center">
                        <h3>Manage Task</h3>
                    </label>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="projectForTask">Project name:</label>
                    <div class="col-md-8">
                        <select id="projectForTask" name="projectForTask" ng-model="projectForTask"  ng-disabled="true">
                            <option value=""></option>
                            <option ng-repeat="project in projects" value="{{project.projectId}}">{{project.projectName}}</option>
                        </select>
                        <span style="color:red" ng-show="!projectForTask">
                            Please select a project first
                        </span>
                        <button class="btn btn-success" ng-click="openProjectPopup('edit_task')">Select Project</button>
                        <button class="btn btn-danger" ng-click="clearProjectSelection()">Clear</button>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="taskName">Task*:</label>
                    <div class="col-md-8">
                        <input type="text" name="taskName" ng-model="taskName" class="form-control input-sm" required ng-disabled="!projectForTask"></input>                       
                    </div>

                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="priority">Priority*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            0<input type="range" min="0" max="30" value="0" class="slider" name="priority" ng-model="priority"
                                ng-disabled="!projectForTask">30
                        </div>
                        <span style="color:blue">
                            priority is {{priority}}
                        </span>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="parentTask">Parent Task:</label>
                    <div class="col-md-8">
                        <select id="parentTask" name="parentTask" ng-model="parentTask" ng-disabled="true">
                            <option value=""></option>
                            <option ng-repeat="task in tasks|filter:parentTaskFilter" value="{{task.taskId}}">{{task.taskName}}</option>
                        </select>
                        <button class="btn btn-success" ng-click="openTaskPopup()" ng-disabled="!projectForTask">Select Parent</button>
                        <button class="btn btn-danger" ng-click="clearParentTaskSelection()">Clear</button>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="settingDateNeeded"></label>
                    <div class="col-md-8">
                        <input type="checkbox" name="settingDateNeeded" ng-model="settingDateNeeded" class="" value="false" /> Select the task start/end date
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="startDate">Start Date*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            <input type="date" min="2019-01-01" max="2019-12-31" value="2019-01-01" name="startDate" ng-model="startDate" required format-date
                                ng-disabled="!settingDateNeeded"></input>
                        </div>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="endDate">End Date*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            <input type="date" min="2019-01-01" max="2019-12-31" value="2019-12-31" name="endDate" ng-model="endDate" required format-date
                                ng-disabled="!settingDateNeeded"></input>
                        </div>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="taskManager">User:</label>
                    <div class="col-md-8">
                        <select id="taskManager" name="taskManager" ng-model="taskManager" ng-disabled="true">
                            <option value="0"></option>
                            <option ng-repeat="user in users" value="{{user.empId}}">{{user.empId}} - {{user.firstName}} {{user.lastName}}</option>
                        </select>
                        <button class="btn btn-success" ng-click="openManagerPopup('from_task')">Select Manager</button>
                        <button class="btn btn-danger" ng-click="clearTaskManagerSelection()">Clear</button>
                    </div>
                </div>
                <hr/>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-8">
                        <input ng-disabled="taskForm.taskName.$invalid " type="submit" class="btn btn-success" value="{{updateAddTest}}" ng-click="taskSubmitted()">
                        <button class="btn btn-danger" ng-click="resetTaskForm()">Reset</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- This is for view tasks page -->
        <div class="col-md-8 col-sm-8 col-xs-8 col-xs-offset-2 col-md-offset-2 col-sm-offset-2 bg-white border rounded" ng-show="showViewPage">
            
                <label class="col-md-12 control-lable" style="text-align:center">
                    <h3>View Task</h3>
                </label>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="projectForViewTask">Project name:</label>
                    <div class="col-md-8">
                        <select id="projectForViewTask" name="projectForViewTask" ng-model="projectForViewTask" ng-disabled="true">
                            <option value=""></option>
                            <option ng-repeat="project in projects" value="{{project.projectId}}">{{project.projectName}}</option>
                        </select>
                        <span style="color:red" ng-show="!projectForViewTask">
                            Please select a project first
                        </span>
                        <button class="btn btn-success" ng-click="openProjectPopup('view_task')">Select Project</button>
                    	<button class="btn btn-danger" ng-click="clearProjectViewSelection()">Clear</button>
                    </div>
                </div>
                <hr/>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <td class="col-xs-2">
                                <button ng-click="sortTaskBy('taskName')"> Task Name</button>
                                <span class="sortorder" ng-show="taskPropertyName === 'taskName'" ng-class="{reverse: reverse}"></span>                  
                            </td>
                            <td class="col-xs-1">
                                <button ng-click="sortTaskBy('priority')">Priority</button>
                                <span class="sortorder" ng-show="taskPropertyName === 'priority'" ng-class="{reverse: reverse}"></span>                  
                            </td>
                            <td class="col-xs-1">
                                <button ng-click="sortTaskBy('startDate')">Start</button>
                                <span class="sortorder" ng-show="taskPropertyName === 'startDate'" ng-class="{reverse: reverse}"></span>                  
                            </td>
                            <td class="col-xs-1">
                                <button ng-click="sortTaskBy('endDate')">End</button>
                                <span class="sortorder" ng-show="taskPropertyName === 'endDate'" ng-class="{reverse: reverse}"></span>                  
                            </td>
                            <td class="col-xs-2">
                                <button ng-click="sortTaskBy('parentTask')">Parent</button>
                                <span class="sortorder" ng-show="taskPropertyName === 'parentTask'" ng-class="{reverse: reverse}"></span>                  
                            </td>
                            <td class="col-xs-1">
                                <button ng-click="sortTaskBy('empId')">EmpId</button>
                                <span class="sortorder" ng-show="taskPropertyName === 'empId'" ng-class="{reverse: reverse}"></span>
                            </td>
                            <td class="col-xs-1">
                                <button ng-click="sortTaskBy('taskended')">Ended</button>
                                <span class="sortorder" ng-show="taskPropertyName === 'taskended'" ng-class="{reverse: reverse}"></span>
                            </td>
                            <th class="col-xs-2"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-repeat="task in tasks|filter:taskFilter|orderBy:taskPropertyName:reverse">
                            <td class="col-xs-2">{{task.taskName}}</td>
                            <td class="col-xs-1">{{task.priority}}</td>
                            <td class="col-xs-1">{{task.startDate}}</td>
                            <td class="col-xs-1">{{task.endDate}}</td>
                            <td class="col-xs-2">{{task.parentTask}}</td>
                            <td class="col-xs-1">{{task.empId}}</td>
                            <td class="col-xs-1">{{task.taskended}}</td>
                            <td class="col-xs-2">
                                <button class="btn btn-primary" ng-click="updateTask(task.taskId)" ng-disabled="task.taskended">Update</button>
                                <button class="btn btn-danger" ng-click="endTask(task.taskId)" ng-disabled="task.taskended" title="End the task">End Task</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            
        </div>

        <!-- This is for user page -->
        <div class="col-md-8 col-sm-8 col-xs-8 col-xs-offset-2 col-md-offset-2 col-sm-offset-2 bg-white border rounded" ng-show="showUserPage">
            <form name="userForm" novalidate>
                <div class="alert alert-info mt-3" role="alert" ng-show="alertmessageUser">
                    {{alertmessageUser}}
                </div>
                <div class="row form-group mt-3">
                    <label class="col-md-12 control-lable" style="text-align:center">
                        <h3>Manage User</h3>
                    </label>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="firstName">FirstName*:</label>
                    <div class="col-md-8">
                        <input type="text" name="firstName" ng-model="firstName" class="form-control input-sm" required></input>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="lastName">LastName*:</label>
                    <div class="col-md-8">
                        <input type="text" name="lastName" ng-model="lastName" class="form-control input-sm" required></input>                       
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="empID">Employee ID(6 digit number)*:</label>
                    <div class="col-md-8">
                        <input type="number" name="empID" ng-model="empID" ng-disabled="updateAddUserTest=='Update User'" class="form-control input-sm"
                            minlength="6" maxlength="6" required></input>
                    </div>
                </div>
                <hr/>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-8">
                        <input ng-disabled="userForm.firstName.$invalid || userForm.LastName.$invalid || userForm.empID.$invalid" type="submit" class="btn btn-success"
                            value="{{updateAddUserTest}}" ng-click="userSubmitted()">
                        <button class="btn btn-danger" ng-click="resetUserForm()">Reset</button>
                    </div>
                </div>
                <hr/>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="searchUser">Search:</label>
                    <div class="col-md-8">
                        <input type="text" name="searchUser" ng-model="searchUser" ng-disabled="updateAddUserTest=='Update User'" class="form-control input-sm"></input>
                    </div>
                </div>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th class="col-xs-3">
                                <button ng-click="sortUserBy('firstName')"> First Name</button>
                                <span class="sortorder" ng-show="UserPropertyName === 'firstName'" ng-class="{reverse: reverse}"></span>
                            </th>
                            <th class="col-xs-3">
                                <button ng-click="sortUserBy('lastName')"> Last Name</button>
                                <span class="sortorder" ng-show="UserPropertyName === 'lastName'" ng-class="{reverse: reverse}"></span>
                            </th>
                            <th class="col-xs-3">
                                <button ng-click="sortUserBy('empId')"> Employee ID</button>
                                <span class="sortorder" ng-show="UserPropertyName === 'empId'" ng-class="{reverse: reverse}"></span>
                            </th>
                            <th class="col-xs-2"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-repeat="user in users|filter:searchUser|orderBy:propertyName:reverse">
                            <td class="col-xs-3">{{user.firstName}}</td>
                            <td class="col-xs-3">{{user.lastName}}</td>
                            <td class="col-xs-3">{{user.empId}}</td>
                            <td class="col-xs-2">
                                <button class="btn btn-primary" ng-click="updateUser(user.userId)">Update</button>
                                <button class="btn btn-danger" ng-click="deleteUser(user.userId,user.empId)">Delete</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>

        <!-- This is for project page -->
        <div class="col-md-8 col-sm-8 col-xs-8 col-xs-offset-2 col-md-offset-2 col-sm-offset-2 bg-white border rounded" ng-show="showProjectPage">
            <form name="projectForm" novalidate>
                <div class="alert alert-info mt-3" role="alert" ng-show="alertmessageProject">
                    {{alertmessageProject}}
                </div>
                <div class="row form-group mt-3">
                    <label class="col-md-12 control-lable" style="text-align:center">
                        <h3>Manage Project</h3>
                    </label>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="projectName">Project name*:</label>
                    <div class="col-md-8">
                        <input type="text" name="projectName" ng-model="projectName" class="form-control input-sm" required></input>
                   </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="settingDateNeeded"></label>
                    <div class="col-md-8">
                        <input type="checkbox" name="settingDateNeeded" ng-model="settingDateNeeded" class="" value="false" /> Select the project start/end date
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="projectStartDate">Start Date*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            <input type="date" min="2019-01-01" max="2019-12-31" value="2019-11-01" name="projectStartDate" ng-model="projectStartDate"
                                ng-disabled="!settingDateNeeded" required format-date></input>
                        </div>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="projectEndDate">End Date*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            <input type="date" min="2019-01-01" max="2019-12-31" value="2019-05-31" name="projectEndDate" ng-model="projectEndDate" ng-disabled="!settingDateNeeded"
                                required format-date></input>
                        </div>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="projectPriority">Priority*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            0<input type="range" min="0" max="30" value="0" class="slider" name="projectPriority" ng-model="projectPriority">30
                        </div>
                        <span style="color:blue">
                            priority is {{projectPriority}}
                        </span>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="projectManager">Manager:</label>
                    <div class="col-md-8">
                        <select id="projectManager" name="projectManager" ng-model="projectManager" ng-disabled="true">
                            <option value="0"></option>
                            <option ng-repeat="user in users" value="{{user.empId}}">{{user.empId}} - {{user.firstName}} {{user.lastName}}</option>
                        </select>
                        <button class="btn btn-success" ng-click="openManagerPopup('from_project')">Select Manager</button>
                        <button class="btn btn-danger" ng-click="clearManagerSelection()">Clear</button>
                    </div>
                </div>
                <hr/>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-8">
                        <input ng-disabled="projectForm.projectName.$invalid" type="submit" class="btn btn-success" value="{{updateProjectTest}}"
                            ng-click="projectSubmitted()">
                        <button class="btn btn-danger" ng-click="resetProjectForm()">Reset</button>
                    </div>
                </div>
                <hr/>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="searchProject">Search:</label>
                    <div class="col-md-8">
                        <input type="text" name="searchProject" ng-model="searchProject" ng-disabled="updateProjectTest=='Update Project'" class="form-control input-sm"></input>
                    </div>
                </div>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th class="col-xs-3">
                                <button ng-click="sortProjectBy('projectName')"> Project Name</button>
                                <span class="sortorder" ng-show="projectPropertyName === 'projectName'" ng-class="{reverse: reverse}"></span>
                            </th>
                            <th class="col-xs-2">
                                <button ng-click="sortProjectBy('startDate')"> Start Date</button>
                                <span class="sortorder" ng-show="projectPropertyName === 'startDate'" ng-class="{reverse: reverse}"></span>
                            </th>
                            <th class="col-xs-2">
                                <button ng-click="sortProjectBy('endDate')"> End Date</button>
                                <span class="sortorder" ng-show="projectPropertyName === 'endDate'" ng-class="{reverse: reverse}"></span>
                            </th>
                            <th class="col-xs-1">
                                <button ng-click="sortProjectBy('priority')"> Priority</button>
                                <span class="sortorder" ng-show="projectPropertyName === 'priority'" ng-class="{reverse: reverse}"></span>
                            </th>
                            <th class="col-xs-1">
                                <button ng-click="sortProjectBy('projectEnded')"> Project Ended</button>
                                <span class="sortorder" ng-show="projectPropertyName === 'projectEnded'" ng-class="{reverse: reverse}"></span>
                            </th>
                            <th class="col-xs-2"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-repeat="project in projects|filter:searchProject|orderBy:propertyName:reverse">
                            <td class="col-xs-3">{{project.projectName}}</td>
                            <td class="col-xs-2">{{project.startDate}}</td>
                            <td class="col-xs-2">{{project.endDate}}</td>
                            <td class="col-xs-1">{{project.priority}}</td>
                            <td class="col-xs-1">{{project.ended}}</td>
                            <td class="col-xs-2">
                                <button class="btn btn-primary" ng-click="updateProject(project.projectId)" ng-disabled="project.ended">Update</button>
                                <button class="btn btn-danger" ng-click="suspendProject(project.projectId)" ng-disabled="project.ended">Suspend</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
</body>
</html>