CREATE OR REPLACE PROCEDURE PROLONGER_TACHE(
    IDTACHE_IN IN NUMBER,
    NOUVELLE_DATE_ECHEANCE IN DATE
) IS
BEGIN
    UPDATE TACHE
    SET DATE_ECHEANCE = NOUVELLE_DATE_ECHEANCE
    WHERE IDTACHE = IDTACHE_IN;
END;
/



-- make execute every DAY

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'update_etatproj_job',
    job_type        => 'EXECUTABLE',
    job_action      => '/opt/oracle/instantclient_21_4/sqlplus /nolog @/home/hicham/update_etatproj.sql',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0',
    enabled         => TRUE
  );
END;
/

-- make it execute every minute

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'update_etatproj_job',
    job_type        => 'EXECUTABLE',
    job_action      => '/opt/oracle/instantclient_21_4/sqlplus /nolog @/home/hicham/update_etatproj.sql',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=1',
    enabled         => TRUE
  );
END;
/


--- to drop it 

BEGIN
  DBMS_SCHEDULER.DROP_JOB (
    job_name        => 'update_etatproj_job',
    force           => FALSE
  );
END;
/