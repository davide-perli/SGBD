-- 10
/* Inserarea in tabela Magazine genereaza modificari a rentabilitatii la ora a magazinului 
aflat la aceeasi adresa cu sponsorul: ma folosesc de o noua tabela care grupeaza ce se afla 
in select dupa IDSponsor si cu ajutorul unui cursor care e parcurs la fiecare inserare, modifica 
datele din tabela Rentabilitate_Magazine_Bazata_Sponsor in fucntie de IDSponsor FK din noua inserare 
in Magazine. Legat de regulile de modificare a rentabilitatii la ora: RentabilitateOra creste cu 20% 
pentru suma totala de investitie e mai mare ca 10000, altfel scade cu 10%. */

--DROP TABLE Rentabilitate_Magazine_Bazata_Sponsor;

-- Vreau ca noul tabel sa fie grupat dupa IDMagazin astfel sa pot sa gasesc numarul de magazine sustinute de acelasi sponsor si o medie a rentabilitatii la ora dintre aceste magazine sustinute
CREATE TABLE Rentabilitate_Magazine_Bazata_Sponsor AS
SELECT S.IDSponsor, COUNT(M.IDMagazin) AS NrMagazine, AVG(M.RentabilitateOra) AS RentabilitateOra
FROM Magazine M
JOIN Sponsor S ON (M.IDSponsor = S.IDSponsor)
GROUP BY S.IDSponsor;

-- Suma de sponsorizare e 0 in momentul asta
ALTER TABLE Rentabilitate_Magazine_Bazata_Sponsor
ADD SumaSponsorizare NUMBER DEFAULT 0;

CREATE OR REPLACE TRIGGER Trigger_Sponsor_Rentabilitate_Magazine-- Trigger la nivel de comanda (fara for each row)
AFTER INSERT ON Magazine
DECLARE
    CURSOR c_sponsori_info IS
        SELECT S.IDSponsor, COUNT(M.IDMagazin), AVG(M.RentabilitateOra), SUM(S.SumaInvestitie)
        FROM Magazine M
        JOIN Sponsor S ON (M.IDSponsor = S.IDSponsor)
        GROUP BY S.IDSponsor;-- Cursorul practic imi recalculeaza numarul de magazine, media si totalul sumei investite de sponsor
    id_sponsor Sponsor.IDSponsor%TYPE;
    nr_magazine NUMBER;
    medie_rentabilitate_ora Magazine.RentabilitateOra%TYPE;
    suma_sponsorizare_total NUMBER;

BEGIN
    OPEN c_sponsori_info;
    LOOP
        FETCH c_sponsori_info INTO id_sponsor, nr_magazine, medie_rentabilitate_ora, suma_sponsorizare_total;
        EXIT WHEN c_sponsori_info%NOTFOUND;
        
        UPDATE Rentabilitate_Magazine_Bazata_Sponsor-- dau update la coloanele din tabel cu ce se afla curent in cursor
        SET NrMagazine = nr_magazine,
            SumaSponsorizare = suma_sponsorizare_total,
            RentabilitateOra = 
            CASE 
                WHEN suma_sponsorizare_total >= 10000 THEN LEAST(medie_rentabilitate_ora + (medie_rentabilitate_ora * 0.2), 100)
                ELSE GREATEST(medie_rentabilitate_ora - (medie_rentabilitate_ora * 0.1), 0)
            END-- Daca suma totala investita e mai mare ca 10000, creste rentabilitatea la ora, dar exprimat in functie de medie_rentabilitate_ora ce e intotdeauna recalculat in cursor
        WHERE IDSponsor = id_sponsor;
        -- Cu LEAST si GREATEST ma aisgur ca nu intrec limitele logice (chiar daca nu am pus un constraint in noul tabel)
        
    END LOOP;
    CLOSE c_sponsori_info;
    
END Trigger_Sponsor_Rentabilitate_Magazine;
/
INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (14, 8, 2, 11, 'Pufic 14', 10);-- Incrementez magazinele sponsorului 11, rentabilitate = 41.517, suma = 7037.97
INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (15, 8, 2, 11, 'Pufic 15', 24);-- Incrementez magazinele sponsorului 11, scade de la 41.517 la 36.54 rentabilitatea si creste suma investita cu inca 2345.99 (2345.99 + 7037.97 = 9383.96)
INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (16, 8, 2, 11, 'Pufic 16', 79.99);-- Incrementez magazinele sponsorului 11, Creste de la 36.54 la 58.176 rentabilitatea si creste suma investita la 11729.95
ROLLBACK;
DROP TRIGGER Trigger_Sponsor_Rentabilitate_Magazine;