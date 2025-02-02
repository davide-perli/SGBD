CREATE TABLE cititor_DP AS SELECT * FROM cititor;
CREATE TABLE domeniu_DP AS SELECT * FROM domeniu;
CREATE TABLE carte_DP AS SELECT * FROM carte;
CREATE TABLE imprumuta_DP AS SELECT * FROM imprumuta;
COMMIT;

--1
CREATE OR REPLACE PROCEDURE Nume_Titluri
IS
    TYPE Lista_Titluri IS TABLE OF carte_DP.titlu%TYPE INDEX BY BINARY_INTEGER;
    L_Titluri Lista_Titluri;
BEGIN
    SELECT c.titlu
    BULK COLLECT INTO L_Titluri
    FROM CARTE_DP c
    JOIN IMPRUMUTA_DP i ON (c.id_carte = i.cod_carte)
    ORDER BY i.dataim ASC;
    FOR i in 1..L_Titluri.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(L_Titluri(i));
    END LOOP;
    
END;
/
BEGIN 
    Nume_Titluri;
END;
/

--2
CREATE OR REPLACE PROCEDURE Numar_Imprumuturi
IS
    TYPE Lista_Imprumuturi IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    NR_Imprumuturi Lista_Imprumuturi;
BEGIN
    SELECT COUNT(i.cod_carte)
    BULK COLLECT INTO NR_Imprumuturi
    FROM IMPRUMUTA_DP i
    GROUP BY i.cod_carte;
    FOR i in 1..NR_Imprumuturi.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(NR_Imprumuturi(i));
    END LOOP;
    
END;
/
BEGIN 
    Numar_Imprumuturi;
END;
/

--3
CREATE OR REPLACE PROCEDURE Domeniu_Detalii
IS 
    TYPE detalii_domeniu is RECORD(
        denumire domeniu.denumire%TYPE,
        numar_carti NUMBER,
        pret_mediu NUMBER,
        nr_total_carti CARTE_DP.nrex%TYPE
    );
    
    TYPE Lista_Domenii IS TABLE OF detalii_domeniu INDEX BY BINARY_INTEGER;
    Domenii Lista_Domenii;
    
BEGIN
    SELECT d.denumire, COUNT(c.id_carte), AVG(c.pret), SUM(c.nrex)
    BULK COLLECT INTO Domenii
    FROM DOMENIU_DP d
    JOIN CARTE_DP c on (d.id_domeniu = c.cod_domeniu)
    GROUP BY d.denumire;
    
    FOR i in 1..Domenii.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Denumire '|| Domenii(i).denumire || ' Numar Carti '|| Domenii(i).numar_carti || ' Pret mediu domeniu '|| Domenii(i).pret_mediu || ' Numar total carti '|| Domenii(i).nr_total_carti);
    END LOOP;
END;
/
BEGIN 
    Domeniu_Detalii;
END;
/

--4
CREATE OR REPLACE PROCEDURE Numar_Imprumuturi
IS
    TYPE Lista_Imprumuturi IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    L_Imprumuturi Lista_Imprumuturi;
    
BEGIN
    SELECT COUNT(cod_carte)
    BULK COLLECT INTO L_Imprumuturi
    FROM IMPRUMUTA_DP
    GROUP BY cod_carte;
    FOR i in 1..L_Imprumuturi.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(L_Imprumuturi(i));
    END LOOP;
END;
/
BEGIN
    Numar_Imprumuturi;
END;
/
    

--5
CREATE OR REPLACE PROCEDURE Numar_NeImprumuturi
IS
    TYPE Lista_NeImprumuturi IS TABLE OF CARTE_DP.titlu%TYPE INDEX BY BINARY_INTEGER;
    L_NeImprumuturi Lista_NeImprumuturi;

BEGIN
    SELECT c.titlu
    BULK COLLECT INTO L_NeImprumuturi
    FROM CARTE_DP c
    LEFT JOIN IMPRUMUTA_DP i ON (c.id_carte = i.cod_carte)
    WHERE i.cod_carte IS NULL;

    FOR i IN 1..L_NeImprumuturi.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(L_NeImprumuturi(i));
    END LOOP;
END;
/
BEGIN
    Numar_NeImprumuturi;
END;
/

--21
CREATE OR REPLACE PROCEDURE Cititor_Detalii
IS
    CURSOR cititori_cursor IS
        SELECT DISTINCT c.nume
        FROM CITITOR_DP c
        JOIN IMPRUMUTA_DP i ON (c.id_cititor = i.cod_cititor)
        JOIN CARTE_DP carte ON (i.cod_carte = carte.id_carte)
        JOIN DOMENIU_DP d ON (d.id_domeniu = carte.cod_domeniu)
        WHERE EXTRACT(DAY FROM c.data_nasterii) = 23 AND carte.nrex = 1 AND d.denumire = 'Informatica';

    nume cititor.nume%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Nascut pe 23 si a imprumutat carti de un singur exemplar din sectiunea Informatica');
    
    OPEN cititori_cursor;
    LOOP
        FETCH cititori_cursor INTO nume;
        EXIT WHEN cititori_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(nume);
    END LOOP;
    CLOSE cititori_cursor;
END;
/
BEGIN
    Cititor_Detalii;
END;
/

--22
CREATE OR REPLACE PROCEDURE Carti_Scumpe
IS
    CURSOR carti_cursor IS
        SELECT titlu, pret
        FROM CARTE_DP
        ORDER BY pret DESC
        FETCH FIRST 4 ROWS ONLY;

    titlu carte_DP.titlu%TYPE;
    pret carte_DP.pret%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('4 cele mai scumpe carti');
    
    OPEN carti_cursor;
    LOOP
        FETCH carti_cursor INTO titlu, pret;
        EXIT WHEN carti_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(titlu||' '||pret);
    END LOOP;
    CLOSE carti_cursor;
END;
/
BEGIN
    Carti_Scumpe;
END;
/

--23
CREATE OR REPLACE PROCEDURE Pret_Carte(titlu_carte CARTE_DP.titlu%TYPE)
IS
    pret_carte CARTE_DP.pret%TYPE;
BEGIN
    SELECT pret
    INTO pret_carte
    FROM CARTE_DP
    WHERE titlu = titlu_carte;

    IF pret_carte > 60 THEN
        DBMS_OUTPUT.PUT_LINE('Scumpa, peste 60');
    ELSIF pret_carte BETWEEN 35 AND 60 THEN
        DBMS_OUTPUT.PUT_LINE('Decent, intre 35 si 60');
    ELSIF pret_carte < 35 THEN
        DBMS_OUTPUT.PUT_LINE('Ieftina, sub 35');
    END IF;
END;
/
BEGIN
    Pret_Carte('CarteInfo5');
    Pret_Carte('Carte1');
    Pret_Carte('CarteLit2');
END;
/

--24
CREATE OR REPLACE PROCEDURE Autor5
IS
    TYPE Lista_Cititor IS TABLE OF CITITOR_DP.nume%TYPE;
    cititori Lista_Cititor;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cine a imprumutat tot ce a scris Autor5');
    
    SELECT c.nume
    BULK COLLECT INTO cititori
    FROM cititor_DP c
    JOIN imprumuta_DP i ON c.id_cititor = i.cod_cititor
    JOIN carte_DP carte ON i.cod_carte = carte.id_carte
    WHERE carte.autor = 'Autor5'
    GROUP BY c.nume, c.id_cititor
    HAVING COUNT(DISTINCT carte.id_carte) =
    (   SELECT COUNT(DISTINCT id_carte)
        FROM carte_DP
        WHERE autor = 'Autor5' );

    FOR i IN 1..cititori.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(cititori(i));
    END LOOP;
END;
/
BEGIN
    Autor5;
END;
/

--25
CREATE OR REPLACE PROCEDURE Neimprumutat_Info AS
    TYPE Lista_Titluri IS TABLE OF CARTE_DP.titlu%TYPE;
    titluri Lista_Titluri;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Neimprumutat de Info de nimeni');
    
    SELECT c.titlu
    BULK COLLECT INTO titluri
    FROM carte_DP c
    JOIN domeniu_DP d ON (d.id_domeniu = c.cod_domeniu)
    WHERE c.autor IS NULL AND d.denumire = 'Informatica'
    AND c.id_carte NOT IN
    (   SELECT i.cod_carte
        FROM imprumuta i
        WHERE i.dataef IS NULL );

    FOR i IN 1..titluri.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(titluri(i));
    END LOOP;
END;
/
BEGIN
    Neimprumutat_Info;
END;
/

--26
CREATE OR REPLACE PROCEDURE Sterge_Cod_Invalid AS
BEGIN
    UPDATE carte_DP
    SET cod_domeniu = NULL
    WHERE cod_domeniu NOT IN (SELECT id_domeniu FROM domeniu);
END;
/
BEGIN
    INSERT INTO CARTE_DP VALUES(606, 'BioMecanica', 'Davide', 55, 4, 4352);
    Sterge_Cod_Invalid;
END;
/
ROLLBACK;

--27
CREATE OR REPLACE PROCEDURE Modifica_Pret
IS
    pret_max NUMBER;
BEGIN
    SELECT MAX(c.pret)
    INTO pret_max
    FROM carte_DP c
    JOIN domeniu_DP d ON (d.id_domeniu = c.cod_domeniu)
    WHERE d.denumire = 'Literatura';

    UPDATE carte_DP
    SET pret = pret_max
    WHERE autor = 'Autor5';
END;
/
BEGIN
    INSERT INTO CARTE_DP VALUES(606, 'DEX', 'Autor7', 100, 4, 200);
    Modifica_Pret;
END;
/
ROLLBACK;

--28
CREATE OR REPLACE PROCEDURE Sterge_Carti
IS
    pret_mediu NUMBER;
BEGIN
    SELECT AVG(pret)
    INTO pret_mediu
    FROM carte_DP;

    DELETE FROM carte_DP
    WHERE id_carte NOT IN
    (   SELECT cod_carte
        FROM imprumuta_DP )
    AND pret < pret_mediu;
END;
/
BEGIN
    Sterge_Carti;
END;
/
ROLLBACK;

--29
CREATE OR REPLACE PROCEDURE Dublare_Exemplare AS
    max_imprumuturi NUMBER;
BEGIN
    SELECT MAX(COUNT(cod_carte))
    INTO max_imprumuturi
    FROM imprumuta_DP
    GROUP BY cod_carte;

    UPDATE carte_DP
    SET nrex = nrex*2
    WHERE id_carte IN
    (   SELECT cod_carte
        FROM imprumuta_DP
        GROUP BY cod_carte
        HAVING COUNT(*) = max_imprumuturi );
END;
/
BEGIN
    Dublare_Exemplare;
END;
/
ROLLBACK;

--30
CREATE OR REPLACE PROCEDURE Intarziere
IS
    suma_totala NUMBER := 0;
    suma_curenta NUMBER := 0;
    numar_intarzieri NUMBER := 0;
    suma_pe_carte NUMBER := 0;
    
    CURSOR cititor_cursor IS 
        SELECT id_cititor, nume
        FROM cititor_DP;
    id_cititor cititor_DP.id_cititor%TYPE;
    nume cititor_DP.nume%TYPE;
    
    CURSOR imprumuturi_cursor(id_primit cititor_DP.id_cititor%TYPE) IS 
        SELECT i.dataim, i.dataef
        FROM imprumuta_DP i
        WHERE i.cod_cititor = id_primit;
    data_imprumut imprumuta_DP.dataim%TYPE;
    data_restituire imprumuta_DP.dataef%TYPE;
    
BEGIN
    OPEN cititor_cursor;
    LOOP
        FETCH cititor_cursor INTO id_cititor, nume;
        EXIT WHEN cititor_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Cititorul ' ||nume);
        
        suma_totala := 0;
        suma_curenta := 0;
        numar_intarzieri := 0;
        suma_pe_carte := 0;
        
        OPEN imprumuturi_cursor(id_cititor);
        LOOP
            FETCH imprumuturi_cursor INTO data_imprumut, data_restituire;
            EXIT WHEN imprumuturi_cursor%NOTFOUND;
            
            IF SYSDATE > data_imprumut THEN
                numar_intarzieri := numar_intarzieri + 1;
            END IF;
            
            IF data_restituire IS NOT NULL THEN
                IF data_restituire > data_imprumut THEN
                    suma_totala := suma_totala+(TRUNC(data_restituire)-TRUNC(data_imprumut))*2;
                END IF;
            ELSE
                IF SYSDATE > data_imprumut THEN
                    suma_curenta := suma_curenta+(TRUNC(SYSDATE)-TRUNC(data_imprumut))*2;
                END IF;
            END IF;

            IF data_restituire IS NOT NULL THEN
                suma_pe_carte := suma_pe_carte+(TRUNC(data_restituire)-TRUNC(data_imprumut))*2;
            ELSE
                suma_pe_carte := suma_pe_carte+(TRUNC(SYSDATE)-TRUNC(data_imprumut))*2;
            END IF;
            
        END LOOP;
        CLOSE imprumuturi_cursor;
        
        DBMS_OUTPUT.PUT_LINE('Suma totala data din cauza intarzierii '||suma_totala);
        DBMS_OUTPUT.PUT_LINE('Suma curenta de plata din cauza intarzierii '||suma_curenta);
        DBMS_OUTPUT.PUT_LINE('De cate ori a intarziat '||numar_intarzieri);
        DBMS_OUTPUT.PUT_LINE('Suma totala toate cartile imprumutate (inclusiv taxa pe intarziere) '||suma_pe_carte);
        DBMS_OUTPUT.PUT_LINE('');
        
    END LOOP;
    CLOSE cititor_cursor;
END;
/
BEGIN
    Intarziere;
END;
/

--31
CREATE OR REPLACE PROCEDURE Cititor4_Submultime
IS
    nume cititor_DP.nume%TYPE;
    id_cititor cititor_DP.id_cititor%TYPE;
    CURSOR cititori_cursor IS
        SELECT DISTINCT c.id_cititor, c.nume
        FROM cititor_DP c
        WHERE c.id_cititor IN
        (   SELECT i.cod_cititor
            FROM imprumuta_DP i
            WHERE i.cod_carte IN
            (   SELECT cod_carte
                FROM imprumuta_DP
                WHERE cod_cititor = (SELECT id_cititor FROM cititor_DP WHERE nume = 'Cititor4') )
            GROUP BY i.cod_cititor
            HAVING COUNT(DISTINCT i.cod_carte) =
            (   SELECT COUNT(DISTINCT cod_carte)
                FROM imprumuta_DP
                WHERE cod_cititor = (SELECT id_cititor FROM cititor_DP WHERE nume = 'Cititor4') ) );
            
    carte imprumuta_DP.cod_carte%TYPE;
    CURSOR carti_cursor(id_primit cititor_DP.id_cititor%TYPE) IS
        SELECT cod_carte
        FROM imprumuta_DP
        WHERE cod_cititor = id_primit;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Cititorii care au imprumutat aceleasi carti ca Cititor4 (pot sa aiba carti in plus care nu au fost citite de Cititor4)');
    
    OPEN cititori_cursor;
    LOOP
        FETCH cititori_cursor INTO id_cititor, nume;
        EXIT WHEN cititori_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(nume);
        
        OPEN carti_cursor(id_cititor);
        LOOP
            FETCH carti_cursor INTO carte;
            EXIT WHEN carti_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('  Cartea '||carte);
        END LOOP;
        CLOSE carti_cursor;
    END LOOP;
    CLOSE cititori_cursor;
END;
/
BEGIN
    Cititor4_Submultime;
END;
/

--32
CREATE OR REPLACE PROCEDURE Cititor4
IS
    nume cititor_DP.nume%TYPE;
    id_cititor cititor_DP.id_cititor%TYPE;
    CURSOR cititori_cursor IS
        SELECT DISTINCT c.id_cititor, c.nume
        FROM cititor_DP c
        WHERE NOT EXISTS
        (   SELECT cod_carte
            FROM imprumuta_DP i
            WHERE i.cod_cititor = c.id_cititor
            MINUS
            SELECT cod_carte
            FROM imprumuta_DP i4
            WHERE i4.cod_cititor = (SELECT id_cititor FROM cititor WHERE nume = 'Cititor4') );
            
    carte imprumuta_DP.cod_carte%TYPE;
    CURSOR carti_cursor(id_primit cititor_DP.id_cititor%TYPE) IS
        SELECT cod_carte
        FROM imprumuta_DP
        WHERE cod_cititor = id_primit;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Cititorii care au imprumutat cel mult aceleasi carti ca Cititor4');

    OPEN cititori_cursor;
    LOOP
        FETCH cititori_cursor INTO id_cititor, nume;
        EXIT WHEN cititori_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(nume);
        
        OPEN carti_cursor(id_cititor);
        LOOP
            FETCH carti_cursor INTO carte;
            EXIT WHEN carti_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('  Cartea '||carte);
        END LOOP;
        CLOSE carti_cursor;
    END LOOP;
    CLOSE cititori_cursor;
END;
/
BEGIN
    Cititor4;
END;
/

--33
CREATE OR REPLACE PROCEDURE Cititor4_Exact
IS
    nume cititor_DP.nume%TYPE;
    id_cititor cititor_DP.id_cititor%TYPE;
    CURSOR cititori_cursor IS
        SELECT c.id_cititor, c.nume
        FROM cititor c
        WHERE NOT EXISTS
        (   SELECT cod_carte
            FROM imprumuta i4
            WHERE i4.cod_cititor = (SELECT id_cititor FROM cititor WHERE nume = 'Cititor4')
            MINUS
            SELECT cod_carte
            FROM imprumuta i
            WHERE i.cod_cititor = c.id_cititor )
        AND NOT EXISTS
        (   SELECT cod_carte
            FROM imprumuta i
            WHERE i.cod_cititor = c.id_cititor
            MINUS
            SELECT cod_carte
            FROM imprumuta i4
            WHERE i4.cod_cititor = (SELECT id_cititor FROM cititor WHERE nume = 'Cititor4') );
            
    carte imprumuta_DP.cod_carte%TYPE;
    CURSOR carti_cursor(id_primit cititor_DP.id_cititor%TYPE) IS
        SELECT cod_carte
        FROM imprumuta_DP
        WHERE cod_cititor = id_primit;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Cititorii care au imprumutat exact aceleasi carti ca Cititor4');

    OPEN cititori_cursor;
    LOOP
        FETCH cititori_cursor INTO id_cititor, nume;
        EXIT WHEN cititori_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(nume);
        
        OPEN carti_cursor(id_cititor);
        LOOP
            FETCH carti_cursor INTO carte;
            EXIT WHEN carti_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('  Cartea '||carte);
        END LOOP;
        CLOSE carti_cursor;
    END LOOP;
    CLOSE cititori_cursor;
END;
/
BEGIN
    Cititor4_Exact;
END;
/




