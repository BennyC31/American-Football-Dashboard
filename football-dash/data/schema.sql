-- football_sch.profootballyearsummary definition

-- Drop table

-- DROP TABLE IF EXISTS football_sch.profootballyearsummary;

CREATE TABLE IF NOT EXISTS football_sch.profootballyearsummary
(
    leag_year int NULL,
	team_id varchar(50) NULL,
	team_location varchar(50) NULL,
	team_name varchar(50) NULL,
	conference varchar(50) NULL,
	division varchar(50) NULL,
	w int NULL,
	l int NULL,
	t int NULL,
	pf int NULL,
	pa int NULL,
	place int NULL,
	leagabrv varchar(50) NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE sports_data;

ALTER TABLE IF EXISTS football_sch.profootballyearsummary
    OWNER to si_info;

GRANT ALL ON TABLE football_sch.profootballyearsummary TO si_info;


-- football_sch.teamlocation definition

-- Drop table

-- DROP TABLE football_sch.teamlocation cascade;

CREATE TABLE football_sch.teamlocation (
	loc_id int primary key,
	team_location varchar(50) NOT NULL,
	state_code varchar(4) NOT NULL,
	lat float4 NULL,
	lon float4 null,
	football_location varchar(50) NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE sports_data;

ALTER TABLE IF EXISTS football_sch.teamlocation
    OWNER to si_info;

GRANT ALL ON TABLE football_sch.teamlocation TO si_info;

-- football_sch.footballchamps definition

-- Drop table

-- DROP TABLE football_sch.footballchamps cascade;

CREATE TABLE football_sch.footballchamps (
	leag_year int NULL,
	team_id varchar(50) NULL,
	team_location varchar(50) NULL,
	team_name varchar(50) NULL,
	leagabrv varchar(50) null,
	champ_name varchar(30) NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE sports_data;

ALTER TABLE IF EXISTS football_sch.footballchamps
    OWNER to si_info;

GRANT ALL ON TABLE football_sch.footballchamps TO si_info;

-- football_sch.teamid_loc definition

-- Drop table

-- DROP TABLE football_sch.teamid_loc;

CREATE TABLE football_sch.teamid_loc (
	loc_id int4 NOT NULL,
	team_id varchar(50) NOT NULL,
	CONSTRAINT teamidloc_pkey PRIMARY KEY (loc_id, team_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE sports_data;

ALTER TABLE IF EXISTS football_sch.teamid_loc
    OWNER to si_info;

GRANT ALL ON TABLE football_sch.teamid_loc TO si_info;

-- football_sch.teamfranchise definition

-- Drop table

-- DROP TABLE football_sch.teamfranchise;

CREATE TABLE football_sch.teamfranchise (
	franchiseid int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	team_id varchar(50) NOT NULL,
	team_location varchar(50) NOT NULL,
	team_name varchar(50) NOT NULL,
	fullname varchar(50) NOT NULL,
	leagid int4 NOT NULL,
	CONSTRAINT teamfranchiseid_pkey PRIMARY KEY (franchiseid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE sports_data;

ALTER TABLE IF EXISTS football_sch.teamfranchise
    OWNER to si_info;

GRANT ALL ON TABLE football_sch.teamfranchise TO si_info;

-- views

--DROP VIEW football_sch.nfl2021;

create view football_sch.nfl2021
as
select distinct p.team_id ,p.team_location ,p.team_name  
from football_sch.profootballyearsummary p 
join football_sch.teamlocation t on p.team_location = t.football_location 
where p.leag_year =2021
order by team_location, team_id;

--DROP VIEW football_sch.locationinfo2021;

create view football_sch.locationinfo2021 
as
select n.team_location as football_location, n.team_name,
t.team_location, t.lat, t.lon, t.state_code, n.team_id
from football_sch.nfl2021 n 
join football_sch.teamlocation t on n.team_location = t.football_location
where t.team_location <> 'New York';

--DROP VIEW football_sch.locationinfo2021all;

create view football_sch.locationinfo2021all
as
select l.football_location, l.team_name, l.team_location,
l.state_code, l.lat, l.lon, p.conference, p.division, l.team_id 
from football_sch.locationinfo2021 l
join football_sch.profootballyearsummary p on l.team_id = p.team_id 
where p.leag_year = 2021
order by p.conference, p.division, l.football_location, l.team_name;

-- DROP VIEW football_sch.teamlookup;

create view football_sch.teamlookup
as
select distinct p.team_id,p.team_location,p.team_name,
concat(p.team_location, ' ', p.team_name) as fullname  
from football_sch.profootballyearsummary p
order by p.team_id ;

-- 01/26/2023:
-- DROP VIEW football_sch.data_grt_2011;

create view football_sch.data_grt_2011
as
select * 
from football_sch.profootballyearsummary p
where p.leag_year > 2011 and p.leagabrv = 'NFL';

-- DROP VIEW football_sch.data_sum_grt_2011;

create view football_sch.data_sum_grt_2011
as
select la.football_location, la.team_name, la.team_id, a.w, a.l, a.t, a.pf, a.pa
from football_sch.locationinfo2021all la
join
(select dg.team_id, sum(w) as w, sum(l) as l, sum(t) as t, sum(pf) as pf, sum(pa) as pa
from football_sch.data_grt_2011 dg 
group by dg.team_id) a on la.team_id = a.team_id
order by a.w desc, a.l asc, a.pf desc, a.pa asc;

-- football_sch.tmp_team_year source

CREATE VIEW football_sch.tmp_team_year
AS SELECT p.team_id,
    max(p.leag_year) AS lg_year
   FROM football_sch.profootballyearsummary p
  GROUP BY p.team_id
  ORDER BY (max(p.leag_year)) DESC;
  
 -- football_sch.vw_franchise source

CREATE OR REPLACE VIEW football_sch.vw_franchise
AS SELECT t2.franchiseid,
    t.loc_id,
    t2.team_id,
    t2.fullname AS franchisename,
    t.team_location,
    t2.leagid
   FROM football_sch.teamlocation t
     JOIN football_sch.teamid_loc tl ON t.loc_id = tl.loc_id
     JOIN football_sch.teamfranchise t2 ON tl.team_id::text = t2.team_id::text
  ORDER BY t2.franchiseid, t.team_location, t2.team_name, t2.leagid;
 
 
 -- football_sch.vw_locations source

CREATE OR REPLACE VIEW football_sch.vw_locations
AS SELECT t.loc_id,
    t.team_location,
    t.state_code,
    t.lat,
    t.lon
   FROM football_sch.teamlocation t;
 
  
 -- football_sch.vw_location_team_id source

CREATE OR REPLACE VIEW football_sch.vw_location_team_id
AS SELECT vl.loc_id,
    vl.team_location,
    vl.state_code,
    vl.lat,
    vl.lon,
    tl.team_id
   FROM football_sch.vw_locations vl
     JOIN football_sch.teamid_loc tl ON vl.loc_id = tl.loc_id
  ORDER BY vl.loc_id, tl.team_id;
 
