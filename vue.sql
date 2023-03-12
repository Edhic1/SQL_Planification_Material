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
        TACHE               T,
        AFFECTATIONMATERIEL A,
        MATERIEL            M
    WHERE
        T.IDTACHE=A.IDTACHE
        AND A.ID_MAT=M.ID_MAT
        AND T.PN=(
            SELECT
                USER
            FROM
                DUAL
        );

/****************************  cette vue permet au chef de projet de voir le tache affecter a chaque personne dans un PROJECT   *****************************************/
CREATE OR REPLACE VIEW AFFICHETTACHECHEF(
    PN,
    DATE_CREATION,
    DATE_ECHEANCE,
    DUREE_ESTIMEE,
    ETATT,
    DECRIPTION,
    NOMM
) AS
    SELECT
        P.PN,
        DATE_CREATION,
        DATE_ECHEANCE,
        DUREE_ESTIMEE,
        ETATT,
        DECRIPTION,
        M.NOMM
    FROM
        TACHE                T,
        AFFECTATIONMATERIEL  A,
        MATERIEL             M,
        PROJET               PR,
        AFFECTATIONPERSONNEL AFP,
        PERSONNE             P
    WHERE
        T.IDTACHE=A.IDTACHE
        AND A.ID_MAT=M.ID_MAT
        AND T.IDPROJ=AFP.IDPROJ
        AND T.PN=AFP.PN
        AND AFP.IDPROJ=PR.IDPROJ
        AND AFP.PN=P.PN
        AND PR.PN=(
            SELECT
                PN
            FROM
                PERSONNE
            WHERE
                NOMP =(
                    SELECT
                        USER
                    FROM
                        DUAL
                )
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
        P.PN,
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
        TYPE,
        c.QUANTITE,
        ETATD,
        ETATM
    FROM
        PROJET   PR,
        CONTIENT C,
        MATERIEL M
    WHERE
        PR.IDPROJ=C.IDPROJ
        AND C.ID_MAT=M.ID_MAT
        AND PR.PN=(
            SELECT
                USER
            FROM
                DUAL
        );