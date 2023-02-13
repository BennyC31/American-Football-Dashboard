select * from football_sch.profootballyearsummary;

select distinct team_id,team_location,team_name
from football_sch.profootballyearsummary p 
where team_location ='St. Louis'
order by team_id;

insert into football_sch.teamid_loc
select distinct t.loc_id,p.team_id 
from football_sch.profootballyearsummary p
join football_sch.teamlocation t on p.team_location = t.team_location 
order by p.team_id,t.loc_id;

select * from football_sch.profootballyearsummary p where p.team_id ='NFLTeam30';

-- football_sch.teamid_loc definition

-- Drop table

-- DROP TABLE football_sch.teamid_loc;

CREATE TABLE football_sch.teamid_loc (
	loc_id int4 NOT NULL,
	team_id varchar(50) NOT NULL,
	CONSTRAINT teamidloc_pkey PRIMARY KEY (loc_id,team_id)
);

select * from football_sch.teamid_loc tl ;

select distinct  p.team_id,t.team_location ,t.team_name 
from football_sch.profootballyearsummary p
join football_sch.teamlookup t on p.team_id = t.team_id 
order by 1;

create view football_sch.tmp_team_year as
select p.team_id, max(p.leag_year) as lg_year
from football_sch.profootballyearsummary p
group by p.team_id order by lg_year desc;

insert into football_sch.teamfranchise (team_id,team_location,team_name,fullname,leagid)
select tty.team_id,p.team_location ,p.team_name,concat(p.team_location, ' ',p.team_name) as fullname,l.id 
from football_sch.tmp_team_year tty 
join football_sch.profootballyearsummary p on 
tty.team_id = p.team_id and tty.lg_year = p.leag_year
join football_sch.league l on p.leagabrv = l.leag_abbr 
order by tty.team_id;


-- football_sch.teamfranchise definition

-- Drop table

-- DROP TABLE football_sch.teamfranchise;

CREATE TABLE football_sch.teamfranchise (
	franchiseid int4 generated by default as identity,
	team_id varchar(50) NOT NULL,
	team_location varchar(50) NOT NULL,
	team_name varchar(50) not NULL,
	fullname varchar(50) not null,
	leagid int4 not null,
	CONSTRAINT teamfranchiseid_pkey PRIMARY KEY (franchiseid)
);



drop view football_sch.vw_franchise;


create view football_sch.vw_franchise as
select t2.franchiseid, t.loc_id , t2.team_id , t2.fullname as franchisename, t.team_location, t2.leagid 
from football_sch.teamlocation t 
join football_sch.teamid_loc tl on t.loc_id = tl.loc_id 
join football_sch.teamfranchise t2 on tl.team_id = t2.team_id 
--where t.loc_id =72
order by t2.franchiseid, t.team_location, t2.team_name, t2.leagid;



select * from football_sch.profootballyearsummary p where leag_year =1920 and leagabrv ='NFL' order by p.conference,p.division,p.place;

select count(*) from football_sch.profootballyearsummary p ;

select vf.franchiseid,p.leag_year ,vf.loc_id,p.team_location as yr_loc, p.team_name, vf.leagid 
from football_sch.vw_franchise vf 
left join football_sch.profootballyearsummary p on vf.team_id = p.team_id and vf.team_location = p.team_location 
--where vf.team_id ='NFLTeam1'
where p.leag_year =1920
order by p.leag_year,vf.team_location;

---Here:

select * from vw_franchise vf ;

--drop view football_sch.vw_franchise;


--create view football_sch.vw_franchise as
select t2.franchiseid, t.loc_id , t2.team_id , t2.fullname as franchisename, t.team_location, t2.leagid 
from football_sch.teamlocation t 
join football_sch.teamid_loc tl on t.loc_id = tl.loc_id 
join football_sch.teamfranchise t2 on tl.team_id = t2.team_id 
--where t.loc_id =72
order by t2.franchiseid, t.team_location, t2.team_name, t2.leagid;

select distinct min(leag_year) as tmlocyear,p.team_location, p.team_id
from profootballyearsummary p 
--where p.team_id ='NFLTeam10'
group by p.team_location, p.team_id  order by tmlocyear asc ;


select distinct p.team_location, p.team_id
from profootballyearsummary p 
--where p.team_id ='NFLTeam10'
group by p.team_location, p.team_id  order by p.team_id asc ;

create view football_sch.tmp_team_year as
select p.team_id, max(p.leag_year) as lg_year
from football_sch.profootballyearsummary p
group by p.team_id order by lg_year desc;

select * from tmp_team_year tty ;
-- 2/10/2023
create view football_sch.vw_locations as
select t.loc_id,t.team_location,t.state_code,t.lat,t.lon from football_sch.teamlocation t ;


select * from teamid_loc tl ;
select * from vw_franchise vf ;

select * from football_sch.vw_locations vl ;

select * from vw_location_team_id vlti ;

create view football_sch.vw_location_team_id as
select vl.loc_id, vl.team_location, vl.state_code,
vl.lat, vl.lon, tl.team_id 
from football_sch.vw_locations vl 
join teamid_loc tl on vl.loc_id = tl.loc_id 
order by vl.loc_id,tl.team_id;