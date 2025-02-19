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