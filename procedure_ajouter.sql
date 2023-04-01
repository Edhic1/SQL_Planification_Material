-- Procédure pour l'ajout d'une personne
CREATE OR REPLACE PROCEDURE AJOUTER_PERSONNE (
    P_NOMP IN VARCHAR2,
    P_PRENOM IN VARCHAR2,
    P_EMAIL IN VARCHAR2,
    P_DATEEMB IN DATE,
    P_TITRE IN VARCHAR2,
    P_NDEP IN NUMBER
) AS
BEGIN
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
CREATE OR REPLACE PROCEDURE ajouter_materiel (
p_nomM IN VARCHAR2,
p_type IN VARCHAR2,
p_id_proj IN NUMBER
)
AS
BEGIN
INSERT INTO Materiel (id_mat, nomM, type, IDPROJ)
VALUES (seq_Materiel.NEXTVAL, p_nomM, p_type, p_id_proj);
END;
/

-- Procédure pour l'ajout d'un projet
CREATE OR REPLACE PROCEDURE AJOUTER_PROJET (
    P_NOMPROJ IN VARCHAR2,
    P_DATEDEB IN DATE,
    P_DESCRIPTION IN VARCHAR2,
    P_PN IN NUMBER
) AS
BEGIN
    INSERT INTO PROJET (
        IDPROJ,
        NOMPROJ,
        DATEDEB,
        DESCRIPTION,
        PN
    ) VALUES (
        SEQ_PROJET.NEXTVAL,
        P_NOMPROJ,
        P_DATEDEB,
        P_DESCRIPTION,
        P_PN
    );
END;
/

-- Procédure pour l'ajout d'une tâche
CREATE OR REPLACE PROCEDURE ajouter_tache (
p_date_creation IN DATE,
p_date_echeance IN DATE,
p_duree_estimee IN VARCHAR2,
p_idProj IN NUMBER,
p_pn IN NUMBER
)
AS
BEGIN
INSERT INTO Tache (idTache, date_creation, date_echeance, duree_estimee, idProj, pn)
VALUES (seq_Tache.NEXTVAL, p_date_creation, p_date_echeance, p_duree_estimee, p_idProj, p_pn);
END;
/

/*****  procedure pour affecte personne a un projet      ******/
CREATE or REPLACE PROCEDURE  affecterpersonneAprojet(id_per NUMBER,id_poj NUMBER,DATEDEBUT1 DATE,DATEFIN1 DATE)
IS
BEGIN
INSERT INTO AFFECTATIONPERSONNEL 
VALUES (id_per,id_poj,DATEDEBUT1,DATEFIN1);
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

CREATE or REPLACE PROCEDURE  affecterMaterielTache(id_mat1 NUMBER,id_tache NUMBER,DATEDEBUTM DATE,DATEFINM DATE)
IS
BEGIN
INSERT INTO AFFECTATIONMATERIEL
VALUES (id_mat1,id_tache,DATEDEBUTM ,DATEFINM );
END;
/

