CREATE OR REPLACE TABLE DEMO.DEMO_SCHEMA.WEATHERTABLE (data variant);

COPY INTO DEMO.DEMO_SCHEMA.WEATHERTABLE
FROM @DEMO.DEMO_SCHEMA.weather_stage;

SELECT *
FROM DEMO.DEMO_SCHEMA.WEATHERTABLE;

SELECT data:city:findname,
data:city:coord:lat,
data:city:coord:lon,
data:clouds:all,
data:main:humidity,
data:main:pressure,
data:main:temp,
data:time,
data:weather[0].main //weather is a list (array). we need to specify the index
FROM DEMO.DEMO_SCHEMA.WEATHERTABLE;


CREATE OR REPLACE TABLE DEMO.DEMO_SCHEMA.WEATHER (
	CITYNAME STRING,
	LAT FLOAT,
	LON FLOAT,
	CLOUDS INTEGER,
	HUMIDITY INTEGER,
	PRESSURE FLOAT,
	TEMP FLOAT,
	TIME TIMESTAMP,
	WEATHER STRING
);


// Examples on querying straight from a stage : https://docs.snowflake.com/en/user-guide/querying-stage#query-examples


//Command used to Copy data from the weather_stage into the end table WEATHER:

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

SELECT *
FROM DEMO.DEMO_SCHEMA.WEATHER;
    