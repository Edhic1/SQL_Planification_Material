/*
Trigger pour la table Departement :

Ce déclencheur permet de vérifier que le nom du département ne contient pas plus de 50 caractères 
lorsqu'une nouvelle ligne est insérée ou mise à jour dans la table Departement.

*/
CREATE OR REPLACE TRIGGER trg_nomD_Departement
BEFORE INSERT OR UPDATE ON DEPARTEMENT
FOR EACH ROW
BEGIN
    IF LENGTH(:NEW.NOMD) > 50 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le nom du département doit contenir moins de 50 caractères.');
    END IF;
END;
/

/*
Trigger pour la table Materiel :

Ce déclencheur permet de vérifier que la quantité de matériel est toujours positive 
lorsque la quantité est mise à jour dans la table Materiel.

*/

CREATE OR REPLACE TRIGGER trg_quantite_Materiel
BEFORE UPDATE or INSERT ON CONTIENT
FOR EACH ROW
BEGIN
    IF :NEW.QUANTITE < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La quantité de matériel doit être positive.');
    END IF;
END;
/

/*

Trigger pour la table Personne :

Ce déclencheur permet de vérifier que la date d'embauche d'une personne est antérieure à la date actuelle 
lorsqu'une nouvelle ligne est insérée ou mise à jour dans la table Personne.

*/

CREATE OR REPLACE TRIGGER trg_dateEmb_Personne
BEFORE INSERT OR UPDATE ON PERSONNE
FOR EACH ROW
BEGIN
    IF :NEW.DATEEMB > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20003, 'La date d''embauche ne peut pas être postérieure à la date actuelle.');
    END IF;
END;
/

/*

Trigger pour la table Projet :

Ce déclencheur permet de vérifier que la date de début d'un projet est antérieure à la date d'aujourd'hui 
lorsqu'une nouvelle ligne est insérée dans la table Projet.

*/

CREATE OR REPLACE TRIGGER trg_dateDeb_Projet
BEFORE INSERT ON PROJET
FOR EACH ROW
BEGIN
    IF :NEW.DATEDEB > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20004, 'La date de début du projet ne peut pas être postérieure à la date actuelle.');
    END IF;
END;
/


/*

Trigger pour la table Tache :

Ce déclencheur permet de vérifier que la date d'échéance d'une tâche est postérieure à la date de création de 
la tâche lorsqu'une nouvelle ligne est insérée ou mise à jour dans la table Tache.

*/

CREATE OR REPLACE TRIGGER trg_date_echeance_Tache
BEFORE INSERT OR UPDATE ON TACHE
FOR EACH ROW
BEGIN
    IF :NEW.DATE_ECHEANCE < :NEW.DATE_CREATION THEN
        RAISE_APPLICATION_ERROR(-20005, 'La date d''échéance de la tâche doit être postérieure à la date de création.');
    END IF;
END;
/

/******** cette TRIGGER permet de blocker l'ajout d'un utilisateur si il travaille dans un autre projet */
CREATE or REPLACE TRIGGER trg_block_utl
BEFORE INSERT ON AFFECTATIONPERSONNEL
FOR EACH ROW
DECLARE
  v_id NUMBER;
BEGIN
  SELECT PN INTO v_id
  FROM AFFECTATIONPERSONNEL
  WHERE pn = :NEW.pn;
if :NEW.pn in (v_id) THEN
  RAISE_APPLICATION_ERROR(-20006,'empleye est dejat affectee a un projet');
END IF;
end;
/

