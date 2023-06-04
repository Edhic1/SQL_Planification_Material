DROP FUNCTION GENEREMOTPASSE;

-- Procédure pour l'ajout d'une personne
CREATE OR REPLACE FUNCTION GENEREMOTPASSE(
    P_LONGUEUR IN NUMBER
) RETURN VARCHAR2 AS
    TMP   VARCHAR2(1000);
    CHARS VARCHAR2(1000) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
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
    P_NDEP IN NUMBER,
    ISCHEF IN NUMBER DEFAULT 0
) AS
    TMP VARCHAR2(60);
BEGIN
    TMP := GENEREMOTPASSE(8);
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
        UPPER(P_NOMP),
        P_PRENOM,
        P_EMAIL,
        P_DATEEMB,
        P_TITRE,
        P_NDEP
    );
    EXECUTE IMMEDIATE 'create user '
        || P_NOMP
        || ' identified by 1234 ';
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO '
        || P_NOMP;
    IF (ISCHEF = 1) THEN
        EXECUTE IMMEDIATE 'GRANT ROLECHEF2 TO '
            || P_NOMP;
    ELSE
        EXECUTE IMMEDIATE 'GRANT ROLEEMP TO '
            || P_NOMP;
    END IF;
    INSERT INTO USERPASSWORD VALUES (
        SEQ_PERSONNE.CURRVAL,
        UPPER(P_NOMP),
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
    P_DESCRIPTION IN VARCHAR2,
    P_PN IN NUMBER,
    P_DATEDEB IN DATE DEFAULT SYSDATE() -- I DID IT BECAUSE FORM OF NOUVEAU PROJET SOME ONE CAN MAKE A BEGIN OF PROJECT IN DATE HE CHOSE
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
    P_DUREE_ESTIMEE IN TIMESTAMP,
    P_IDPROJ IN NUMBER,
    P_PN IN NUMBER,
    VAL_DESCRIPTION VARCHAR2
) AS
BEGIN
    INSERT INTO TACHE (
        IDTACHE,
        DUREE_ESTIMEE,
        IDPROJ,
        PN,
        DECRIPTION
    ) VALUES (
        SEQ_TACHE.NEXTVAL,
        P_DUREE_ESTIMEE,
        P_IDPROJ,
        P_PN,
        VAL_DESCRIPTION
    );
END;
/

-- Procédure pour l'ajout d'une tâche
CALL AJOUTER_TACHE2('projet1', '30/05/2023 19:55', 22, 14, 'tache2');

CREATE OR REPLACE PROCEDURE AJOUTER_TACHE2 (
    P_NOMT IN VARCHAR2,
    P_DUREE_ESTIMEE IN VARCHAR2,
    P_IDPROJ IN NUMBER,
    P_PN IN NUMBER,
    VAL_DESCRIPTION VARCHAR2
) AS
BEGIN
    INSERT INTO TACHE (
        IDTACHE,
        DUREE_ESTIMEE,
        NOMT,
        IDPROJ,
        PN,
        DECRIPTION
    ) VALUES (
        SEQ_TACHE.NEXTVAL,
        TO_TIMESTAMP(P_DUREE_ESTIMEE, 'DD/MM/YYYY HH24:MI'),
        P_NOMT,
        P_IDPROJ,
        P_PN,
        VAL_DESCRIPTION
    );
END;
/

CREATE OR REPLACE PROCEDURE AJOUTER_TACHE3 (
    ID_TACHE NUMBER,
    P_NOMT IN VARCHAR2,
    P_DUREE_ESTIMEE IN VARCHAR2,
    P_IDPROJ IN NUMBER,
    P_PN IN NUMBER,
    VAL_DESCRIPTION VARCHAR2
) AS
BEGIN
    INSERT INTO TACHE (
        IDTACHE,
        DUREE_ESTIMEE,
        NOMT,
        IDPROJ,
        PN,
        DECRIPTION
    ) VALUES (
        ID_TACHE,
        TO_TIMESTAMP(P_DUREE_ESTIMEE, 'DD/MM/YYYY HH24:MI'),
        P_NOMT,
        P_IDPROJ,
        P_PN,
        VAL_DESCRIPTION
    );
END;
/

/*
INSERT INTO TACHE
VALUES (SEQ_TACHE.NEXTVAL,, TO_TIMESTAMP('2023-04-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-09 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'en cours de execution', 'Effectuer la maintenance du système',1,7);
*/
/*****  procedure pour affecte personne a un projet      ******/
CALL AJOUTER_TACHE2('projet1', '31/05/2023 19:55', 22, 14, 'tache2');

CALL AFFECTERPERSONNEAPROJET(14, 22, SYSDATE, '31/05/2023');

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

/******************** fonction permettant de retourner la liste des matereille utilise pour cette tache ***/
CREATE OR REPLACE FUNCTION recupererTache(id_tache IN INT) RETURN VARCHAR2 AS
  resulta VARCHAR2(1000) := '';
  CURSOR cur_mateselect IS
    SELECT DISTINCT m.NOMM AS nomm FROM AFFECTATIONMATERIEL a, MATERIEL m WHERE a.ID_MAT = m.ID_MAT AND a.idtache = id_tache;
BEGIN
  FOR val IN cur_mateselect LOOP
    resulta := resulta || val.nomm || ',';
  END LOOP;
  RETURN resulta;
END;
/


/****     fonction qui verifie si personne et affecte a ce projet           ***/

CREATE OR REPLACE FUNCTION APPARTIENTAUPROJET2(
    PN_VAL INT,
    ID_PROJET_VAL INT
) RETURN INT AS
    VAL SUPER.AFFECTATIONPERSONNEL.PN%TYPE;
BEGIN
    BEGIN
        SELECT
            1 INTO VAL
        FROM
            SUPER.AFFECTATIONPERSONNEL
        WHERE
            PN = PN_VAL
            AND IDPROJ = ID_PROJET_VAL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END;
    IF VAL = 1 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

SELECT
    APPARTIENTAUPROJET2(13,
    22) AS RESULTAT
FROM
    DUAL;

/************* fonction qui verifie si le nom de cette tache existe ou non ****/

CREATE OR REPLACE FUNCTION TACHEEXISTE(
    NOM VARCHAR2
) RETURN INT AS
    VAL SUPER.TACHE.NOMT%TYPE;
BEGIN
    BEGIN
        SELECT
            DISTINCT(1) INTO VAL
        FROM
            SUPER.TACHE
        WHERE
            NOMT=NOM;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END;
    IF VAL = 1 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

/************************ fontion qui verifie si le nom de ce projet existe ou non ***/
CREATE OR REPLACE FUNCTION PROJETEXISTE(
    NOM VARCHAR2
) RETURN INT AS
    VAL SUPER.PROJET.NOMPROJ%TYPE;
BEGIN
    BEGIN
        SELECT
            DISTINCT(1) INTO VAL
        FROM
            SUPER.PROJET
        WHERE
            NOMPROJ=NOM;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END;
    IF VAL = 1 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
/

/********************* procedure qui permet de retirer le personne et le materiel de ce projet *****/

CREATE OR REPLACE PROCEDURE METREAJOURPERSONNE(
    ID_TACHE INT
)AS
    CURSOR CURS_PERS IS
        SELECT
            P.PN PN
        FROM
            TACHE    T,
            PERSONNE P
        WHERE
            T.IDTACHE=ID_TACHE
            AND P.PN=T.PN;
BEGIN
    FOR VAL IN CURS_PERS LOOP
        UPDATE PERSONNE
        SET
            ETATP='TRUE'
        WHERE
            PN=VAL.PN;
        COMMIT;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE METREAJOURMATERIEL(
    ID_TACHE INT
) AS
    CURSOR CURS_MAT IS
        SELECT
            A.ID_MAT IDMAT
        FROM
            TACHE               T,
            AFFECTATIONMATERIEL A
        WHERE
            T.IDTACHE=ID_TACHE
            AND T.IDTACHE=A.IDTACHE;
BEGIN
    FOR VAL IN CURS_MAT LOOP
        UPDATE MATERIEL
        SET
            ETATD='TRUE'
        WHERE
            ID_MAT=VAL.IDMAT;
        COMMIT;
    END LOOP;
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

/*************** procedure permet de mettre a jour les inforamtion d'une tache **************************/

CREATE OR REPLACE PROCEDURE RATETACHE(
    ID_TACHE INT,
    SCOREVAL INT
) IS
    V_DATE_ECHEANCE TIMESTAMP;
    V_DUREE_ESTIMEE TIMESTAMP;
BEGIN
    UPDATE TACHE
    SET
        SCORE = SCOREVAL,
        DATE_ECHEANCE = SYSDATE
    WHERE
        IDTACHE = ID_TACHE;
    SELECT
        DATE_ECHEANCE,
        DUREE_ESTIMEE INTO V_DATE_ECHEANCE,
        V_DUREE_ESTIMEE
    FROM
        TACHE
    WHERE
        IDTACHE = ID_TACHE;
    IF V_DATE_ECHEANCE > V_DUREE_ESTIMEE THEN
        UPDATE TACHE
        SET
            ETATT = 'non terminee'
        WHERE
            IDTACHE = ID_TACHE;
    ELSE
        UPDATE TACHE
        SET
            ETATT = 'terminee'
        WHERE
            IDTACHE = ID_TACHE;
    END IF;
END;
/

--------
--GRANT ROLECHEF2 TO super WITH ADMIN OPTION;

CREATE OR REPLACE PROCEDURE AFFECTERROLETOUSER IS
    CURSOR CURUSER IS
        SELECT
            USERNAME
        FROM
            USERPASSWORD;
BEGIN
    FOR VAL IN CURUSER LOOP
        EXECUTE IMMEDIATE 'grant ROLECHEF2 to '
            ||VAL.USERNAME;
    END LOOP;
END;
/