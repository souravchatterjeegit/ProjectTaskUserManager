# ProjectTaskUserManager
create table ProjectTask(
	task_id bigint not null auto_increment,
    parent_id bigint default 0,
    project_id bigint default 0,
    task_name varchar(50),
    start_date date,
    end_date date,
    priority int default 0 check(priority between 0 and 30),
    task_ended boolean default false,
    employee_id bigint default 0,
    primary key(task_id)
);
create table ProjectParentTask(
	parent_id bigint not null auto_increment,
    parent_task varchar(50),
    primary key(parent_id)
);
create table Project(
	project_id bigint not null auto_increment,
    project_name varchar(50),
    start_date date,
    end_date date,
    priority int default 0 check(priority between 0 and 30),
    project_ended boolean default false,
    employee_id bigint default 0,
    primary key(project_id)
);
create table ProjectUser(
	user_id bigint not null auto_increment,
    first_name varchar(50),
    last_name varchar(50),
    employee_id bigint default 0,
    primary key(user_id)
);
insert into ProjectUser values(1,"Sourav","Chatterjee",100001);
insert into ProjectUser values(2,"Madan","Kumar",100002);

insert into Project values(1,"Mellon",'2019-01-01','2019-12-31',20,false,100001);
insert into Project values(2,"Liberty",'2019-01-01','2019-12-31',10,false,100002);

insert into ProjectTask values(1,0,1,"Mellon Task 1",'2019-01-01','2019-01-31',10,false,100001);
insert into ProjectTask values(2,0,2,"Liberty Task 1",'2019-01-01','2019-01-31',10,false,100002);

insert into ProjectParentTask values(1,"Mellon Task 1");
insert into ProjectParentTask values(2,"Liberty Task 1");
truncate Project;
truncate ProjectTask;
truncate ProjectParentTask;
truncate ProjectUser;

1.For Front End –zipped application
2.For Backend -Packaged code files (Source code and WAR).
3.For SCM* –Project Code should be present in active GIT repository
4.Few Steps on how to run the solution.
5.Regular Build Reports from CI server
6.Emma coverage reports
7.Load test reports

*SCM –Source Code Management
