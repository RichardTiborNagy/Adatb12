--*-os mekong
--instr

--ezek sem jok meg
select tld, nev, instr((select orszagok from nikovits.folyok where nev = 'Mekong'), tld) from branyi.vilag_orszagai;

select tld, nev, instr((select orszagok from nikovits.folyok where nev = 'Mekong'), tld) from branyi.vilag_orszagai
where instr((select orszagok from nikovits.folyok where nev = 'Mekong'), tld)>0 order by 3;

--ez sem jo, az Odera nem helyes, Poland-n ketszer is keresztul folyis
accept x
select tld, nev, instr((select orszagok from nikovits.folyok where nev = '&x'), tld) from branyi.vilag_orszagai
where instr((select orszagok from nikovits.folyok where nev = '&x'), tld)>0 order by 3;

