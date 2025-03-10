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

-- 7
/* Pentru un numar k de arome, se vor prelua primele k arome ordonate
descrescator dupa pret, se vor afisa toate comenzile
care au suma cantitatii de arome vanduta peste media cantitatii per comanda.
2 cursoare: c_arome, c_comenzi(IDAroma) parametrizat */

CREATE OR REPLACE PROCEDURE Afiseaza_Arome_Si_Comenzi(k IN NUMBER)
IS
    CURSOR c_arome IS
        SELECT IDAroma, Pret
        FROM Arome
        ORDER BY Pret DESC;-- Cursor simplu refeitor la detalii arome ordonate dupa pret desc
    id_aroma Arome.IDAroma%TYPE;
    pret Arome.Pret%TYPE;

    CURSOR c_comenzi(id IN Arome.IDAroma%TYPE) IS
        SELECT AA.IDComanda, SUM(AA.Cantitate)
        FROM AdaugaAroma AA
        WHERE AA.IDAroma = id
        GROUP BY AA.IDComanda;-- Cursor parametrizat dupa aroma pentru comenzile ce vor contine aroma aceea
    id_comanda Vanzari.IDComanda%TYPE;
    suma_cantitate NUMBER;

    medie_cantitate NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Primele k arome in functie de pret descrescator ('||k||'):');
    OPEN c_arome;
    FOR i IN 1..k LOOP
        FETCH c_arome INTO id_aroma, pret;
        EXIT WHEN c_arome%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Aroma cu IDAroma '||id_aroma||' si pret '||pret||' ocupa pozitia '||i);
    
        -- Average-ul poate fi calculat inainte de a deschide cursorul c_comenzi
        -- De retinut ca average-ul depinde de IDAroma, insemnand ca vor avea diferite valori deoarece unele arome sunt mai vandute decat celelalte
        SELECT AVG(Suma) INTO medie_cantitate 
        FROM (  SELECT SUM(AA.Cantitate) AS Suma-- Ce se afla in from e exact la fel cu ce e in cursor, e mai usor sa fac average deoarece stiu numarul de comenzi datorita group by IDComanda
                FROM AdaugaAroma AA
                WHERE AA.IDAroma = id_aroma
                GROUP BY AA.IDComanda );
        
        OPEN c_comenzi(id_aroma);
        LOOP
            FETCH c_comenzi INTO id_comanda, suma_cantitate;
            EXIT WHEN c_comenzi%NOTFOUND;

            IF suma_cantitate > medie_cantitate THEN
                DBMS_OUTPUT.PUT_LINE('Comanda cu IDComanda '||id_comanda||' are suma cantitatilor mai mare decat media ('||suma_cantitate||'>'||medie_cantitate||')');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Comanda cu IDComanda '||id_comanda||' NU are suma cantitatilor mai mare decat media ('||suma_cantitate||'<='||medie_cantitate||')');
            END IF;
        END LOOP;
        CLOSE c_comenzi;
        
    END LOOP;
    CLOSE c_arome;
    DBMS_OUTPUT.PUT_LINE('');
    
END Afiseaza_Arome_Si_Comenzi;
/
BEGIN
    Afiseaza_Arome_Si_Comenzi(3);
    Afiseaza_Arome_Si_Comenzi(10);
    Afiseaza_Arome_Si_Comenzi(11);
END;
/

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

-- 9
/* Pentru un client se vor afisa recenziile postate (NO_REVIEW_YET daca nu a postat inca niciun review) 
si pentru acelasi client si o adresa se vor afisa detaliile comenzilor clientului respectiv plasate de 
catre un angajat care lucreaza magazinul cu adresa data (NO_ADDRESS_FOUND).*/

CREATE OR REPLACE PROCEDURE Verifica_Client_Recenzii_Adresa_Comenzi(id_client Clienti.IDClient%TYPE, id_adresa IN Adresa.IDAdresa%TYPE)
IS
    CURSOR c_recenzii IS-- Cursor simplu recenzii in functie de client
        SELECT Rating, Comentariu
        FROM Recenzii
        WHERE IDClient = id_client;
    TYPE record_recenzie IS RECORD (
        rating Recenzii.Rating%TYPE,
        comm Recenzii.Comentariu%TYPE
    );
    TYPE tablou_indexat_recenzii IS TABLE OF record_recenzie INDEX BY BINARY_INTEGER;
    tablou_rec tablou_indexat_recenzii;-- Toate rezultatele cursorului vor fi puse BULK COLLECT INTO in acest tablou de recenzii
    
    CURSOR c_comenzi IS
        SELECT V.IDClient, C.Prenume, V.IDComanda, V.IDAngajat, A.Nume, V.DataVanzare, M.IDMagazin, M.IDAdresa, AD.Oras, AD.Strada 
        FROM Clienti C
        JOIN Vanzari V ON (C.IDClient = V.IDClient)
        JOIN Angajati A ON (V.IDAngajat = A.IDAngajat)
        JOIN Magazine M ON (A.IDMagazin = M.IDMagazin)
        jOIN Adresa AD ON(AD.IDAdresa = M.IDAdresa)
        WHERE M.IDAdresa = id_adresa AND V.IDClient = id_client;-- Multe detalii legate de vanzare, join 5 tabele astefl incat vanzarea are clientul dat, iar magazinul in care lucreaza ang ce a prelucrat comanda e la adresa data
    TYPE record_vanzare IS RECORD (
        id_client Clienti.IDClient%TYPE,
        prenume_client Clienti.Prenume%TYPE,
        id_comanda Comenzi.IDComanda%TYPE,
        id_ang Angajati.IDAngajat%TYPE,
        nume_ang Angajati.Nume%TYPE,
        data_vanzare Vanzari.DataVanzare%TYPE,
        id_magazin_ang Magazine.IDMagazin%TYPE,
        id_adresa Adresa.IDAdresa%TYPE,
        oras Adresa.Oras%TYPE,
        strada Adresa.Strada%TYPE
    );
    TYPE tablou_indexat_vanzari IS TABLE OF record_vanzare INDEX BY BINARY_INTEGER;
    tablou_vanzari tablou_indexat_vanzari;-- Inca o data BULK COLLECT INTO
    
    NO_REVIEW_YET EXCEPTION;
    NO_ADDRESS_FOUND EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Clientul '||id_client||':');
    OPEN c_recenzii;
    FETCH c_recenzii BULK COLLECT INTO tablou_rec;
    CLOSE c_recenzii;
    
    IF tablou_rec.COUNT = 0 THEN-- Nicio recenzie nu a fost gasita, deci NO_REVIEW_YET asociat clientului dat
        RAISE NO_REVIEW_YET;
    END IF;

    FOR i IN 1..tablou_rec.COUNT LOOP
        IF i = 1 THEN
            DBMS_OUTPUT.PUT_LINE('Primul comentariu:');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Al '||i||'-lea comentariu:');
        END IF;
        DBMS_OUTPUT.PUT_LINE('rating '||tablou_rec(i).rating||', comentariu '||tablou_rec(i).comm);
    END LOOP;
    
    OPEN c_comenzi;
    FETCH c_comenzi BULK COLLECT INTO tablou_vanzari;
    CLOSE c_comenzi;

    IF tablou_vanzari.COUNT = 0 THEN-- Nu merge sa gaseasca adresa magazinului (sigur orice client are cel putin o vanzare deci nu e un caz pe care ar trebui sa-l tratez)
        RAISE NO_ADDRESS_FOUND;
    END IF;

    FOR i IN 1..tablou_vanzari.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Clientul cu prenumele '||tablou_vanzari(i).prenume_client||' a plasat comanda '||tablou_vanzari(i).id_comanda||' procesata de angajatul '||tablou_vanzari(i).id_ang||' cu numele '||tablou_vanzari(i).nume_ang);
        DBMS_OUTPUT.PUT_LINE('Detalii vanzare:');
        DBMS_OUTPUT.PUT_LINE('data vanzare: '||TO_CHAR(tablou_vanzari(i).data_vanzare, 'DD-MON-YYYY')||', magazinul la care lucreaza angajatul: '||tablou_vanzari(i).id_magazin_ang||', adresa magazinului: '||tablou_vanzari(i).oras||', '||tablou_vanzari(i).strada);      
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN NO_REVIEW_YET THEN
        DBMS_OUTPUT.PUT_LINE('Clientul '||id_client||' nu a postat nicio recenzie inca');
        DBMS_OUTPUT.PUT_LINE('');-- Pentru afisare cu new line
    WHEN NO_ADDRESS_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nicio comanda nu a fost identificata ca fiind procesata de un angajat care lucreaza la magazinul cu adresa '||id_adresa);
        DBMS_OUTPUT.PUT_LINE('');
        
END Verifica_Client_Recenzii_Adresa_Comenzi;
/
BEGIN
    Verifica_Client_Recenzii_Adresa_Comenzi(1, 2);-- NO_REVIEW_YET
    Verifica_Client_Recenzii_Adresa_Comenzi(3, 6);
    Verifica_Client_Recenzii_Adresa_Comenzi(5, 9);
    Verifica_Client_Recenzii_Adresa_Comenzi(5, 1);-- NO_ADRESS_FOUND
    Verifica_Client_Recenzii_Adresa_Comenzi(2, 6);
END;
/

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




