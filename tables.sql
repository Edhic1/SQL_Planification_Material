CREATE TABLE DEPARTEMENT (
    NDEP NUMBER(10) PRIMARY KEY,
    NOMD VARCHAR2(50) NOT NULL
);

CREATE TABLE PERSONNE (
    PN NUMBER(10) PRIMARY KEY,
    NOMP VARCHAR2(50) NOT NULL,
    PRENOM VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(50) NOT NULL,
    DATEEMB DATE NOT NULL,
    TITRE VARCHAR2(50) NOT NULL,
    ETATP VARCHAR2(6) DEFAULT 'TRUE' NOT NULL,
    NDEP NUMBER(10) NOT NULL,
    ISCHEF INT DEFAULT 0 NOT NULL,
    CONSTRAINT CHK_ISCHEF CHECK (ISCHEF IN (0, 1)),
    CONSTRAINT CHK_ETATP CHECK (ETATP IN ('TRUE', 'FALSE')),
    CONSTRAINT FK_PERSONNE_DEPARTEMENT FOREIGN KEY (NDEP) REFERENCES DEPARTEMENT(NDEP)
);

CREATE TABLE PROJET (
    IDPROJ NUMBER(10) PRIMARY KEY,
    NOMPROJ VARCHAR2(50) NOT NULL,
    DATEDEB DATE DEFAULT SYSDATE NOT NULL, -- TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS')
    DATEFIN DATE NOT NULL,
    DESCRIPTION VARCHAR2(50) NOT NULL,
    PN NUMBER(10) NOT NULL,
    ETATPROJ VARCHAR2(40) DEFAULT 'en cours de execution' NOT NULL,
    CONSTRAINT FK_PROJET_PERSONNE FOREIGN KEY (PN) REFERENCES PERSONNE(PN),
    CONSTRAINT CHK_ETATPROJ CHECK (ETATPROJ IN ('en cours de execution', 'terminee', 'non terminee'))
);

CREATE TABLE MATERIEL (
    ID_MAT NUMBER(10) PRIMARY KEY,
    NOMM VARCHAR2(50) NOT NULL,
    TYPE VARCHAR2(50) NOT NULL,
    ETATD VARCHAR2(6) DEFAULT 'TRUE' NOT NULL,
    ETATM VARCHAR2(6) DEFAULT 'FALSE' NOT NULL,
    CONSTRAINT CHK_ETATD CHECK (ETATD IN ('TRUE', 'FALSE')),
    CONSTRAINT CHK_ETATM CHECK (ETATM IN ('TRUE', 'FALSE'))
);

CREATE TABLE AFFECTATIONPERSONNEL (
    PN NUMBER(10) NOT NULL,
    IDPROJ NUMBER(10) NOT NULL,
    DATEDEBUT DATE NOT NULL,
    DATEFIN DATE,
    PRIMARY KEY (PN, IDPROJ),
    CONSTRAINT FK_PERSONNE FOREIGN KEY (PN) REFERENCES PERSONNE(PN),
    CONSTRAINT FK_PROJET FOREIGN KEY (IDPROJ) REFERENCES PROJET(IDPROJ)
);

CREATE TABLE TACHE (
    IDTACHE NUMBER(10) PRIMARY KEY,
    DATE_CREATION TIMESTAMP DEFAULT SYSDATE NOT NULL,
    DATE_ECHEANCE TIMESTAMP, ---- date de fin d'une tache par un employe-------
    DUREE_ESTIMEE TIMESTAMP NOT NULL, ------- date final fixe par depart ---------
    ETATT VARCHAR2(50) DEFAULT 'en cours de execution' NOT NULL,
    DECRIPTION VARCHAR2(50),
    SCORE INT, --------- ce champ permet a un chef de projet de evaluer le travaille d'un enmploye
    IDPROJ NUMBER(10) NOT NULL,
    PN NUMBER(10) NOT NULL,
    CONSTRAINT FK_AFFECTATIONPERSONNEL FOREIGN KEY(PN, IDPROJ) REFERENCES AFFECTATIONPERSONNEL(PN, IDPROJ),
    CONSTRAINT CHK_ETATT CHECK (ETATT IN ('en cours de execution', 'terminee', 'non terminee')),
    CONSTRAINT CHEK_DATE CHECK(DUREE_ESTIMEE>=DATE_CREATION)
);

/*
select SUM(DUREE_ESTIMEE-date_creation)
 from tache
 group by pn;
*/
CREATE TABLE AFFECTATIONMATERIEL (
    ID_MAT NUMBER(10) NOT NULL,
    IDTACHE NUMBER(10) NOT NULL,
    DATEDEBUTM DATE NOT NULL,
    DATEFINM DATE NOT NULL,
    PRIMARY KEY (ID_MAT, IDTACHE),
    CONSTRAINT FK_MATERIEL FOREIGN KEY (ID_MAT) REFERENCES MATERIEL(ID_MAT),
    CONSTRAINT FK_TACHE FOREIGN KEY (IDTACHE) REFERENCES TACHE(IDTACHE)
);

/*
-- on ne peut pas utilise association pour quantite
CREATE TABLE CONTIENT (
    ID_MAT NUMBER(10) NOT NULL,
    IDPROJ NUMBER(10) NOT NULL,
    QUANTITE NUMBER(10) NOT NULL,
    PRIMARY KEY (ID_MAT, IDPROJ),
    CONSTRAINT FK_PROJET FOREIGN KEY (IDPROJ) REFERENCES PROJET(IDPROJ),
    CONSTRAINT FK_MATERIEL FOREIGN KEY (ID_MAT) REFERENCES MATERIEL(ID_MAT)
);
*/

-- creation sequence pour les clés primaires

CREATE SEQUENCE SEQ_DEPARTEMENT START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE NOCACHE;

/* no cycle est pour pas que la sequence revienne a 1 NOCACHE;*/

/* no cahe est pour pas que la sequence soit stocker en memoire */

CREATE SEQUENCE SEQ_MATERIEL START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE NOCACHE;

CREATE SEQUENCE SEQ_PERSONNE START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE NOCACHE;

CREATE SEQUENCE SEQ_PROJET START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE NOCACHE;

CREATE SEQUENCE SEQ_TACHE START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE NOCACHE;

CREATE TABLE USERPASSWORD (
    IDUSER NUMBER(10) PRIMARY KEY,
    USERNAME VARCHAR2(50) NOT NULL,
    PASSWORD VARCHAR2(50) NOT NULL
);