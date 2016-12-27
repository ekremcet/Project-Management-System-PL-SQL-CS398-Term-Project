/* Project Leader Trigger Tests */
INSERT INTO OZU_PROJECTS(PROJECT_ID, PROJECT_NAME,
                         PROJECT_STATUS, PROJECT_START_DATE, PROJECT_END_DATE)
VALUES(2007,'UI DEVELOPMENT','P',CURRENT_DATE,CURRENT_DATE);

INSERT INTO OZU_PROJECTS(PROJECT_ID, PROJECT_NAME,
                         PROJECT_STATUS, PROJECT_START_DATE, PROJECT_END_DATE)
VALUES(2008,'WEB SITE DEVELOPMENT','S',CURRENT_DATE,CURRENT_DATE);

UPDATE OZU_PROJECTS SET LEADER_ID = 344166 WHERE PROJECT_ID = 2007;
UPDATE OZU_PROJECTS SET PROJECT_STATUS = 'S' WHERE PROJECT_ID = 2007;
UPDATE OZU_PROJECTS SET LEADER_ID = NULL WHERE PROJECT_ID = 2007;

DELETE FROM OZU_PROJECTS WHERE PROJECT_ID = 2007;
/**/

/* Member Count Trigger Test */
INSERT INTO OZU_PROJECT_TEAMS(PROJECT_ID, EMPLOYEE_ID, WORK_PERCENTAGE)
VALUES(2003,268721,0.15);

INSERT INTO OZU_PROJECT_TEAMS(PROJECT_ID, EMPLOYEE_ID, WORK_PERCENTAGE)
VALUES(2004,268721,0.15);

INSERT INTO OZU_PROJECT_TEAMS(PROJECT_ID, EMPLOYEE_ID, WORK_PERCENTAGE)
VALUES(2006,268721,0.15); /* 6th Project - Error */

DELETE FROM OZU_PROJECT_TEAMS WHERE PROJECT_ID = 2006 AND EMPLOYEE_ID = 268721;

INSERT INTO OZU_PROJECT_TEAMS(PROJECT_ID, EMPLOYEE_ID, WORK_PERCENTAGE)
VALUES(2006,268721,0.15);

DELETE FROM OZU_PROJECT_TEAMS WHERE PROJECT_ID = 2006 AND EMPLOYEE_ID = 268721;
DELETE FROM OZU_PROJECT_TEAMS WHERE PROJECT_ID = 2004 AND EMPLOYEE_ID = 268721;
DELETE FROM OZU_PROJECT_TEAMS WHERE PROJECT_ID = 2003 AND EMPLOYEE_ID = 268721;
/**/

/* Work Percentage Trigger Test */
INSERT INTO OZU_PROJECT_TEAMS(PROJECT_ID, EMPLOYEE_ID, WORK_PERCENTAGE)
VALUES(2003,268721,0.45);

INSERT INTO OZU_PROJECT_TEAMS(PROJECT_ID, EMPLOYEE_ID, WORK_PERCENTAGE)
VALUES(2004,268721,0.35); /* Current work per is 0.85, this dml gives error */

INSERT INTO OZU_PROJECT_TEAMS(PROJECT_ID, EMPLOYEE_ID, WORK_PERCENTAGE)
VALUES(2004,268721,0.15); /* Now the total is 1 */

UPDATE OZU_PROJECT_TEAMS SET WORK_PERCENTAGE = 0.25 WHERE EMPLOYEE_ID = 268721 AND PROJECT_ID = 2003;
/**/

/* Project Leader Check */
UPDATE OZU_PROJECTS SET LEADER_ID = 587191 WHERE PROJECT_ID = 2001;
UPDATE OZU_PROJECTS SET LEADER_ID = 442461 WHERE PROJECT_ID = 2001; /*Error*/
UPDATE OZU_PROJECTS SET LEADER_ID = 392051 WHERE PROJECT_ID = 2001; /*Correct*/
/**/

/* AUDIT Tests */
UPDATE OZU_PROJECTS SET PROJECT_STATUS = 'S' WHERE PROJECT_ID = 2002;
UPDATE OZU_PROJECTS SET PROJECT_STATUS = 'F' WHERE PROJECT_ID = 2002;

UPDATE OZU_TASKS SET TASK_STATUS = 'S' WHERE TASK_ID = 3324;
UPDATE OZU_TASKS SET TASK_STATUS = 'F' WHERE TASK_ID = 3324;

SELECT * FROM OZU_AUDIT_PROJECTS;
SELECT * FROM OZU_AUDIT_TASKS;
/**/
