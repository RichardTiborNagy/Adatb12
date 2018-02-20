--grid szerveren dolgozunk
create database link aramis1 connect to gwsazv identified by jelszo using 'aramis';

create database link aramis2 connect to gwsazv identified by jelszo
using 'aramis.inf.elte.hu:1521/eszakigrid97';

select * from sz;
select * from sz@aramis;
--everythings broken

-- back to aramis

select * from dba_db_links;
select * from user_db_links;

--
--grid-en igy lenne jo:
select * from nikovits.folyok@aramis1; --aramis-on van
select * from nikovits.vilag_orszagai; --grid-en van
--hf nikovits oldalon, Mekong folyo

--lol fokonyvtarba ~5000 1 betus txt file => full

select * from dba_data_files;
select * from dba_temp_files;

select * from dba_tablespaces;

select * from dba_segments;
select * from user_segments;

select * from dba_extents;
select * from user_extents;

select * from dba_free_space;
select * from user_free_space;

select * from dba_tables;
select * from user_tables;

--hf branyi t02 

--mo lesz nikovitsnal, de zh elott leszedi











