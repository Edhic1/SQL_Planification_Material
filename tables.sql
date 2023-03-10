CREATE TABLE Departement (
    nDep NUMBER(10) PRIMARY KEY,
    nomD VARCHAR2(50) NOT NULL
);

CREATE TABLE Materiel (
    id_mat NUMBER(10) PRIMARY KEY,
    nomM VARCHAR2(50) NOT NULL,
    type VARCHAR2(50) NOT NULL,
    quantite NUMBER(10) NOT NULL,
    etatD BOOLEAN DEFAULT 'TRUE' NOT NULL,
    etatM BOOLEAN DEFAULT 'FALSE' NOT NULL,
    CONSTRAINT chk_etatD CHECK (etatD IN ('TRUE', 'FALSE')),
    CONSTRAINT chk_etatM CHECK (etatM IN ('TRUE', 'FALSE'))
);

CREATE TABLE Personne (
    pn NUMBER(10) PRIMARY KEY,
    nomP VARCHAR2(50) NOT NULL,
    prenom VARCHAR2(50) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    dateEmb DATE NOT NULL,
    titre VARCHAR2(50) NOT NULL,
    etatP BOOLEAN DEFAULT 'TRUE' NOT NULL,
    ndep NUMBER(10) NOT NULL,
    CONSTRAINT chk_etatP CHECK (etatP IN ('TRUE', 'FALSE')),
    CONSTRAINT fk_Personne_Departement FOREIGN KEY (ndep)
        REFERENCES Departement(nDep)
);

CREATE TABLE Projet (
    idProj NUMBER(10) PRIMARY KEY,
    nomProj VARCHAR2(50) NOT NULL,
    dateDeb DATE NOT NULL,
    description VARCHAR2(50) NOT NULL,
    /* en MLD etatP de projet ? */
    pn NUMBER(10) NOT NULL,
    CONSTRAINT fk_Projet_Personne FOREIGN KEY (pn)
        REFERENCES Personne(pn)
);

CREATE TABLE AffectationPersonnel (
    pn NUMBER(10) NOT NULL,
    idProj NUMBER(10) NOT NULL,
    dateDebut DATE NOT NULL,
    dateFin DATE NOT NULL,
    PRIMARY KEY (pn, idProj),
    CONSTRAINT fk_AffectationPersonnel_Personne FOREIGN KEY (pn)
        REFERENCES Personne(pn),
    CONSTRAINT fk_AffectationPersonnel_Projet FOREIGN KEY (idProj)
        REFERENCES Projet(idProj)
);

CREATE TABLE Tache (
    idTache NUMBER(10) PRIMARY KEY,
    date_creation DATE NOT NULL,
    date_echeance DATE NOT NULL,
    duree_estimee VARCHAR2(50) NOT NULL,
    etatT VARCHAR2(50) DEFAULT 'en cours de execution' NOT NULL,
    idProj NUMBER(10) NOT NULL,
    pn NUMBER(10) NOT NULL,
    CONSTRAINT fk_Tache_Personne FOREIGN KEY (pn)
        REFERENCES Personne(pn),
    CONSTRAINT fk_Tache_Projet FOREIGN KEY (idProj)
        REFERENCES Projet(idProj)
    CONSTRAINT chk_etatT CHECK (etatT IN ('en cours de execution', 'terminee', 'non terminee'))
);

CREATE TABLE AffectationMateriel (
    id_mat NUMBER(10) NOT NULL,
    idTache NUMBER(10) NOT NULL,
    dateDebutM DATE NOT NULL,
    dateFinM DATE NOT NULL,
    PRIMARY KEY (id_mat, idTache),
    CONSTRAINT fk_AffectationMateriel_Materiel FOREIGN KEY (id_mat)
        REFERENCES Materiel(id_mat),
    CONSTRAINT fk_AffectationMateriel_Tache FOREIGN KEY (idTache)
        REFERENCES Tache(idTache)
);

-- creation sequence pour les clés primaires

CREATE SEQUENCE seq_Departement
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE /* no cycle est pour pas que la sequence revienne a 1 */
    NOCACHE; /* no cahe est pour pas que la sequence soit stocker en memoire */

CREATE SEQUENCE seq_Materiel
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

CREATE SEQUENCE seq_Personne
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

CREATE SEQUENCE seq_Projet
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

CREATE SEQUENCE seq_Tache
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

