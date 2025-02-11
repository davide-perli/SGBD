-- 13
/* Am un pachet care are o procedura si o functie (1 variabila globala - id_sponsor):
-	functie care primeste un angajat si verifica daca magazinul la care lucreaza e sponsorizat (true sau false)
-	procedura care creaza un tablou indexat cu toti angajatii si pentru angajatii la care da true daca apelez 
functia anterioara, verific daca la nivelul magazinului o treime din suma salariilor angajatilor e suportata de
SumaInvestitie a sponsorului
*/

CREATE OR REPLACE PACKAGE Pachet_Angajati AS
    id_sponsor Sponsor.IDSponsor%TYPE;-- Variabila deoarece doresc daca la apelul functiei pentru un angajat curent sa stiu si sponsorul global (il gasesc in functie si il afisez abia in procedura)
    FUNCTION Verifica_Sponsor_Magazin(id_ang IN Angajati.IDAngajat%TYPE) RETURN BOOLEAN;-- Se face apelarea functiei in interiorul procedurii
    PROCEDURE Afisare_Angajati_Cheltuieli_Acoperite_Magazin;-- Procedura nu va avea nevoie de parametrii deoarece am stabilit ca va lua toti angajatii din BD
END Pachet_Angajati;
/
CREATE OR REPLACE PACKAGE BODY Pachet_Angajati AS

    FUNCTION Verifica_Sponsor_Magazin(id_ang Angajati.IDAngajat%TYPE)
    RETURN BOOLEAN
    IS
        bool_sponsorizat BOOLEAN := FALSE;
    BEGIN
        SELECT M.IDSponsor INTO id_sponsor-- Folosesc variabila globala
        FROM Magazine M
        JOIN Angajati A ON (A.IDMagazin = M.IDMagazin)
        WHERE A.IDAngajat = id_ang;-- Primit ca parametru in functie
        
        IF id_sponsor IS NOT NULL THEN
            bool_sponsorizat := TRUE;
        END IF;
        
        RETURN bool_sponsorizat;
    END Verifica_Sponsor_Magazin;

    PROCEDURE Afisare_Angajati_Cheltuieli_Acoperite_Magazin
    IS
        CURSOR c_angajati IS
            SELECT A.IDAngajat, A.IDMagazin, A.Nume, A.Salariu
            FROM Angajati A;
        id_angajat Angajati.IDAngajat%TYPE;
        id_magazin Magazine.IDMagazin%TYPE;
        nume_ang Angajati.Nume%TYPE;
        salariu_ang Angajati.Salariu%TYPE;
        
        suma_salarii NUMBER;-- Fac suma cu un select ca sa nu ma complic
        total_suma_investitie NUMBER;
    BEGIN
        OPEN c_angajati;
        LOOP
            FETCH c_angajati INTO id_angajat, id_magazin, nume_ang, salariu_ang;
            EXIT WHEN c_angajati%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('Angajatul cu IDAngajat '||id_angajat||', nume '||nume_ang||', salariu '||salariu_ang);
            
            IF Verifica_Sponsor_Magazin(id_angajat) THEN
                DBMS_OUTPUT.PUT_LINE('Angajatul '||id_angajat||' lucreaza la un magazin sponsorizat cu IDMagazin '||id_magazin);
                DBMS_OUTPUT.PUT_LINE('Magazinul are sponsorul '||id_sponsor);
                
                SELECT SUM(A.Salariu) INTO suma_salarii
                FROM Angajati A
                WHERE A.IDMagazin = id_magazin;
                
                SELECT SUM(S.SumaInvestitie) INTO total_suma_investitie
                FROM Magazine M
                JOIN Sponsor S ON (M.IDSponsor = S.IDSponsor)
                WHERE M.IDMagazin = id_magazin;
                
                DBMS_OUTPUT.PUT_LINE('Suma salariilor: '||suma_salarii||', Total suma investitie: '||total_suma_investitie);
                IF (suma_salarii / 3) <= total_suma_investitie THEN-- Conditia de acoperire cheltuieli salarii
                    DBMS_OUTPUT.PUT_LINE('Suma salariilor angajatilor din magazinul curent este acoperita mai mult de o treime din suma de investitie');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('Suma salariilor angajatilor din magazinul curent NU este acoperita mai mult de o treime din suma de investitie');
                END IF;
                
            END IF;
            
        END LOOP;
        CLOSE c_angajati;

    END Afisare_Angajati_Cheltuieli_Acoperite_Magazin;

END Pachet_Angajati;
/
BEGIN
    Pachet_Angajati.Afisare_Angajati_Cheltuieli_Acoperite_Magazin;
    INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
    VALUES (14, 14, 5, null, 'Pufic 14', 66.11);-- Magazinul a fost ales sa nu aiba sponsor
    INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
    VALUES (27, 14, 'Baietica', 'Luminita', TO_DATE('2022-07-29', 'YYYY-MM-DD'), 3600.00);-- Un angajat de la magazinul fara sponsor
    IF Pachet_Angajati.Verifica_Sponsor_Magazin(27) THEN-- TRUE
        DBMS_OUTPUT.PUT_LINE('Angajatul adaugat lucreaza la un magazin sponsorizat');
    ELSE-- FALSE
        DBMS_OUTPUT.PUT_LINE('Angajatul adaugat NU lucreaza la un magazin sponsorizat');
    END IF;
    ROLLBACK;
END;
/