ACCEPT LOC PROMPT 'Locatie';
ACCEPT DEPT PROMPT 'Cod Departament';

-- Doua select-uri in blocuri de begin pentru a arunca exceptiile imediat, una dupa alta
DECLARE
    v_locatie_nume departments.department_name%type;
    v_deptartament_nume departments.department_name%type;
BEGIN
    BEGIN
        SELECT department_name INTO v_locatie_nume 
        FROM departments
        WHERE location_id = &loc;
        
        DBMS_OUTPUT.PUT_LINE('Numele departamentului pentru locatie: '||v_locatie_nume);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Eroare: Niciun departament gasit pentru locatia specificata');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare: Prea multe dept gasite pentru locatia specificata');
    END;

    BEGIN
        SELECT department_name INTO v_deptartament_nume 
        FROM departments
        WHERE department_id = &dept;
        
        DBMS_OUTPUT.PUT_LINE('Numele departamentului pentru codul dat: '||v_deptartament_nume);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Eroare: Niciun departament gasit pentru codul specificat');
    END;
END;
/

ACCEPT LOC PROMPT 'Locatie';
ACCEPT DEPT PROMPT 'Cod Departament';

-- De data asta e un singur bloc de select-uri si la no_data_found cuprind ambele cazuri fie bazat pe loc fie pe dept care nu au fost gasite si de sigur returnez un mesaj mai general
DECLARE
    v_locatie_nume departments.department_name%TYPE;
    v_deptartament_nume departments.department_name%TYPE;
BEGIN
    SELECT department_name INTO v_locatie_nume 
    FROM departments
    WHERE location_id = &loc;

    DBMS_OUTPUT.PUT_LINE('Numele departamentului pentru locatie: '||v_locatie_nume);

    SELECT department_name INTO v_deptartament_nume 
    FROM departments
    WHERE department_id = &dept;

    DBMS_OUTPUT.PUT_LINE('Numele departamentului pentru codul dat: '||v_deptartament_nume);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: Niciun departament gasit pentru locatia sau codul specificat');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: Prea multe departamente gasite pentru locatia sau codul specificat');
        -- Teoretic TOO_MANY_ROWS pentru department_name nu e un caz care ar putea aparea
END;
/

SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_val PROMPT 'Dati valoarea medie a aromelor: '

DECLARE
    v_val NUMBER := &p_val;
    v_numar NUMBER := 0;
    exceptie EXCEPTION;-- Exceptie definita utilizator
    
    CURSOR c_angajati IS
        SELECT V.IDAngajat
        FROM AdaugaAroma A
        JOIN Comenzi C ON (A.IDComanda = C.IDComanda)
        JOIN Vanzari V ON (C.IDComanda = V.IDComanda)
        GROUP BY V.IDAngajat
        HAVING SUM(A.Cantitate) / COUNT(DISTINCT A.IDComanda) > v_val;
BEGIN
    FOR rec IN c_angajati LOOP
        v_numar := v_numar + 1;-- Un nou ID inseamna sa incrementez
    END LOOP;

    IF v_numar = 0 THEN
        RAISE exceptie;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('NR de angajati care au procesat mai mult de '||v_val||' arome in medie (per comanda) este: '||v_numar);
    END IF;

EXCEPTION
    WHEN exceptie THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista angajati care sa fi procesat mai mult de '||v_val||' arome in medie');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Alta eroare: ' || SQLERRM);
END;
/
SET VERIFY ON
SET SERVEROUTPUT OFF
