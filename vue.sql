/****************************** creation des vues ***************************************************/

/***********  cette vue permet d'afficher les information des tache pour un simple utilisateur   *************/
CREATE OR REPLACE VIEW CONSULETTACHEEMP(
    DATE_CREATION,
    DATE_ECHEANCE,
    DUREE_ESTIMEE,
    ETATT,
    DECRIPTION,
    NOMM
) AS
    SELECT
        DATE_CREATION,
        DATE_ECHEANCE,
        DUREE_ESTIMEE,
        ETATT,
        DECRIPTION,
        M.NOMM
    FROM
        TACHE T,
        AFFECTATIONMATERIEL A,
        MATERIEL M
    WHERE
        T.IDTACHE=A.IDTACHE
        AND A.ID_MAT=M.ID_MAT,
        AND T.PN=(
            SELECT
                USER
            FROM
                DUAL
        );

/********************** cette vue permet au chef de projet de voir tout les personne qui appatient a ce projet *********************************/

CREATE OR REPLACE VIEW AFFICHERPERPROJ(
    PN,
    NOMP,
    PRENOM,
    EMAIL,
    DATEEMB,
    TITRE,
    ETATP
) AS
    SELECT
        PN,
        NOMP,
        PRENOM,
        EMAIL,
        DATEEMB,
        TITRE,
        ETATP
    FROM
        PERSONNE             P,
        AFFECTATIONPERSONNEL AF,
        PROJET               PR,
        DEPARTEMENT          D
    WHERE
        P.PN=AF.PN
        AND PR.IDPROJ=AF.IDPROJ
        AND P.NDEP=D.NDEP
        AND PR.PN=(
            SELECT
                USER
            FROM
                DUAL
        );

/*********************************** cette vue permet d'afficher le materiel qui appartient au projet de chef actuelle *******************/

CREATE OR REPLACE VIEW AFFICHERMATPROJ(
    NOMM,
    TYPEM,
    QUANTITE,
    ETATD,
    ETATM
) AS
    SELECT
        NOMM,
        TYPEM,
        QUANTITE,
        ETATD,
        ETATM
    FROM
        PROJET   PR,
        MATERIEL M
    WHERE
        PR.IDPROJ=M.IDPROJ
        AND PR.PN=(
            SELECT
                USER
            FROM
                DUAL
        );