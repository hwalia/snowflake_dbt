CREATE OR REPLACE TASK DEMO.DEMO_SCHEMA.WEATHERTASK
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 0 * * * UTC'
ALLOW_OVERLAPPING_EXECUTION =  FALSE 
USER_TASK_TIMEOUT_MS = 300000 
SUSPEND_TASK_AFTER_NUM_FAILURES = 3
TASK_AUTO_RETRY_ATTEMPTS = 2
  AS
COPY INTO DEMO.DEMO_SCHEMA.WEATHER
FROM
(
	select
	t.$1:city:findname, //$1 represent the first column in stage table.
	t.$1:city:coord:lat,
	t.$1:city:coord:lon,
	t.$1:clouds:all,
	t.$1:main:humidity,
	t.$1:main:pressure,
	t.$1:main:temp,
	t.$1:time,
	t.$1:weather[0]:main
	FROM @DEMO.DEMO_SCHEMA.weather_stage t
);

CREATE OR REPLACE TASK DEMO.DEMO_SCHEMA.BIKETASK
WAREHOUSE = COMPUTE_WH
ALLOW_OVERLAPPING_EXECUTION =  FALSE 
USER_TASK_TIMEOUT_MS = 300000 
--SUSPEND_TASK_AFTER_NUM_FAILURES = 3 //Cannot set parameter SUSPEND_TASK_AFTER_NUM_FAILURES on non-root task BIKETASK. Non-root tasks use the parameter setting from their root task. Please set this on the root task for this task instead.
-- TASK_AUTO_RETRY_ATTEMPTS = 2 // Cannot set parameter TASK_AUTO_RETRY_ATTEMPTS on non-root task BIKETASK. Non-root tasks use the parameter setting from their root task. Please set this on the root task for this task instead.
AFTER DEMO.DEMO_SCHEMA.WEATHERTASK
  AS
COPY INTO DEMO.DEMO_SCHEMA.BIKE
        FROM
        (
        SELECT
        t.$1,
        t.$2,
        t.$3,
        t.$4,
        t.$5,
        t.$6,
        t.$7,
        t.$8,
        t.$9,
        t.$10,
        t.$11,
        t.$12,
        t.$13
        FROM
        @DEMO_SCHEMA.BIKE_STAGE t);

//By default all tasks created are in suspended state
SHOW TASKS; --check the state column to see current status

/*To resume status we can alter them. Order is very crucial when resuming tasks. 
child tasks (dependent) should be resumed first with ROOT (parent) task at last.
Unable to update graph with root task DEMO.DEMO_SCHEMA.WEATHERTASK since that root task is not suspended. */

ALTER TASK DEMO.DEMO_SCHEMA.BIKETASK RESUME;
ALTER TASK DEMO.DEMO_SCHEMA.WEATHERTASK RESUME;

//verify to see if tasks are resumed
SHOW TASKS;

//to run the task, use execute command
EXECUTE TASK DEMO.DEMO_SCHEMA.WEATHERTASK;

//How to query task history
SELECT * 
    FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
    ORDER BY SCHEDULED_TIME DESC;

//If you filter on the database and schema name, you can see the state of task as SUCCEEDED, FAILED, OR SCHEDULED
SELECT * 
    FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
    WHERE DATABASE_NAME = 'DEMO' AND SCHEMA_NAME = 'DEMO_SCHEMA'
    ORDER BY SCHEDULED_TIME DESC;