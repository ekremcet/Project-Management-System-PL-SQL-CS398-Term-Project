CREATE OR REPLACE TRIGGER project_status_change_trigger
BEFORE UPDATE OF PROJECT_STATUS ON OZU_PROJECTS
FOR EACH ROW
BEGIN
  IF NOT((:OLD.PROJECT_STATUS = 'P' AND :NEW.PROJECT_STATUS = 'S') OR
         (:OLD.PROJECT_STATUS = 'S' AND :NEW.PROJECT_STATUS IN ('C','F'))
  ) THEN
    RAISE_APPLICATION_ERROR(-20500,'STATUS OF PROJECT CAN ONLY BE CHANGED AS FOLLOWING P -> S -> C || F');
  END IF;
END;

CREATE OR REPLACE TRIGGER task_status_change_trigger
BEFORE UPDATE OF TASK_STATUS ON OZU_TASKS
FOR EACH ROW
BEGIN
  IF NOT((:OLD.TASK_STATUS = 'P' AND :NEW.TASK_STATUS = 'S') OR
         (:OLD.TASK_STATUS = 'S' AND :NEW.TASK_STATUS IN ('C','F'))
  ) THEN
    RAISE_APPLICATION_ERROR(-20501,'STATUS OF TASK CAN ONLY BE CHANGED AS FOLLOWING P -> S -> C || F');
  END IF;
END;

CREATE OR REPLACE TRIGGER project_leader_null_trigger
BEFORE INSERT OR UPDATE OF LEADER_ID ON OZU_PROJECTS
FOR EACH ROW
BEGIN
  IF NOT(:NEW.PROJECT_STATUS = 'P') THEN
    IF(:NEW.LEADER_ID IS NULL) THEN
      RAISE_APPLICATION_ERROR(-20502,'PROJECT MUST HAVE A LEADER UNLESS ITS STATUS IS P');
    END IF;
  END IF;
END;

CREATE OR REPLACE TRIGGER project_leader_correct_trigger
AFTER INSERT OR UPDATE OF LEADER_ID ON OZU_PROJECTS
FOR EACH ROW
DECLARE
  v_department_id OZU_EMPLOYEES.DEPARTMENT_ID%TYPE;
  v_manager_id OZU_DEPARTMENTS.HEAD_ID%TYPE;
  v_exists NUMBER := 0;
BEGIN
  SELECT DEPARTMENT_ID INTO v_department_id FROM OZU_EMPLOYEES
  WHERE EMPLOYEE_ID = :NEW.LEADER_ID;

  SELECT HEAD_ID INTO v_manager_id FROM OZU_DEPARTMENTS
  WHERE DEPARTMENT_ID = v_department_id;

  BEGIN
    SELECT EMPLOYEE_ID INTO v_exists FROM OZU_PROJECT_TEAMS
    WHERE PROJECT_ID = :NEW.PROJECT_ID AND EMPLOYEE_ID = v_manager_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      v_exists := 0;
  END;

  IF (v_exists != 0) THEN
    RAISE_APPLICATION_ERROR(-20503,'A MEMBER CANNOT BE PROJECT LEADER IF HIS/HER MANAGER IS ALSO IN THE TEAM');
  END IF;
END;

CREATE OR REPLACE TRIGGER member_count_trigger
BEFORE DELETE OR INSERT OR UPDATE OF EMPLOYEE_ID,PROJECT_ID ON OZU_PROJECT_TEAMS
FOR EACH ROW
DECLARE
  v_old_project_status OZU_PROJECTS.PROJECT_STATUS%TYPE := 'A';
  v_new_project_status OZU_PROJECTS.PROJECT_STATUS%TYPE;
  v_member_count OZU_EMPLOYEES.MEMBERSHIP_COUNT%TYPE;
BEGIN
  IF NOT DELETING THEN
    IF UPDATING THEN
      SELECT PROJECT_STATUS INTO v_old_project_status FROM OZU_PROJECTS
      WHERE PROJECT_ID = :OLD.PROJECT_ID;
    END IF;

    SELECT PROJECT_STATUS INTO v_new_project_status FROM OZU_PROJECTS
    WHERE PROJECT_ID = :NEW.PROJECT_ID;

    SELECT MEMBERSHIP_COUNT INTO v_member_count FROM OZU_EMPLOYEES
    WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;
    IF (v_old_project_status IN ('S','P') AND v_new_project_status IN ('C','F')) THEN
       v_member_count := v_member_count - 1;
    ELSIF (v_new_project_status IN ('C','F')) THEN
      v_member_count := v_member_count;
    ELSE
      v_member_count := v_member_count + 1;
    END IF;

    IF(v_member_count > 5) THEN
      RAISE_APPLICATION_ERROR(-20503,'AN EMPLOYEE CANNOT BE MEMBER OF MORE THAN 5 ACTIVE PROJECTS');
    ELSE
      UPDATE OZU_EMPLOYEES SET MEMBERSHIP_COUNT = v_member_count WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;
    END IF;
    /* If deleting part */
  ELSE
    SELECT MEMBERSHIP_COUNT INTO v_member_count FROM OZU_EMPLOYEES
    WHERE EMPLOYEE_ID = :OLD.EMPLOYEE_ID;
    v_member_count := v_member_count - 1;
    UPDATE OZU_EMPLOYEES SET MEMBERSHIP_COUNT = v_member_count WHERE EMPLOYEE_ID = :OLD.EMPLOYEE_ID;
  END IF;
END;

CREATE OR REPLACE TRIGGER work_percentage_trigger
BEFORE DELETE OR INSERT OR UPDATE OF WORK_PERCENTAGE ON OZU_PROJECT_TEAMS
FOR EACH ROW
DECLARE
  v_per_difference OZU_EMPLOYEES.TOTAL_WORK_PERCENTAGE%TYPE := :NEW.WORK_PERCENTAGE;
  v_work_per OZU_EMPLOYEES.TOTAL_WORK_PERCENTAGE%TYPE;
  v_project_status OZU_PROJECTS.PROJECT_STATUS%TYPE;
BEGIN
  IF NOT DELETING THEN
    SELECT TOTAL_WORK_PERCENTAGE INTO v_work_per FROM OZU_EMPLOYEES
    WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;
    SELECT PROJECT_STATUS INTO v_project_status FROM OZU_PROJECTS
    WHERE PROJECT_ID = :NEW.PROJECT_ID;
    IF UPDATING THEN
      v_per_difference := :NEW.WORK_PERCENTAGE - :OLD.WORK_PERCENTAGE;
    END IF;

    IF(v_project_status IN ('P','S')) THEN
      v_work_per := v_work_per + v_per_difference;
    ELSIF(v_project_status IN ('C','F')) THEN
      v_work_per := v_work_per;
    END IF;

    IF(v_work_per > 1 OR v_work_per < 0) THEN
      RAISE_APPLICATION_ERROR(-20505,'TOTAL WORK PERCENTAGE OF EMPLOYEE CANNOT BE MORE THAN 1, AND SMALLER THAN 0');
    ELSE
      UPDATE OZU_EMPLOYEES SET TOTAL_WORK_PERCENTAGE = v_work_per WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;
    END IF;
  /* deleting part*/
  ELSE
    SELECT TOTAL_WORK_PERCENTAGE INTO v_work_per FROM OZU_EMPLOYEES
    WHERE EMPLOYEE_ID = :OLD.EMPLOYEE_ID;
    v_work_per := v_work_per - :OLD.WORK_PERCENTAGE;
    UPDATE OZU_EMPLOYEES SET TOTAL_WORK_PERCENTAGE = v_work_per WHERE EMPLOYEE_ID = :OLD.EMPLOYEE_ID;
  END IF;
END;

CREATE TABLE OZU_AUDIT_TASKS (
  C_TASK_ID    NUMBER(4),
  C_DATE       DATE,
  C_OLD_STATUS VARCHAR2(1),
  C_NEW_STATUS VARCHAR2(1)
);

CREATE TABLE OZU_AUDIT_PROJECTS (
  C_PROJECT_ID    NUMBER(4),
  C_DATE       DATE,
  C_OLD_STATUS VARCHAR2(1),
  C_NEW_STATUS VARCHAR2(1)
);

CREATE OR REPLACE TRIGGER task_audit_trigger
AFTER UPDATE OF TASK_STATUS ON OZU_TASKS
FOR EACH ROW
BEGIN
  INSERT INTO OZU_AUDIT_TASKS(C_TASK_ID, C_DATE, C_OLD_STATUS, C_NEW_STATUS)
  VALUES(:NEW.TASK_ID,CURRENT_DATE,:OLD.TASK_STATUS,:NEW.TASK_STATUS);
END;

CREATE OR REPLACE TRIGGER project_audit_trigger
AFTER UPDATE OF PROJECT_STATUS ON OZU_PROJECTS
FOR EACH ROW
BEGIN
  INSERT INTO OZU_AUDIT_PROJECTS(C_PROJECT_ID, C_DATE, C_OLD_STATUS, C_NEW_STATUS)
  VALUES(:NEW.PROJECT_ID,CURRENT_DATE,:OLD.PROJECT_STATUS,:NEW.PROJECT_STATUS);
END;