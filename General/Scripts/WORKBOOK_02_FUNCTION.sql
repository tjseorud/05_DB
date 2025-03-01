SELECT * FROM TB_DEPARTMENT;
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_PROFESSOR;
SELECT * FROM TB_CLASS;
SELECT * FROM TB_GRADE;

--1
SELECT STUDENT_NO AS"학번",STUDENT_NAME AS"이름",ENTRANCE_DATE AS"입학년도" 
FROM TB_STUDENT
WHERE DEPARTMENT_NO ='002'
ORDER BY ENTRANCE_DATE ASC;

--2
SELECT PROFESSOR_NAME,PROFESSOR_SSN FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';

--3
SELECT PROFESSOR_NAME AS "교수이름",2025-TO_NUMBER('19'||SUBSTR(PROFESSOR_SSN,1,2)) AS"나이"
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1) ='1'
ORDER BY "나이" ASC, PROFESSOR_NAME ASC;

--4
SELECT SUBSTR(PROFESSOR_NAME,2) AS "이름" FROM TB_PROFESSOR;

--5
SELECT STUDENT_NO,STUDENT_NAME FROM TB_STUDENT ;
--WHERE TO_NUMBER(SUBSTR)-||SUBSTR(STUDENT_SSN,1,2);

--6
SELECT STUDENT_NO,STUDENT_NAME FROM TB_STUDENT 
WHERE STUDENT_NO NOT LIKE 'A%';

--7
SELECT ROUND(AVG(POINT),1) AS "평점" FROM TB_STUDENT s,TB_GRADE g
WHERE s.STUDENT_NO = g.STUDENT_NO AND S.STUDENT_NAME ='한아름';

--8

SELECT DEPARTMENT_NO AS "학과번호", COUNT(*)AS"학생수(명)" FROM TB_STUDENT
GROUP BY DEPARTMENT_NO 
ORDER BY DEPARTMENT_NO ASC;
--9
SELECT COUNT(*) FROM TB_STUDENT 
WHERE COACH_PROFESSOR_NO IS NULL;

--10
SELECT SUBSTR(g.TERM_NO,1,4)AS TERM_NO ,ROUND(AVG(POINT),1)AS "년도 별 평점"
FROM TB_STUDENT s
	LEFT JOIN TB_GRADE g ON(s.STUDENT_NO=g.STUDENT_NO)
WHERE s.STUDENT_NO ='A112113'
GROUP BY g.TERM_NO ;

--11
SELECT 
	DEPARTMENT_NO AS "학과번호", 
	COUNT(DECODE(ABSENCE_YN,'Y','휴학', ''))AS"학생수(명)" ,
	--COUNT(컬럼명|함수식) :컬럼에 값이 몇개있는가 카운트(NULL 제외)
	SUM(DECODE(ABSENCE_YN,'Y',1 ,'N',0))AS"학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO 
ORDER BY DEPARTMENT_NO ASC;

--12
SELECT STUDENT_NAME AS "동일이름" ,COUNT(*)AS"동명인 수"  FROM TB_STUDENT
GROUP BY STUDENT_NAME
	HAVING STUDENT_NAME = STUDENT_NAME;

--13
SELECT 
	NVL(SUBSTR(TERM_NO,1,4),' ')AS "년도" ,
	NVL(SUBSTR(TERM_NO,5,2),' ')AS "학기" ,
	ROUND(AVG(POINT),1)AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO ='A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO,1,4) ,SUBSTR(TERM_NO,5,2))
ORDER BY SUBSTR(TERM_NO,1,4) ASC;
