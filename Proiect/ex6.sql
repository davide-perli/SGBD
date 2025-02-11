-- 6
/* Pentru un magazin se vor afisa toti angajatii (tablou indexat) si toti clientii ai fiecarui angajat 
(tablou imbricat), impreuna cu cele mai recente 5 recenzii date de acel client (varray(5)). */

CREATE OR REPLACE PROCEDURE Magazine_Angajati_si_Recenzii(id_magazin IN Magazine.IDMagazin%TYPE)
IS
    TYPE tablou_indexat_angajati IS TABLE OF Angajati.IDAngajat%TYPE INDEX BY BINARY_INTEGER;-- Angajatii care lucreaza la magazin 
    tablou_ang tablou_indexat_angajati;
    nume_ang Angajati.Nume%TYPE;
    prenume_ang Angajati.Prenume%TYPE;
    
    TYPE tablou_imbricat_clienti IS TABLE OF Clienti.IDClient%TYPE;-- Clientii fiecarui angajat
    tablou_clienti tablou_imbricat_clienti;
    
    TYPE varray_recenzii IS VARRAY(5) OF Recenzii.IDRecenzie%TYPE;-- Primele 5 recenzii reprezinta de fapt un varray cu IDRecenzie
    vector_rec varray_recenzii := varray_recenzii();-- Initializare varray
    rating Recenzii.Rating%TYPE;
    comm Recenzii.Comentariu%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Detalii angajati si clienti afisate pentru magazinul '||id_magazin);
    
    SELECT IDAngajat BULK COLLECT INTO tablou_ang
    FROM Angajati 
    WHERE IDMagazin = id_magazin;-- Toti angajatii cu FK = id_magazin dat ca parametru

    FOR i IN 1..tablou_ang.COUNT LOOP
        SELECT Nume, Prenume INTO nume_ang, prenume_ang
        FROM Angajati
        WHERE IDAngajat = tablou_ang(i);
        
        DBMS_OUTPUT.PUT_LINE('Angajatul cu IDAngajat '||tablou_ang(i)||' ('||nume_ang||' '||prenume_ang||') a vandut comenzi la clientii:');

        SELECT DISTINCT(IDClient) BULK COLLECT INTO tablou_clienti
        -- Atentie la conditia de DISTINCT deoarece pot exista doua comenzi diferite care sa aiba valorile de IDAngajat si IDClient aceleasi, deci duplicat la IDClient
        FROM Vanzari
        WHERE IDAngajat = tablou_ang(i);-- Clientii angajatului cu IDAngajat tablou_ang(i)

        FOR j IN 1..tablou_clienti.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Client: '||tablou_clienti(j));

            -- 5 recenzii recente ale clientului curent
            SELECT IDRecenzie
            BULK COLLECT INTO vector_rec
            FROM Recenzii
            WHERE IDClient = tablou_clienti(j)
            ORDER BY DataRecenzie DESC;
            
            FOR k IN 1..LEAST(vector_rec.COUNT, vector_rec.LIMIT) LOOP
                SELECT Rating, Comentariu INTO rating, comm
                FROM Recenzii
                where IDRecenzie = vector_rec(k);
                -- Practic daca in vector_rec pentru clientul curent sunt mai putin de 5 recenzii contorul merge pana la vector_rec.COUNT
                -- Altfel, daca sunt fix 5 recenzii in vector_rec, se merge pana la vector_rec.LIMIT
                DBMS_OUTPUT.PUT_LINE('Recenzie cu IDRecenzie '||vector_rec(k)||', rating '||rating||', comentariu '||comm);
            END LOOP;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END Magazine_Angajati_si_Recenzii;
/
BEGIN
    Magazine_Angajati_si_Recenzii(1);
    Magazine_Angajati_si_Recenzii(2);
    Magazine_Angajati_si_Recenzii(3);
END;
/
