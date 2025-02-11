CREATE OR REPLACE TRIGGER d_dept_ang-- Doar delete pt dept de la fiecare ang
BEFORE DELETE ON DEPT_TEST_DP-- Trigger la nivel de linie care s-ar declansa inainte
FOR EACH ROW
BEGIN
    DELETE FROM EMP_TEST_DP WHERE department_id = :OLD.department_id;
END;
/

CREATE OR REPLACE TRIGGER u_dept_ang
BEFORE UPDATE ON DEPT_TEST_DP
FOR EACH ROW
BEGIN
    IF :NEW.department_id != :OLD.department_id THEN
        UPDATE EMP_TEST_DP 
        SET department_id = :NEW.department_id 
        WHERE department_id = :OLD.department_id;
    END IF;
END;
/



--Testez fara constrangere de fk in emp referitor la dept
DROP TABLE DEPT_TEST_DP CASCADE CONSTRAINTS;
DROP TABLE EMP_TEST_DP;

CREATE TABLE DEPT_TEST_DP (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL
);

CREATE TABLE EMP_TEST_DP (
    employee_id NUMBER PRIMARY KEY,
    last_name VARCHAR2(50),
    first_name VARCHAR2(50),
    department_id NUMBER-- Pentru testare valori nu il definesc ca fiind foreign key constraint
    --Altfel ar fi fost: FOREIGN KEY (department_id) REFERENCES dept_test_dp(department_id)
);

INSERT INTO DEPT_TEST_DP (department_id, department_name)
SELECT department_id, department_name
FROM departments;

INSERT INTO EMP_TEST_DP (employee_id, last_name, first_name, department_id)
SELECT employee_id, last_name, first_name, department_id
FROM employees;

--Mai intai identific ce department_id pot alege dintre ce e inserat in emp
SELECT *
FROM EMP_TEST_DP e
WHERE e.department_id NOT IN (
    SELECT d.department_id
    FROM DEPT_TEST_DP d );
-- Niciun rezultat, inserez un angajat al carui dept nu exista for fun
INSERT INTO EMP_TEST_DP (employee_id, last_name, first_name, department_id)
VALUES (207, 'Marcel', 'Petrescu', 206);
INSERT INTO EMP_TEST_DP (employee_id, last_name, first_name, department_id)
VALUES (208, 'Ghita', 'Pestisor', 206);

--Testare triggeri
--Pt delete
DELETE FROM DEPT_TEST_DP WHERE department_id = 50;-- se sterg angajatii fara nicio problema cu toat ca deptarment_id nu e definit ca fk
DELETE FROM DEPT_TEST_DP WHERE department_id = 206;-- noul ang care de fapt are un dept inexistent, nu dispare
--Pt update
UPDATE DEPT_TEST_DP 
SET department_id = 130
WHERE department_id = 100;-- 130 exista ca si dept, unique constraint violated



--Testez cu constrangere de fk in emp referitor la dept
DROP TABLE DEPT_TEST_DP CASCADE CONSTRAINTS;
DROP TABLE EMP_TEST_DP;

CREATE TABLE DEPT_TEST_DP (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL
);

CREATE TABLE EMP_TEST_DP (
    employee_id NUMBER PRIMARY KEY,
    last_name VARCHAR2(50),
    first_name VARCHAR2(50),
    department_id NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES DEPT_TEST_DP(department_id)
);

INSERT INTO DEPT_TEST_DP (department_id, department_name)
SELECT department_id, department_name
FROM departments;

INSERT INTO EMP_TEST_DP (employee_id, last_name, first_name, department_id)
SELECT employee_id, last_name, first_name, department_id
FROM employees;

--Chestia asta nu merge, cum ma asteptam
INSERT INTO EMP_TEST_DP (employee_id, last_name, first_name, department_id)
VALUES (207, 'Marcel', 'Petrescu', 206);-- parent key not found

--Testare triggeri
--Pt delete
DELETE FROM DEPT_TEST_DP WHERE department_id = 50;-- se sterg angajatii
--Pt update
UPDATE DEPT_TEST_DP 
SET department_id = 130
WHERE department_id = 100;-- 130 exista ca si dept, unique constraint violated
UPDATE EMP_TEST_DP 
SET department_id = 999-- Ceva ce nu exista nu va functiona ca inainte deoarece nu e gasit parent key
WHERE department_id = 100;





--Testez cu constrangere de fk in emp referitor la dept on delete cascade
DROP TABLE DEPT_TEST_DP CASCADE CONSTRAINTS;
DROP TABLE EMP_TEST_DP;

CREATE TABLE DEPT_TEST_DP (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL
);

CREATE TABLE EMP_TEST_DP (
    employee_id NUMBER PRIMARY KEY,
    last_name VARCHAR2(50),
    first_name VARCHAR2(50),
    department_id NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (department_id) 
        REFERENCES DEPT_TEST_DP(department_id) 
        ON DELETE CASCADE
);

INSERT INTO DEPT_TEST_DP (department_id, department_name)
SELECT department_id, department_name
FROM departments;

INSERT INTO EMP_TEST_DP (employee_id, last_name, first_name, department_id)
SELECT employee_id, last_name, first_name, department_id
FROM employees;

--Testare triggeri
--Pt delete
DELETE FROM DEPT_TEST_DP WHERE department_id = 50;-- se sterg angajatii
--Pt update
UPDATE DEPT_TEST_DP 
SET department_id = 130
WHERE department_id = 100;-- 130 exista ca si dept, unique constraint violated
UPDATE DEPT_TEST_DP 
SET department_id = 999
WHERE department_id = 100;



--Testez cu constrangere de fk in emp referitor la dept on delete set null
DROP TABLE DEPT_TEST_DP CASCADE CONSTRAINTS;
DROP TABLE EMP_TEST_DP;

CREATE TABLE DEPT_TEST_DP (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL
);

CREATE TABLE EMP_TEST_DP (
    employee_id NUMBER PRIMARY KEY,
    last_name VARCHAR2(50),
    first_name VARCHAR2(50),
    department_id NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (department_id) 
        REFERENCES DEPT_TEST_DP(department_id) 
        ON DELETE SET NULL
);

INSERT INTO DEPT_TEST_DP (department_id, department_name)
SELECT department_id, department_name
FROM departments;

INSERT INTO EMP_TEST_DP (employee_id, last_name, first_name, department_id)
SELECT employee_id, last_name, first_name, department_id
FROM employees;

--Testare triggeri
--Pt delete
DELETE FROM DEPT_TEST_DP WHERE department_id = 50;-- nu se sterg angajatii, se seteaza department_id la null
--Pt update
UPDATE DEPT_TEST_DP 
SET department_id = 130
WHERE department_id = 100;-- 130 exista ca si dept, unique constraint violated
UPDATE DEPT_TEST_DP 
SET department_id = 999
WHERE department_id = 100;


--E6 pt baza mea de date
CREATE TABLE EroriMagazinInghetata (
    user_id VARCHAR2(128),
    nume_bd VARCHAR2(128),
    erori VARCHAR2(4000),
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE TRIGGER Erori
AFTER SERVERERROR ON DATABASE
BEGIN
    INSERT INTO EroriMagazinInghetata (user_id, nume_bd, erori)
    VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, DBMS_UTILITY.FORMAT_ERROR_STACK);
END;
/
-- il creez in sys_homedb1
-- apoi ca sa generez niste erori interesante fac cu contstraint uri interesante in sys_homedb1 si sgbd_homedb1
GRANT CREATE TRIGGER TO SGBD_HOMEDB1;

-- exista deja recenziile 1 si 2
INSERT INTO Recenzii (IDRecenzie , IDClient , Rating , Comentariu , DataRecenzie)
VALUES (1 , 1 , 5 , 'O sa mai trec vara asta' , TO_DATE('2024-01-03' , 'YYYY-MM-DD'));
INSERT INTO Recenzii (IDRecenzie , IDClient , Rating , Comentariu , DataRecenzie)
VALUES (2 , 2 , 4 , 'Produse peste asteptari wow' , TO_DATE('2024-01-04' , 'YYYY-MM-DD'));
INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (2, NULL, 4);-- nu pot asocia o comanda cu o aroma care e null
ALTER TABLE AdaugaAroma MODIFY IDAroma null;-- nu merge pt ca AdaugaAroma are o cheie primara compusa care trebuie sa fie unique si not null prin defeinitie
CREATE SEQUENCE SecventaComanda
START WITH 100
INCREMENT BY 5
NOCACHE
NOCYCLE;-- exista deja, eroare name is already used





--E7
DROP TABLE InfoComenzi;
CREATE TABLE InfoComenzi (
    IDAdresa NUMBER PRIMARY KEY,
    Suma NUMBER,
    FOREIGN KEY (IDAdresa) REFERENCES Adresa(IDAdresa)
);

CREATE OR REPLACE PROCEDURE modific_suma_adresa
(
    v_id_adresa InfoComenzi.IDAdresa%TYPE,
    v_suma InfoComenzi.Suma%TYPE
) AS 
BEGIN
    UPDATE InfoComenzi 
    SET Suma = NVL(Suma, 0) + v_suma 
    WHERE IDAdresa = v_id_adresa;
END;
/

CREATE OR REPLACE TRIGGER trig_update_suma_adrese
AFTER INSERT OR DELETE OR UPDATE OF SumaInvestitie ON Sponsor
FOR EACH ROW 
BEGIN
    IF UPDATING THEN
        modific_suma_adresa(:OLD.IDAdresa, :NEW.SumaInvestitie-:OLD.SumaInvestitie);
    ELSIF DELETING THEN
        modific_suma_adresa(:OLD.IDAdresa, -1*:OLD.SumaInvestitie);
    ELSIF INSERTING THEN
        modific_suma_adresa(:OLD.IDAdresa, :NEW.SumaInvestitie);
    END IF;
END;
/
DELETE FROM InfoComenzi;
INSERT INTO InfoComenzi (IDAdresa, Suma) VALUES (12, 1000);
INSERT INTO Sponsor VALUES (16, 12, 'MaxFactoryy', 'max@gmail.com', '0880187170', 200.4, 2);-- nu stiu de ce nu merge
UPDATE Sponsor
SET SumaInvestitie = SumaInvestitie + 1000
WHERE IDSponsor = 16;
DELETE FROM Sponsor WHERE IDSponsor = 16;