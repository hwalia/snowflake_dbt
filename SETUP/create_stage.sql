//Providing a external link make it an external stage
CREATE OR REPLACE STAGE DEMO.DEMO_SCHEMA.weather_stage
URL = 's3://snowflake-workshop-lab/weather-nyc'
//defining file format of stage
FILE_FORMAT = (TYPE = JSON);


LIST @DEMO.DEMO_SCHEMA.weather_stage;