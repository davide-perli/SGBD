declare
    nume_department departments.department_name%type;
begin
    select department_name
    into nume_department
    from departments
    where department_id = 100
    dbms_output.put_line(nume_department);
end;
/

set verify off;
declare
    v_cod departments.department_id%type:= &dep_cod;
    v_nr_ang integer ;
    v_nume employees.last_name%type;
begin
    select count(*) into v_nr_ang
    from employees e
    where department_id = v_cod
    if v_nr_ang > 10
        then 
            select last_name into v_nume
            from employees
            where department_id = v_cod
            and salary = min(select max(salary) from employees
                             where department_id = v_cod);
    elseif v_nr_ang < 5  
        then 
            select last_name into v_nume
            from employees
            where department_id = v_cod
            and salary = min(select min(salary) from employees
                             where department_id = v_cod);
                             
    else
        dbms_output.put_line('to-do');
    end if;
    dbms_output.putline(v_nume);
end;
/
set verify off;           
   
   
--14. Rula?i urm?toarea cerere SQL: 
SELECT EXTRACT(YEAR FROM SYSDATE) 
FROM   dual;  

--15. Modifica?i cererea anterioar? astfel încât s? ob?ine?i ziua, respectiv luna datei curente.
SELECT EXTRACT(DAY FROM SYSDATE)   --se afiseaza ziua curenta
FROM dual;

SELECT EXTRACT(MONTH FROM SYSDATE) --se afiseaza luna curenta
FROM dual;

select * from employees
where employee_id = 103;

declare
    cod_ang employees.employee_id%type := &p_cod;
    cod_dept departments.department_id%type := &p_cod_dept;
    procent number:= &p_procent; 
    cod_ang_aux integer;
    cod_dept_aux integer;
begin
    select count(*) into cod_ang_aux
    from employees
    where employee_id = cod_ang;
    
    select count(*) into cod_dept_aux
    from departments
    where department_id = cod_dept;
    
    case when cod_ang_aux = 1 and cod_dept_aux = 1
        then update employees
            set department_id = cod_dept,
                salary = salary + (salary * procent)/100
            where employee_id = cod_ang;
            dbms_output.put_line('actualizare realizate');
        else    
            dbms_output.put_line('actualizare nerealizata');
    end case;
    dbms_output.put_line(cod_ang);
end;
/
    
[17:50, 24.10.2024] Mami?: --nume ang, dep ang; daca nu lucreaza mesaj; "ang nu lucreaza"
declare
    minim number := 1;
    maxim number := 1;
    aux_nu_exista integer;
    type angajat_afisare is record(nume employees.last_name%type, prenume employees.first_name%type, department departments.department_name%type);
    ang angajat_afisare;
begin
    select min(employee_id) into minim
    from employees;
    select max(employee_id) into maxim
    from employees;
    
    loop
        select count(*) into aux_nu_exista
        from employees
        where employee_id = minim;
        if aux_nu_exista > 0 then
            select e.first_name, e.last_name, d.department_name into ang
            from employees e
            join departments d on(e.department_id = d.department_id)
            where employee_id = minim;
            minim := minim + 1;
            
            if ang.departament is NULL
                then dbms_output.put_line('Angajatul ' || ang.nume || ' ' || ang.prenume || 'nu lcreaza in niciun departament');
            else
                dbms_output.put_line('Angajatul ' || ang.nume || ' ' || ang.prenume || ' cu departamentul ' || ang.departament);
            end if;
            exit when minim > maxim;
        elsif aux_nu_exista = 0
            then minim := minim + 1;
        end if;
    end loop;
end;
/

 --nume ang, dep ang; daca nu lucreaza mesaj; "ang nu lucreaza"
declare
    minim number := 1;
    maxim number := 1;
    aux_nu_exista integer;
    type angajat_afisare is record(nume employees.last_name%type, prenume employees.first_name%type, departament departments.department_name%type);
    ang angajat_afisare;
begin
    select min(employee_id) into minim
    from employees;
    select max(employee_id) into maxim
    from employees;
    
    loop
        select count(*) into aux_nu_exista
        from employees
        where employee_id = minim;
        if aux_nu_exista > 0 then
            select e.first_name, e.last_name, d.department_name into ang
            from employees e 
            join departments d on(e.department_id = d.department_id)
            where employee_id = minim;
            minim := minim + 1;
            
            if ang.departament is NULL
                then dbms_output.put_line('Angajatul ' || ang.nume || ' ' || ang.prenume || 'nu lcreaza in niciun departament');
            else
                dbms_output.put_line('Angajatul ' || ang.nume || ' ' || ang.prenume || ' cu departamentul ' || ang.departament);
                exit when minim > maxim;
            end if;
            
        elsif aux_nu_exista = 0
            then minim := minim + 1;
        end if;
    end loop;
end;
/

declare
    id_ang employees.employee_id%type := &p_cod;
    type info_ang is record(nume employees.last_name%type NOT NULL DEFAULT 'test', dep departments.department_name%type, nr_joburi integer);
    angajat info_ang;
begin
    select e.last_name, d.department_name, count(*)
    into angajat
    from employees e
    left join departments d on(d.department_id = e.department_id)
    left join job_history jh on(jh.department_id = d.department_id)
    where e.employee_id = id_ang
    group by e.last_name, d.department_name;
    dbms_output.put_line('Angajatul pe nume ' || angajat.nume || ' lucreaza in departamentul ' || angajat.dep || ' si are ' || angajat.nr_joburi || ' joburi');
end;
/