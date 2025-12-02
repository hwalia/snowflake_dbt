//Providing a external link make it an external stage
CREATE OR REPLACE STAGE DEMO.DEMO_SCHEMA.weather_stage
URL = 's3://snowflake-workshop-lab/weather-nyc'
//defining file format of stage
FILE_FORMAT = (TYPE = JSON);
//defining type = JSON make all the the data in first column as JSON can only produce only one column.

LIST @DEMO.DEMO_SCHEMA.weather_stage;