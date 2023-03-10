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

CREATE PROFILE PROFILECHEF LIMIT SESSIONS_PER_USER 2 IDLE_TIME 2 PASSWORD_LIFE_TIME 10 PASSWORD_VERIFY_FUNCTION VERIFIERMOTPASSE;

/*////////////////// PROFILE POUR LES EMPLOYEES /////////////////////// /*/

CREATE PROFILE PROFILEEMP LIMIT SESSIONS_PER_USER 2 IDLE_TIME 2 PASSWORD_LIFE_TIME 10 PASSWORD_VERIFY_FUNCTION VERIFIERMOTPASSE;

/************************** creation des utilisateurs *****************************/

/* creation d'une table user contient les utilisateur et les mot de passe */

CREATE SEQUENCE SEQP START WITH 1 INCREMENT BY 1;

CREATE TABLE USERPASSWORD(
    IDUS INT PRIMARY KEY,
    USER VARCHAR2(50),
    PASSWORD VARCHAR2(50)
);

CREATE OR REPLACE PROCEDURE CREEUTILISATEUR IS
    CURSOR PERC IS
        SELECT
            NOMP
        FROM
            PERSONNE;
    TMP VARCHAR(60);
BEGIN
    FOR I IN PERC LOOP
        TMP:=GENEREMOTPASSE(5);
        CREATE USER I.NOMP IDENTIFIED BY TMP;
        INSERT INTO USERPASSWORD VALUES(
            SEQP.NEXTVAL,
            I.NOMP,
            TMP
        );
    END LOOP;
END;
/

/************************* creation des roles *************************/