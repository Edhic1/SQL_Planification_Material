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
        AND T.PN=(select pn from personne where nomp=USER);

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
    NOMEMP
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
        P.NOMP
    FROM
        TACHE                T,
        PROJET               PR,
        PERSONNE             P,
        AFFECTATIONPERSONNEL AFF
    WHERE
        P.PN=AFF.PN
        AND PR.IDPROJ=AFF.IDPROJ
        AND T.PN=AFF.PN
        AND T.IDPROJ=AFF.IDPROJ
        and pr.PN=(select pn from personne where UPPER(NOMP)=USER);

/********************** cette vue permet au chef de projet de voir tout les personne qui appatient a ces projet *********************************/

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
        PROJET               PR
    WHERE
        P.PN=AF.PN
        AND PR.IDPROJ=AF.IDPROJ
        AND PR.PN=(select pn from personne WHERE UPPER(nomp)=user)
    group BY P.PN,NOMP,PRENOM,EMAIL,DATEEMB,TITRE,ETATP;

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
        c.QUANTITE,
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

create or replace view afficherProjet(idProjet,nomProjet,dateDeb,DATEFIN,description,chefProjet,etatProjet)
as
SELECT IDPROJ,NOMPROJ,DATEDEB,DATEFIN,DESCRIPTION,pr.PN,ETATPROJ from PROJET pr,PERSONNE p
where pr.pn=p.pn and  UPPER(P.nomp) = USER;


----------------------- une view permet de calculer la difference entre datefin d'une tache et date estimée  ------------------

create or replace VIEW afficherdiffrenceEntredate(idemp,diffrence)
as
SELECT aff.NOMP, SUM((EXTRACT(DAY FROM (DATE_ECHEANCE-DUREE_ESTIMEE))*86400
+EXTRACT(DAY FROM (DATE_ECHEANCE-DUREE_ESTIMEE))*3600
+EXTRACT(DAY FROM (DATE_ECHEANCE-DUREE_ESTIMEE))*60)/(60*60*24))
FROM TACHE t,personne p,projet pr,AFFICHERPERPROJ aff
where pr.IDPROJ=t.IDPROJ and pr.pn=p.pn and aff.pn=t.pn and UPPER(p.nomp)=user
GROUP BY aff.nomp;

----------------------- une view permet de calculer le score total des tache pour un employee  ------------------

create or replace VIEW afficherScore(nomemp,Score)
as
SELECT aff.NOMP,sum(t.score)
FROM TACHE t,personne p,projet pr,AFFICHERPERPROJ aff
where pr.IDPROJ=t.IDPROJ and pr.pn=p.pn and aff.pn=t.pn and UPPER(p.nomp)=user
GROUP BY aff.NOMP;


--pour mali mali
select * from dev.afficherScore;
select * from dev.afficherdiffrenceEntredate

sqlplus mali/1234@//20.55.44.15:1521/ORCLCDB.localdomain
Dupont/1234
