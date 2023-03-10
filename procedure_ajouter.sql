-- Procédure pour l'ajout d'une personne
CREATE OR REPLACE PROCEDURE ajouter_personne (
p_nomP IN VARCHAR2,
p_prenom IN VARCHAR2,
p_email IN VARCHAR2,
p_dateEmb IN DATE,
p_titre IN VARCHAR2,
p_etatP IN BOOLEAN,
p_ndep IN NUMBER
)
AS
BEGIN 
INSERT INTO Personne (pn, nomP, prenom, email, dateEmb, titre, etatP, ndep)
VALUES (seq_Personne.NEXTVAL, p_nomP, p_prenom, p_email, p_dateEmb, p_titre, p_etatP, p_ndep);
END;
/


-- Procédure pour l'ajout d'un département
CREATE OR REPLACE PROCEDURE ajouter_departement (
p_nomD IN VARCHAR2
)
AS
BEGIN
INSERT INTO Departement (nDep, nomD)
VALUES (seq_Departement.NEXTVAL, p_nomD);
END;
/


-- Procédure pour l'ajout d'un matériel
CREATE OR REPLACE PROCEDURE ajouter_materiel (
p_nomM IN VARCHAR2,
p_type IN VARCHAR2,
p_quantite IN NUMBER
)
AS
BEGIN
INSERT INTO Materiel (id_mat, nomM, type, quantite)
VALUES (seq_Materiel.NEXTVAL, p_nomM, p_type, p_quantite);
END;
/


-- Procédure pour l'ajout d'un projet
CREATE OR REPLACE PROCEDURE ajouter_projet (
p_nomProj IN VARCHAR2,
p_dateDeb IN DATE,
p_description IN VARCHAR2,
p_pn IN NUMBER
)
AS
BEGIN
INSERT INTO Projet (idProj, nomProj, dateDeb, description, pn)
VALUES (seq_Projet.NEXTVAL, p_nomProj, p_dateDeb, p_description, p_pn);
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

