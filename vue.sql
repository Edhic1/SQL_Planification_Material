/****************************** creation des vues ***************************************************/

/***********  cette vue permet d'afficher les information des tache pour un simple utilisateur   *************/
CREATE OR REPLACE VIEW CONSULETTACHEEMP(
    DATE_CREATION,
    DUREE_ESTIMEE,
    ETATT,
    DECRIPTION,
    NOMM
) AS
    SELECT
        DATE_CREATION,
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
                PN
            FROM
                PERSONNE
            WHERE
                NOMP=USER
        );

/****************************  cette vue permet au chef de projet de voir la tache affecter a chaque personne dans un PROJECT   *****************************************/
CREATE OR REPLACE VIEW AFFICHERTACHEPROJETCHEF(
    IDTACHE,
    DATE_CREATION,
    DATE_ECHEANCE,
    DUREE_ESTIMEE,
    ETATT,
    DECRIPTION,
    SCORE,
    IDPROJ,
    NOMPROJ,
    NOMEMP,
    NOMTACHE,
    NOMCHEF
)AS
    SELECT
        T.IDTACHE,
        T.DATE_CREATION,
        T.DATE_ECHEANCE,
        T.DUREE_ESTIMEE,
        T.ETATT,
        T.DECRIPTION,
        T.SCORE,
        T.IDPROJ,
        PR.NOMPROJ,
        P.NOMP,
        T.NOMT,
        CHEF.NOMP
    FROM
        TACHE                T,
        PROJET               PR,
        PERSONNE             P,
        AFFECTATIONPERSONNEL AFF,
        PERSONNE             CHEF
    WHERE
        P.PN=AFF.PN
        AND PR.IDPROJ=AFF.IDPROJ
        AND T.PN=AFF.PN
        AND T.IDPROJ=AFF.IDPROJ
        AND PR.PN=CHEF.PN
        AND PR.PN=(
            SELECT
                PN
            FROM
                PERSONNE
            WHERE
                UPPER(NOMP)=USER
        );

/*********************** cette vue permet d'afficher les taches pour l'employer *******************************/
CREATE OR REPLACE VIEW AFFICHERTACHEEMP(
    IDTACHE,
    DATE_CREATION,
    DATE_ECHEANCE,
    DUREE_ESTIMEE,
    ETATT,
    DECRIPTION,
    SCORE,
    IDPROJ,
    NOMPROJ,
    NOMEMP,
    NOMTACHE,
    CHEF
) AS
    SELECT
        T.IDTACHE,
        T.DATE_CREATION,
        T.DATE_ECHEANCE,
        T.DUREE_ESTIMEE,
        T.ETATT,
        T.DECRIPTION,
        T.SCORE,
        T.IDPROJ,
        PR.NOMPROJ,
        P.NOMP,
        T.NOMT,
        CHEF.NOMP
    FROM
        TACHE                T,
        PROJET               PR,
        PERSONNE             P,
        AFFECTATIONPERSONNEL AFF,
        PERSONNE             CHEF
    WHERE
        P.PN=AFF.PN
        AND PR.IDPROJ=AFF.IDPROJ
        AND T.PN=AFF.PN
        AND T.IDPROJ=AFF.IDPROJ
        AND PR.PN=CHEF.PN
        AND T.PN=(
            SELECT
                PN
            FROM
                PERSONNE
            WHERE
                UPPER(NOMP)=USER
        );

/********************** cette vue permet au chef de projet de voir tout les personne qui appatient a ces projet *********************************/CREATE OR REPLACE VIEW AFFICHERPERPROJ(
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
        PROJET               PR
    WHERE
        P.PN=AF.PN
        AND PR.IDPROJ=AF.IDPROJ
        AND PR.PN=(
            SELECT
                PN
            FROM
                PERSONNE
            WHERE
                UPPER(NOMP)=USER
        )
    GROUP BY
        P.PN,
        NOMP,
        PRENOM,
        EMAIL,
        DATEEMB,
        TITRE,
        ETATP;

/*********************************** cette vue permet d'afficher le materiel qui appartient au projet de chef actuelle *******************/
--- THIS NEED TO BE CHANGED
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
        C.QUANTITE,
        ETATD,
        ETATM
    FROM
        PROJET   PR,
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

/*********** cette view permet d'afficher tout les projet pour le chef de projet actuellement connecter a cette session             *********************/

CREATE OR REPLACE VIEW AFFICHERPROJET(
    IDPROJET,
    NOMPROJET,
    DATEDEB,
    DATEFIN,
    DESCRIPTION,
    CHEFPROJET,
    ETATPROJET
) AS
    SELECT
        IDPROJ,
        NOMPROJ,
        DATEDEB,
        DATEFIN,
        DESCRIPTION,
        PR.PN,
        ETATPROJ
    FROM
        PROJET   PR,
        PERSONNE P
    WHERE
        PR.PN=P.PN
        AND UPPER(P.NOMP) = USER;

----------------------- une view permet de calculer la difference entre datefin d'une tache et date estimée  ------------------

CREATE OR REPLACE VIEW AFFICHERDIFFRENCEENTREDATE(
    IDEMP,
    DIFFRENCE
) AS
    SELECT
        AFF.NOMP,
        SUM((EXTRACT(DAY
    FROM
        (DATE_ECHEANCE-DUREE_ESTIMEE))*86400 +EXTRACT(DAY FROM (DATE_ECHEANCE-DUREE_ESTIMEE))*3600 +EXTRACT(DAY FROM (DATE_ECHEANCE-DUREE_ESTIMEE))*60)/(60*60*24))
    FROM
        TACHE           T,
        PERSONNE        P,
        PROJET          PR,
        AFFICHERPERPROJ AFF
    WHERE
        PR.IDPROJ=T.IDPROJ
        AND PR.PN=P.PN
        AND AFF.PN=T.PN
        AND UPPER(P.NOMP)=USER
    GROUP BY
        AFF.NOMP;

----------------------- une view permet de calculer le score total des tache pour un employee  ------------------

CREATE OR REPLACE VIEW AFFICHERSCORE(
    NOMEMP,
    SCORE
) AS
    SELECT
        AFF.NOMP,
        SUM(T.SCORE)
    FROM
        TACHE           T,
        PERSONNE        P,
        PROJET          PR,
        AFFICHERPERPROJ AFF
    WHERE
        PR.IDPROJ=T.IDPROJ
        AND PR.PN=P.PN
        AND AFF.PN=T.PN
        AND UPPER(P.NOMP)=USER
    GROUP BY
        AFF.NOMP;

--pour mali mali
SELECT
    *
FROM
    DEV.AFFICHERSCORE;

SELECT
    *
FROM
    DEV.AFFICHERDIFFRENCEENTREDATE SQLPLUS MALI/1234@//20.55.44.15:1521/ORCLCDB.LOCALDOMAIN DUPONT/1234