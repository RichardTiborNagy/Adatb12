--2.gyak
select owner from dba_objects where object_type = 'TABLE' group by owner having count(*)>40 minus
select owner from dba_objects where object_type = 'INDEX' group by owner having count(*)>37;

select * from emp;
select * from nikovits.emp;
select * from user_tab_columns;
select * from dba_tab_columns;
select * from dba_tab_columns where owner = 'NIKOVITS' and table_name='EMP';
--1
select count(*) from dba_tab_columns where owner = 'NIKOVITS' and table_name='EMP';

--2
select data_type from dba_tab_columns where owner = 'NIKOVITS' and table_name='EMP' and column_id = 6;

--3
select distinct owner, table_name from dba_tab_columns where column_name like 'Z%';

--4
select table_name, count(*) from dba_tab_columns where data_type = 'DATE' group by table_name having count(*)>=8; --sok embernek van emp tablaja, mindenkinek 1 date tipussal, osszedobjak, rossz
select owner, table_name, count(*) from dba_tab_columns where data_type = 'DATE' group by owner,table_name having count(*)>=8;
select distinct table_name from dba_tab_columns where data_type = 'DATE' group by owner,table_name having count(*)>=8;

--5
select table_name from dba_tab_columns where column_id = 1 and data_type = 'VARCHAR2'; 
select table_name from dba_tab_columns where column_id = 4 and data_type = 'VARCHAR2'; --tablak ahol 4. oszlop varchar2 tipusu

select table_name from dba_tab_columns where column_id=1 and data_type='VARCHAR2' intersect 
select table_name from dba_tab_columns where column_id=4 and data_type='VARCHAR2'; --2 külön sör tabla, egyiknek 1. oszlopa tenyleg varchar, de 4. oszlopa nincs is, a masiknak a 4. varchar, igy bekerül a sör tabla

select * from branyi.sör;
select * from sila.sör;

select owner,table_name from dba_tab_columns where column_id=1 and data_type='VARCHAR2' intersect 
select owner,table_name from dba_tab_columns where column_id=4 and data_type='VARCHAR2';


----2. gyak anyag (t02)

create or replace synonym ne for nikovits.emp;
select * from ne;

select * from user_synonyms;
select * from dba_synonyms;
select * from dba_synonyms where owner='PUBLIC' and synonym_name='DUAL';

select 1+1 from dual;
create synonym d for sys.dual;
select 1+1 from d;

--create view nev as lekerdezes;

select * from branyi.sz;
select * from sila.szeret;

create view nevek as select nev from sila.szeret;

select * from nevek;

insert into nevek values('Kutya'); --nem lehet, nincs jog, 
--egyeb okok ami miatt nem lehetne lehetseges: a view tobb tablabol kerdez le, van rajta megszoritas, van benne szamolas utjan letrejott oszlop, distinct oszlop

select * from user_views;
select * from dba_views;

--almatszeretok view, ide beszur ('Macska', 'korte'), be lehet, de a view nem fogja mutatni, a szeret tablaba szurodik be a sor

create sequence a
start with 10 
increment by 7
nocycle
nocache;

select a from dual;
select a.currval from dual;
select a.nextval from dual; --kezdoertek, majd hetesevel

select * from x;
insert into x values(a.nextval);
insert into x values(a.currval);

select * from user_sequences;
select * from dba_sequences;




