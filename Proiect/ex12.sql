-- 12
/* Se inregistreaza intr-un tabel toate operatiile LDD din baza de date, impreuna cu timestamp-ul la care a avut loc create/ alter/ drop.*/
--DROP TRIGGER Trigger_DDL;
--DROP TABLE OperatiiMagazinInghetata;
--DROP TABLE TestTable;
CREATE TABLE OperatiiMagazinInghetata (
    TimestampOperatie TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UserId VARCHAR2(125),
    TipEveniment VARCHAR2(50),
    NumeObiect VARCHAR2(255)-- Pe ce obiect se face actiunea
);

CREATE OR REPLACE TRIGGER Trigger_DDL
AFTER CREATE OR ALTER OR DROP ON SCHEMA
BEGIN
    INSERT INTO OperatiiMagazinInghetata (UserId, TipEveniment, NumeObiect)
    VALUES (SYS.LOGIN_USER, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME);
END Trigger_DDL;
/

CREATE TABLE TestTable (
    ID INT PRIMARY KEY,
    Nume VARCHAR2(100)
);
ALTER TABLE TestTable DROP COLUMN Nume;