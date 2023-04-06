/*****************************************/
 -- creation d'un utilisateur qui s'applle dev qui va creer les table est les procedure 
create user dev IDENTIFIED by 1234;
grant dba to  dev;
grant create USER to dev;
GRANT CREATE SESSION To dev WiTH ADMIN OPTION;
/*******************************************/




/*************************** creation des fontions et porcedure aide ****************/

CREATE OR REPLACE FUNCTION VERIFIERMOTPASSE(
    IDENTIFI VARCHAR2,
    NOUVEAU VARCHAR2,
    ENCIEN VARCHAR2
) RETURN BOOLEAN IS
BEGIN
    IF(NOUVEAU = ENCIEN
    OR LENGTH(NOUVEAU)<8
    OR NOT REGEXP_LIKE(NOUVEAU, '[^a-zA-Z0-9]')) THEN
        RETURN FALSE;
    END IF;
    RETURN TRUE;
END;
/

/************ permet d'ouvrir le verillage d'un compte *********/

CREATE or REPLACE PROCEDURE unlokuser(name VARCHAR2)
IS
BEGIN
EXECUTE IMMEDIATE 'ALTER USER'|| name||' ACCOUNT UNLOCK';
END;
/
/********** permet de genrerer un mot de passe aleatoir ************************/
CREATE OR REPLACE FUNCTION GENEREMOTPASSE(
    LONGUEUR INT
) RETURN VARCHAR2 IS
    ALPHABET VARCHAR2(1000) := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    RESULTAT VARCHAR2(60):='';
    TMP   INT;
BEGIN
    FOR I IN 1..LONGUEUR LOOP
        TMP:=DBMS_RANDOM.VALUE(1, LENGTH(ALPHABET));
        RESULTAT := RESULTAT
            || SUBSTR(ALPHABET, TMP,1);
    END LOOP;
    RETURN RESULTAT;
END;
/

SELECT SUBSTR('Bonjour tout le monde', 8, 4) FROM DUAL;
SELECT GENEREMOTPASSE(8) FROM DUAL;




/************************** creation des utilisateurs *****************************/

/* creation d'une table user contient les utilisateur et les mot de passe */

/** CREATE SEQUENCE SEQP START WITH 1 INCREMENT BY 1; **/

CREATE TABLE USERPASSWORD(
    IDUS NUMBER(10) PRIMARY KEY,
    USERe VARCHAR2(50),
    PASSWORD VARCHAR2(50)
);

create or REPLACE PROCEDURE ajouteruserpass(id int,nom VARCHAR2)
AS
tmp VARCHAR2(60);
BEGIN
tmp:=GENEREMOTPASSE(8);
INSERT into USERPASSWORD VALUES(id,nom,tmp);
END;
/

CREATE OR REPLACE PROCEDURE CREEUTILISATEUR IS
    CURSOR PERC IS
        SELECT *
        FROM PERSONNE;
    TMP VARCHAR(60);
BEGIN
    FOR I IN PERC LOOP
        TMP := GENEREMOTPASSE(5);
        EXECUTE IMMEDIATE 'CREATE USER ' || I.PN || ' IDENTIFIED BY ' || TMP || ' PROFILE PROFILEEMP';
        EXECUTE IMMEDIATE 'GRANT ROLEEMP TO ' || I.PN;
        INSERT INTO USERPASSWORD VALUES(I.PN, I.NOMP, TMP);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE CREEUTILISATEUR2 IS
CURSOR PERC IS
        SELECT *
        FROM PERSONNE;
BEGIN
  FOR I IN PERC LOOP
        EXECUTE IMMEDIATE 'create user '|| I.NOMP ||' identified by 1234'; 
        INSERT INTO USERPASSWORD VALUES(I.PN, I.NOMP,'1234');
    END LOOP;

END;
/
grant dba to Johnson,Williams,Brown,Jones

CREATE OR REPLACE PROCEDURE droperUser IS
CURSOR PERC IS
        SELECT *
        FROM PERSONNE;
BEGIN
  FOR I IN PERC LOOP
        EXECUTE IMMEDIATE 'drop user '|| I.NOMP ; 
    END LOOP;

END;
/




/************************** creation des PROFILE *********************/


/*////////////////// PROFILE POUR LES CHEG ///////////////////////// /*/

CREATE PROFILE PROFILECHEF LIMIT 
SESSIONS_PER_USER UNLIMITED 
IDLE_TIME UNLIMITED 
PASSWORD_LIFE_TIME 20
PASSWORD_GRACE_TIME 20
PASSWORD_VERIFY_FUNCTION VERIFIERMOTPASSE;

/*////////////////// PROFILE POUR LES EMPLOYEES /////////////////////// /*/

CREATE PROFILE PROFILEEMP LIMIT 
SESSIONS_PER_USER 2 
IDLE_TIME 2 
PASSWORD_LIFE_TIME 10 
PASSWORD_GRACE_TIME 7
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_VERIFY_FUNCTION VERIFIERMOTPASSE;


/************************** creation de chef *****************************/

CREATE OR REPLACE PROCEDURE CREATE_CHEF_USER(username VARCHAR2, password VARCHAR2) AS
BEGIN
    -- Créer un chef
    EXECUTE IMMEDIATE 'CREATE USER ' || username || ' IDENTIFIED BY ' || password || ' PROFILE PROFILECHEF';
    EXECUTE IMMEDIATE 'GRANT ROLECHEF TO ' || username;
END;
/


/************************* creation des roles *************************/

/*////////////////// ROLE POUR LES CHEG ///////////////////////// /*/

CREATE ROLE ROLECHEF;

GRANT CREATE SESSION TO ROLECHEF;
GRANT SELECT, INSERT, UPDATE, DELETE ON DEPARTEMENT TO ROLECHEF;
GRANT SELECT, INSERT, UPDATE, DELETE ON PERSONNE TO ROLECHEF;
GRANT SELECT, INSERT, UPDATE, DELETE ON PROJET TO ROLECHEF;
GRANT SELECT, INSERT, UPDATE, DELETE ON MATERIEL TO ROLECHEF;
GRANT SELECT, INSERT, UPDATE, DELETE ON AFFECTATIONPERSONNEL TO ROLECHEF;
GRANT SELECT, INSERT, UPDATE, DELETE ON TACHE TO ROLECHEF;
GRANT SELECT, INSERT, UPDATE, DELETE ON AFFECTATIONMATERIEL TO ROLECHEF;


/*////////////////// ROLE POUR LES EMPLOYEES /////////////////////// /*/

/**** USER IS ID DU PERSONNE  ***/

/*

Dans ce code, nous avons remplacé chaque occurrence de "USER" par la fonction 
SYS_CONTEXT('USERENV', 'SESSION_USER'), qui renvoie le id d'utilisateur connecté 
à la session en cours.

*/

CREATE ROLE ROLEEMP;

GRANT CREATE SESSION TO ROLEEMP;

GRANT SELECT ON PROJET WHERE IDPROJET IN (SELECT IDPROJET FROM AFFECTATIONPERSONNEL WHERE PN = SYS_CONTEXT('USERENV', 'SESSION_USER')) TO ROLEEMP;
GRANT SELECT ON TACHE WHERE IDTACHE IN (SELECT IDTACHE FROM AFFECTATIONPERSONNEL WHERE PN = SYS_CONTEXT('USERENV', 'SESSION_USER')) TO ROLEEMP;
GRANT SELECT ON MATERIEL WHERE ID_MAT IN (SELECT ID_MAT FROM AFFECTATIONMATERIEL WHERE PN = SYS_CONTEXT('USERENV', 'SESSION_USER')) TO ROLEEMP;

GRANT SELECT ON AFFECTATIONPERSONNEL WHERE PN = SYS_CONTEXT('USERENV', 'SESSION_USER') TO ROLEEMP;
GRANT SELECT ON AFFECTATIONMATERIEL WHERE PN = SYS_CONTEXT('USERENV', 'SESSION_USER') TO ROLEEMP;

GRANT SELECT ON PERSONNE WHERE PN = SYS_CONTEXT('USERENV', 'SESSION_USER') TO ROLEEMP;
GRANT SELECT ON DEPARTEMENT WHERE NDEP IN (SELECT NDEP FROM PERSONNE WHERE PN = SYS_CONTEXT('USERENV', 'SESSION_USER')) TO ROLEEMP;

/************************* UPDATE EMP TO CHEF *************************/

CREATE OR REPLACE PROCEDURE CHANGETOCHEF (IDCHEF_IN IN NUMBER)
IS
BEGIN
    UPDATE PERSONNE
    SET ischef = 1
    WHERE PN = IDTACHE_IN;
    EXECUTE IMMEDIATE 'GRANT ROLE CHEF TO ' || IDTACHE_IN;
END;