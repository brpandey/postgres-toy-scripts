CREATE TABLE Courses (
course_id SERIAL PRIMARY KEY,
course_name varchar(31),
teacher_id smallint REFERENCES Teachers
);

CREATE TABLE Teachers (
teacher_id SERIAL PRIMARY KEY,
teacher_name varchar(20)
);

CREATE TABLE Students (
student_id SERIAL PRIMARY KEY,
student_name varchar(31)
);

CREATE TABLE StudentCourses (
course_id smallint REFERENCES Courses,
student_id integer REFERENCES Students,
PRIMARY KEY (course_id, student_id));


INSERT INTO Teachers (teacher_name) VALUES ('Alan Turing'), ('Ada Lovelace'),('Grace Hopper'),('Donald Knuth');
INSERT INTO Teachers (teacher_name) VALUES ('John McCarthy'), ('Dennis Ritchie'),('Edsger Dijkstra'), ('John von Neuman');

INSERT INTO Courses (course_name, teacher_id) VALUES ('CSE326', 1), ('CSE450', 2), ('CSE341', 3), ('CSE421', 4);

 INSERT INTO Students (student_name) VALUES ('Rasmus Lerdorf'), ('Bjarne Stroustrup'), ('Larry Wall'), 
 ('Guido van Rossum'), ('Bram Cohen'), ('Brendan Eich'), ('Douglas Crockford'), ('Yukihiro Matsumoto'), 
 ('John Resig'), ('John D. Carmack'), ('Linus Torvalds'), ('Larry Page'), ('Mark Zuckerberg'), ('Jack Dorsey'), 
 ('Paul Graham'), ('Doug Cutting'), ('Michael Stonebraker'), ('David H. Hansson'), ('Rich Hickey'), 
 ('Brian Behlendorf'); 


INSERT INTO StudentCourses VALUES (2,1), (3,2), (1,3), (4,4), (3,5), (2,6), (2,7), (2,8), (2,9), (1,10), (1,11), (4,12), (4, 13), (3, 14), (2,15), (1, 16), (3, 17), (1,18), (4, 19), (4,20); 

INSERT INTO StudentCourses VALUES (3,1), (2,2), (3,3), (2,5),  (1,8), (4,9), (2, 14), (1,15), (4, 16),  (2, 19), (1,20); 


/*Query 1 - Student Enrollment - 
Get a list of all students and how many courses each student is enrolled in #broken down*/

SELECT Students.student_id, StudentCourses.course_id        
FROM Students LEFT JOIN StudentCourses
ON Students.student_id = StudentCourses.student_id;


SELECT Students.student_id, count(StudentCourses.course_id) as Cnt
FROM Students LEFT JOIN StudentCourses
ON Students.student_id = StudentCourses.student_id
GROUP BY Students.student_id


SELECT Students.student_name, Students.student_id, num_courses
FROM (
 SELECT Students.student_id, count(StudentCourses.course_id) as num_courses
 FROM Students LEFT JOIN StudentCourses
 ON Students.student_id = StudentCourses.student_id
 GROUP BY Students.student_id
) T
INNER JOIN Students on T.student_id = Students.student_id
ORDER BY Students.student_name;

/* or */
CREATE VIEW enrollment AS 
SELECT Students.student_id, count(StudentCourses.course_id) as num_courses
 FROM Students LEFT JOIN StudentCourses
 ON Students.student_id = StudentCourses.student_id
 GROUP BY Students.student_id
;

SELECT Students.student_name, Students.student_id, num_courses 
FROM enrollment INNER JOIN Students 
ON enrollment.student_id = Students.student_id
ORDER BY Students.student_name;

/*
    student_name    | student_id | num_courses 
--------------------+------------+-------------
 Douglas Crockford  |          7 |           1
 Doug Cutting 			|         16 |           2
 Rasmus Lerdorf     |          1 |           2
 Larry Wall       	|          3 |           2
 Mark Zuckerberg    |         13 |           1
 Yukihiro Matsumoto |          8 |           2
 Brendan Eich       |          6 |           1
 Guido van Rossum   |          4 |           1
 John Resig         |          9 |           2
 David H. Hansson   |         18 |           1
 John D. Carmack    |         10 |           1
 Bjarne Stroustrup  |          2 |           2
 Paul Graham  			|         15 |           2
 Rich Hickey        |         19 |           2
 Bram Cohen        	|          5 |           2
 Linus Torvalds     |         11 |           1
 Brian Behlendorf   |         20 |           2
 Larry Page      		|         12 |           1
 Michael Stonebraker|         17 |           1
 Jack Dorsey      	|         14 |           2
(20 rows)
*/

/* or simply */

SELECT Students.student_name, Students.student_id, count(StudentCourses.course_id)
FROM Students LEFT JOIN StudentCourses
ON Students.student_id = StudentCourses.student_id
GROUP BY Students.student_id, Students.student_name 
ORDER BY Students.student_name;



/*Query 2 - Teacher Class Size - 
Get a list of all teachers and how many students they each teach.  
If a teacher teaches the same student in two courses, you should double count the student.
Sort the list in descending order of the number of students a teacher teaches*/

/*First get a list of Teacher IDs and how many students are associated with each Teacher ID*/
SELECT Teachers.teacher_name, Teachers.teacher_id, num_students                              
FROM (
 SELECT Courses.teacher_id as teacher_id, count(StudentCourses.student_id) as num_students
 FROM Courses INNER JOIN StudentCourses 
 ON Courses.course_id = StudentCourses.course_id 
 GROUP BY Courses.teacher_id ) 
SS INNER JOIN Teachers 
ON SS.teacher_id = Teachers.teacher_id;

/*
 teacher_name  | teacher_id | num_students 
----------------+------------+--------------
 Donald Knuth  |          4 |            7
 Alan Turing 	 |          1 |            8
 Grace Hopper  |          3 |            6
 Ada Lovelace  |          2 |           10
(4 rows)
*/

/*Without the grouping*/
SELECT Teachers.teacher_name, Teachers.teacher_id, student_id
FROM (
 SELECT Courses.teacher_id as teacher_id, StudentCourses.student_id as student_id
 FROM Courses INNER JOIN StudentCourses ON Courses.course_id = StudentCourses.course_id ORDER BY teacher_id) 
SS INNER JOIN Teachers 
ON SS.teacher_id = Teachers.teacher_id;

/*
  teacher_name  | teacher_id | student_id 
----------------+------------+------------
 Alan Turing 		|          1 |         20
 Alan Turing 		|          1 |          3
 Alan Turing 		|          1 |         10
 Alan Turing 		|          1 |         11
 Alan Turing 		|          1 |         16
 Alan Turing 		|          1 |         18
 Alan Turing 		|          1 |          8
 Alan Turing 		|          1 |         15
 Ada Lovelace 	|          2 |          9
 Ada Lovelace  	|          2 |         14
 Ada Lovelace  	|          2 |         15
 Ada Lovelace  	|          2 |          1
 Ada Lovelace  	|          2 |          2
 Ada Lovelace  	|          2 |          5
 Ada Lovelace  	|          2 |         19
 Ada Lovelace  	|          2 |          6
 Ada Lovelace  	|          2 |          7
 Ada Lovelace  	|          2 |          8
 Grace Hopper 	|          3 |          1
 Grace Hopper 	|          3 |         14
 Grace Hopper 	|          3 |          3
 Grace Hopper 	|          3 |          2
 Grace Hopper 	|          3 |         17
 Grace Hopper 	|          3 |          5
 Donald Knuth   |          4 |         19
 Donald Knuth   |          4 |         16
 Donald Knuth   |          4 |         20
 Donald Knuth   |          4 |          9
 Donald Knuth   |          4 |         12
 Donald Knuth   |          4 |         13
 Donald Knuth   |          4 |          4
(31 rows)
*/

/*Add RIGHT JOIN to select those teachers that aren't teaching any classes as reflected in StudentCourses*/
SELECT Teachers.teacher_name, Teachers.teacher_id, num_students                              
FROM (
 SELECT Courses.teacher_id as teacher_id, count(StudentCourses.student_id) as num_students
 FROM Courses INNER JOIN StudentCourses 
 ON Courses.course_id = StudentCourses.course_id 
 GROUP BY Courses.teacher_id ) 
SS RIGHT JOIN Teachers 
ON SS.teacher_id = Teachers.teacher_id;

/*
teacher_name  		| teacher_id | num_students 
----------------+------------+--------------
 Donald Knuth 		|          4 |            7
 Alan Turing 			|          1 |            8
 Grace Hopper 		|          3 |            6
 Ada Lovelace 		|          2 |           10
 John McCarthy		|          5 |             
 John von Neuman	|          8 |             
 Dennis Ritchie 	|          6 |             
 Edsger Dijkstra 	|          7 |             
(8 rows)
*/
