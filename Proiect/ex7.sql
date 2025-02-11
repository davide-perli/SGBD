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