--/*
drop table imprumuta cascade constraints;
drop table cititor cascade constraints;
drop table domeniu cascade constraints;
drop table carte cascade constraints;
--*/

create table domeniu (
   id_domeniu number(4) primary key,
   denumire varchar2(20));
					  
create table carte (
   id_carte number(4) primary key, 
   titlu varchar2(20), 
   autor varchar2(10), 
   pret number(4) default 10, 
   nrex number(2), 
   cod_domeniu number(4) references domeniu(id_domeniu));
				
create table cititor (
   id_cititor number(4) primary key, 
   nume varchar2(10), 
   data_nasterii date);

create table imprumuta (
   cod_cititor number(4), 
   cod_carte number(4), 
   dataim date,
   dataef date,
   datares date,
   constraint cp_imp primary key (cod_cititor, cod_carte, dataim),
   constraint ce_imp1 foreign key (cod_cititor) references cititor(id_cititor),
   constraint ce_imp2 foreign key (cod_carte) references carte(id_carte));
						
insert into domeniu values (100, 'Informatica');
insert into domeniu values (200, 'Literatura');
insert into domeniu values (300, 'Matematica');
insert into domeniu values (400, 'Biologie'); 

-- carti din domeniul informatica
insert into carte values (101,'CarteInfo1','Autor1',35,1,100);
insert into carte values (102,'CarteInfo2','Autor1',32,4,100);
insert into carte values (103,'CarteInfo3','Autor2',45,8,100);
insert into carte values (104,'CarteInfo4','Autor3',45,3,100);
insert into carte values (105,'CarteInfo5','Autor4',35,1,100);
insert into carte values (106,'CarteInfo6', null,   32,2,100); -- autor necunoscut
--carti din domeniul litaratura
insert into carte values (201,'CarteLit1','Autor5',35,7,200);
insert into carte values (202,'CarteLit2','Autor5',32,3,200);
--carti din domeniul matematica
insert into carte values (301,'CarteMate1','Autor1',30,2,300); -- autor care are carti 2 domenii: mate si info
insert into carte values (302,'CarteMate2','Autor7',30,5,300);
--carti din domeniul biologie
  -- domeniul nu are carti inregistrate
--carti cu domeniul necunoscut
insert into carte values (501,'Carte1','Autor8',90,2,null); 


-- cititori
insert into cititor values (1,'Cititor1',to_date('01-05-1978','dd-mm-yyyy'));
insert into cititor values (2,'Cititor2',to_date('23-05-1982','dd-mm-yyyy'));
insert into cititor values (3,'Cititor3',to_date('21-05-1980','dd-mm-yyyy'));
INSERT INTO cititor VALUES (4,'Cititor4',to_date('10-04-1985','dd-mm-yyyy'));
INSERT INTO cititor VALUES (5,'Cititor5',to_date('11-09-1970','dd-mm-yyyy'));
INSERT INTO cititor VALUES (6,'Cititor6',to_date('23-11-1984','dd-mm-yyyy'));
INSERT INTO cititor VALUES (7,'Cititor7',to_date('20-11-1984','dd-mm-yyyy'));
INSERT INTO cititor VALUES (8,'Cititor8',to_date('01-12-1980','dd-mm-yyyy'));
INSERT INTO cititor VALUES (9,'Cititor9',to_date('30-07-1980','dd-mm-yyyy'));
INSERT INTO cititor VALUES (10,'Cititor10',to_date('14-05-1979','dd-mm-yyyy'));

--imprumuturi
--carti imprumutate din domeniul informatica
--CarteInfo1: 1 exemplar; toate exemplarele imprumutate in prezent
insert into imprumuta values (2, 101,to_date('01-05-2017','dd-mm-yyyy'),to_date('11-05-2017','dd-mm-yyyy'),add_months(to_date('01-05-2017','dd-mm-yyyy'),1));
insert into imprumuta values (10,101,sysdate-60, sysdate-50, add_months(sysdate-60,1));
insert into imprumuta values (1, 101,sysdate, null, add_months(sysdate,1)); 
--CarteInfo2: 4 exemplare; niciun exemplar imprumutat in prezent
insert into imprumuta values (2,102,to_date('02-05-2017','dd-mm-yyyy'),to_date('11-05-2017','dd-mm-yyyy'),add_months(to_date('02-05-2017','dd-mm-yyyy'),1));
--CarteInfo3: 8 exemplare; toate exemplarele imprumutate in prezent
insert into imprumuta values (2,103,to_date('01-05-2017','dd-mm-yyyy'),to_date('11-05-2017','dd-mm-yyyy'),add_months(to_date('01-05-2017','dd-mm-yyyy'),1));
insert into imprumuta values (4,103,to_date('01-05-2017','dd-mm-yyyy'),to_date('04-05-2017','dd-mm-yyyy'),add_months(to_date('01-05-2017','dd-mm-yyyy'),1));
insert into imprumuta values (1,103,sysdate-90, null,add_months(to_date(sysdate-90,'dd-mm-yyyy'),1)); -- termen depasit
insert into imprumuta values (2,103,sysdate-90, null,add_months(to_date(sysdate-90,'dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (4,103,sysdate-80, null,add_months(to_date(sysdate-80,'dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (5,103,sysdate-80, null,add_months(to_date(sysdate-80,'dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (6,103,sysdate-60, null,add_months(to_date(sysdate-60,'dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (7,103,sysdate-50, null,add_months(to_date(sysdate-50,'dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (9,103,sysdate-40, null,add_months(to_date(sysdate-40,'dd-mm-yyyy'),1)); -- termen depasit
insert into imprumuta values (10,103,sysdate,   null,add_months(to_date(sysdate,'dd-mm-yyyy'),1)); 
--CarteInfo4: 3 exemplare; niciun exemplar imprumutat in prezent
  -- nu are imprumuturi
--CarteInfo5: 1 exemplar; niciun exemplar imprumutat in prezent
  -- nu are imprumuturi
--CarteInfo6: 2 exemplare; niciun exemplar imprumutat in prezent
  -- nu are imprumuturi

--carti imprumutate din domeniul literatura
--CarteLit1: 7 exemplare; toate exemplarele imprumutate in prezent
INSERT INTO imprumuta VALUES (4,201,to_date('01-02-2018','dd-mm-yyyy'),null,add_months(to_date('01-03-2018','dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (6,201,to_date('10-02-2018','dd-mm-yyyy'),null,add_months(to_date('10-03-2018','dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (5,201,to_date('01-02-2018','dd-mm-yyyy'),null,add_months(to_date('01-03-2018','dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (8,201,to_date('10-02-2018','dd-mm-yyyy'),null,add_months(to_date('10-03-2018','dd-mm-yyyy'),1)); -- termen depasit
insert into imprumuta values (1,201,to_date('28-02-2018','dd-mm-yyyy'),null,add_months(to_date('28-03-2018','dd-mm-yyyy'),1)); -- termen depasit
insert into imprumuta values (2,201,to_date('28-02-2018','dd-mm-yyyy'),null,add_months(to_date('28-03-2018','dd-mm-yyyy'),1)); -- termen depasit
insert into imprumuta values (10,201, sysdate, null, add_months(sysdate,1));
insert into imprumuta values (10,201, sysdate-60, sysdate-50, add_months(sysdate-60,1)); 
--CarteLit2: 3 exemplare; 2 exemplare imprumutate in prezent
insert into imprumuta values (1,202,to_date('09-01-2018','dd-mm-yyyy'),add_months(to_date('09-01-2018','dd-mm-yyyy'),1)+2, add_months(to_date('09-01-2018','dd-mm-yyyy'),1));
INSERT INTO imprumuta VALUES (5,202,to_date('01-02-2018','dd-mm-yyyy'),null,add_months(to_date('01-02-2018','dd-mm-yyyy'),1)); -- termen depasit
INSERT INTO imprumuta VALUES (9,202,to_date('10-02-2018','dd-mm-yyyy'),null,add_months(to_date('10-02-2018','dd-mm-yyyy'),1)); -- termen depasit
commit;

--carti imprumutate din domeniul matematica
--nicio carte imprumutata din acest domeniu

--carti imprumutate din domeniul biologie
--domeniul nu are carti inregistrate 

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

--6
CREATE OR REPLACE PROCEDURE Numar_Carti_Neimprumutate
IS
    v_numar_carti_neimprumutate_var1 NUMBER;
    v_numar_carti_neimprumutate_var2 NUMBER;
    
    TYPE Lista_NeImprumuturi IS TABLE OF CARTE_DP.titlu%TYPE INDEX BY BINARY_INTEGER;
    L_NeImprumuturi Lista_NeImprumuturi;
BEGIN
    SELECT COUNT(*) INTO v_numar_carti_neimprumutate_var1
    FROM CARTE_DP c
    WHERE NOT EXISTS (  SELECT 1
                        FROM IMPRUMUTA_DP i
                        WHERE i.cod_carte = c.id_carte );

    SELECT c.titlu
    BULK COLLECT INTO L_NeImprumuturi
    FROM CARTE_DP c
    LEFT JOIN IMPRUMUTA_DP i ON (c.id_carte = i.cod_carte)
    WHERE i.cod_carte IS NULL;
    
    v_numar_carti_neimprumutate_var2 := L_NeImprumuturi.COUNT;
    
    if v_numar_carti_neimprumutate_var2 = v_numar_carti_neimprumutate_var1 then
        DBMS_OUTPUT.PUT_LINE('Nr de carti neimprumutate este: '||v_numar_carti_neimprumutate_var1);
    end if;
END;
/
BEGIN
    Numar_Carti_Neimprumutate;
END;
/

--7
CREATE OR REPLACE PROCEDURE Carti_2_Ori_Imprumutate
IS
    CURSOR c_carti IS
        SELECT c.titlu
        FROM CARTE_DP c
        JOIN IMPRUMUTA_DP i ON (c.id_carte = i.cod_carte)
        GROUP BY c.titlu
        HAVING COUNT(i.cod_carte) >= 2;

    v_titlu CARTE.titlu%TYPE;
BEGIN
    OPEN c_carti;
    LOOP
        FETCH c_carti INTO v_titlu;
        EXIT WHEN c_carti%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Titlul cartii: '||v_titlu);
    END LOOP;
    CLOSE c_carti;
END;
/
BEGIN
    Carti_2_Ori_Imprumutate;
END;
/

--8
CREATE OR REPLACE PROCEDURE Carti_2_Ori_Imprumutate_Numar
IS
    numar_carti_imprumutate_de_2_ori NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO numar_carti_imprumutate_de_2_ori
    FROM (  SELECT cod_carte
            FROM IMPRUMUTA_DP
            GROUP BY cod_carte
            HAVING COUNT(*) >= 2 );

    DBMS_OUTPUT.PUT_LINE('Nr de carti imprumutate de 2 ori este: '||numar_carti_imprumutate_de_2_ori);
END;
/
BEGIN
    Carti_2_Ori_Imprumutate_Numar;
END;
/

--9
CREATE OR REPLACE PROCEDURE Numar_Carti_Imprumutate_Domeniu
IS
    CURSOR c_domenii IS
        SELECT d.denumire AS domeniu, COUNT(c.id_carte) AS numar_carti_imprumutate
        FROM DOMENIU_DP d
        JOIN CARTE_DP c ON (d.id_domeniu = c.cod_domeniu)
        JOIN IMPRUMUTA_DP i ON (c.id_carte = i.cod_carte)
        AND i.dataef IS NULL
        GROUP BY d.denumire;

    domeniu DOMENIU_DP.denumire%TYPE;
    numar_carti NUMBER;
BEGIN
    OPEN c_domenii;
    LOOP
        FETCH c_domenii INTO domeniu, numar_carti;
        EXIT WHEN c_domenii%NOTFOUND;
    
        DBMS_OUTPUT.PUT_LINE('Domeniu: '||domeniu||', nr carti imprumutate: '||numar_carti);
    END LOOP;
    CLOSE c_domenii;
END;
/
BEGIN
    Numar_Carti_Imprumutate_Domeniu;
END;
/

--10
CREATE OR REPLACE PROCEDURE Cititori_Carti_Nerestituite
IS
    CURSOR c_cititori IS
        SELECT c.id_cititor, c.nume, COUNT(i.cod_carte)
        FROM CITITOR_DP c
        JOIN IMPRUMUTA_DP i ON (c.id_cititor = i.cod_cititor)
        WHERE i.dataef IS NULL OR i.datares < SYSDATE
        GROUP BY c.id_cititor, c.nume
        HAVING COUNT(i.cod_carte) > 1;

    id_cititor CITITOR.id_cititor%TYPE;
    nume CITITOR.nume%TYPE;
    numar_carti NUMBER;
BEGIN
    OPEN c_cititori;
    LOOP
        FETCH c_cititori INTO id_cititor, nume, numar_carti;
        EXIT WHEN c_cititori%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Id cititor: '||id_cititor||', nume: '||nume||', nr carti nerestituite: '||numar_carti);
    END LOOP;
    CLOSE c_cititori;
END;
/
BEGIN
    Cititori_Carti_Nerestituite;
END;
/

--11
CREATE OR REPLACE PROCEDURE Domenii_Fara_Carti
IS
    CURSOR c_domenii IS
        SELECT d.id_domeniu, d.denumire
        FROM DOMENIU_DP d
        WHERE ( SELECT COUNT(*) 
                FROM CARTE_DP c 
                WHERE c.cod_domeniu = d.id_domeniu) = 0;

    id_domeniu DOMENIU_DP.id_domeniu%TYPE;
    denumire DOMENIU_DP.denumire%TYPE;
BEGIN
    OPEN c_domenii;
    LOOP
        FETCH c_domenii INTO id_domeniu, denumire;
        EXIT WHEN c_domenii%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Id domeniu: '||id_domeniu||', denumire: '||denumire);
    END LOOP;
    CLOSE c_domenii;
END;
/
BEGIN
    Domenii_Fara_Carti;
END;
/

--12
CREATE OR REPLACE PROCEDURE Domenii_Carti
IS
    CURSOR c_domenii IS
        SELECT id_domeniu, denumire
        FROM DOMENIU_DP;

    id_domeniu DOMENIU_DP.id_domeniu%TYPE;
    denumire DOMENIU_DP.denumire%TYPE;
    
    TYPE Lista_Titluri IS TABLE OF CARTE_DP.titlu%TYPE INDEX BY BINARY_INTEGER;
    Titluri Lista_Titluri;
BEGIN
    OPEN c_domenii;
    LOOP
        FETCH c_domenii INTO id_domeniu, denumire;
        EXIT WHEN c_domenii%NOTFOUND;
        
        Titluri.DELETE;
        
        SELECT titlu
        BULK COLLECT INTO Titluri
        FROM CARTE_DP
        WHERE cod_domeniu = id_domeniu;

        DBMS_OUTPUT.PUT_LINE('Domeniu: '||denumire);
        IF Titluri.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Nu are carti');
        ELSE
            FOR i IN 1..Titluri.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE('  Carte: '||Titluri(i));
            END LOOP;
        END IF;
    END LOOP;
    CLOSE c_domenii;
END;
/
BEGIN
    Domenii_Carti;
END;
/

--13
CREATE OR REPLACE PROCEDURE Carti_Scumpe_Autor3
IS
    pret_carte NUMBER;

    CURSOR c_carti IS
        SELECT titlu, pret
        FROM CARTE_DP
        WHERE pret > pret_carte;

    titlu CARTE_DP.titlu%TYPE;
    pret CARTE_DP.pret%TYPE;
BEGIN
    SELECT pret
    INTO pret_carte
    FROM CARTE_DP
    WHERE titlu = 'CarteInfo4'
    AND autor = 'Autor3';

    OPEN c_carti;
    LOOP
        FETCH c_carti INTO titlu, pret;
        EXIT WHEN c_carti%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Titlu: '||titlu||', pret: '||pret);
    END LOOP;
    CLOSE c_carti;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('CarteInfo4 scrisa de Autor3 nu a fost gasita');
END;
/
BEGIN
    Carti_Scumpe_Autor3;
END;
/

--14
CREATE OR REPLACE PROCEDURE Cititori_Intarziere
IS
    CURSOR c_cititori IS
        SELECT DISTINCT c.id_cititor, c.nume
        FROM CITITOR_DP c
        JOIN IMPRUMUTA_DP i ON (c.id_cititor = i.cod_cititor)
        WHERE i.dataef IS NULL
        OR i.datares < SYSDATE;

    id_cititor CITITOR_DP.id_cititor%TYPE;
    nume CITITOR_DP.nume%TYPE;
BEGIN
    OPEN c_cititori;
    LOOP
        FETCH c_cititori INTO id_cititor, nume;
        EXIT WHEN c_cititori%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Id cititor: '||id_cititor||', nume: '||nume);
    END LOOP;
    CLOSE c_cititori;
END;
/
BEGIN
    Cititori_Intarziere;
END;
/

--15
CREATE OR REPLACE PROCEDURE Cititori_Autor5
IS
    CURSOR c_cititori IS
        SELECT DISTINCT c.nume
        FROM CITITOR_DP c
        JOIN IMPRUMUTA_DP i ON c.id_cititor = i.cod_cititor
        JOIN CARTE_DP carte ON i.cod_carte = carte.id_carte
        WHERE carte.autor = 'Autor5';

    nume CITITOR_DP.nume%TYPE;
BEGIN
    OPEN c_cititori;
    LOOP
        FETCH c_cititori INTO nume;
        EXIT WHEN c_cititori%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Cititor: '||nume);
    END LOOP;
    CLOSE c_cititori;
END;
/
BEGIN
    Cititori_Autor5;
END;
/

--16
CREATE OR REPLACE PROCEDURE Cititori_Nu_Autor5
IS
    CURSOR c_cititori IS
        SELECT DISTINCT c.nume
        FROM CITITOR_DP c
        WHERE c.id_cititor NOT IN ( SELECT i.cod_cititor
                                    FROM IMPRUMUTA_DP i
                                    JOIN CARTE_DP carte ON (i.cod_carte = carte.id_carte)
                                    WHERE carte.autor = 'Autor5' );

    nume CITITOR_DP.nume%TYPE;
BEGIN
    OPEN c_cititori;
    LOOP
        FETCH c_cititori INTO nume;
        EXIT WHEN c_cititori%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Cititor: '||nume);
    END LOOP;
    CLOSE c_cititori;
END;
/
BEGIN
    Cititori_Nu_Autor5;
END;
/

--17
CREATE OR REPLACE PROCEDURE Informatica
IS
    CURSOR c_cititori_o_carte IS
        SELECT c.nume
        FROM CITITOR_DP c
        JOIN IMPRUMUTA_DP i ON (c.id_cititor = i.cod_cititor)
        JOIN CARTE_DP carte ON (i.cod_carte = carte.id_carte)
        JOIN DOMENIU_DP d ON (d.id_domeniu = carte.cod_domeniu)
        WHERE d.denumire = 'Informatica'
        GROUP BY c.id_cititor, c.nume
        HAVING COUNT(i.cod_carte) = 1;

    CURSOR c_cititori_macar_o_carte IS
        SELECT DISTINCT c.nume
        FROM CITITOR_DP c
        JOIN IMPRUMUTA_DP i ON (c.id_cititor = i.cod_cititor)
        JOIN CARTE_DP carte ON (i.cod_carte = carte.id_carte)
        JOIN DOMENIU_DP d ON (d.id_domeniu = carte.cod_domeniu)
        WHERE d.denumire = 'Informatica';

    CURSOR c_cititori_o_singura_data IS
        SELECT c.nume
        FROM CITITOR_DP c
        JOIN IMPRUMUTA_DP i ON (c.id_cititor = i.cod_cititor)
        JOIN CARTE_DP carte ON (i.cod_carte = carte.id_carte)
        JOIN DOMENIU_DP d ON (d.id_domeniu = carte.cod_domeniu)
        WHERE d.denumire = 'Informatica'
        GROUP BY c.id_cititor, c.nume, i.dataim
        HAVING COUNT(DISTINCT i.dataim) = 1;

    nume CITITOR_DP.nume%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Cititori care au imprumutat o singura carte de informatica:');
    OPEN c_cititori_o_carte;
    LOOP
        FETCH c_cititori_o_carte INTO nume;
        EXIT WHEN c_cititori_o_carte%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Cititor: '||nume);
    END LOOP;
    CLOSE c_cititori_o_carte;

    DBMS_OUTPUT.PUT_LINE('Cititori care au imprumutat cel putin o carte de informatica:');
    OPEN c_cititori_macar_o_carte;
    LOOP
        FETCH c_cititori_macar_o_carte INTO nume;
        EXIT WHEN c_cititori_macar_o_carte%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Cititor: '||nume);
    END LOOP;
    CLOSE c_cititori_macar_o_carte;
    
    DBMS_OUTPUT.PUT_LINE('Cititori care au imprumutat o carte de informatica o singura data:');
    OPEN c_cititori_o_singura_data;
    LOOP
        FETCH c_cititori_o_singura_data INTO nume;
        EXIT WHEN c_cititori_o_singura_data%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Cititor: '||nume);
    END LOOP;
    CLOSE c_cititori_o_singura_data;
END;
/
BEGIN
    Informatica;
END;
/

--18
CREATE OR REPLACE PROCEDURE Toti_Cititorii_Informatica
IS
    CURSOR c_cititori IS
        SELECT c.nume, carte.titlu
        FROM CITITOR_DP c
        JOIN IMPRUMUTA_DP i ON (c.id_cititor = i.cod_cititor)
        JOIN CARTE_DP carte ON (i.cod_carte = carte.id_carte)
        JOIN DOMENIU_DP d ON (d.id_domeniu = carte.cod_domeniu)
        WHERE d.denumire = 'Informatica'
        ORDER BY c.nume;

    nume CITITOR_DP.nume%TYPE;
    titlu CARTE_DP.titlu%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cititorii care au imprumutat carti de informatica:');
    OPEN c_cititori;
    LOOP
        FETCH c_cititori INTO nume, titlu;
        EXIT WHEN c_cititori%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Cititor: '||nume||', carte: '||titlu);
    END LOOP;
    CLOSE c_cititori;
END;
/
BEGIN
    Toti_Cititorii_Informatica;
END;
/

--19
CREATE OR REPLACE PROCEDURE Toate_Exemplarele_Imprumutate
IS
    CURSOR c_carti IS
        SELECT c.titlu
        FROM CARTE_DP c
        WHERE c.nrex = (    SELECT COUNT(*)
                            FROM IMPRUMUTA_DP i
                            WHERE i.cod_carte = c.id_carte );

    titlu CARTE_DP.titlu%TYPE;
BEGIN
    OPEN c_carti;
    LOOP
        FETCH c_carti INTO titlu;
        EXIT WHEN c_carti%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Carte: '||titlu);
    END LOOP;
    CLOSE c_carti;
END;
/
BEGIN
    Toate_Exemplarele_Imprumutate;
END;
/

--20
CREATE OR REPLACE PROCEDURE Coduri_Cititori
IS
    CURSOR c_cititori IS
        SELECT i.cod_cititor, i.cod_carte
        FROM IMPRUMUTA_DP i
        WHERE i.dataim = (  SELECT MAX(dataim)
                            FROM IMPRUMUTA_DP
                            WHERE cod_cititor = i.cod_cititor );

    cod_cititor IMPRUMUTA_DP.cod_cititor%TYPE;
    cod_carte IMPRUMUTA_DP.cod_carte%TYPE;

BEGIN
    OPEN c_cititori;
    LOOP
        FETCH c_cititori INTO cod_cititor, cod_carte;
        EXIT WHEN c_cititori%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Cod cititor: '||cod_cititor||', cod ultima carte: '||cod_carte);
    END LOOP;
    CLOSE c_cititori;
END;
/
BEGIN
    Coduri_Cititori;
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




