CREATE OR REPLACE STAGE DEMO.DEMO_SCHEMA.bike_stage;

list @DEMO.DEMO_SCHEMA.BIKE_STAGE;

ALTER STAGE DEMO_SCHEMA.BIKE_STAGE REFRESH;

CREATE OR REPLACE FILE FORMAT CSVBIKE type='csv' field_delimiter=',';

select
    t.$1
    ,t.$2
    ,t.$3
    ,t.$4
    ,t.$5
    ,t.$6
    ,t.$7
    ,t.$8
    ,t.$9
    ,t.$10
    ,t.$11
    ,t.$12
    ,t.$13
    ,t.$14
    ,t.$15
FROM
    @DEMO.DEMO_SCHEMA.BIKE_STAGE (FILE_FORMAT => 'CSVBIKE') t limit 100;


CREATE OR REPLACE TABLE DEMO.DEMO_SCHEMA.BIKE 
(
    TRIPDURATION STRING
    ,STARTTIME STRING
    ,STOPTIME STRING	
    ,START_STATION_ID STRING	
    ,START_STATION_NAME STRING	
    ,START_STATION_LATITUDE STRING	
    ,START_STATION_LONGITUDE STRING	
    ,END_STATION_ID STRING	
    ,END_STATION_NAME STRING	
    ,END_STATION_LATITUDE STRING	
    ,END_STATION_LONGITUDE STRING	
    ,BIKEID STRING	
    ,USERTYPE STRING	
    ,BIRTH_YEAR STRING	
    ,GENDER STRING
);

        

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
        t.$13,
        t.$14,
        t.$15
    FROM
    @DEMO_SCHEMA.BIKE_STAGE t
);