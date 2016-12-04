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
  /* procedures for ozu_departments will be implemented */
  /* procedures for ozu_project_teams will be implemented */
  /* procedures for ozu_projects will be implemented */
  /* procedures for ozu_tasks will be implemented */
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

  
END cs398dml_pack;