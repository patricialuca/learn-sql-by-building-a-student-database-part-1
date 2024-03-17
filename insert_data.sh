#!/bin/bash
#Script to insert data from courses.csv and students.csv into students database
#Creamos un bucle que lea cada una de las lineas del archivo courses.csv
#La primera parte se asigna a la variable "MAJOR" y la segunda parte se asigna
#a la variable "COURSE". Luego, el script imprime el valor de la variable
#"MAJOR" en cada iteración del bucle.
#Tenemos que establecer la tabulación correcta introduciendo IFS=","
#Para correr el script ./insert_data.sh
PSQL="psql -X --username=freecodecamp --dbname=students --no-align --tuples-only -c"
echo $($PSQL "TRUNCATE students, majors, courses, majors_courses")
cat courses_test.csv | while IFS="," read MAJOR COURSE 
do
if [[ $MAJOR != major ]]
  then
    #get major_id
    MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")
    #if not found
    if [[ -z $MAJOR_ID ]]
      then
        #insert major
        INSERT_MAJOR_RESULT=$($PSQL "INSERT INTO majors(major) VALUES('$MAJOR')")
        if [[ $INSERT_MAJOR_RESULT == "INSERT 0 1" ]]
          then
            echo Inserted into majors, $MAJOR
          fi
        #get new major_id
        MAJOR_ID=$($PSQL "SELECT major_id FROM majors WHERE major='$MAJOR'")
      fi
    #get course_id
    COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")
    #if not found
    if [[ -z $COURSE_ID ]]
      then
        #insert course
        INSERT_COURSE_RESULT=$($PSQL "INSERT INTO courses(course) VALUES('$COURSE')")
        if [[ $INSERT_COURSE_RESULT == "INSERT 0 1" ]]
          then
            echo Inserted into courses, $COURSE
          fi
        #get new course_id
        COURSE_ID=$($PSQL "SELECT course_id FROM courses WHERE course='$COURSE'")
      fi
    #insert into majors_courses
    INSERT_MAJORS_COURSES_RESULT=$($PSQL "INSERT INTO majors_courses(major_id, course_id) VALUES($MAJOR_ID, $COURSE_ID)")
    if [[ $INSERT_MAJORS_COURSES_RESULT == "INSERT 0 1" ]]
          then
            echo Inserted into majors_courses, $MAJOR : $COURSE
          fi
  fi
done