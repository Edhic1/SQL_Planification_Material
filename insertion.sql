-------------- insersion departement -----------------------------

--INSERT INTO DEPARTEMENT (NDEP, NOMD) VALUES (SEQ_DEPARTEMENT.NEXTVAL, 'Informatique');
--INSERT INTO DEPARTEMENT (NDEP, NOMD) VALUES (SEQ_DEPARTEMENT.NEXTVAL, 'Marketing');

call AJOUTER_DEPARTEMENT('Informatique');
call AJOUTER_DEPARTEMENT('Marketing');
call AJOUTER_DEPARTEMENT('Finance');
call AJOUTER_DEPARTEMENT('Ressources Humaines');
call AJOUTER_DEPARTEMENT('Ventes');
call AJOUTER_DEPARTEMENT('Juridique');
call AJOUTER_DEPARTEMENT('Service client');
call AJOUTER_DEPARTEMENT('Logistique');
call AJOUTER_DEPARTEMENT('Production');
call AJOUTER_DEPARTEMENT('Recherche et développement');

-- here is for commit ajouter
commit;

---------------------- insersion personne -----------------------------------------
-- pour appler cette prcedure vous devez cree un table userpassword , et donner au dev les pivilege create user et create session
call AJOUTER_PERSONNE('Dupont', 'Jean', 'jean.dupont@entreprise.com', TO_DATE('09/05/2022', 'DD/MM/YYYY'), 'Ingénieur',1);
call AJOUTER_PERSONNE('Durand', 'Marie', 'marie.durand@entreprise.com','01/02/2020', 'Assistant Marketing',2);
call AJOUTER_PERSONNE('Mali', 'Dronyo', 'mali.dronyo@entreprise.com','01/01/2021', 'Ingénieur',2);
call AJOUTER_PERSONNE( 'Durand', 'Marie', 'marie.durand@entreprise.com','01/02/2022', 'Assistant Marketing', 2);
call AJOUTER_PERSONNE( 'Doe', 'John', 'john.doe@entreprise.com','01-01-2021','Directeur', 1);
call AJOUTER_PERSONNE( 'Smith', 'Emma', 'emma.smith@entreprise.com','01-02-2021', 'Manager', 2);
call AJOUTER_PERSONNE('Johnson', 'Michael', 'michael.johnson@entreprise.com','01-03-2021', 'Manager',3);
call AJOUTER_PERSONNE( 'Williams', 'Emily', 'emily.williams@entreprise.com','01-04-2021', 'Employé', 4);
call AJOUTER_PERSONNE( 'Brown', 'James', 'james.brown@entreprise.com','01-05-2021', 'Employé', 5);

----- employer -------
call AJOUTER_PERSONNE( 'jhon', 'dj', 'james.brown@entreprise.com','01-05-2021', 'Employé', 5);
call AJOUTER_PERSONNE( 'ahmed', 'James', 'james.brown@entreprise.com','01-05-2021', 'Employé', 5);
call AJOUTER_PERSONNE( 'nabil', 'James', 'james.brown@entreprise.com','01-05-2021', 'Employé', 5);

-- here is for commit ajouter
commit;


------------- personne --------------
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Doe', 'John', 'john.doe@entreprise.com', TO_DATE('01-01-2021', 'DD-MM-YYYY'), 'Directeur', 'TRUE', 1);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Smith', 'Emma', 'emma.smith@entreprise.com', TO_DATE('01-02-2021', 'DD-MM-YYYY'), 'Manager', 'TRUE', 2);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Johnson', 'Michael', 'michael.johnson@entreprise.com', TO_DATE('01-03-2021', 'DD-MM-YYYY'), 'Manager', 'TRUE', 3);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Williams', 'Emily', 'emily.williams@entreprise.com', TO_DATE('01-04-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 4);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Brown', 'James', 'james.brown@entreprise.com', TO_DATE('01-05-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 5);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Jones', 'Sophie', 'sophie.jones@entreprise.com', TO_DATE('01-06-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 6);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Taylor', 'Daniel', 'daniel.taylor@entreprise.com', TO_DATE('01-07-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 7);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Miller', 'Olivia', 'olivia.miller@entreprise.com', TO_DATE('01-08-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 8);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Wilson', 'Thomas', 'thomas.wilson@entreprise.com', TO_DATE('01-09-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 9);
--INSERT INTO PERSONNE VALUES (SEQ_PERSONNE.NEXTVAL, 'Davis', 'Ava', 'ava.davis@entreprise.com', TO_DATE('01-10-2021', 'DD-MM-YYYY'), 'Employé', 'TRUE', 10);

--INSERT INTO PERSONNE (PN, NOMP, PRENOM, EMAIL, DATEEMB, TITRE, ETATP, NDEP) VALUES
 (SEQ_PERSONNE.NEXTVAL, 'Dupont', 'Jean', 'jean.dupont@entreprise.com', TO_DATE('09/05/2022', 'DD/MM/YYYY'), 'Ingénieur', 'TRUE', 1);
--INSERT INTO PERSONNE (PN, NOMP, PRENOM, EMAIL, DATEEMB, TITRE, ETATP, NDEP) VALUES 
 (SEQ_PERSONNE.NEXTVAL, 'Durand', 'Marie', 'marie.durand@entreprise.com', TO_DATE('01/02/2020', 'DD/MM/YYYY'), 'Assistant Marketing', 'TRUE', 2);
--INSERT INTO PERSONNE (PN, NOMP, PRENOM, EMAIL, DATEEMB, TITRE, ETATP, NDEP) VALUES
 (SEQ_PERSONNE.NEXTVAL, 'Mali', 'Dronyo', 'mali.dronyo@entreprise.com', TO_DATE('01/01/2021', 'DD/MM/YYYY'), 'Ingénieur', 'TRUE', 1);

----------------- insersiont projet -------------------------------------------------

CALL AJOUTER_PROJET('projet2','01/01/2024','Description Projet 3',4);
CALL AJOUTER_PROJET('projet3','02/12/2024','Description Projet 3',4);
CALL AJOUTER_PROJET('projet4','03/02/2024','Description Projet 3',4);
CALL AJOUTER_PROJET('projet5','04/06/2024','Description Projet 3',4);
CALL AJOUTER_PROJET('projet6','05/07/2024','Description Projet 3',4);

CALL AJOUTER_PROJET('projet7','05/07/2024','Description Projet 3',7);
CALL AJOUTER_PROJET('projet8','05/07/2024','Description Projet 3',7);
CALL AJOUTER_PROJET('projet9','05/07/2024','Description Projet 3',7);
CALL AJOUTER_PROJET('projet10','05/07/2024','Description Projet 3',7);
CALL AJOUTER_PROJET('projet12','05/07/2024','Description Projet 3',7);

-------------- les chef de projet

call AJOUTER_PERSONNE('mohamed','elouafi','elouafimed@gmail.com',SYSDATE,'ingénieur',10,1);
call AJOUTER_PERSONNE('hicham','hicham2','hicham@gmail.com',SYSDATE,'ingénieur',9,1);
call AJOUTER_PERSONNE('laila','lail2','laila@gmail.com',SYSDATE,'ingénieur',8,1);
call AJOUTER_PERSONNE('nabilchef','etihdi','nabil@gmail.com',SYSDATE,'ingénieur',7,1);

-----------autre employer

----INSERT INTO PROJET (IDPROJ, NOMPROJ, DATEDEB,DATEFIN, DESCRIPTION, PN, ETATPROJ) VALUES 
--(SEQ_PROJET.NEXTVAL, 'Projet 11', TO_DATE('01/01/2023', 'DD/MM/YYYY'),TO_DATE('01/01/2024', 'DD/MM/YYYY'), 'Description Projet 3',6, 'en cours de execution');
----INSERT INTO PROJET (IDPROJ, NOMPROJ, DATEDEB, DESCRIPTION, PN, ETATPROJ) VALUES 
--(SEQ_PROJET.NEXTVAL, 'Projet 12', TO_DATE('01/01/2023', 'DD/MM/YYYY'), 'Description Projet 4',6, 'en cours de execution');
----INSERT INTO PROJET (IDPROJ, NOMPROJ, DATEDEB, DESCRIPTION, PN, ETATPROJ) VALUES 
--(SEQ_PROJET.NEXTVAL, 'Projet 13', TO_DATE('01/01/2023', 'DD/MM/YYYY'), 'Description Projet 5',6, 'en cours de execution');
----INSERT INTO PROJET (IDPROJ, NOMPROJ, DATEDEB, DESCRIPTION, PN, ETATPROJ) VALUES 
--(SEQ_PROJET.NEXTVAL, 'Projet 14', TO_DATE('01/01/2023', 'DD/MM/YYYY'), 'Description Projet 7',6, 'en cours de execution');


------------- tache --------------------------------------------

CALL AJOUTER_TACHE(TO_TIMESTAMP('2023-04-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'),2,4,'create a activity'); ----
--INSERT INTO TACHE VALUES(1,'01/06/2023','01/07/2023','12','en cours de execution','tache1',1,10);
--INSERT INTO TACHE VALUES(2,'01/06/2023','01/07/2023','30','en cours de execution','tache1',2,10);
--INSERT INTO TACHE VALUES(3,'01/06/2023','15/07/2023','40','en cours de execution','tache1',3,10);
--INSERT INTO TACHE VALUES(4,'01/06/2023','20/07/2023','10','en cours de execution','tache1',1,9);
--INSERT INTO TACHE VALUES(5,'01/06/2023','30/07/2023','5','en cours de execution','tache1',2,9);
--INSERT INTO TACHE VALUES(6,'01/06/2023','16/07/2023','20','en cours de execution','tache1',3,9);

CALL AJOUTER_TACHE2('tache1','30/05/2023 18:00',1,2,'create a activity'); ----


INSERT INTO TACHE
VALUES (SEQ_TACHE.NEXTVAL, TO_TIMESTAMP('2023-04-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-07 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'en cours de execution','tache 1',9,1,2);
INSERT INTO TACHE
VALUES (SEQ_TACHE.NEXTVAL, TO_TIMESTAMP('2023-04-06 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-08 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'en cours de execution','tache 2',8,2,2);
INSERT INTO TACHE
VALUES (SEQ_TACHE.NEXTVAL, TO_TIMESTAMP('2023-04-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-12 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'en cours de execution','tache 3',5,3,2);
INSERT INTO TACHE
VALUES (SEQ_TACHE.NEXTVAL, TO_TIMESTAMP('2023-04-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-09 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'en cours de execution','tache 4',9,1,3);
INSERT INTO TACHE
VALUES (SEQ_TACHE.NEXTVAL, TO_TIMESTAMP('2023-04-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-09 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'en cours de execution','tache 5',10,2,3);
INSERT INTO TACHE
VALUES (SEQ_TACHE.NEXTVAL, TO_TIMESTAMP('2023-04-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-04-09 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'en cours de execution','tache 6',7,3,3);

CALL AJOUTER_TACHE3(1,'tache1','30/05/2023 18:00',1,2,'create a activity');
CALL AJOUTER_TACHE3(1,'tache1','30/05/2023 18:00',1,7,'create a activity');


------------- affectaionpersonnel -----------------------

INSERT INTO AFFECTATIONPERSONNEL VALUES(2,1,'01/06/2023','01/07/2023');
INSERT INTO AFFECTATIONPERSONNEL VALUES(2,2,'01/06/2023','30/12/2023');
INSERT INTO AFFECTATIONPERSONNEL VALUES(2,3,'01/06/2023','15/07/2023');
INSERT INTO AFFECTATIONPERSONNEL VALUES(5,1,'01/06/2023','20/07/2023');
INSERT INTO AFFECTATIONPERSONNEL VALUES(5,2,'01/06/2023','19/07/2023');
INSERT INTO AFFECTATIONPERSONNEL VALUES(5,3,'01/06/2023','30/07/2023');





/************************ insertion pour materiel ***********************************************/

INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'Ordinateur portable', 'Informatique', 'TRUE', 'FALSE');
INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'Imprimante', 'Informatique', 'TRUE', 'TRUE');
INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'Projecteur', 'Informatique', 'TRUE', 'TRUE');

INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'pc_'||GENEREMOTPASSE(4), 'Informatique', 'TRUE', 'FALSE');
INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'Projecteur', 'Informatique', 'TRUE', 'FALSE');
INSERT INTO MATERIEL (ID_MAT, NOMM, TYPE, ETATD, ETATM) VALUES 
(SEQ_MATERIEL.NEXTVAL, 'Projecteur', 'Informatique', 'TRUE', 'FALSE');

INSERT INTO AFFECTATIONPERSONNEL (PN, IDPROJ, DATEDEBUT, DATEFIN) VALUES 
(1, 1, TO_DATE('01/01/2023', 'DD/MM/YYYY'), TO_DATE('31/12/2023', 'DD/MM/YYYY'));
INSERT INTO AFFECTATIONPERSONNEL (PN, IDPROJ, DATEDEBUT, DATEFIN) VALUES 
(2, 2, TO_DATE('01/02/2023', 'DD/MM/YYYY'), TO_DATE('31/12/2023', 'DD/MM/YYYY'));

INSERT INTO TACHE (IDTACHE, DATE_ECHEANCE, DUREE_ESTIMEE, ETATT, DECRIPTION, IDPROJ, PN) VALUES 
(SEQ_TACHE.NEXTVAL, TO_DATE('01/06/2023', 'DD/MM/YYYY'), '4 mois', 'en cours de execution', 'Description Tâche 1', 1, 8);


/**********************************************************************************************************/




/*************************************** insersion pour personne chef de projet ****************************************************/
INSERT INTO PERSONNE (PN, NOMP, PRENOM, EMAIL, DATEEMB, TITRE, ETATP, NDEP) VALUES 
 (SEQ_PERSONNE.NEXTVAL, 'Hicham', 'Bchina', 'hicham.bchina@entreprise.com', TO_DATE('01/02/2022', 'DD/MM/YYYY'), 'Chef de projet', 'TRUE', 2);

 INSERT PERSONNE (PN, NOMP, PRENOM, EMAIL, DATEEMB, TITRE, ETATP, NDEP) VALUES 
 (SEQ_PERSONNE.NEXTVAL, 'Alwafi', 'Mohamed', 'alwafi.mohamed@entreprise.com', TO_DATE('01/02/2022', 'DD/MM/YYYY'), 'Chef de projet', 'TRUE', 2);



/********************************* insersion par procedure *******************************************************/

select pn,sum(DUREE_ESTIMEE-(DATE_ECHEANCE-DATE_CREATION))
from tache
GROUP by pn ;