/*SELECT
 * -지정된 테이블에서 원하는 데이터가 존재하는지 행,열을 선택해서 조회하는 SQL(구조적 질의 언어)
 * -선택된 데이터 == 조회 결과 묶음 == RESULT SET
 * -조회 결과는 0행 이상(조건에 맞는 행이 없을수 있다)
 * */
/*[SELECT 작성법 1]
 * 2)SELECT * || 컬럼명, ...
 * 1)FROM 테이블명;
 * -지정된 테이블의 모든 행에서 특정 열(컬럼)만 조회하기
 * */
--EMPLOYEE 테이블에서 모든 행의 이름(EMP_NAME),급여(SALARY) 컬럼조회
SELECT EMP_NAME,SALARY FROM EMPLOYEE;

--EMPLOYEE 테이블에서 모든 행(== 모든 사원)의 사번, 이름, 급여 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE;

--EMPLOYEE 테이블에서 모든 행,열 조회 --> *(asterisk) "모든","포함"을 내타내는 기호
SELECT * FROM EMPLOYEE;

--DEPARTMENT 테이블에서 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

--EMPLOYEE 테이블에서 이름, 이메일, 전화번호 조회
SELECT EMP_NAME,EMAIL,PHONE FROM EMPLOYEE;

----
/*컬럼 값 산술연산*/
/*컬럼 값 :행과 열이 교차되는 한 칸에 작성된 값
 * -SELECT문 작성시 SELECT절 컬럼명에 산술연산을 작성하면
 *  조회결과()에서 모든행에 산술연산이 적용된 컬럼값이 조회된다
 * */
--EMPLOYEE 테이블에서 모든 사원의 이름, 급여, 급여 + 100만 조회
SELECT EMP_NAME,SALARY,SALARY+1000000 FROM EMPLOYEE;

--모든 사원의 이름, 급여(1개월), 연봉(급여 * 12) 조회
SELECT EMP_NAME,SALARY,SALARY*12 FROM EMPLOYEE;

----
/*SYSDATE / CURRENT_DATE
 *SYSTIMESTAMP /CURRENT_TIMESTAMP
 * *DB는 날짜/시간 관련 데이터를 다룰 수 있도록하는 자료형 제공
 * 
 * -DATE 타입 			:년,월,일,시,분,초,요일 저장
 * -TIMESTAMP 타입	:년,월,일,시,분,초,요일,ms, 지역 저장
 * 
 * -SYS(시스템)			:시스템에 설정된 시간
 * -CURRENT 			:현재 접속된 세션(사용자)의 시간 기반
 * 
 * -SYSDATE 현재 	:시스템 시간 얻어오기
 * -CURRENT_DATE 	:현재 사용자계정 기반 시간 얻어오기
 * *DATE ->TIMESTAMP 바꾸면 ms단위 + 지역정보를 추가로 얻어옴
 * */
SELECT SYSDATE , CURRENT_DATE FROM DUAL;
SELECT SYSTIMESTAMP , CURRENT_TIMESTAMP FROM DUAL;
/*DUAL(DUmmy tAbLe) 테이블
 * -임시 테이블(가짜 테이블)
 * -조회하려는 데이터가 실제테이블에 저장된 데이터가 아닌 경우 사용하는 임시테이블*/

/*날짜 데이터 연산하기 (+,-,만 가능)*/
--날짜 + 정수 :정수만큼 "일"수 증가
--날짜 - 정수 :정수만큼 "일"수 감소

--어제,오늘,내일,모레 조회
SELECT CURRENT_DATE -1,CURRENT_DATE ,CURRENT_DATE +1,CURRENT_DATE +2 FROM dual;

/*시간 연산 응용(알아두면 도움됨)*/
SELECT CURRENT_DATE,
	CURRENT_DATE +1/24,	-- +1시간
	CURRENT_DATE +1/24/60,	-- +1분
	CURRENT_DATE +1/24/60/60,	-- +1초
	CURRENT_DATE +1/24/60/60*30	-- +30초
FROM dual;

/*날짜 끼리 - 연산
 * 날짜 -날짜 =두 날짜 사이의 차이나는 일 수
 * 
 * *TO_DATE('날짜모양문자열','인식패턴')
 *  ->'날짜모양문자열'을 '인식패턴'을 이용해 해석하여 DATE 타입으로 변환
 * */
SELECT TO_DATE('2025-02-19','YYYY-MM-DD'),'2025-02-19' FROM dual;

--오늘(2/19)부터 2/28 까지 남은일수
SELECT TO_DATE('2025-02-28','YYYY-MM-DD')-TO_DATE('2025-02-19','YYYY-MM-DD') FROM dual;

--종강일(7/17) 까지 남은일수
SELECT TO_DATE('2025-07-17','YYYY-MM-DD')-TO_DATE('2025-02-19','YYYY-MM-DD') FROM dual;

--퇴근시간까지 남은시간
SELECT (TO_DATE('2025-02-19 17:50:00','YYYY-MM-DD HH24:MI:SS')-CURRENT_DATE)*24*60 
FROM dual; 

--EMPLOYEE 테이블에서 모든 사원의 사번, 이름, 입사일, 현재까지 근무일수, 연차조회 
SELECT EMP_ID,EMP_NAME,HIRE_DATE,
	FLOOR(CURRENT_DATE-HIRE_DATE), 	--내림처리
	CEIL((CURRENT_DATE-HIRE_DATE)/365)	--올림처리
FROM EMPLOYEE;

----
/*컬럼명 별칭(Alias) 지정하기
 * [지정방법]
 * 1)컬럼명 AS 별칭		:문자 O, 띄어쓰기 X, 특수문자 X
 * 2)컬럼명 AS "별칭"	:문자 O, 띄어쓰기 O, 특수문자 O
 * *AS 구문은 생략가능
 * 
 * *ORACLE에서 ""의 의미
 *  -""내부에 작성된 글자모양 그대로를 인식해라
 * ex)문자열		오라클인식
 * 		abc 	->ABC,abc	(대소문자 구분 X)
 * 		"abc"	->abc			(""내부 작성된 모양으로만 인식)
 * */
--EMPLOYEE 테이블에서 모든 사원의 사번, 이름, 입사일, 현재까지 근무일수, 연차조회 
--단, 별칭 지정
SELECT 
	EMP_ID AS 사번,
	EMP_NAME 이름,
	HIRE_DATE AS "입사한 날짜",
	FLOOR(CURRENT_DATE-HIRE_DATE) "근무 일수", 	--내림처리
	CEIL((CURRENT_DATE-HIRE_DATE)/365) AS "연차"	--올림처리
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 모든 사원의 사번, 이름, 급여(원), 연봉(급여*12) 조회 
--단, 컬럼명은 모두 별칭 적용
SELECT 
	EMP_ID AS "사번",
	EMP_NAME AS "이름",
	SALARY AS "급여(원)",
	SALARY*12 AS "연봉(급여*12)"
FROM EMPLOYEE;

----
/*연결 연산자(||) 
 * -두 컬럼값 또는 리터럴을 하나의 문자열로 연결할때 사용
 * */
SELECT EMP_ID,EMP_NAME, EMP_ID||EMP_NAME FROM EMPLOYEE;

----
/*리터럴 :값(DATA)을 표기하는 방식(문법)
 * -NUMBER 타입	:정수,실수 표기
 * -CHAR,VARCHAR2 타입(문자열)	: 'AB','가나다' ('' 홑따옴표)
 * *SELECT절에 리터럴을 작성하면 조회결과(RESULT SET) 모든행에 리터럴이 추가된다
 */
SELECT SALARY,'원',SALARY ||'원' AS "급여" FROM EMPLOYEE;

----
/*DISTINCT(별개의, 전혀다른)
 * -조회결과 집합(RESULT SET)에서 DISTINCT가 지정된 컬럼에 중복된 값이 존재한 경우
 *  중복을 제거하고 한번만 표시할때 사용(중복된 데이터를 가진 행을 제거)
 * */
--EMPLOYEE 테이블에서 모든 사원의 부서코드(DEPT_CODE) 조회
SELECT DEPT_CODE FROM EMPLOYEE;
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;	--사원들이 속한 부서코드 조회(중복 X)

----
/*SELECT
 * 3)SELECT 컬럼명 || 리터럴, ...	--열 선택
 * 1)FROM 테이블명	--테이블 선택
 * 2)WHERE 조건식; 	--행 선택
 * */
/*WHERE
 * -테이블에서 조건을 충족하는 행을 조회할 때 사용
 * -WHERE 절에는 조건식(결과가 T/F)만 작성 가능
 * -비교 연산자 :<, >, <=, >=, =(같다), !=, <>(같지 않다)
 * -논리 연산자 :AND, OR, NOT
 * */
--EMPLOYEE 테이블에서 급여가 400만원을 초과하는 사원의 사번,이름,급여를 조회
SELECT 
	EMP_ID AS "사번",
	EMP_NAME "이름",
	SALARY "급여"
FROM EMPLOYEE 
WHERE SALARY >4000000;

--EMPLOYEE 테이블에서 급여가 500만원을 이하인 사원의 사번,이름,급여,부서코드,직급코드를 조회
SELECT 	
	EMP_ID AS "사번",
	EMP_NAME "이름",
	SALARY "급여",
	DEPT_CODE "부서코드",
	JOB_CODE "직급코드"
FROM EMPLOYEE 
WHERE SALARY <= 5000000;

--EMPLOYEE 테이블에서 연봉이 5천만원을 이하인 사원의 이름,연봉 조회
SELECT 	
	EMP_NAME "이름",
	SALARY *12 "연봉"
FROM EMPLOYEE 
WHERE SALARY *12 <= 50000000;

--이름이 '노옹철'인 사원의 사번,이름,전화번호 조회
SELECT EMP_ID "사번", EMP_NAME "이름", PHONE "전화번호"
FROM EMPLOYEE
WHERE EMP_NAME ='노옹철';

--부서코드(DEPT_CODE)가 'D9'이 아닌 사원의 이름, 부서코드 조회
SELECT EMP_NAME AS "이름", DEPT_CODE AS "부서코드"
FROM EMPLOYEE 
WHERE DEPT_CODE ='D9';

----
/*NULL
 * -DB에서 NULL :빈칸 (저장된 값이 없음)
 * -NULL은 비교 대상이 없기 때문에 =,!= 등의 비교 연산결과가 무조건 false
 * */
/*NULL 비교연산
 * 1)컬럼명 IS NULL 			:해당 컬럼 값이 NULL 이면 true 반환
 * 2)컬럼명 IS NOT NULL 	:해당 컬럼 값이 NULL 아니면 true 반환 == 컬럼에 값이 존재하면 true
 *
 * */
--EMPLOYEE 테이블에서 부서코드(DEPT_CODE)가 없는 사원의 사번,이름,부서코드 조회
SELECT EMP_ID "사번", EMP_NAME AS "이름", DEPT_CODE AS "부서코드"
FROM EMPLOYEE 
WHERE DEPT_CODE IS NULL;	--DEPT_CODE = NULL; --안됨

--BONUS가 존재하는 사원의 이름, 보너스 조회
SELECT EMP_NAME AS "이름", BONUS "보너스"
FROM EMPLOYEE 
WHERE BONUS IS NOT NULL;

----
/*논리 연산자(AND/OR)
 * -두 조건식의 결과에 따라 새로운 결과를 만드는 연산
 * -AND :	두연산의결과가 true 일때만 최종 결과 true
 * 	->두 조건을 모두 만족하는 행만 결과집합(Result set)에 포함
 * -OR :	두연산의결과가 false 일때만 최종 결과 false
 * 	->두 조건을 하나라도 만족하는 행을 결과집합(Result set)에 포함
 * -우선순위 :AND > OR
 */
--EMPLOYEE 테이블에서 부서코드(DEPT_CODE)가 'D6'인 사원 중 급여가 400만원을 초과하는 사원의 이름,부서코드,급여 조회
SELECT EMP_NAME ,DEPT_CODE ,SALARY 
FROM EMPLOYEE 
WHERE DEPT_CODE ='D6' AND SALARY > 4000000;

--EMPLOYEE 테이블에서 급여가 300만 이상 500만 미만인 사원의 사번,이름,급여 조회
SELECT EMP_ID ,EMP_NAME ,SALARY 
FROM EMPLOYEE 
WHERE SALARY <5000000 AND SALARY >=3000000;

--EMPLOYEE 테이블에서 급여가 300만 미만 500만 이상인 사원의 사번,이름,급여 조회
SELECT EMP_ID ,EMP_NAME ,SALARY 
FROM EMPLOYEE 
WHERE SALARY >=5000000 OR SALARY <3000000;

----
/*컬럼명 BETWEEN (A) AND (B)
 * -컬럼 값이 (A)이상 (B)이하인 경우 true(조회 하겠다)
 * */
--EMPLOYEE 테이블에서 급여가 400만 - 600만인 사원의 이름,급여 조회
SELECT EMP_NAME ,SALARY 
FROM EMPLOYEE 
WHERE SALARY BETWEEN 4000000 AND 6000000;	--SALARY >=4000000 AND SALARY <=6000000;

/*컬럼명 NOT BETWEEN (A) AND (B)
 * -컬럼 값이 (A)이상 (B)이하인 경우 false
 *  ->(A)미만 (B)초과인 경우 true
 * */
--급여가 400만 - 600만이 아닌 사원의 이름,급여 조회
SELECT EMP_NAME ,SALARY 
FROM EMPLOYEE 
WHERE SALARY NOT BETWEEN 4000000 AND 6000000;

/*날짜 비교에 더많이 사용*/
--EMPLOYEE 테이블에서 2010년대()에 입사한 사원의 이름,입사일 조회
SELECT EMP_NAME ,HIRE_DATE 
FROM EMPLOYEE 
WHERE HIRE_DATE BETWEEN TO_DATE('2010.01.01','YYYY.MM.DD') AND TO_DATE('2019.12.31','YYYY.MM.DD');  

/*일치하는 값만 조회*/
--부서코드가 'D5','D6','D9'인 사원의 사번,이름,부서코드 조회
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE ='D5' OR DEPT_CODE ='D6' OR DEPT_CODE ='D9';

/*컬럼명 IN (값1,값2,값3, ...)
 * -컬럼 값이 IN() 안에 존재한다면 true ==연속으로 OR연산을 작성한것 같은 효과
 */
--위 SQL에서 OR -> IN 변경
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D5','D6','D9');

/*컬럼명 NOT IN (값1,값2,값3, ...)
 * -컬럼 값이 IN() 안에 존재한다면 false ==값이 포함되지 않는 행만 조회
 */
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE NOT IN ('D5','D6','D9');	--DEPT_CODE가 NULL인 사원은 포함 X

--부서코드가 'D5','D6','D9'이 아닌 사원 조회 + NULL인 사원도 포함
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE NOT IN ('D5','D6','D9') OR DEPT_CODE IS NULL;

----
/*LIKE(같은, 비슷한)
 * -비교하려는 값이 특정한 패턴을 만족하면 조회하는 연산자
 * 
 *[작성법]
 * WHERE 컬럼명 LIKE '패턴'
 * 
 *[패턴에 사용되는 기호(와일드카드)]
 * 1)'%' (포함) 
 * 	'%A' 	:A로 끝나는 문자열인 경우 true ->앞쪽에는 어떤 문자열이든 관계없음(빈칸 OK)
 * 	'A%' 	:A로 시작하는 문자열인 경우 true
 * 	'%A%' :A로 포함한 문자열인 경우 true
 * 
 * 2)'_' (글자 수, _ 1개당 1글자)
 *  ___		:문자열이 3글자인 경우 true
 *  A___	:A로 시작하고 뒤에 3글자인 경우 true	->ex) ABCD (O), ABCDE (X)
 *  ___A	:앞에 3글자, 마지막은 A로 끝나는 경우 true
 */
--EMPLOYEE 테이블에서 성이 '전'씨인 사원 찾기
SELECT EMP_NAME 
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '전%';

--이름이 '수' 사원 찾기
SELECT EMP_NAME 
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '%수';

--이름이 '하'가 포함된 사원 찾기
SELECT EMP_NAME 
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '%하%';

--전화번호가 010으로 시작하는 사원의 이름,전화번호 조회
SELECT EMP_NAME,PHONE 
FROM EMPLOYEE 
WHERE 
--	PHONE LIKE '010%';	--% 방법
	PHONE LIKE '010________';	--_ 방법

--EMAIL 컬럼에서 @앞에 ID 글자수가 5글자인 사원의 사번,이름,이메일 조회
SELECT EMP_ID ,EMP_NAME ,EMAIL 
FROM EMPLOYEE 
WHERE EMAIL LIKE '_____@%';

--EMAIL 아이디 중 '_' 앞 글자수가 3글자인 사원의 사번,이름,이메일 조회
SELECT EMP_ID ,EMP_NAME ,EMAIL 
FROM EMPLOYEE 
WHERE EMAIL LIKE '____%';	--EMAIL이 4글자 이상이면 조회 Q.
/*Q.
 * "구분자"로 사용하려던 '_'가 LIKE의 와일드카드 '_'로 해석되면서 문제 발생 
 * 
 *[해결방법]
 * -LIKE ESCAPE OPTION 이용
 * 	->지정된 특수문자 뒤 '딱 한글자'를 와일드카드가 아닌 단순 문자열로 인식시키는 옵션
 * 
 *[작성법]
 * WHERE EMAIL LIKE '___#_%' ESCAPE '#';
 *  '#'말고 다른 특수문자 OK
 */
SELECT EMP_ID ,EMP_NAME ,EMAIL 
FROM EMPLOYEE 
WHERE EMAIL LIKE '___#_%' ESCAPE '#';

----
/*[SELECT 작성법 3]
 * 3)SELECT		컬럼명 ...	--열 선택
 * 1)FROM 		테이블명		--테이블 선택
 * 2)WHERE		조건식		--행 선택
 * 4)ORDER BY 	정렬기준	--조회결과 정렬
 * 
 * *ORDER BY절
 * -SELECT의 조회결과 집합(RESULT SET)을 원하는 순서로 정렬할 떄 사용하는 구문
 * 
 * -작성법
 *  ORDER BY 컬럼명 || 별칭 || 컬럼순서 || 함수
 * 		[ASC / DESC](오름차순 / 내림차순)
 * 		[NULLS FIRST / NULLS LAST] (NULL 데이터 위치)
 * 
 * **ORDER BY절은 해당 SELECT문 제일 마지막에만 수행
 * 
 * -오름차순(ASCENDING)	:점점 커지는 순서로 정렬
 * 	ex)과거 -> 미래
 * -내림차순(DESCENDING)	:점점 작아지는 순서로 정렬
 * */
--EMPLOYEE 테이블에서모든사원의 이름 오름차순 정렬 조회
SELECT EMP_NAME
FROM EMPLOYEE 
ORDER BY EMP_NAME ASC;

--급여 내림차순으로 이름,급여 조회
SELECT EMP_NAME ,SALARY 
FROM EMPLOYEE 
ORDER BY SALARY DESC;

--부서코드가 'D5','D6','D9'인 사원의 사번,이름,급여,부서코드를 급여 내림차순으로 조회
SELECT EMP_ID ,EMP_NAME ,SALARY ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY SALARY DESC;

--부서코드가 'D5','D6','D9'인 사원의 사번,이름,급여,부서코드를 부서코드 오름차순으로 조회
SELECT EMP_ID ,EMP_NAME ,SALARY ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY DEPT_CODE ASC;

----
/*별칭을 이용하여 정렬하기
 * -ORDER BY절은 제일 마지막에 해석됨
 * -ORDER BY보다 먼저 해석된 SELECT절 별칭을 ORDER BY절에 인식 OK
 * ??SELECT보다 먼저 해석되는 WHERE
 * */
--사번,이름,연봉을 연봉 오름차순으로 정렬 (컬럼명 별칭 적용)
SELECT EMP_ID AS "사번",EMP_NAME AS "이름",SALARY *12 AS "연봉"
FROM EMPLOYEE
ORDER BY 연봉 ASC;	--별칭 이용

--연봉을 5천만원 이상 받는 사원의 사번,이름,연봉 조회,연봉 오름차순으로 정렬
SELECT EMP_ID AS "사번",EMP_NAME AS "이름",SALARY *12 AS "연봉"
FROM EMPLOYEE
--WHERE 연봉 >=50000000  --Err ->아직 별칭 인식 전
WHERE SALARY *12 >=50000000
ORDER BY 연봉 ASC;

----
/*컬럼순서를 이용하여 정렬하기
 * -SELECT가 해석되면서 조회하려면 컬럼이 지정되면서 컬럼의 순서도 같이 지정된다
 *  ->ORDER BY에서 컬럼순서 이용가능(권장 X)
 * */
--급여가 400만 이상 600만 이하인 사원의 사번,이름,급여를 급여 내림차순으로 조회
SELECT EMP_ID ,EMP_NAME ,SALARY 
FROM EMPLOYEE 
WHERE SALARY BETWEEN 4000000 AND 6000000
ORDER BY 3 DESC;	--SALARY --권장 X

----
/*SELECT에 작성되지 않은 컬럼을 이용해 정렬하기*/
--모든 사원의 사번,이름을 부서코드 오름차순으로 조회
SELECT EMP_ID ,EMP_NAME 
FROM EMPLOYEE 
ORDER BY DEPT_CODE ASC;
--ORDER BY 해석 전 SELECT,FROM 모두 해석되어있기 때문에 SELECT에 없는 컬럼을 작성해도 정렬 OK

----
/*NULLS FIRST, NULLS LAST*/
SELECT EMP_NAME ,BONUS 
FROM EMPLOYEE 
ORDER BY BONUS ASC NULLS FIRST;
--오름차순 기본값 :NULLS LAST
--내림차순 기본값 :NULLS FIRST

----
/*정렬 기준 "중첩"작성
 * -먼저 작성된 정렬을 적용하고 그 안에서 형성된 그룹별로 정렬 진행
 * -형성되는 그룹 == 같은 컬럼 값을 가지는 행
 * */
--EMPLOYEE 테이블에서 이름,부서코드,급여를 부서코드 오름차순, 급여 내림차순으로 정렬해서 조회
SELECT EMP_NAME ,DEPT_CODE ,SALARY 
FROM EMPLOYEE 
ORDER BY DEPT_CODE ASC, SALARY desc;

--EMPLOYEE 테이블에서 이름,부서코드,직급코드를 조회
--부서코드 오름차순, 직급코드 내림차순,이름 오름차순으로 정렬
SELECT EMP_NAME "이름",DEPT_CODE "부서코드",JOB_CODE "직급코드"
FROM EMPLOYEE 
ORDER BY DEPT_CODE ASC,JOB_CODE DESC,EMP_NAME ASC;
