-- 한 줄 주석 :<Ctrl + />
/* 범위 주석 :<Ctrl + Shift + /> */

/*SQL 실행
 * 단일 실행 :<Ctrl + Enter>
 * 다중 실행 :(블록 지정 후) <Alt + Enter>
 * */
ALTER SESSION SET "_oracle_script" =TRUE;

/*사용자 계정 생성*/
CREATE USER KH14_SDK IDENTIFIED BY "KH1234";

/*사용자 계정 사용량(200MB) 지정*/
ALTER USER KH14_SDK DEFAULT TABLESPACE "USERS" QUOTA 200M ON "USERS";

/*사용자 권한 부여
 * -CONNECT :DB 접속권한
 * -RESOURCE :기본 객체 8개 제어권한
 * -CREATE VIEW :VIEW 객체 생성권한
*/
GRANT CONNECT, RESOURCE, CREATE VIEW TO KH14_SDK;

---------------------------------------------------------------------------
/*DB -공용으로 사용할 데이터를 중복을 최소화하여 구조적모으는 곳
 * 
 *DBMS(DateBase Management System) 
 * -DB 데이터를 추출, 조작, 정의 ,제어할 수 있는 프로그램
 *
 *SQL(Structured Query Language, 구조적 질의 언어)
 * -데이터를 조회, 조작, 관리하기 위해 사용하는 언어
 * 
 *DQL(Date Query Language) :데이터 질이 언어
 * -테이블에서 데이터를 조회하는 구문
 * -SELECT
 * 
 *DML(Data Manipulation(조작) Language) :데이터 조작 언어
 * -테이블에 값을 조작(삽입,수정,삭제)하는 구문
 * -INSERT, UPDATE, DELETE, MERGE
 * 
 *TCL(Transaction Control Language) :트랜잭션 제어 언어
 * -Transaction :데이터 변경사항(DML)을 묶어 관리하는 DB의 논리적 연산단위
 * 
 *DDL(Data Definition Language) :데이터 정의 언어
 * -객체를 만들고(CREATE), 수정하고(ALTER), 삭제하는(DROP) 구문
 *
 *DCL(Data Control Language) :데이터 제어 언어
 * -계정 별로 권한 제어(부여, 회수)
 * -권한 부여 :GRANT 권한... TO 사용자명;
 * -권한 회수 :REVOKE 권한... FROM 사용자명;
 * 
 * ROLE(역할) 	:권한의 묶음
 * -CONNECT 	:접속 권한
 * -RESOURCE	:기본 객체 8개 생성 권한
 *
 *---------------------------------------------------------------------------
 *[SELECT 작성법]
 * 5)SELECT 컬럼명|함수식|리터럴|서브쿼리(스칼라) [AS "별칭"]
 * 1)FROM 테이블명|서브쿼리(인라인뷰)+ JOIN
 * 2)WHERE 조건식
 * 3)GROUP BY 컬럼명|함수식
 * 4)HAVING 	컬럼명|그룹합수를 이용한 조건식
 * 6)ORDER BY 컬럼명|컬럼순서|별칭 [ASC|DESC][NULLS FIRST|LAST];
 * 
 *[INSERT 작성법]
 * INSERT INTO 테이블명(컬럼명...) VALUES(값...);
 *  ->지정된 컬럼에만 값을 대입하여 테이블에 행 삽입
 *  ->언급되지 않은 컬럼은 NULL|DEFAULT
 * 
 * INSERT INTO 테이블명 VALUES(값...);
 * 	->테이블에 행 삽입
 *  ->VALUES()에는 테이블의 모든 컬럼 값 순서대로 작성
 * 
 *[UPDATE 작성법]
 * UPDATE 테이블명 SET
 *  컬럼명 = 변경할 값,
 *  컬럼명 = 변경할 값,
 *  ...
 * WHERE 조건식; --어떤 행만 수정할지 지정
 * 
 *[DELETE 작성법] 
 * DELETE 
 * FROM 테이블명
 * WHERE 조건식; --어떤 행만 삭제할지 지정
 */

---------------------------------------------------------------------------
/*[TCL 구문]
 * COMMIT :트랜잭션에 저장된 변경사항을 DB에 반영
 * 
 * ROLLBACK :트랜잭션을 삭제 ->마지막 COMMIT 상태로 돌아감
 * 
 * SAVEPOINT :트랜잭션에 저장 지점을 설정하여 원하는 위치 까지만 ROLLBACK
 * */

---------------------------------------------------------------------------
/*[테이블 생성 SQL]
 * CREATE TABLE 테이블명(
 * 	컬럼명 자료형(크기),
 * 	컬럼명 자료형(크기)[컬럼레벨 제약조건],
 *  [테이블레벨 제약조건]
 * );
 * 
 *[DB 자료형]
 * NUMBER 	:숫자(정수,실수)
 * DATE 		:날짜(TIMESTAMP :DATE + MS + UTC)
 * CHAR			:문자열, 고정크기, MAX 2000BYTE
 * VARCHAR2	:문자열, 가변크기, MAX 4000BYTE
 * BLOB			:이진 데이터 저장(MAX 4GB)
 * CLOB			:문자 데이터 저장(MAX 4GB)
 * 
 *[제약조건]
 * -정의 :조건에 맞는 데이터만 유지하기 위해 컬럼에 설정하는 제약
 *  ->데이터 무결성 확보(중복X, NULL X, 신뢰할 수 있는 데이터)
 * 
 * [NOT NULL]
 * 	-컬럼에 반드시 값을 기록해야 된다는 제약조건
 *  -무조건 컬럼 레벨로만 설정가능
 * 
 * [UNIQUE]
 *  -같은 컬럼에 중복되는 값을 제한하는 제약조건(중복X)
 *  -컬럼/테이블 레벨 모두 설정가능
 *  -복합키 설정가능
 *  -NULL 삽입가능, NULL 중복가능
 * 
 * [PRIMARY KEY]
 *  -테이블에서 한행의 정보를 찾기위해 사용하는 컬럼 ->식별자 역할
 *  -테이블당 1개만 설정가능
 *  -중복X, NULL X
 * 	-컬럼/테이블 레벨 모두 설정가능
 *  -복합키 설정가능
 * 
 * [FOREIGN KEY]
 *  -참조된 다른 테이블(부모)의 컬럼에서 제공하는 값만 사용할 수 있게 하는 제약조건
 *    부모 <-(참조)- 자식
 *  -테이블간의 관계(Relationship)가 형성됨
 *   ->테이블간의 JOIN 가능한 컬럼이 특정지어짐
 * 	-컬럼/테이블 레벨 모두 설정 가능
 * 
 *  -삭제옵션
 *   1)ON DELETE SET NULL
 *    -참조하던 부모 컬럼 값이 삭제되면 자식 컬럼값을 NULL로 세팅
 *   2)ON DELETE CASCADE
 *    -참조하던 부모 컬럼 값이 삭제되면 자식 행도 삭제
 * 
 * [CHECK]
 *  -컬럼에 기록되는 값에 조건을 설정하는 제약조건
 *  -조건에 사용되는 비교값은 리터럴만 작성가능
 * 	-컬럼/테이블 레벨 모두 작성가능
 *  -FK의 하위 호환
 * 
 *---------------------------------------------------------------------------
 *[ALTER] :객체의 구조를 변경하는 구문
 *
 *[ALTER TABLE 구문]
 * -컬럼(추가/수정/삭제)
 * -제약조건(추가/삭제)
 * -이름변경(테이블, 컬럼, 제약조건)
 * 
 *[DROP] :객체의 구조를 삭제하는 구문
 *
 *[DROP TABLE 테이블명 CASCADE CONSTRAINTS]
 * -삭제되는 테이블과 관계를 맺기 위한 제약조건(FK)모두 삭제
 * */


