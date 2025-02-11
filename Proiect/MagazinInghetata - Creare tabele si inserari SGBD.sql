/*DELETE FROM AdaugaAroma;
DELETE FROM Recenzii;
DELETE FROM Vanzari;
DELETE FROM Angajati;
DELETE FROM Comenzi;
DELETE FROM Arome;
DELETE FROM Furnizori;
DELETE FROM Clienti;
DELETE FROM Magazine;
DELETE FROM Sponsor;
DELETE FROM OrarMagazine;
DELETE FROM Adresa;

DROP SEQUENCE SecventaComanda;

DROP TABLE Vanzari CASCADE CONSTRAINTS;
DROP TABLE Comenzi CASCADE CONSTRAINTS;
DROP TABLE Clienti CASCADE CONSTRAINTS;
DROP TABLE Sponsor CASCADE CONSTRAINTS;
DROP TABLE Magazine CASCADE CONSTRAINTS;
DROP TABLE Furnizori CASCADE CONSTRAINTS;
DROP TABLE Arome CASCADE CONSTRAINTS;
DROP TABLE Angajati CASCADE CONSTRAINTS;
DROP TABLE OrarMagazine CASCADE CONSTRAINTS;
DROP TABLE Recenzii CASCADE CONSTRAINTS;
DROP TABLE AdaugaAroma CASCADE CONSTRAINTS;
DROP TABLE Adresa CASCADE CONSTRAINTS;*/

-- Creare secventa
CREATE SEQUENCE SecventaComanda
START WITH 10000
INCREMENT BY 1
MAXVALUE 99999
NOCYCLE
NOCACHE;

-- Creare tabele
--1
CREATE TABLE Clienti (
    IDClient INT PRIMARY KEY,
    Prenume VARCHAR2(50) NOT NULL,
    Nume VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100),
    NumarTelefon VARCHAR2(15)
);

--2
CREATE TABLE Comenzi (
    IDComanda NUMBER(5) PRIMARY KEY,
    DataComanda TIMESTAMP NOT NULL,
    TipPlata CHAR(4) NOT NULL,
    CONSTRAINT Plata CHECK(TipPlata = 'card' OR TipPlata = 'cash')
);

--3
CREATE TABLE Adresa (
    IDAdresa INT PRIMARY KEY,
    Oras VARCHAR(255),
    Strada VARCHAR(255)
);

--4
CREATE TABLE Sponsor (
    IDSponsor INT PRIMARY KEY,
    IDAdresa INT,
    Nume VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100),
    NumarTelefon VARCHAR2(15),
    SumaInvestitie NUMBER(6, 2) NOT NULL,
    NumarEvenimente INT,
    FOREIGN KEY (IDAdresa) REFERENCES Adresa (IDAdresa)
);

--5
CREATE TABLE OrarMagazine (
    IDOrar INT PRIMARY KEY,
    OraDeschidere TIMESTAMP NOT NULL,
    OraInchidere TIMESTAMP NOT NULL
);

--6
CREATE TABLE Magazine (
    IDMagazin INT PRIMARY KEY,
    IDAdresa INT,
    IDOrar INT,
    IDSponsor INT,
    NumeMagazin VARCHAR2(100) UNIQUE,
    RentabilitateOra NUMBER(5, 2),
    CONSTRAINT ConstraintProcent CHECK(RentabilitateOra > 0 AND RentabilitateOra < 100),
    FOREIGN KEY (IDAdresa) REFERENCES Adresa (IDAdresa),
    FOREIGN KEY (IDOrar) REFERENCES OrarMagazine(IDOrar),
    FOREIGN KEY (IDSponsor) REFERENCES  Sponsor(IDSponsor)
);

--7
CREATE TABLE Angajati (
    IDAngajat INT PRIMARY KEY,
    IDMagazin INT,
    Nume VARCHAR2(100) NOT NULL,
    Prenume VARCHAR2(100) NOT NULL,
    DataAngajare DATE NOT NULL,
    Salariu DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (IDMagazin) REFERENCES Magazine(IDMagazin)
);

--8
CREATE TABLE Furnizori (
    IDFurnizor INT PRIMARY KEY,
    NumeFurnizor VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100),
    NumarTelefon VARCHAR2(15)
);

--9
CREATE TABLE Arome (
    IDAroma INT PRIMARY KEY,
    IDFurnizor INT,
    Pret DECIMAL(10, 2) NOT NULL,
    NumeAroma VARCHAR2(100) UNIQUE,
    FOREIGN KEY (IDFurnizor) REFERENCES Furnizori (IDFurnizor) ON DELETE SET NULL
);

--10
CREATE TABLE Vanzari (
    IDClient INT,
    IDAngajat INT,
    IDComanda INT,
    DataVanzare TIMESTAMP NOT NULL,
    PRIMARY KEY (IDClient, IDAngajat, IDComanda),
    FOREIGN KEY (IDClient) REFERENCES Clienti(IDClient),
    FOREIGN KEY (IDAngajat) REFERENCES Angajati(IDAngajat),
    FOREIGN KEY (IDComanda) REFERENCES Comenzi(IDComanda) ON DELETE CASCADE
);

--11
CREATE TABLE Recenzii (
    IDRecenzie INT PRIMARY KEY,
    IDClient INT,
    Rating INT NOT NULL,
    Comentariu VARCHAR2(255),
    DataRecenzie DATE,
    FOREIGN KEY (IDClient) REFERENCES Clienti (IDClient)
);

--12
CREATE TABLE AdaugaAroma (
    IDComanda INT,
    IDAroma INT,
    Cantitate INT NOT NULL,
    PRIMARY KEY (IDComanda, IDAroma),
    FOREIGN KEY (IDComanda) REFERENCES Comenzi (IDComanda) ON DELETE CASCADE,
    FOREIGN KEY (IDAroma) REFERENCES Arome (IDAroma)
);


-- Inserare date in tabele
--1 Inserare date in Clienti
INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (1, 'Alin', 'George', 'alin.george@gmail.com', '1234567890');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (2, 'Teo', 'Vas', 'teo.vasile@gmail.com', '0987654321');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (3, 'Maria', 'Beni', 'maria.beni@gmail.com', '0687645321');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (4, 'Ana', 'Vasilescu', 'ana.vasilescu@gmail.com', '0775101171');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (5, 'Robi', 'Nico', 'robi.nico@gmail.com', '0216674478');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (6, 'Andrei', 'Paun', 'andrei.paun@gmail.com', '0217654321');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (7, 'George', 'Bob', 'george.bob@gmail.com', '0887654321');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (8, 'Gabi', 'Paki', 'gabi.paki@gmail.com', '087240521');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (9, 'Gabriel', 'Parintele', 'gabriel.parintele@gmail.com', '0314375461');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (10, 'Ionut', 'Pacate', 'ionut.pacate@gmail.com', '0354654321');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (11, 'Teodor', 'Ene', 'teodor.ene@gmail.com', '0259954624');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (12, 'Andra', 'Andreescu', 'andra.andreescu@gmail.com', '078101178');

INSERT INTO Clienti (IDClient, Prenume, Nume, Email, NumarTelefon)
VALUES (13, 'Melisa', 'Marcel', 'melisa.marcel@gmail.com', '0554121363');

--2 Inserare date in Comenzi
INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2023-05-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2023-05-02 15:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2023-06-02 13:42:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2022-08-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-07-30 11:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2022-01-02 17:41:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-08-21 14:48:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-03-09 11:39:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2023-12-02 10:28:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-11-29 19:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-09-25 18:18:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-01-12 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-06-22 20:55:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-05-19 09:55:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2023-02-09 11:23:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2023-04-14 12:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2023-03-11 17:21:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2023-11-17 20:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-05-13 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'card');

INSERT INTO Comenzi (IDComanda, DataComanda, TipPlata)
VALUES (SecventaComanda.nextval, TO_DATE('2024-09-09 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'cash');

--3 Inserare date in Adresa
INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (1, 'Bulevardul Grigorescu 3', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (2, 'Bulevardul Decebal 2', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (3, 'Strada Lotrioarei 4', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (4, 'Intrarea Odobesti 8', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (5, 'Bulevardul Traian 9', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (6, 'Strada Bordesti 4', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (7, 'Bulevardul Victoriei 23', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (8, 'Bulevardul Kiselef 17', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (9, 'Bulevardul Roseti 7', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (10, 'Bulevardul Unirii 1', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (11, 'Strada Livezilor 18', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (12, 'Soseaua Oltenitei 6', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (13, 'Soseaua Pajura 34', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (14, 'Bulevardul Roseti 34', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (15, 'Soseaua Pajura 5', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (16, 'Bulevardul Grigorescu 34', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (17, 'Bulevardul Decebal 17', 'Bucuresti');

INSERT INTO Adresa (IDAdresa, Strada, Oras)
VALUES (18, 'Strada Lunca Bradului 3', 'Bucuresti');

--4 Inserare date in Sponsor
INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (1, 5, 'DairyQueen', 'dairy.queen@gmail.com', '0880101170', 3455.99, 3);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (2, 3, 'Alpro', 'alpro@gmail.com', '0770101170', 5670.20, 4);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (3, 14, 'Olympus', 'olympus@gmail.com', '021101170', 4320.50, 6);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (4, 17, 'Zuzu', 'zuzu@gmail.com', '0880187170', 6779.99, 3);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (5, 6, 'Heidi', 'heidi@gmail.com', '0310107870', 7000.50, 6);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (6, 12, 'Milka', 'milka@gmail.com', '0550101170', 9100.30, 6);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (7, 2, 'Michelin', 'michelin@gmail.com', '0450101170', 5000.60, 3);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (8, 15, 'PlusINC', 'plus@gmail.com', '0225434587', 3029.99, 2);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (9, 16, 'Ikea', 'ikea@gmail.com', '0334101170', 7499.99, 6);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (10, 18, 'XXLUX', 'xxlux@gmail.com', '0775801170', 9350.30, 3);

INSERT INTO Sponsor (IDSponsor, IDAdresa, Nume, Email, NumarTelefon, SumaInvestitie, NumarEvenimente)
VALUES (11, 16, 'Decathlon', 'decathlon@gmail.com', '0780254170', 2345.99, 2);

--5 Inserare date in tabela OrarMagazine
INSERT INTO OrarMagazine (IDOrar, OraDeschidere, OraInchidere)
VALUES (1, TO_DATE('08:30:00', 'HH24:MI:SS'), TO_DATE('17:25:00', 'HH24:MI:SS'));

INSERT INTO OrarMagazine (IDOrar, OraDeschidere, OraInchidere)
VALUES (2, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('23:00:00', 'HH24:MI:SS'));

INSERT INTO OrarMagazine (IDOrar, OraDeschidere, OraInchidere)
VALUES (3, TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('14:00:00', 'HH24:MI:SS'));

INSERT INTO OrarMagazine (IDOrar, OraDeschidere, OraInchidere)
VALUES (4, TO_DATE('07:30:00', 'HH24:MI:SS'), TO_DATE('19:30:00', 'HH24:MI:SS'));

INSERT INTO OrarMagazine (IDOrar, OraDeschidere, OraInchidere)
VALUES (5, TO_DATE('09:30:00', 'HH24:MI:SS'), TO_DATE('18:30:00', 'HH24:MI:SS'));

INSERT INTO OrarMagazine (IDOrar, OraDeschidere, OraInchidere)
VALUES (6, TO_DATE('07:00:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));

INSERT INTO OrarMagazine (IDOrar, OraDeschidere, OraInchidere)
VALUES (7, TO_DATE('08:30:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));

INSERT INTO OrarMagazine (IDOrar, OraDeschidere, OraInchidere)
VALUES (8, TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:30:00', 'HH24:MI:SS'));

--6 Inserare date in Magazine
INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (1, 1, 7, 11, 'Pufic 1', 70.90);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (2, 2, 5, 11, 'Pufic 2', 57.50);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (3, 3, 8, 3, 'Pufic 3', 49.99);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (4, 4, 8, 1, 'Pufic 4', 23.79);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (5, 5, 8, 5, 'Pufic 5', 78.80);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (6, 6, 1, 6, 'Pufic 6', 99.99); -- conceptual trebuie sa existe un maxim

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (7, 7, 3, 8, 'Pufic 7', 75.81);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (8, 8, 2, 2, 'Pufic 8', 68.99);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (9, 9, 3, 7, 'Pufic 9', 95.55);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (10, 10, 4, 4, 'Pufic 10', 57.89);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (11, 11, 7, 2, 'Pufic 11', 81.23);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (12, 12, 6, 10, 'Pufic 12', 87.47);

INSERT INTO Magazine (IDMagazin, IDAdresa, IDOrar, IDSponsor, NumeMagazin, RentabilitateOra)
VALUES (13, 13, 5, 9, 'Pufic 13', 66.11);

--7 Inserare date pentru Angajati
INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (1, 1, 'Popescu', 'Ion', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 3500.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (2, 1, 'Popa', 'Iooan', TO_DATE('2020-03-18', 'YYYY-MM-DD'), 3300.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (3, 1, 'Ionescu', 'Maria', TO_DATE('2019-05-20', 'YYYY-MM-DD'), 4000.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (4, 2, 'Ioan', 'Antonio', TO_DATE('2018-12-20', 'YYYY-MM-DD'), 4000.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (5, 3, 'Constantinescu', 'Ana', TO_DATE('2021-03-10', 'YYYY-MM-DD'), 3200.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (6, 10, 'Constantin', 'Teo', TO_DATE('2021-02-10', 'YYYY-MM-DD'), 3210.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (7, 3, 'Dumitrescu', 'Mihai', TO_DATE('2018-11-05', 'YYYY-MM-DD'), 4200.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (8, 4, 'Dumitru', 'Matei', TO_DATE('2018-09-04', 'YYYY-MM-DD'), 4100.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (9, 2, 'Armin', 'Matei', TO_DATE('2024-05-14', 'YYYY-MM-DD'), 2200.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (10, 1, 'Anastasia', 'Maria', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 2300.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (11, 6, 'Giunca', 'Andrei', TO_DATE('2024-05-22', 'YYYY-MM-DD'), 2000.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (12, 6, 'Gheorge', 'Roberto', TO_DATE('2022-07-25', 'YYYY-MM-DD'), 2800.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (13, 9, 'Barca', 'Stefan', TO_DATE('2023-10-03', 'YYYY-MM-DD'), 2700.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (14, 7, 'Bankai', 'Mihai', TO_DATE('2023-07-30', 'YYYY-MM-DD'), 2750.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (15, 8, 'Stefanescu', 'Andi', TO_DATE('2022-09-14', 'YYYY-MM-DD'), 3000.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (16, 5, 'Stamate', 'Andrei', TO_DATE('2022-02-21', 'YYYY-MM-DD'), 3100.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (17, 6, 'Scarlat', 'Ana', TO_DATE('2021-07-23', 'YYYY-MM-DD'), 4000.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (18, 9, 'Voinescu', 'Anastasia', TO_DATE('2020-08-27', 'YYYY-MM-DD'), 4300.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (19, 11, 'Enache', 'Maria', TO_DATE('2020-11-17', 'YYYY-MM-DD'), 4200.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (20, 10, 'Enitei', 'Andreea', TO_DATE('2020-10-19', 'YYYY-MM-DD'), 4100.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (21, 11, 'Ridu', 'Monica', TO_DATE('2019-12-08', 'YYYY-MM-DD'), 4300.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (22, 11, 'Tunaru', 'Monica', TO_DATE('2019-08-05', 'YYYY-MM-DD'), 4100.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (23, 9, 'Enica', 'Raluca', TO_DATE('2023-08-25', 'YYYY-MM-DD'), 3100.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (24, 12, 'Afina', 'Ramona', TO_DATE('2023-08-20', 'YYYY-MM-DD'), 3100.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (25, 3, 'Anapol', 'Denisa', TO_DATE('2022-09-30', 'YYYY-MM-DD'), 3700.00);

INSERT INTO Angajati (IDAngajat, IDMagazin, Nume, Prenume, DataAngajare, Salariu)
VALUES (26, 13, 'Ceausu', 'Dakia', TO_DATE('2022-07-29', 'YYYY-MM-DD'), 3600.00);

--8 Inserare date in Furnizori
INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (1, 'Chocolate Factory', 'chocolate.factory@gmail.com', '1234567890');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (2, 'Carrefour', 'carrefour@gmail.com', '9876543210');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (3, 'Lidl', 'lidl@gmail.com', '5558889999');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (4, 'MegaImage', 'megaimage@gmail.com', '1548889939');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (5, 'Oreo', 'oreo@gmail.com', '07558889987');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (6, 'GusturiRomanesti', 'gusturiromanesti@gmail.com', '03225689999');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (7, 'Mizo', 'mizo@gmail.com', '355779999');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (8, 'ChocoMix', 'chocomix@gmail.com', '0658389979');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (9, 'CocaCola', 'cocacola@gmail.com', '2158866499');

INSERT INTO Furnizori (IDFurnizor, NumeFurnizor, Email, NumarTelefon)
VALUES (10, 'Fruitty', 'fruitty@gmail.com', '041548523');

--9 Inserare date in Arome
INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (1, 1, 5.50, 'Fistic');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (2, 1, 2.50, 'Ciocolata');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (3, 1, 3.45, 'Cookies and Cream');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (4, 2, 1.45, 'Bubblegum');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (5, 4, 5.35, 'Cirese');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (6, 1, 6.75, 'Kinder');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (7, 7, 3.00, 'Banane');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (8, 5, 5.65, 'Oreo');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (9, 10, 2.75, 'Caise');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (10, 10, 3.25, 'Menta');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (11, 2, 3.00, 'Alune');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (12, 6, 1.65, 'Portocale');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (13, 8, 4.15, 'Caramel');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (14, 10, 3.00, 'Lamaie');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (15, 10, 3.25, 'Fructe de padure');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (16, 7, 2.00, 'Vanilie');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (17, 3, 3.00, 'Zmeura');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (18, 4, 6.55, 'Nuci si smochine');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (19, 9, 4.55, 'Coca Cola');

INSERT INTO Arome (IDAroma, IDFurnizor, Pret, NumeAroma)
VALUES (20, 8, 4.40, 'Triple Choco');

--10 Inserare date in Vanzari
INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (1, 21, 10000, TO_DATE('2023-05-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));-- dupa 30 min

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (1, 1, 10001, TO_DATE('2023-05-04 15:45:00', 'YYYY-MM-DD HH24:MI:SS'));-- dupa 2 zile

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (1, 3, 10002, TO_DATE('2023-06-02 13:42:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (2, 12, 10003, TO_DATE('2022-08-27 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));-- dupa 3 zile

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (2, 12, 10004, TO_DATE('2024-07-31 12:35:00', 'YYYY-MM-DD HH24:MI:SS'));-- dupa 1 zi

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (3, 11, 10005, TO_DATE('2022-01-02 18:41:00', 'YYYY-MM-DD HH24:MI:SS'));-- dupa 1 ora

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (3, 14, 10006, TO_DATE('2024-08-23 14:48:00', 'YYYY-MM-DD HH24:MI:SS'));-- dupa 2 zile

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (4, 12, 10007, TO_DATE('2024-03-09 11:39:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (5, 13, 10008, TO_DATE('2023-12-03 10:28:00', 'YYYY-MM-DD HH24:MI:SS'));-- dupa 1 zi

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (6, 3, 10009, TO_DATE('2024-11-29 20:25:00', 'YYYY-MM-DD HH24:MI:SS'));-- dupa 1 ora

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (7, 6, 10010, TO_DATE('2024-09-25 18:18:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (7, 7, 10011, TO_DATE('2024-01-12 20:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (8, 21, 10012, TO_DATE('2024-06-22 20:55:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (9, 20, 10013, TO_DATE('2024-05-19 09:55:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (10, 9, 10014, TO_DATE('2023-02-09 11:23:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (11, 25, 10015, TO_DATE('2023-04-14 12:35:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (12, 1, 10016, TO_DATE('2023-03-11 17:21:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (12, 2, 10017, TO_DATE('2023-11-17 20:50:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (13, 25, 10018, TO_DATE('2024-05-13 14:45:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Vanzari (IDClient, IDAngajat, IDComanda, DataVanzare)
VALUES (13, 7, 10019, TO_DATE('2024-09-09 12:45:00', 'YYYY-MM-DD HH24:MI:SS'));

--11 Inserare date in tabela Recenzii
INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (1, 6, 4, 'Foarte multumit de calitatea produsului!', TO_DATE('2023-06-01', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (2, 3, 2, 'Produsul a fost OK, dar livrarea a  nt rziat', TO_DATE('2023-06-02', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (3, 7, 3, NULL, TO_DATE('2023-08-02', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (4, 2, 5, 'Produsul a fost bun, dar cam scump', TO_DATE('2023-09-24', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (5, 5, 3, NULL, TO_DATE('2021-09-30', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (6, 4, 4, 'Foarte buna inghetata', TO_DATE('2021-03-02', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (7, 8, 5, NULL, TO_DATE('2022-10-21', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (8, 4, 5, 'O inghetata delicioasa', TO_DATE('2024-04-09', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (9, 5, 5, 'Una dintre cele mai bune inghetate', TO_DATE('2024-01-02', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (10, 5, 4, 'O sa ma intorc cu siguranta', TO_DATE('2023-12-29', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (11, 2, 2, 'Prea scump', TO_DATE('2023-10-25', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (12, 12, 5, 'Un gust unic si autentic', TO_DATE('2024-02-12', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (13, 5, 4, 'Extraordinar', TO_DATE('2023-07-22', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (14, 12, 4, NULL, TO_DATE('2023-07-22', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (15, 3, 3, NULL, TO_DATE('2023-07-22', 'YYYY-MM-DD'));

INSERT INTO Recenzii (IDRecenzie, IDClient, Rating, Comentariu, DataRecenzie)
VALUES (16, 13, 5, 'Recomand inghetata de fistic, e cea mai buna', TO_DATE('2023-07-22', 'YYYY-MM-DD'));

--12 Inserare date in tabela AdaugaAroma
INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10000, 1, 3);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10000, 11, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10001, 2, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10002, 5, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10002, 17, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10003, 3, 3);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10004, 6, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10005, 9, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10005, 7, 3);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10005, 2, 3);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10006, 7, 3);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10007, 8, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10008, 4, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10009, 18, 3);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10010, 20, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10010, 19, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10010, 16, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10011, 16, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10012, 6, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10013, 1, 3);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10014, 13, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10015, 11, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10015, 1, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10016, 16, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10016, 20, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10016, 6, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10017, 13, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10018, 17, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10018, 10, 1);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10018, 1, 2);

INSERT INTO AdaugaAroma (IDComanda, IDAroma, Cantitate)
VALUES (10019, 18, 2);

COMMIT;