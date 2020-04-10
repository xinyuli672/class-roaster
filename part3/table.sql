
#WIP??

CREATE TABLE concentration(
	concentration_name, min_gpa DECIMAL(2,1), min_unit int, degree_type, degree_name
    CONSTRAINT pk_concentration PRIMARY KEY(concentration_name)
);
CREATE TABLE concentration_course(
	concentration_name,	course_id,  
	CONSTRAINT pk_cc PRIMARY KEY(concentration_name, course_id),
	FOREIGN KEY (concentration_name) REFERENCES concentration,
	FOREIGN KEY (course_id) REFERENCES course
);
CREATE TABLE have_taken(
    student_ssn int, course_number, quarter, year int, grade_option, unit int,	grade,
    CONSTRAINT pk_ht PRIMARY KEY(student_ssn,course_number),
	FOREIGN KEY (student_ssn) REFERENCES student,
	FOREIGN KEY (course_number) REFERENCES class
);

CREATE TABLE graduate(
    student_ssn int, department_name,
    CONSTRAINT pk_graduate PRIMARY KEY(student_ssn),
    FOREIGN KEY (student_ssn) REFERENCES student,
    FOREIGN KEY (department_name) REFERENCES department
);




#courses in every concentraion in selected degree the selected student has not taken yet. 
SELECT con.concentration_name, c.course_number, c.title, c.currently_taught, c.quarter_next, c.year_next 
FROM  class c, concentration con, concentration_course cc
WHERE con.degree_name = " + degreename +" 
  AND con.degree_type = 'M.S.'
  AND con.concentration_course = cc.course_id
  AND c.course_number = cc.concentration_course
  AND NOT EXISTS (SELECT * 
                  FROM have_taken h 
                  WHERE h.student_ssn = "+ SSN + ") 
GROUP BY con.concentration_name


SELECT con.concentration_name, c.course_number, c.title, c.currently_taught, c.quarter_next, c.year_next FROM class c, concentration con, concentration_course cc WHERE con.degree_name = " + degreename +" AND con.degree_type = 'M.S.' AND con.concentration_course = cc.course_id AND c.course_number = cc.concentration_course AND NOT EXISTS (SELECT * FROM have_taken h WHERE h.student_ssn = "+ SSN + ") GROUP BY con.concentration_name





#display concentrations completed
#check the units taken for per concentration, unitstaken >= min_unit req'd
#check the gpa for courses count toward concentration, gap >= min_gpa req'd
#ignore classes with IN grade and s/u (check grade_option) for gpa
#ignore classes with IN for unit

SELECT DISTINCT c.concentration_name, 
                SUM(h.unit*g.NUMBER_GRADE)/SUM(h.unit) AS gpa 
FROM concentration c, concentration_course cc, have_taken h, grade_conversion g 
WHERE h.student_ssn = " + SSN + "
  AND c.concentration_name = cc.concentration_name 
  AND cc.course_id = h.course_number 
  AND g.LETTER_GRADE = h.grade
  AND h.grade <> 'IN'
  AND h.grade_option <> 'S/U'
  AND NOT EXISTS (
  	     SELECT * 
  	     FROM concentration_course req 
  	     WHERE gpa < req.min_gpa 
  	       AND req.concentration_name = cc.concentration_name ) 
  GROUP BY c.concentration_name

NATURAL JOIN

SELECT DISTINCT c.concentration_name, 
                SUM(h.unit) AS unitstaken, 
FROM concentration c, concentration_course cc, have_taken h, grade_conversion g 
WHERE h.student_ssn = " + SSN + "
  AND c.concentration_name = cc.concentration_name 
  AND cc.course_id = h.course_number 
  AND g.LETTER_GRADE = h.grade
  AND h.grade <>  "IN"
  AND NOT EXISTS (
  	     SELECT * 
  	     FROM concentration_course req 
  	     WHERE unitstaken < req.min_unit
  	       AND req.concentration_name = cc.concentration_name ) 
  GROUP BY c.concentration_name

















SELECT DISTINCT c.concentration_name, SUM(h.unit*g.NUMBER_GRADE)/SUM(h.unit) AS gpa FROM concentration c, concentration_course cc, have_taken h, grade_conversion g WHERE h.student_ssn = " + SSN + " AND c.concentration_name = cc.concentration_name AND cc.course_id = h.course_number AND g.LETTER_GRADE = h.grade AND h.grade <> 'IN' AND h.grade_option <> 'S/U' AND NOT EXISTS (SELECT * FROM concentration_course req WHERE gpa < req.min_gpa AND req.concentration_name = cc.concentration_name ) GROUP BY c.concentration_name
JOIN
SELECT DISTINCT c.concentration_name, 
                SUM(h.unit) AS unitstaken, 
FROM concentration c, concentration_course cc, have_taken h, grade_conversion g 
WHERE h.student_ssn = " + SSN + "
  AND c.concentration_name = cc.concentration_name 
  AND cc.course_id = h.course_number 
  AND g.LETTER_GRADE = h.grade
  AND h.grade <>  "IN"
  AND NOT EXISTS (
  	     SELECT * 
  	     FROM concentration_course req 
  	     WHERE unitstaken < req.min_unit
  	       AND req.concentration_name = cc.concentration_name ) 
  GROUP BY c.concentration_name