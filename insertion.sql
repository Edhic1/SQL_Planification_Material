INSERT INTO DEPARTEMENT (NDEP, NOMD) VALUES (SEQ_DEPARTEMENT.NEXTVAL, 'Informatique');
INSERT INTO DEPARTEMENT (NDEP, NOMD) VALUES (SEQ_DEPARTEMENT.NEXTVAL, 'Marketing');

INSERT INTO PERSONNE (PN, NOMP, PRENOM, EMAIL, DATEEMB, TITRE, ETATP, NDEP) VALUES
 (SEQ_PERSONNE.NEXTVAL, 'Dupont', 'Jean', 'jean.dupont@entreprise.com', TO_DATE('01/01/2022', 'DD/MM/YYYY'), 'Ingénieur', 'TRUE', 1);
INSERT INTO PERSONNE (PN, NOMP, PRENOM, EMAIL, DATEEMB, TITRE, ETATP, NDEP) VALUES 
 (SEQ_PERSONNE.NEXTVAL, 'Durand', 'Marie', 'marie.durand@entreprise.com', TO_DATE('01/02/2022', 'DD/MM/YYYY'), 'Assistant Marketing', 'TRUE', 2);

INSERT INTO PROJET (IDPROJ, NOMPROJ, DATEDEB, DESCRIPTION, PN, ETATPROJ) VALUES 
(SEQ_PROJET.NEXTVAL, 'Projet 1', TO_DATE('01/01/2023', 'DD/MM/YYYY'), 'Description Projet 1', 1, 'en cours de execution');
INSERT INTO PROJET (IDPROJ, NOMPROJ, DATEDEB, DESCRIPTION, PN, ETATPROJ) VALUES 
(SEQ_PROJET.NEXTVAL, 'Projet 2', TO_DATE('02/01/2023', 'DD/MM/YYYY'), 'Description Projet 2', 2, 'terminee');

INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'Ordinateur portable', 'Informatique', 'TRUE', 'FALSE');
INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'Imprimante', 'Informatique', 'TRUE', 'TRUE');
INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'Projecteur', 'Informatique', 'TRUE', 'TRUE');

INSERT INTO AFFECTATIONPERSONNEL (PN, IDPROJ, DATEDEBUT, DATEFIN) VALUES 
(1, 1, TO_DATE('01/01/2023', 'DD/MM/YYYY'), TO_DATE('31/12/2023', 'DD/MM/YYYY'));
INSERT INTO AFFECTATIONPERSONNEL (PN, IDPROJ, DATEDEBUT, DATEFIN) VALUES 
(2, 2, TO_DATE('01/02/2023', 'DD/MM/YYYY'), TO_DATE('31/12/2023', 'DD/MM/YYYY'));

INSERT INTO TACHE (IDTACHE, DATE_ECHEANCE, DUREE_ESTIMEE, ETATT, DECRIPTION, IDPROJ, PN) VALUES 
(SEQ_TACHE.NEXTVAL, TO_DATE('01/06/2023', 'DD/MM/YYYY'), '4 mois', 'en cours de execution', 'Description Tâche 1', 1, 1);


/**********************************************************************************************************/
----- departement -------------------
INSERT INTO DEPARTEMENT VALUES (1, 'Informatique');
INSERT INTO DEPARTEMENT VALUES (2, 'Finance');
INSERT INTO DEPARTEMENT VALUES (3, 'Ressources Humaines');
INSERT INTO DEPARTEMENT VALUES (4, 'Marketing');
INSERT INTO DEPARTEMENT VALUES (5, 'Ventes');
INSERT INTO DEPARTEMENT VALUES (6, 'Juridique');
INSERT INTO DEPARTEMENT VALUES (7, 'Service client');
INSERT INTO DEPARTEMENT VALUES (8, 'Logistique');
INSERT INTO DEPARTEMENT VALUES (9, 'Production');
INSERT INTO DEPARTEMENT VALUES (10, 'Recherche et développement');

------------- personne --------------
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Doe', 'John', 'john.doe@entreprise.com', TO_DATE('01-01-2021', 'DD-MM-YYYY'), 'Directeur', 'TRUE', 1);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Smith', 'Emma', 'emma.smith@entreprise.com', TO_DATE('01-02-2021', 'DD-MM-YYYY'), 'Manager', 'TRUE', 2);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Johnson', 'Michael', 'michael.johnson@entreprise.com', TO_DATE('01-03-2021', 'DD-MM-YYYY'), 'Manager', 'TRUE', 3);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Williams', 'Emily', 'emily.williams@entreprise.com', TO_DATE('01-04-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 4);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Brown', 'James', 'james.brown@entreprise.com', TO_DATE('01-05-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 5);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Jones', 'Sophie', 'sophie.jones@entreprise.com', TO_DATE('01-06-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 6);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Taylor', 'Daniel', 'daniel.taylor@entreprise.com', TO_DATE('01-07-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 7);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Miller', 'Olivia', 'olivia.miller@entreprise.com', TO_DATE('01-08-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 8);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Wilson', 'Thomas', 'thomas.wilson@entreprise.com', TO_DATE('01-09-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 9);
INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Davis', 'Ava', 'ava.davis@entreprise.com', TO_DATE('01-10-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 10);




/********************************* insersion par procedure *******************************************************/
