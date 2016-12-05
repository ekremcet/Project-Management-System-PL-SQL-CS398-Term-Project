CREATE OR REPLACE PACKAGE cs398dml_pack IS
  PROCEDURE p_t_ozu_employees_insert(
    v_employee_id IN NUMBER(6),
    v_first_name IN VARCHAR2(20),
    v_last_name IN VARCHAR2(25),
    v_email IN VARCHAR2(45),
    v_salary IN NUMBER,
    v_total_work_percentage IN NUMBER,
    v_membership_count IN NUMBER(1),
    v_department_id IN NUMBER(4)
  );
  PROCEDURE p_t_ozu_employees_update_salary(
     v_employee_id IN NUMBER(6),
     v_salary IN NUMBER
  );
  PROCEDURE p_t_ozu_employees_update_total_work_percentage(
    v_employee_id IN NUMBER(6),
    v_total_work_percentage IN NUMBER
  );
  PROCEDURE p_t_ozu_employees_update_membership_count(
    v_employee_id IN NUMBER(6),
    v_membership_count IN NUMBER(1)
  );
  PROCEDURE p_t_ozu_employees_update_department_id(
    v_employee_id IN NUMBER(6),
    v_department_id IN NUMBER(4)
  );
  PROCEDURE p_t_ozu_employees_delete_employee(
    v_employee_id IN NUMBER(6)
  );
  /**** END OF OZU_EMPLOYEES PROCEDURES *******/
  PROCEDURE p_t_ozu_departments_insert(
    v_department_id IN NUMBER(4),
    v_department_name IN VARCHAR2(25),
    v_head_id IN NUMBER(6)
  );
  PROCEDURE p_t_ozu_departments_update_head(
    v_department_id IN NUMBER(4),
    v_head_id IN NUMBER(6)
  );
  PROCEDURE p_t_ozu_departments_delete_department(
    v_department_id IN NUMBER(4)
  );
  /*********** END OF OZU_DEPARTMENTS PROCEDURES *******/
  PROCEDURE p_t_ozu_projects_insert(
    v_project_id IN NUMBER(4),
    v_leader_id IN NUMBER(6),
    v_project_status IN VARCHAR2(1),
    v_project_start_date IN DATE,
    v_project_end_date IN DATE
  );
  PROCEDURE p_t_ozu_projects_update_leader(
    v_project_id IN NUMBER(4),
    v_leader_id IN NUMBER(6)
  );
  PROCEDURE p_t_ozu_projects_update_project_status(
    v_project_id IN NUMBER(4),
    v_project_status IN VARCHAR2(1)
  );
  PROCEDURE p_t_ozu_projects_update_project_end_date(
    v_project_id IN NUMBER(4),
    v_project_end_date IN DATE
  );
  PROCEDURE p_t_ozu_projects_delete_project(
    v_project_id IN NUMBER(4)
  );
  /*********** END OF OZU_PROJECTS PROCEDURES *********/
  PROCEDURE p_t_ozu_project_teams_insert(
    v_project_id IN NUMBER(4),
    v_employee_id IN NUMBER(6),
    v_task_id IN NUMBER(4),
    v_work_percentage IN NUMBER
  );
  PROCEDURE p_t_ozu_project_teams_update_task_of_employee(
    v_employee_id IN NUMBER(6),
    v_project_id IN NUMBER(4),
    v_task_id IN NUMBER(4)
  );
  PROCEDURE p_t_ozu_project_teams_update_work_of_employee(
    v_employee_id IN NUMBER(6),
    v_task_id IN NUMBER(4),
    v_work_percentage IN NUMBER
  );
  PROCEDURE p_t_ozu_project_teams_delete_employee(
    v_employee_id IN NUMBER(6),
    v_project_id IN NUMBER(4)
  );
  PROCEDURE p_t_ozu_project_teams_delete_project_team(
    v_project_id IN NUMBER(4)
  );
  /******** END OF OZU_PROJECT_TEAMS PROCEDURES *******/

END cs398dml_pack;

CREATE OR REPLACE PACKAGE BODY cs398dml_pack IS
  PROCEDURE p_t_ozu_employees_insert(
    v_employee_id IN NUMBER(6),
    v_first_name IN VARCHAR2(20),
    v_last_name IN VARCHAR2(25),
    v_email IN VARCHAR2(45),
    v_salary IN NUMBER,
    v_total_work_percentage IN NUMBER,
    v_membership_count IN NUMBER(1),
    v_department_id IN NUMBER(4))
  IS
  BEGIN
    INSERT INTO OZU_EMPLOYEES(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,
                              EMAIL,SALARY,TOTAL_WORK_PERCENTAGE,
                              MEMBERSHIP_COUNT,DEPARTMENT_ID)
    VALUES (v_employee_id,v_first_name,v_last_name,v_email,
            v_salary,v_total_work_percentage,v_membership_count,v_department_id);
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'Employee not inserted, Check Values');
    END IF;
  END p_t_ozu_employees_insert;

  PROCEDURE p_t_ozu_employees_update_salary(v_employee_id IN NUMBER(6),v_salary IN NUMBER)
  IS
  BEGIN
    UPDATE OZU_EMPLOYEES SET SALARY = v_salary
    WHERE EMPLOYEE_ID = v_employee_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20222,'Salary not updated, Check Values');
    END IF;
  END p_t_ozu_employees_update_salary;

  PROCEDURE p_t_ozu_employees_update_total_work_percentage(v_employee_id IN NUMBER(6),
    v_total_work_percentage IN NUMBER)
  IS
  BEGIN
    UPDATE OZU_EMPLOYEES SET TOTAL_WORK_PERCENTAGE = v_total_work_percentage
    WHERE EMPLOYEE_ID = v_employee_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20223,'Work Percentage Not Updated, Check Values');
    END IF;
  END p_t_ozu_employees_update_total_work_percentage;

  PROCEDURE p_t_ozu_employees_update_membership_count(v_employee_id IN NUMBER(6),
    v_membership_count IN NUMBER(1))
  IS
  BEGIN
    UPDATE OZU_EMPLOYEES SET MEMBERSHIP_COUNT = v_membership_count
    WHERE EMPLOYEE_ID = v_employee_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20224,'Membership Count not updated, Check Values');
    END IF;
  END p_t_ozu_employees_update_membership_count;

  PROCEDURE p_t_ozu_employees_update_department_id(v_employee_id IN NUMBER(6),
    v_department_id IN NUMBER(4))
  IS
  BEGIN
    UPDATE OZU_EMPLOYEES SET DEPARTMENT_ID = v_department_id
    WHERE EMPLOYEE_ID = v_employee_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20225,'Department not updated, Check Values');
    END IF;
  END p_t_ozu_employees_update_department_id;

  PROCEDURE p_t_ozu_employees_delete_employee(v_employee_id IN NUMBER(6))
  IS
  BEGIN
    DELETE FROM OZU_EMPLOYEES
    WHERE EMPLOYEE_ID = v_employee_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20250,'Employee not deleted, Check Values');
    END IF;
  END p_t_ozu_employees_delete_employee;

  /******************************************************************************/
  /****************** END OF OZU_EMPLOYEES PROCEDURES ***************************/
  /******************************************************************************/

  PROCEDURE p_t_ozu_departments_insert(
    v_department_id IN NUMBER(4),
    v_department_name IN VARCHAR2(25),
    v_head_id IN NUMBER(6)
  )
  IS
  BEGIN
    INSERT INTO OZU_DEPARTMENTS(DEPARTMENT_ID,DEPARTMENT_NAME,HEAD_ID)
    VALUES (v_department_id,v_department_name,v_head_id);
    IF SQL%NOTFOUND THEN
     RAISE_APPLICATION_ERROR(-20201,'Department not inserted, Check Values');
    END IF;
  END p_t_ozu_departments_insert;

  PROCEDURE p_t_ozu_departments_update_head(v_department_id IN NUMBER(4),
    v_head_id IN NUMBER(6))
  IS
  BEGIN
    UPDATE OZU_DEPARTMENTS SET HEAD_ID = v_head_id
    WHERE DEPARTMENT_ID = v_department_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20226,'Department head not updated, Check Values');
    END IF;
  END p_t_ozu_departments_update_head;

  PROCEDURE p_t_ozu_departments_delete_department(v_department_id IN NUMBER(4))
  IS
  BEGIN
    DELETE FROM OZU_DEPARTMENTS
    WHERE DEPARTMENT_ID = v_department_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20251,'Department not deleted, Check Values');
    END IF;
  END p_t_ozu_departments_delete_department;

  /******************************************************************************/
  /****************** END OF OZU_DEPARTMENTS PROCEDURES *************************/
  /******************************************************************************/

  PROCEDURE p_t_ozu_projects_insert(
    v_project_id IN NUMBER(4),
    v_leader_id IN NUMBER(6),
    v_project_status IN VARCHAR2(1),
    v_project_start_date IN DATE,
    v_project_end_date IN DATE
  )
  IS
  BEGIN
    INSERT INTO OZU_PROJECTS(PROJECT_ID, LEADER_ID, PROJECT_STATUS,
                             PROJECT_START_DATE, PROJECT_END_DATE)
    VALUES(v_project_id,v_leader_id,v_project_status,v_project_start_date,v_project_end_date);
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20202,'Project not inserted, Check Values');
    END IF;
  END p_t_ozu_projects_insert;

  PROCEDURE p_t_ozu_projects_update_leader(v_project_id IN NUMBER(4),v_leader_id IN NUMBER(6))
  IS
  BEGIN
    UPDATE OZU_PROJECTS SET LEADER_ID = v_leader_id
    WHERE PROJECT_ID = v_project_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20227,'Project Leader not updated, Check Values');
    END IF;
  END p_t_ozu_projects_update_leader;

  PROCEDURE p_t_ozu_projects_update_project_status(v_project_id IN NUMBER(4),
    v_project_status IN VARCHAR2(1))
  IS
  BEGIN
    UPDATE OZU_PROJECTS SET PROJECT_STATUS = v_project_status
    WHERE PROJECT_ID = v_project_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20228,'Project status not updated, Check Values');
    END IF;
  END p_t_ozu_projects_update_project_status;

  PROCEDURE p_t_ozu_projects_update_project_end_date(v_project_id IN NUMBER(4),
    v_project_end_date IN DATE)
  IS
  BEGIN
    UPDATE OZU_PROJECTS SET PROJECT_END_DATE = v_project_end_date
    WHERE PROJECT_ID = v_project_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20229,'Project end date not updated, Check Values');
    END IF;
  END p_t_ozu_projects_update_project_end_date;

  PROCEDURE p_t_ozu_projects_delete_project(v_project_id IN NUMBER(4))
  IS
  BEGIN
    DELETE FROM OZU_PROJECTS
    WHERE PROJECT_ID = v_project_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20252,'Project not deleted, Check Values');
    END IF;
  END p_t_ozu_projects_delete_project;

  /******************************************************************************/
  /****************** END OF OZU_PROJECTS PROCEDURES ****************************/
  /******************************************************************************/

  PROCEDURE p_t_ozu_project_teams_insert(
    v_project_id IN NUMBER(4),
    v_employee_id IN NUMBER(6),
    v_task_id IN NUMBER(4),
    v_work_percentage IN NUMBER
  )
  IS
  BEGIN
    INSERT INTO OZU_PROJECT_TEAMS(PROJECT_ID, EMPLOYEE_ID, TASK_ID, WORK_PERCENTAGE)
    VALUES(v_project_id,v_employee_id,v_task_id,v_work_percentage);
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20203,'Project team not inserted, Check Values');
    END IF;
  END p_t_ozu_project_teams_insert;

  PROCEDURE p_t_ozu_project_teams_update_task_of_employee(v_project_id IN NUMBER(4),
    v_employee_id IN NUMBER(6),v_task_id IN NUMBER(4))
  IS
  BEGIN
    UPDATE OZU_PROJECT_TEAMS SET TASK_ID = v_task_id
    WHERE EMPLOYEE_ID = v_employee_id AND PROJECT_ID = v_project_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20230,'Employee Task not updated, Check Values');
    END IF;
  END p_t_ozu_project_teams_update_task_of_employee;

  PROCEDURE p_t_ozu_project_teams_update_work_of_employee(v_project_id IN NUMBER(4),
    v_employee_id IN NUMBER(6), v_work_percentage IN NUMBER)
  IS
  BEGIN
    UPDATE OZU_PROJECT_TEAMS SET WORK_PERCENTAGE = v_work_percentage
    WHERE EMPLOYEE_ID = v_employee_id AND PROJECT_ID = v_project_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20231,'Employee work percentage not updated, Check Values');
    END IF;
  END p_t_ozu_project_teams_update_work_of_employee;

  PROCEDURE p_t_ozu_project_teams_delete_employee(v_employee_id IN NUMBER(6),
    v_project_id IN NUMBER(4))
  IS
  BEGIN
    DELETE FROM OZU_PROJECT_TEAMS
    WHERE EMPLOYEE_ID = v_employee_id AND PROJECT_ID = v_project_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20253,'Employee in project team not deleted, Check Values');
    END IF;
  END p_t_ozu_project_teams_delete_employee;

  PROCEDURE p_t_ozu_project_teams_delete_project_team(v_project_id IN NUMBER(4))
  IS
  BEGIN
    DELETE FROM OZU_PROJECT_TEAMS
    WHERE PROJECT_ID = v_project_id;
    IF SQL%NOTFOUND THEN
      RAISE_APPLICATION_ERROR(-20254,'Project team not deleted, Check Values');
    END IF;
  END p_t_ozu_project_teams_delete_project_team;

  /******************************************************************************/
  /****************** END OF OZU_PROJECT_TEAMS PROCEDURES ***********************/
  /******************************************************************************/


END cs398dml_pack;
