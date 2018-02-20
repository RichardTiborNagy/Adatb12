select * from branyi.vilag_orszagai;
select * from nikovits.folyok;

--grid97, lennenk, ha mukodne
select * from nikovits.vilag_orszagai;
select * from nikovits.folyok;

--ez a nem *-os, abc sorrend
select * from branyi.vilag_orszagai where
(select orszagok from nikovits.folyok where nev='Mekong') like '%'||tld||'%';

--folyasirannyal kell melle egy sorszam, igy sorba lehet tenni (ez meg nincs kesz) 
select tld,nev from branyi.vilag_orszagai where
(select orszagok from nikovits.folyok where nev='Mekong') like '%'||tld||'%';

--user_tables, ha a partitioned oszlopban yes van, akkor az a tabla tobb fajlban van tarolva

select * from user_tables;

select * from sila.szeret;

select rownum, * from sila.szeret; --hibas
select rownum from sila.szeret;
select rownum, NEV, GYUMOLCS from sila.szeret;
select rownum, szeret.* from sila.szeret;

select rowid, szeret.* from sila.szeret; --amikor egy sor letrejon, kap egy id-t, ami orokre az ove marad, torleskor torlodik
--157.181 elte .162 gepterem .94 gep, ip 256-os szamrendszerben
--row id 64-es szamrendszer, jelolesek a honlapon, felosztas a holnapon (

select * from dba_objects where owner='SILA' and object_name='SZERET';

--
select * from dba_tablespaces;

--hany blokk?
select * from nikovits.cikk;

select * from dba_tables where owner='NIKOVITS' and table_name='CIKK';
--ez csak kozelito, rossz
select blocks from dba_tables where owner='NIKOVITS' and table_name='CIKK';

--ez nem a tenyleges adatmennyiseg, hanem hogy mennyi van lefoglalva
select * from dba_segments where owner='NIKOVITS' and segment_name='CIKK' and segment_Type='TABLE';
select blocks from dba_segments where owner='NIKOVITS' and segment_name='CIKK' and segment_Type='TABLE';

--igy pontos:
select rowid,cikk.* from nikovits.cikk;
select rowid from nikovits.cikk;
select substr(rowid,10,6) from nikovits.cikk;
select distinct substr(rowid,10,6) from nikovits.cikk;
select count(distinct substr(rowid,10,6)) from nikovits.cikk; --es sem jo lol, ha kulon fajlban vannak, a blokkok sorszama lehet ugyanaz
select count(distinct substr(rowid,1,15)) from nikovits.cikk; --igy jo, figyeli a kulonbozo fajlokat is

--ez sem pontos, lehet particionalt tabla
select blocks from dba_extents where owner='NIKOVITS' and segment_name='CIKK' and segment_type='TABLE';

select * from user_segments;
select * from user_extents;

--most: blokkonkent hany rekord?
select substr(rowid,1,15),count(*) from nikovits.cikk group by substr(rowid,1,15);

--jovo hetre atnezni: pl/sql, foleg masolas sorszam szerint, insert


drop table cikkt;
create table cikkt as select * from nikovits.cikk; --de csak a szerkezete kell
create table cikkt as select * from nikovits.cikk where 1=2; -- igy ures, de a megszoritasok nem mennek at
select * from cikkt;

drop table cikkt; --ez az users tablateren volt

select * from user_tables;
select * from user_segments;

create table cikkt tablespace example as select * from nikovits.cikk where 1=2; -- igy jo a tablespace is
select * from user_segments; --amig nincs benne adat, a gep nem foglal neki helyet, nincs a segmentekben

insert into cikkt values(1,'x','szin',2);

drop table cikkt; --128 kb kell

create table cikkt tablespace example storage(initial 128k) as select * from nikovits.cikk where 1=2;
select * from user_tables;
select * from user_segments;

drop table cikkt;

create table cikkt tablespace example storage(initial 128k) as select * from nikovits.cikk where 1=2;
--most ezutan manualisan foglaljunk le meg 128kb-ot
alter table cikkt allocate extent (size 128k); --igy
select * from user_tables;
select * from user_segments; --de igy mar bekerul, hiaba ures. kenytelen letarolni, hogy tudja tarolni, hogy ki van bovitve
select * from user_extents;

--

select rowid, szeret.* from sila.szeret; -- mi van, ha egy sorban atirom malackat egy 2000 hosszu stringre?

select rowid,cikk.* from nikovits.cikk;

--az indexek rowid alapjan mukodnek, pontosan mutatjak hogy hol a rekord
--kell: kettes szamrendszerben szamolas
