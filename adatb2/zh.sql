--1
--select table_name from DBA_TAB_SUBPARTITIONS;
select owner from DBA_INDEXES where index_type='BITMAP' and table_name in (select table_name from DBA_TAB_SUBPARTITIONS);

--2
select tablespace_name from (select count(*), tablespace_name from DBA_TABLES where owner<>'SYS' group by tablespace_name order by count(*)) where rownum=1;
--select count(*), tablespace_name from DBA_TABLES where owner<>'SYS' group by tablespace_name order by count(*);

--3
select segment_name, segment_type, blocks from dba_segments where owner='NIKOVITS' and segment_name in ('MEGYE', 'SZT_CKOD');

--4
--select * from hr.employees;-- where rownum=20;--(select max(rownum) from hr.employees);
select dbms_rowid.rowid_relative_fno(rowid), dbms_rowid.rowid_block_number(rowid), dbms_rowid.rowid_row_number(rowid) from hr.employees where rowid in (select max(rowid) from hr.employees);
select rowid from hr.employees where rowid in (select max(rowid) from hr.employees);

--5
--select cluster_name from DBA_CLUSTERS where cluster_type = 'HASH';
select owner, segment_name, bytes from dba_segments where segment_type = 'CLUSTER' and segment_name in (select cluster_name from DBA_CLUSTERS where cluster_type = 'HASH');

--6
--select * from DBA_INDEXES where index_type='FUNCTION-BASED NORMAL'; 
select index_name,index_owner from DBA_IND_EXPRESSIONS where column_position = 3 and index_name in 
(
select index_name from DBA_IND_COLUMNS where column_position = 3 
minus 
select index_name from DBA_IND_COLUMNS where column_position = 4
);



--1
select distinct owner from dba_tables where partitioned='YES' and table_name in (select table_name from dba_indexes where index_type='NORMAL' group by table_name having count(*)>=3);

--2
select * from (select owner from dba_segments where segment_type = 'INDEX' group by owner order by sum(bytes) desc ) where rownum=1;

--3
select table_name from dba_tab_columns where data_type='DATE' and column_id = 1
intersect
select table_name from dba_tab_columns asd where data_type='DATE' and column_id=(select max(column_id) from dba_tab_columns where owner = asd.owner and table_name=asd.table_name)
;

--select distinct table_name from
    --(select owner, table_name from dba_tab_columns where column_id=1 and data_type='DATE' intersect
--    select owner, table_name from dba_tab_columns d 
  --  where column_id=(select max(column_id) from dba_tab_columns where owner=d.owner and table_name=d.table_name)
    --and data_type='DATE');
    
--4
select tablespace_name from (select tablespace_name, count(*) from DBA_TABLES group by tablespace_name order by count(*) asc) where rownum=1;

--5
select * from dba_tables where iot_type is not null;

--6
select segment_name, blocks from (select * from dba_segments where segment_type = 'CLUSTER' order by blocks desc) where rownum=1;














--1.
--mely felhasznalóknak van olyan particionált táblája amelyre legalább 3 normal index van létrehozva
select owner, table_name from dba_tables where partitioned='YES'
intersect
select owner, table_name from dba_indexes where index_type='NORMAL' group by owner, table_name having count(*) >= 3;

--2.
--mely felhasználók indexei foglalják a legtöbb helyet az adatbázisban
select owner from dba_segments where segment_type='INDEX' and bytes=(select max(bytes) from dba_segments where segment_type='INDEX');

--3.
--adjuk meg azoknak a tábláknak a nevét, amelyeknek 1. és utolsó oszlopa is date típusú
select distinct table_name from
    (select owner, table_name from dba_tab_columns where column_id=1 and data_type='DATE' intersect
    select owner, table_name from dba_tab_columns d 
    where column_id=(select max(column_id) from dba_tab_columns where owner=d.owner and table_name=d.table_name)
    and data_type='DATE');
    
--4.
--melyik táblatéren van a legkevesebb tábla
select tablespace_name from
(select tablespace_name, count(*) from dba_segments where segment_type='TABLE' group by tablespace_name order by 2 ASC)
where rownum = 1; -- els? sor, azaz a legkevesebb

--5.
--adjuk meg az összes index szervezett táblák nevét, az index részük nevét, és túlcsordulási részük nevét, ha van. ha nincs túlcsordulási rész akkor a lekérdezés azt írja ki a név helyett, hogy "nincs"
--SELECT dt.table_name, di.index_name FROM dba_tables dt, dba_indexes di
--WHERE dt.table_name = di.table_name and dt.iot_type = 'IOT' and di.index_type='IOT - TOP';
-- nem tudom

--6.
--melyik a legnagyobb méret? cluster szegmens az adatbázisban és hány blokkból áll
select owner, segment_name, blocks from
(select owner, segment_name, bytes, blocks from dba_segments 
where bytes=(select max(bytes) from dba_segments where segment_type='CLUSTER') and segment_type='CLUSTER');

















