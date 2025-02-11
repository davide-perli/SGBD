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