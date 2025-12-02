-- STEP 1: Create your database and schema
CREATE OR REPLACE DATABASE PETS;
CREATE OR REPLACE SCHEMA PETS.PETS_SCHEMA;

-- STEP 2: Create the external stage
-- TO DO: Use the URL 's3://snowflake-dbt-hands-on/' and file format JSON
CREATE OR REPLACE STAGE DEMO.DEMO_SCHEMA.external_pets_stage
URL = 's3://snowflake-dbt-hands-on/'
FILE_FORMAT = (TYPE = JSON);

{
  "age": 31,
  "hobbies": [
    "kayaking",
    "chess",
    "photography"
  ],
  "name": {
    "first": "Orion",
    "last": "Skylark"
  },
  "pet": {
    "name": "Nova",
    "type": "parrot",
    "vaccinated": true
  },
  "user_id": 201
}

-- STEP 3: Explore the data structure
SELECT *
    ,t.$1:name:last as lastname
    ,t.$1:age
    ,t.$1:hobbies[0]
    ,t.$1:pet:type
    ,t.$1:pet:name
FROM
@DEMO.DEMO_SCHEMA.external_pets_stage t;

-- STEP 4: Create your table structure
CREATE OR REPLACE TABLE PETS.PETS_SCHEMA.PETS (
  LASTNAME STRING,
  AGE INT,
  HOBBIE STRING,
  PET_NAME STRING,
  PET_TYPE STRING
);

-- STEP 5: COMPLETE AND EXECUTE THE COPY INTO STATEMENT ( Try and select the first Hobbie of the list per user)

COPY INTO PETS.PETS_SCHEMA.PETS
FROM (
        SELECT t.$1:name:last as lastname
            ,t.$1:age
            ,t.$1:hobbies[0]
            ,t.$1:pet:type
            ,t.$1:pet:name
        FROM
        @DEMO.DEMO_SCHEMA.external_pets_stage t
);

-- STEP 6: Validate your result
SELECT * FROM PETS.PETS_SCHEMA.PETS;

-- STEP 7: Clean up
--DROP DATABASE PETS;
