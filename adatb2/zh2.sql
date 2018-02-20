-- 1.
-- a.)
explain plan for select /*+ no_index(sz) */ * from nikovits.szallit sz natural join nikovits.cikk c where pkod=10;
-- vagy
explain plan for select /*+ full(sz) */ * from nikovits.szallit sz natural join nikovits.cikk c where pkod=10;
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));

-- b.)
explain plan for select /*+ index(sz) no_index(c) */ * from nikovits.szallit sz natural join nikovits.cikk c where pkod=10;
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));

-- 2.
-- a.)
explain plan for select szigsz
from branyi.szül? szül?
minus
select szigsz
from branyi.szül? szül?
where szül?.gyerekszig in (select szigsz from branyi.családtag családtag 
where keresztnév = 'László');
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));

-- b.)
explain plan for select szigsz
from branyi.családtag családtag
where szigsz not in (select cs1.szigsz
from branyi.családtag cs1, branyi.családtag cs2
where cs1.életévek < cs2.életévek);
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));

-- c.)
explain plan for select családtag.szigsz, count(*)
from branyi.családtag családtag, branyi.járt_ott járt_ott
where családtag.szigsz = járt_ott.szigsz and családtag.keresztnév = 'László'
group by családtag.szigsz
having count(*) > 1;
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));







-- 1a
explain plan for select /*+ index(sz) index(c) */ * from nikovits.szallit sz natural join nikovits.cikk c where pkod=10;
-- 1b
explain plan for select /*+ index(c) no_index(sz) */ * from nikovits.szallit sz natural join nikovits.cikk c where pkod=10;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));

-- 2a
explain plan for select sznev
from nikovits.szallito szallito
where szkod in (select x.szkod from nikovits.szallit x where mennyiseg > 0);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));

-- 2b
explain plan for select max(szallit.szkod)
from nikovits.cikk cikk, nikovits.szallit szallit
where cikk.ckod=szallit.ckod and szkod<10;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));

-- 2c bad
explain plan for select /* +no_index(cikk)*/ cikk.ckod
from nikovits.cikk cikk, nikovits.szallit szallit
where cikk.ckod=szallit.ckod and szallit.szkod=(select szkod from nikovits.szallito szallito)
and szallit.ckod>100
and szkod<10;

--c good
explain plan for
select /*+ no_use_nl(sz c) no_index(c) */ mennyiseg from nikovits.szallit sz, nikovits.cikk c, nikovits.szallito szt
where c.ckod > 100 and sz.szkod < 10 and sz.ckod = c.ckod and szt.szkod = sz.szkod;


SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table', null, 'serial'));





1. 
a)
explain plan SET statement_id='1A' for select /*+ no_index(sz) */ * from nikovits.szallit sz natural join nikovits.cikk c where pkod=10;
select plan_table_output from table(dbms_xplan.display('plan_table', '1A', 'serial'));

b)
explain plan SET statement_id='1B' for select /*+ index(sz) no_index(c) */ * from nikovits.szallit sz natural join nikovits.cikk c where pkod=10;
select plan_table_output from table(dbms_xplan.display('plan_table', '1B', 'serial'));

2.
a)
explain plan SET statement_id='2A' for select szigsz
from branyi.szül? szül?
minus
select szigsz
from branyi.szül? szül?
where szül?.gyerekszig in (select szigsz from branyi.családtag családtag 
where keresztnév = 'László');
select plan_table_output from table(dbms_xplan.display('plan_table', '2A', 'serial'));

b)
explain plan SET statement_id='2B' for select szigsz
from branyi.családtag családtag
where szigsz not in (select cs1.szigsz
from branyi.családtag cs1, branyi.családtag cs2
where cs1.életévek < cs2.életévek);
select plan_table_output from table(dbms_xplan.display('plan_table', '2B', 'serial'));

c)
explain plan SET statement_id='2C' for select családtag.szigsz, count(*)
from branyi.családtag családtag, branyi.járt_ott járt_ott
where családtag.szigsz = járt_ott.szigsz and családtag.keresztnév = 'László'
group by családtag.szigsz
having count(*) > 1;
select * from table(dbms_xplan.display('plan_table', '2C', 'serial'))