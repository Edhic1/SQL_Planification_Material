DROP FUNCTION GENEREMOTPASSE;

-- Procédure pour l'ajout d'une personne
CREATE OR REPLACE FUNCTION GENEREMOTPASSE(
    P_LONGUEUR IN NUMBER
) RETURN VARCHAR2 AS
    TMP   VARCHAR2(60);
    CHARS VARCHAR2(60) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    I     NUMBER;
BEGIN
    FOR I IN 1..P_LONGUEUR LOOP
        TMP := TMP
            || SUBSTR(CHARS, FLOOR(DBMS_RANDOM.VALUE(1, LENGTH(CHARS))) + 1, 1);
    END LOOP;
    RETURN TMP;
END;
/

CREATE OR REPLACE PROCEDURE AJOUTER_PERSONNE (
    P_NOMP IN VARCHAR2,
    P_PRENOM IN VARCHAR2,
    P_EMAIL IN VARCHAR2,
    P_DATEEMB IN DATE,
    P_TITRE IN VARCHAR2,
    P_NDEP IN NUMBER
) AS
    TMP VARCHAR2(60);
BEGIN
    TMP:=GENEREMOTPASSE(8);
    INSERT INTO PERSONNE (
        PN,
        NOMP,
        PRENOM,
        EMAIL,
        DATEEMB,
        TITRE,
        NDEP
    ) VALUES (
        SEQ_PERSONNE.NEXTVAL,
        P_NOMP,
        P_PRENOM,
        P_EMAIL,
        P_DATEEMB,
        P_TITRE,
        P_NDEP
    );
    EXECUTE IMMEDIATE 'create user '
        ||P_NOMP
        ||' identified by '
        ||TMP;
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO '
        ||P_NOMP;
    INSERT INTO USERPASSWORD VALUES(
        SEQ_PERSONNE.CURRVAL,
        P_NOMP,
        TMP
    );
END;
/

-- Procédure pour l'ajout d'un département
CREATE OR REPLACE PROCEDURE AJOUTER_DEPARTEMENT (
    P_NOMD IN VARCHAR2
) AS
BEGIN
    INSERT INTO DEPARTEMENT (
        NDEP,
        NOMD
    ) VALUES (
        SEQ_DEPARTEMENT.NEXTVAL,
        P_NOMD
    );
END;
/

-- Procédure pour l'ajout d'un matériel
CREATE OR REPLACE PROCEDURE AJOUTER_MATERIEL (
    P_NOMM IN VARCHAR2,
    P_TYPE IN VARCHAR2,
    P_ID_PROJ IN NUMBER
) AS
BEGIN
    INSERT INTO MATERIEL (
        ID_MAT,
        NOMM,
        TYPE
    ) VALUES (
        SEQ_MATERIEL.NEXTVAL,
        P_NOMM,
        P_TYPE
    );
END;
/

-- Procédure pour l'ajout d'un projet
CREATE OR REPLACE PROCEDURE AJOUTER_PROJET (
    P_NOMPROJ IN VARCHAR2,
    P_DATEFIN IN DATE,
    P_DATEDEB IN DATE DEFAULT SYSDATE(), -- I DID IT BECAUSE FORM OF NOUVEAU PROJET SOME ONE CAN MAKE A BEGIN OF PROJECT IN DATE HE CHOSE
    P_DESCRIPTION IN VARCHAR2,
    P_PN IN NUMBER
) AS
BEGIN
    INSERT INTO PROJET (
        IDPROJ,
        NOMPROJ,
        DATEFIN,
        DATEDEB,
        DESCRIPTION,
        PN
    ) VALUES (
        SEQ_PROJET.NEXTVAL,
        P_NOMPROJ,
        P_DATEFIN,
        P_DATEDEB,
        P_DESCRIPTION,
        P_PN
    );
END;
/

-- Procédure pour l'ajout d'une tâche
CREATE OR REPLACE PROCEDURE AJOUTER_TACHE (
    P_DATE_CREATION IN TIMESTAMP,
    P_DUREE_ESTIMEE IN TIMESTAMP,
    P_IDPROJ IN NUMBER,
    P_PN IN NUMBER
) AS
BEGIN
    INSERT INTO TACHE (
        IDTACHE,
        DATE_CREATION,
        DUREE_ESTIMEE,
        IDPROJ,
        PN
    ) VALUES (
        SEQ_TACHE.NEXTVAL,
        P_DATE_CREATION,
        P_DUREE_ESTIMEE,
        P_IDPROJ,
        P_PN
    );
END;
/

/*
INSERT INTO TACHE
VALUES (SEQ_TACHE.NEXTVAL,, TO_TIMESTAMP('2023-04-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-09 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'en cours de execution', 'Effectuer la maintenance du système',1,7);
*/
/*****  procedure pour affecte personne a un projet      ******/
CREATE OR REPLACE PROCEDURE AFFECTERPERSONNEAPROJET(
    ID_PER NUMBER,
    ID_POJ NUMBER,
    DATEDEBUT1 DATE,
    DATEFIN1 DATE
) IS
BEGIN
    INSERT INTO AFFECTATIONPERSONNEL VALUES (
        ID_PER,
        ID_POJ,
        DATEDEBUT1,
        DATEFIN1
    );
END;
/

/*
--  procedure pour affecte materiel a un projet   

CREATE or REPLACE PROCEDURE  affecterMaterielAprojet(id_mat NUMBER,id_poj NUMBER,QUANTITE1 NUMBER)
IS
BEGIN
INSERT INTO CONTIENT 
VALUES (id_mat,id_poj,QUANTITE1);
END;
/
*/

/*********** procedure affecter materiel a une tache dans un projet ***************/

CREATE OR REPLACE PROCEDURE AFFECTERMATERIELTACHE(
    ID_MAT1 NUMBER,
    ID_TACHE NUMBER,
    DATEDEBUTM DATE,
    DATEFINM DATE
) IS
BEGIN
    INSERT INTO AFFECTATIONMATERIEL VALUES (
        ID_MAT1,
        ID_TACHE,
        DATEDEBUTM,
        DATEFINM
    );
END;
/

------------------------------- fonction permet de verifier si l'utilisateur est un chef ou non------------------

CREATE OR REPLACE FUNCTION FUNCISCHEF RETURN INTEGER IS
    VAR INTEGER;
BEGIN
    SELECT
        ISCHEF INTO VAR
    FROM
        PERSONNE
    WHERE
        UPPER(NOMP) = USER;
    IF VAR = 1 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/