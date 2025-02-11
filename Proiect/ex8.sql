-- 8
/* Pentru un sponsor se ia magazinul aflat la aceeasi adresa (daca nu exista niciun magazin la IDAresa FK din Sponsor, 
atunci NO_DATA_FOUND) si se afiseaza angajatul cu numarul maxim de arome distincte procesate 
(NO_DATA_FOUND daca nu exista niciun angajat care sa lucreze la magazinul gasit, TOO_MANY_ROWS daca exista 2 sau mai 
multi angajati cu numarul maxim de arome procesate, deoarece am stabilit ca vreau doar un nume de angajat).*/

-- De retinut ca magazinele cu id de la 1 la 13 au aceeasi adresa ca si id-ul, iar restul adreselor de la 14-18 pot apartine doar sponsorilor
-- Deci adresele in comun de la magazine si sponsori sunt intre 1-13, dar trebuie verificat in tabela Sponsor
CREATE OR REPLACE FUNCTION Verifica_Adresa_Sponsor_Angajat_Maxim_Arome(id_sponsor IN Sponsor.IDSponsor%TYPE)
RETURN VARCHAR
IS
    id_magazin Magazine.IDMagazin%TYPE;

    CURSOR c_angajat(id Magazine.IDMagazin%TYPE) IS
        SELECT A.Nume, COUNT(DISTINCT(AA.IDAroma)) AS nr_arome_distincte
        FROM Angajati A
        JOIN Vanzari V ON A.IDAngajat = V.IDAngajat
        JOIN Comenzi C ON V.IDComanda = C.IDComanda
        JOIN AdaugaAroma AA ON AA.IDComanda = C.IDComanda
        WHERE A.IDMagazin = id
        GROUP BY A.Nume;

    TYPE record_ang IS RECORD (
        nume_ang Angajati.Nume%TYPE,
        nr_arome_distincte NUMBER
    );
    TYPE tablou_indexat_angajat IS TABLE OF record_ang INDEX BY BINARY_INTEGER;
    tablou_ang tablou_indexat_angajat;
    
    nume_ang_cautat VARCHAR(50);
    maxim_arome_distincte NUMBER := 0;-- Maxim de arome la nivel de magazin 
    count_ang_cu_nr_maxim_arome NUMBER := 0;-- Numara angajatii cu numarul maxim de arome procesate la magazinul respectiv

BEGIN
    -- Un alt bloc begin poentru a trata NO_DATA_FOUND de la magazine, din moment ce va exista si la angajati
    BEGIN
        SELECT M.IDMagazin
        INTO id_magazin
        FROM Magazine M
        JOIN Sponsor S ON (S.IDAdresa = M.IDAdresa)-- Atentie! JOIN in functie de adresa si nu IDSponsor
        WHERE S.IDSponsor = id_sponsor;

        IF id_magazin IS NULL THEN-- Atunci nu exista niciun magazin asociat cu adresa sponsorului
            RAISE NO_DATA_FOUND;
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Nu exista niciun magazin asociat cu adresa sponsorului IDSponsor '||id_sponsor;
    END;

    BEGIN
        OPEN c_angajat(id_magazin);-- Numele angajatilor si numar de arome distincte procesate de ei pentru magazinul gasit anterior (cursor parametrizat)
        FETCH c_angajat BULK COLLECT INTO tablou_ang;
        CLOSE c_angajat;
        
        IF tablou_ang.COUNT = 0 THEN-- Daca BULK COLLECT intoarce un tablou gol, inseamna ca nu exista niciun angajat care lucreaza la magazin
            RAISE NO_DATA_FOUND;
        END IF;
        
        -- Parcurg toti angajatii pentru a-l gasi pe cel cu numar maxim de arome distincte
        -- Nu il gasesc chiar in acest moment, deoarece stiu ca pot exista mai multi, asa ca retin in variabila count_ang_cu_nr_maxim_arome nr de ang cu proprietatea asta
        FOR i IN 1..tablou_ang.COUNT LOOP
            IF tablou_ang(i).nr_arome_distincte > maxim_arome_distincte THEN
                maxim_arome_distincte := tablou_ang(i).nr_arome_distincte;
                count_ang_cu_nr_maxim_arome := 1;-- Un nou maxim inseamna ca e un singur angajat cu acest maxim si se reseteaza counter-ul
            ELSIF tablou_ang(i).nr_arome_distincte = maxim_arome_distincte THEN
                count_ang_cu_nr_maxim_arome := count_ang_cu_nr_maxim_arome + 1;-- Mai multi angajati cu acelasi maxim
            END IF;
        END LOOP;
        
        IF count_ang_cu_nr_maxim_arome > 1 THEN-- Prea multi ang
            RAISE TOO_MANY_ROWS;
        END IF;

        -- M-am asigurat ca e doar unul, ii gasesc numele si termin
        SELECT A.Nume INTO nume_ang_cautat 
        FROM Angajati A 
        WHERE A.IDAngajat = (   SELECT A2.IDAngajat -- Subcererea va returna neaparat un IDAngajat, din moment ce am stabilit WHERE A.IDAngajat =
                                FROM Angajati A2 
                                JOIN Vanzari V ON (A2.IDAngajat = V.IDAngajat) 
                                JOIN Comenzi C ON (V.IDComanda = C.IDComanda)
                                JOIN AdaugaAroma AA ON (AA.IDComanda = C.IDComanda)
                                WHERE A2.IDMagazin = id_magazin 
                                GROUP BY A2.IDAngajat 
                                HAVING COUNT(DISTINCT AA.IDAroma) = maxim_arome_distincte );

        return nume_ang_cautat;
        -- Asa ar fi fost daca era gandita ca o procedura (sa afiseze mesaje)
        --DBMS_OUTPUT.PUT_LINE('Angajatul cu cele mai multe arome distincte este '||nume_ang_cautat);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Nu exista angajati in magazinul cu IDMagazin '||id_magazin;
        WHEN TOO_MANY_ROWS THEN
            RETURN 'Prea multi angajati cu acelasi numar de arome distincte procesate in magazinul cu IDMagazin '||id_magazin;
    END;
END Verifica_Adresa_Sponsor_Angajat_Maxim_Arome;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(Verifica_Adresa_Sponsor_Angajat_Maxim_Arome(1));-- NO_DATA_FOUND angajati care lucreaza
    DBMS_OUTPUT.PUT_LINE(Verifica_Adresa_Sponsor_Angajat_Maxim_Arome(7));
    DBMS_OUTPUT.PUT_LINE(Verifica_Adresa_Sponsor_Angajat_Maxim_Arome(2));
    DBMS_OUTPUT.PUT_LINE(Verifica_Adresa_Sponsor_Angajat_Maxim_Arome(4));-- NO_DATA_FOUND magazine la adresa
    DBMS_OUTPUT.PUT_LINE(Verifica_Adresa_Sponsor_Angajat_Maxim_Arome(5));-- TOO_MANY_ROWS angajati cu acelasi max de arome distincte
END;
/