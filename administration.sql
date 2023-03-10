/*************************** creation des fontions et porcedure aide ****************/

CREATE OR REPLACE FUNCTION VERIFIERMOTPASSE(identifi VARCHAR2 ,nouveau VARCHAR2,encien VARCHAR2) RETURN BOOLEAN IS
BEGIN
 if(nouveau = encien or LENGTH(nouveau)<8  OR NOT REGEXP_LIKE(nouveau, '[^a-zA-Z0-9]'))  THEN
    RETURN FALSE;
 END if;
 return TRUE;

END;
/

create or REPLACE FUNCTION genereMotpasse(longueur INT) RETURN VARCHAR2 IS
    alphabet VARCHAR2(60) := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    resultat VARCHAR2(60):='';
    tmp INT;
BEGIN
    FOR i IN 1..longueur LOOP
        tmp:=dbms_random.value(1, length(alphabet));
        resultat := resultat || substr(alphabet,tmp,tmp);
    END LOOP;
    RETURN resultat;
END;
/

/************************** creation des PROFILE *********************/


/*////////////////// profile pour les cheg //////////////////////////*/
create PROFILE ProfileChef LIMIT
SESSIONS_PER_USER 2
IDLE_TIME 2
PASSWORD_LIFE_TIME 10
PASSWORD_VERIFY_FUNCTION VERIFIERMOTPASSE ;

/*////////////////// profile pour les employees ////////////////////////*/
create PROFILE ProfileEmp LIMIT
SESSIONS_PER_USER 2
IDLE_TIME 2
PASSWORD_LIFE_TIME 10
PASSWORD_VERIFY_FUNCTION VERIFIERMOTPASSE ;

/************************** creation des utilisateurs *****************************/

/* creation d'une table user contient les utilisateur et les mot de passe */

create sequence seqp start with 1 increment by 1;
CREATE TABLE userPassword(
    idus int PRIMARY KEY,
    user VARCHAR2(50),
    PASSWORD VARCHAR2(50)
);

create or REPLACE PROCEDURE creeUtilisateur
IS
CURSOR perC is SELECT NOMP from personne ;
tmp VARCHAR(60);
BEGIN
for i in perC
LOOP
tmp:=genereMotpasse(5);
create USER i.nomp IDENTIFIED by tmp ;
INSERT INTO userPassword VALUES(seqp.nextval,i.nomp,tmp);
END loop;
END;
/


/************************* creation des roles *************************/

