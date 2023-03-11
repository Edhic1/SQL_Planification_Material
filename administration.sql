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

CREATE or REPLACE PROCEDURE unlokuser(name VARCHAR2)
IS
BEGIN
EXECUTE IMMEDIATE 'ALTER USER'|| name||' ACCOUNT UNLOCK';
END;
/

CREATE OR REPLACE FUNCTION GENEREMOTPASSE(
    LONGUEUR INT
) RETURN VARCHAR2 IS
    ALPHABET VARCHAR2(60) := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    RESULTAT VARCHAR2(60):='';
    TMP      INT;
BEGIN
    FOR I IN 1..LONGUEUR LOOP
        TMP:=DBMS_RANDOM.VALUE(1, LENGTH(ALPHABET));
        RESULTAT := RESULTAT
            || SUBSTR(ALPHABET, TMP, TMP);
    END LOOP;
    RETURN RESULTAT;
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

/************************** creation des utilisateurs *****************************/

/* creation d'une table user contient les utilisateur et les mot de passe */

/** CREATE SEQUENCE SEQP START WITH 1 INCREMENT BY 1; **/

CREATE TABLE USERPASSWORD(
    IDUS NUMBER(10) PRIMARY KEY,
    USER VARCHAR2(50),
    PASSWORD VARCHAR2(50)
);

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
GRANT SELECT, UPDATE ON CONTIENT TO ROLECHEF;


/*////////////////// ROLE POUR LES EMPLOYEES /////////////////////// /*/

/**** USER IS ID DU PERSONNE  ***/

CREATE ROLE ROLEEMP;

GRANT CREATE SESSION TO ROLEEMP;

GRANT SELECT ON PROJET WHERE IDPROJET IN (SELECT IDPROJET FROM AFFECTATIONPERSONNEL WHERE PN = USER) TO ROLEEMP;
GRANT SELECT ON TACHE WHERE IDTACHE IN (SELECT IDTACHE FROM AFFECTATIONPERSONNEL WHERE PN = USER) TO ROLEEMP;
GRANT SELECT ON MATERIEL WHERE IDMATERIEL IN (SELECT IDMATERIEL FROM AFFECTATIONMATERIEL WHERE PN = USER) TO ROLEEMP;
GRANT SELECT ON CONTIENT WHERE IDMATERIEL IN (SELECT IDMATERIEL FROM AFFECTATIONMATERIEL WHERE PN = USER) TO ROLEEMP;

GRANT SELECT ON AFFECTATIONPERSONNEL WHERE PN = USER TO ROLEEMP;
GRANT SELECT ON AFFECTATIONMATERIEL WHERE PN = USER TO ROLEEMP;

GRANT SELECT ON PERSONNE WHERE PN = USER TO ROLEEMP;
GRANT SELECT ON DEPARTEMENT WHERE NDEP IN (SELECT NDEP FROM PERSONNE WHERE PN = USER) TO ROLEEMP;

