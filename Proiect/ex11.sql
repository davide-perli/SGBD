-- 11
/* Pentru un inserarea unui nou angajat, creste RentabilitateOra cu 8% pentru toate magazinele cu acelasi numar de 
angajati daca magazinul la care lucreaza angajatul inainte sa fie adaugat are un numar de angajati mai mic 
decat 4 si egal, sau creste cu 2% daca numarul de angajati e mai mare. De retinut ca numarul de angajati 
e calculat fara angajatul care urmeaza sa fie adaugat. Presupun ca doar peste o valoare de 4 angajati se 
genereaza mai putin estimated revenue pentru acel magazin, adica un procent mai mic de RentabilitateOra se 
adauga per angajat daca e intrecuta limita. */

CREATE OR REPLACE TRIGGER Trigger_Rentabilitate_Angajati
BEFORE INSERT ON Angajati-- Dupa inserare
FOR EACH ROW-- Se parcurge fiecare rand din Magazine (desi se modifica un singur magazin) si se modifica dupa inserarea unui angajat, dar e nevoie de FOR EACH ROW pentru operatorul :NEW
DECLARE
    id_magazin Magazine.IDMagazin%TYPE;
    nr_curent_ang NUMBER;
BEGIN
    id_magazin := :NEW.IDMagazin;

    SELECT COUNT(*)
    INTO nr_curent_ang
    FROM Angajati
    WHERE IDMagazin = id_magazin;-- Gasesc numarul de angajati inainte sa inserez noul ang

    -- Rentabilitatea creste cu mai mult daca la un magazin sunt mai putini angajati, cand incep sa fie mai multi, cresterea nu mai e la fel de mare
    IF nr_curent_ang <= 4 THEN
        UPDATE Magazine
        SET RentabilitateOra = LEAST(RentabilitateOra + RentabilitateOra * 0.08, 99)
        WHERE IDMagazin IN (    SELECT IDMagazin
                                FROM Angajati
                                GROUP BY IDMagazin
                                HAVING COUNT(*) = nr_curent_ang );-- Are sens trigger cu for each row pentru ca se actualizeaza mai multe magazine cu acelasi numar de angajati ca cel la care tocmai s-a facut insert de FK in Angajati
    ELSE
        UPDATE Magazine
        SET RentabilitateOra = LEAST(RentabilitateOra + RentabilitateOra * 0.02, 99)
        WHERE IDMagazin IN (    SELECT IDMagazin
                                FROM Angajati
                                GROUP BY IDMagazin
                                HAVING COUNT(*) = nr_curent_ang );
    END IF;

END Trigger_Rentabilitate_Angajati;
/
-- Magazinul cu IDMagazin 11 are 3 angajati si rentabilitate 81.23
INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (27, 11, 'Vlad', 'Mircea', TO_DATE('2022-07-29', 'YYYY-MM-DD'), 3600.00);-- 3 ang (fara cel curent) la magazinul 11, creste cu 8%: 87.73 la id_magazin 11, 53.99 la id_magazin 3, 99 la id_magazin 9; creste cu 2%: 99 la id_magazin 6
INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (28, 11, 'Filipescu', 'Daniel', TO_DATE('2022-07-29', 'YYYY-MM-DD'), 3600.00);-- 4 ang la magazinul 11, creste cu 8%: 94.75 la id_magazin 11, 76.57 la id_magazin 1
INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (29, 11, 'Dumitrescu', 'Dinu', TO_DATE('2022-07-29', 'YYYY-MM-DD'), 3600.00);-- 5 ang la magazinul 11, creste cu 2%: 96.65 la id_magazin 11
INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (30, 11, 'Moraru', 'Rodica', TO_DATE('2022-07-29', 'YYYY-MM-DD'), 3600.00);-- 6 ang la magazinul 11, creste cu 2%: 98.58 la id_magazin 11
-- 7 angajati la magazinul 11
ROLLBACK;
DROP TRIGGER Trigger_Rentabilitate_Angajati;