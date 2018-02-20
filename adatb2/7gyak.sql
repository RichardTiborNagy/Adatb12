-- Part�cion�l�ssal kapcsolatos katal�gusok (adatsz�t�r n�zetek):
-- (DBA_PART_TABLES, DBA_PART_INDEXES, DBA_TAB_PARTITIONS, DBA_IND_PARTITIONS, 
--  DBA_TAB_SUBPARTITIONS, DBA_IND_SUBPARTITIONS, DBA_PART_KEY_COLUMNS, DBA_SUBPART_KEY_COLUMNS)

drop table eladasok;
drop table eladasok2;
drop table eladasok3;
drop table eladasok4;
drop table eladasok5;

-- Particion�l�s tartom�nyok alapj�n
CREATE TABLE eladasok (szla_szam   NUMBER(5), 
                       szla_nev    CHAR(30), 
                       mennyiseg   NUMBER(6), 
                       het         INTEGER ) 
PARTITION BY RANGE (het)  
 (PARTITION negyedev1  VALUES LESS THAN (13) SEGMENT CREATION IMMEDIATE 
    STORAGE(INITIAL 8K NEXT 8K) TABLESPACE users, 
  PARTITION negyedev2  VALUES LESS THAN (26) SEGMENT CREATION IMMEDIATE 
    STORAGE(INITIAL 8K NEXT 8K) TABLESPACE example, 
  PARTITION negyedev3  VALUES LESS THAN (39) SEGMENT CREATION IMMEDIATE  
    STORAGE(INITIAL 8K NEXT 8K) TABLESPACE users)
;

insert into eladasok values(100, 'Sport cikkek', 231, 2);
insert into eladasok values(101, 'Irodai termekek', 1200, 3);
insert into eladasok values(102, 'Eszkozok', 43, 4);
insert into eladasok values(103, 'Gepek', 21, 6);
insert into eladasok values(104, 'Butorok', 31, 7);
insert into eladasok values(105, 'Ingatlan', 3, 8);
insert into eladasok values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok values(107, 'Elelmiszer', 300, 40); -- ezt m�r nem tudja besz�rni, 40 > 39 

-- Particion�l�s hash kulcs alapj�n
CREATE TABLE eladasok2 (szla_szam   NUMBER(5), 
                        szla_nev    CHAR(30), 
                        mennyiseg   NUMBER(6), 
                        het         INTEGER ) 
PARTITION BY HASH ( het )  
   (PARTITION part1 TABLESPACE users, 
    PARTITION part2 TABLESPACE example, 
    PARTITION part3 TABLESPACE users )
;

insert into eladasok2 values(100, 'Sport cikkek', 231, 2);
insert into eladasok2 values(101, 'Irodai termekek', 1200, 3);
insert into eladasok2 values(102, 'Eszkozok', 43, 4);
insert into eladasok2 values(103, 'Gepek', 21, 6);
insert into eladasok2 values(104, 'Butorok', 31, 7);
insert into eladasok2 values(105, 'Ingatlan', 3, 8);
insert into eladasok2 values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok2 values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok2 values(107, 'Elelmiszer', 300, 40);

-- Particion�l�s lista alapj�n
CREATE TABLE eladasok3 (szla_szam   NUMBER(5), 
                        szla_nev    CHAR(30), 
                        mennyiseg   NUMBER(6), 
                        het         INTEGER ) 
PARTITION BY LIST ( het )  
   (PARTITION part1 VALUES(1,2,3,4,5)   SEGMENT CREATION IMMEDIATE 
      STORAGE(INITIAL 8K NEXT 8K) TABLESPACE users, 
    PARTITION part2 VALUES(6,7,8,9)     SEGMENT CREATION IMMEDIATE 
      STORAGE(INITIAL 8K NEXT 8K) TABLESPACE example, 
    PARTITION part3 VALUES(10,11,12,13) SEGMENT CREATION IMMEDIATE 
      STORAGE(INITIAL 8K NEXT 8K) TABLESPACE users ) -- ide sem tud besz�rni > 13-at
;

insert into eladasok3 values(100, 'Sport cikkek', 231, 2);
insert into eladasok3 values(101, 'Irodai termekek', 1200, 3);
insert into eladasok3 values(102, 'Eszkozok', 43, 4);
insert into eladasok3 values(103, 'Gepek', 21, 6);
insert into eladasok3 values(104, 'Butorok', 31, 7);
insert into eladasok3 values(105, 'Ingatlan', 3, 8);
insert into eladasok3 values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok3 values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok3 values(107, 'Elelmiszer', 300, 40);


-- Alpartici�k l�trehoz�sa partici�n bel�l (range-en bel�l hash)
CREATE TABLE eladasok4 (szla_szam   NUMBER(5), 
                        szla_nev    CHAR(30), 
                        mennyiseg   NUMBER(6), 
                        het         INTEGER ) 
PARTITION BY RANGE ( het )
SUBPARTITION BY HASH (mennyiseg)
SUBPARTITIONS 3  
   (PARTITION negyedev1  VALUES LESS THAN  ( 13 )  SEGMENT CREATION IMMEDIATE 
      STORAGE(INITIAL 8K NEXT 8K) TABLESPACE users, 
    PARTITION negyedev2  VALUES LESS THAN  ( 26 )  SEGMENT CREATION IMMEDIATE 
      STORAGE(INITIAL 8K NEXT 8K) TABLESPACE example, 
    PARTITION negyedev3  VALUES LESS THAN  ( 39 )  SEGMENT CREATION IMMEDIATE
      STORAGE(INITIAL 8K NEXT 8K) TABLESPACE users )
;

insert into eladasok4 values(100, 'Sport cikkek', 231, 2);
insert into eladasok4 values(101, 'Irodai termekek', 1200, 3);
insert into eladasok4 values(102, 'Eszkozok', 43, 4);
insert into eladasok4 values(103, 'Gepek', 21, 6);
insert into eladasok4 values(104, 'Butorok', 31, 7);
insert into eladasok4 values(105, 'Ingatlan', 3, 8);
insert into eladasok4 values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok4 values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok4 values(107, 'Elelmiszer', 300, 40);

-- Range-list alpartici�k l�trehoz�sa minta alapj�n. Ez akkor hasznos ha nagyon sok
-- part�ci� lenne, �s �gy nem kell �ket egyes�vel felsorolni
-- mint�ra vonatkoz� inf�k: DBA_SUBPARTITION_TEMPLATES
CREATE TABLE eladasok5 (szla_szam   NUMBER(5), 
                        szla_nev    CHAR(30), 
                        mennyiseg   NUMBER(6), 
                        het         INTEGER ) 
PARTITION BY RANGE ( mennyiseg )
SUBPARTITION BY LIST (het)
SUBPARTITION TEMPLATE
  (SUBPARTITION lista VALUES(1,2,3,4,5), SUBPARTITION other VALUES(DEFAULT))
    (PARTITION kicsi    VALUES LESS THAN  (100) SEGMENT CREATION IMMEDIATE
       STORAGE(INITIAL 8K NEXT 8K) TABLESPACE users,
     PARTITION kozepes  VALUES LESS THAN  (500) SEGMENT CREATION IMMEDIATE  
       STORAGE(INITIAL 8K NEXT 8K) TABLESPACE example, 
     PARTITION nagy     VALUES LESS THAN  (MAXVALUE) SEGMENT CREATION IMMEDIATE 
       STORAGE(INITIAL 8K NEXT 8K) TABLESPACE users )
;

insert into eladasok5 values(100, 'Sport cikkek', 231, 2);
insert into eladasok5 values(101, 'Irodai termekek', 1200, 3);
insert into eladasok5 values(102, 'Eszkozok', 43, 4);
insert into eladasok5 values(103, 'Gepek', 21, 6);
insert into eladasok5 values(104, 'Butorok', 31, 7);
insert into eladasok5 values(105, 'Ingatlan', 3, 8);
insert into eladasok5 values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok5 values(106, 'Szolgaltatasok', 200, 9);
insert into eladasok5 values(107, 'Elelmiszer', 300, 40);

select * from user_part_tables;

select * from user_tab_partitions;

select * from user_tab_subpartitions;

select * from user_part_key_columns;

select * from user_subpart_key_columns;

select * from user_segments;

select * from user_tables where table_name='ELADASOK5'; --sok null mert nem egyertelmuek, tobb helyen vannak a particiok


/**********

A fenti t�bl�kra vonatkoz� inform�ci�k az adatsz�t�r n�zetekben:
----------------------------------------------------------------

SELECT table_name, partitioning_type, subpartitioning_type,
  partition_count, def_subpartition_count 
FROM dba_part_tables WHERE owner='NIKOVITS';

t_name         p_type  sub_type  p_count sub_count
--------------------------------------------------
ELADASOK	RANGE	NONE	  3	  0
ELADASOK2	HASH	NONE	  3	  0
ELADASOK3	LIST	NONE	  3	  0
ELADASOK4	RANGE	HASH	  3	  3
ELADASOK5	RANGE	LIST	  3	  2


SELECT table_name, partition_position, partition_name, composite,
  subpartition_count, high_value
FROM dba_tab_partitions WHERE table_owner='NIKOVITS' ORDER BY 1,2;

t_name      pos   p_name       comp   sub_c  high_value
-------------------------------------------------------
ELADASOK     1    NEGYEDEV1      NO     0    13
ELADASOK     2    NEGYEDEV2      NO     0    26
ELADASOK     3    NEGYEDEV3      NO     0    39
ELADASOK2    1    PART1          NO     0    null
ELADASOK2    2    PART2	         NO     0    null
ELADASOK2    3    PART3	         NO     0    null
ELADASOK3    1    PART1	         NO     0    1, 2, 3, 4, 5
ELADASOK3    2    PART2	         NO     0    6, 7, 8, 9
ELADASOK3    3    PART3	         NO     0    10, 11, 12, 13
ELADASOK4    1    NEGYEDEV1	 YES    3    13
ELADASOK4    2    NEGYEDEV2	 YES    3    26
ELADASOK4    3    NEGYEDEV3	 YES    3    39
ELADASOK5    1    KICSI	         YES    2    100
ELADASOK5    2    KOZEPES        YES    2    500
ELADASOK5    3    NAGY	         YES    2    MAXVALUE


SELECT table_name, partition_name, subpartition_position,
  subpartition_name, high_value
FROM dba_tab_subpartitions WHERE table_owner='NIKOVITS' 
AND table_name='ELADASOK5' ORDER BY 1,2,3;

t-name          p_name  pos    subp_name       high_value
-------------------------------------------------------------
ELADASOK5      KICSI    1      KICSI_LISTA     1, 2, 3, 4, 5
ELADASOK5      KICSI    2      KICSI_OTHER     DEFAULT
ELADASOK5      KOZEPES  1      KOZEPES_LISTA   1, 2, 3, 4, 5
ELADASOK5      KOZEPES  2      KOZEPES_OTHER   DEFAULT
ELADASOK5      NAGY     1      NAGY_LISTA      1, 2, 3, 4, 5
ELADASOK5      NAGY     2      NAGY_OTHER      DEFAULT


SELECT name, column_name, column_position FROM dba_part_key_columns WHERE owner='NIKOVITS';
name        col        pos 
--------------------------
ELADASOK    HET        1
ELADASOK2   HET        1
ELADASOK3   HET        1
ELADASOK4   HET        1
ELADASOK5   MENNYISEG  1

SELECT name, column_name, column_position FROM dba_subpart_key_columns WHERE owner='NIKOVITS';
name        col        pos 
--------------------------
ELADASOK4   MENNYISEG  1
ELADASOK5   HET        1

A szegmens neve megegyezik a t�bla nev�vel, a t�nyleges adatobjektumok
pedig a part�ci�k illetve alpart�ci�k lesznek: 

SELECT segment_name, partition_name, segment_type 
FROM dba_segments WHERE owner='NIKOVITS' AND segment_name='ELADASOK5';

segment_name   partition_name   segment_type
--------------------------------------------------
ELADASOK5      KICSI_LISTA      TABLE SUBPARTITION
ELADASOK5      KICSI_OTHER      TABLE SUBPARTITION
ELADASOK5      KOZEPES_LISTA    TABLE SUBPARTITION
ELADASOK5      KOZEPES_OTHER    TABLE SUBPARTITION
ELADASOK5      NAGY_LISTA       TABLE SUBPARTITION
ELADASOK5      NAGY_OTHER       TABLE SUBPARTITION

**********/

SELECT table_name, partitioning_type FROM dba_part_tables WHERE owner = 'SH';

SELECT * FROM dba_part_tables WHERE owner = 'SH';

SELECT partition_name, blocks FROM dba_tab_partitions WHERE table_owner='SH' AND table_name='COSTS';

SELECT segment_name, partition_name, blocks 
FROM dba_segments WHERE owner='SH' AND segment_type='TABLE PARTITION' and segment_name='COSTS';

SELECT partition_name, partition_position pos, high_value, partition_position FROM dba_tab_partitions 
WHERE (table_owner='NIKOVITS' AND table_name='ELADASOK3'
OR table_owner='SH' AND table_name='COSTS') AND partition_position =2;


-- Inform�ci�k a clusterekr�l a katal�gusban (adatsz�t�r n�zetekben): 
-- DBA_CLUSTERS 
-- DBA_TABLES (cluster_name oszlop -> melyik klaszteren van a t�bla) 
-- DBA_CLU_COLUMNS (t�bl�k oszlopainak megfeleltet�se a klaszter kulcs�nak)
-- DBA_CLUSTER_HASH_EXPRESSIONS (hash klaszterek hash f�ggv�nyei)

drop table emp_clt;
drop table dept_clt;
drop cluster personnel_cl;
drop table cikk_hclt;
drop table szallit_hclt;
drop cluster cikk_hcl;
drop table cikk_hcl2t;
drop cluster cikk_hcl2;
drop cluster cikk_hcl3;

-- Cluster l�trehoz�sa (index cluster lesz):
CREATE CLUSTER personnel_cl (department_number NUMBER(2)) SIZE 4K;

-- T�bl�k l�trehoz�sa a clusteren:
CREATE TABLE emp_clt
  (empno NUMBER PRIMARY KEY, ename VARCHAR2(30), job VARCHAR2(27),
   mgr NUMBER(4), hiredate DATE, sal NUMBER(7,2), comm NUMBER(7,2), 
   deptno NUMBER(2) NOT NULL)
CLUSTER personnel_cl (deptno);
  
CREATE TABLE dept_clt
  (deptno NUMBER(2), dname VARCHAR2(42), loc VARCHAR2(39))
CLUSTER personnel_cl (deptno);

-- Index l�trehoz�sa (csak ezut�n lehet sorokat besz�rni):
CREATE INDEX personnel_cl_idx ON CLUSTER personnel_cl;
INSERT INTO emp_clt SELECT * FROM emp;
INSERT INTO dept_clt SELECT * FROM dept;

/*******
A fentiek ut�n n�zz�k meg az al�bbi lek�rdez�s eredm�ny�t. L�thatjuk, hogy
egy oszt�lybeli sornak �s egy dolgoz�beli sornak ugyanaz a ROWID-je.
SELECT rowid, ename ename_dname FROM emp_clt WHERE deptno=10
 UNION
SELECT rowid, dname FROM dept_clt WHERE deptno=10;

rowid                ename_dname
--------------------------------
AAB7goAAEAAAPG9AAA   ACCOUNTING
AAB7goAAEAAAPG9AAA   CLARK
AAB7goAAEAAAPG9AAB   KING
AAB7goAAEAAAPG9AAC   MILLER
********/


-- L�trehozunk egy hash clustert (HASHKEYS miatt !!!) �s rajta k�t t�bl�t:

CREATE CLUSTER cikk_hcl (ckod  NUMBER ) SIZE 4K  HASHKEYS 30;
CREATE TABLE cikk_hclt(ckod NUMBER, cnev VARCHAR2(20), 
             szin VARCHAR2(15), suly FLOAT) 
CLUSTER cikk_hcl(ckod); 
INSERT INTO cikk_hclt select * from cikk;
CREATE TABLE szallit_hclt(szkod NUMBER, ckod NUMBER, pkod NUMBER, 
             mennyiseg NUMBER, datum DATE) 
CLUSTER cikk_hcl(ckod); 
INSERT INTO szallit_hclt select * from szallit;

-- Saj�t hash f�ggv�nyt adunk meg:

CREATE CLUSTER cikk_hcl2 (ckod  NUMBER ) HASHKEYS 30 HASH IS MOD(ckod, 53);
CREATE TABLE cikk_hcl2t(ckod NUMBER, cnev VARCHAR2(20), 
             szin VARCHAR2(15), suly FLOAT) 
CLUSTER cikk_hcl2(ckod); 
INSERT INTO cikk_hcl2t select * from cikk;

CREATE CLUSTER cikk_hcl3 (ckod  NUMBER ) SINGLE TABLE HASHKEYS 30;


/**************
Inform�ci�k az adatsz�t�rb�l:

SELECT cluster_name, cluster_type, function, hashkeys, single_table
FROM dba_clusters WHERE owner='NIKOVITS';
cl_name        type    function        keys  single
---------------------------------------------------
CIKK_HCL       HASH    DEFAULT2         31    N
CIKK_HCL2      HASH    HASH EXPRESSION  31    N
CIKK_HCL3      HASH    DEFAULT2         31    Y
PERSONNEL_CL   INDEX   null              0    N


SELECT cluster_name, table_name FROM dba_tables 
WHERE owner='NIKOVITS' AND cluster_name IS NOT NULL ORDER BY 1,2;
cl_name       t_name
--------------------------
CIKK_HCL      CIKK_HCLT
CIKK_HCL      SZALLIT_HCLT
CIKK_HCL2     CIKK_HCL2T
PERSONNEL_CL  DEPT_CLT
PERSONNEL_CL  EMP_CLT


SELECT cluster_name, clu_column_name, table_name, tab_column_name 
FROM dba_clu_columns WHERE owner='NIKOVITS';
cl_name       cl_col             t_name        tab_col 
------------------------------------------------------
CIKK_HCL      CKOD               CIKK_HCLT     CKOD
CIKK_HCL      CKOD               SZALLIT_HCLT  CKOD
CIKK_HCL2     CKOD               CIKK_HCL2T    CKOD
PERSONNEL_CL  DEPARTMENT_NUMBER  DEPT_CLT      DEPTNO
PERSONNEL_CL  DEPARTMENT_NUMBER  EMP_CLT       DEPTNO


SELECT cluster_name, hash_expression 
FROM dba_cluster_hash_expressions WHERE owner='NIKOVITS';
cl_name      hash_expr
--------------------------
CIKK_HCL2    MOD(ckod, 53)


Az al�bbi lek�rdez�sben n�zz�k meg az objektum �s adatobjektum azonos�t�kat.

SELECT object_name, object_type, object_id, data_object_id 
FROM dba_objects WHERE owner='NIKOVITS'
AND (object_name LIKE 'CIKK_HCL' OR object_name LIKE '%_HCLT');

object_name     object_type  object_id  data_object_id
------------------------------------------------------
SZALLIT_HCLT      TABLE      100652     100650
CIKK_HCLT         TABLE      100651     100650
CIKK_HCL          CLUSTER    100650     100650


Az al�bbi lek�rdez�sb�l l�that�, hogy csak a clusternek van szegmense.

SELECT segment_name, segment_type, bytes 
FROM dba_segments WHERE owner='NIKOVITS'
AND (segment_name LIKE 'CIKK_HCL' OR segment_name LIKE '%_HCLT');

segment_name   segment_type   bytes
------------------------------------
CIKK_HCL       CLUSTER        589824

************/

select * from user_clusters;

select * from user_clu_columns;

SELECT owner, cluster_name FROM dba_clusters  
 MINUS
SELECT owner, cluster_name FROM dba_tables;

SELECT owner, cluster_name FROM dba_tables WHERE cluster_name IS NOT NULL
GROUP BY owner, cluster_name HAVING COUNT(*) >= 6;

SELECT owner, cluster_name FROM dba_clu_columns  
GROUP BY owner, cluster_name HAVING COUNT(DISTINCT clu_column_name) = 3;

SELECT COUNT(*) FROM
(SELECT owner, cluster_name, hash_expression FROM dba_cluster_hash_expressions);







-----------zh
Nikovits oldalan vannak megoldasok FELADATOK 1-5
papiros
linearis hasitas
b fa
bitmap index

gepes
dba obj, dba tab col, synonyms, view, stb
rowid

pl/sql nem lesz

