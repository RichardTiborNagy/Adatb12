explain plan for
select * from NIKOVITS.EMP natural join NIKOVITS.DEPT;

create table PLAN_TABLE (
        statement_id       varchar2(30),
        plan_id            number,
        timestamp          date,
        remarks            varchar2(4000),
        operation          varchar2(30),
        options            varchar2(255),
        object_node        varchar2(128),
        object_owner       varchar2(30),
        object_name        varchar2(30),
        object_alias       varchar2(65),
        object_instance    numeric,
        object_type        varchar2(30),
        optimizer          varchar2(255),
        search_columns     number,
        id                 numeric,
        parent_id          numeric,
        depth              numeric,
        position           numeric,
        cost               numeric,
        cardinality        numeric,
        bytes              numeric,
        other_tag          varchar2(255),
        partition_start    varchar2(255),
        partition_stop     varchar2(255),
        partition_id       numeric,
        other              long,
        distribution       varchar2(30),
        cpu_cost           numeric,
        io_cost            numeric,
        temp_space         numeric,
        access_predicates  varchar2(4000),
        filter_predicates  varchar2(4000),
        projection         varchar2(4000),
        time               numeric,
        qblock_name        varchar2(30),
        other_xml          clob
);

select * from plan_table;

select * from plan_table order by plan_id, id; --igy jobb, mert keverednek

delete plan_table;

explain plan SET statement_id='lekerdezes1' for
select * from NIKOVITS.EMP natural join NIKOVITS.DEPT;

SELECT * FROM TABLE(dbms_xplan.DISPLAY('PLAN_TABLE','lekerdezes1'));


explain plan for
select deptno from NIKOVITS.EMP natural join NIKOVITS.DEPT;


SELECT * FROM TABLE(dbms_xplan.DISPLAY('PLAN_TABLE','lekerdezes1','BASIC'));

SELECT * FROM TABLE(dbms_xplan.DISPLAY('PLAN_TABLE','lekerdezes1','SERIAL'));           --a nev null is lehet, a nullok kozul az utolsot csinalja
    
SELECT * FROM TABLE(dbms_xplan.DISPLAY('PLAN_TABLE','lekerdezes1','ALL'));

--parameterek nelkul is az utolso nullost csinalja



select sum(suly) from nikovits.cikk where ckod < 11;

explain plan for
select sum(suly) from nikovits.cikk where ckod < 11;

explain plan for
select max(suly) from nikovits.cikk where ckod < 11;

--mindketto aggregate fuggveny, nem lehet kideriteni hogy melyik

SELECT * FROM TABLE(dbms_xplan.DISPLAY());




select sum(suly) from nikovits.cikk where ckod<150; --hasznal indexet, itt meg szerinte gyorsabb igy
select sum(suly) from nikovits.cikk where ckod<500; --mar nem hasznal, inkabb vegignezi mindet, gyorsabb mint blokkokat olvasgatni index szerint


--ab2_feladatok8
--1.feladat a fenti, ad egy plant, talald ki hogy mi volt a select   expl.txt, lehet hasznalni hintet is, Branyi nem fog, de ha csak tudod megoldani ok

--gepes 2.feladat   hintek.txt
--select kozepere megjegyzesbe lehet hinteket adni, hogy mit hasznaljon (nested loop, merge stb)
--itt nincs szintaxis elemzes, nem dob hibat, irjad helyesen

select idekomment * from ...;

/*+ use_nl(tablanev1, tablanev2) */         --ha atnevezed a tablat selectben, akkor ide az uj nev kell. tulaj sose kell
/*+ no_use_hash(tablanev1 tablanev2) */

/*+ no_index(tablanev) */
/*+ full(tablanev) */
/*+ index(tablanev indexnev) */



--nikovits tervek*.txt-t probald vegig

