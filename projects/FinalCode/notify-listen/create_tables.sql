CREATE TABLE public.pc_turnout
(
    state text COLLATE pg_catalog."default" NOT NULL,
    pc_code integer NOT NULL,
    pc_name character varying(50) COLLATE pg_catalog."default",
    male_electors integer,
    male_voters integer,
    maleturnout real,
    female_electors integer,
    female_voters integer,
    female_turnout real,
    total_electors integer,
    total_voters integer,
    total_turnout real,
    CONSTRAINT pc_turnout_pkey PRIMARY KEY (state, pc_code)
);

\copy pc_turnout from 'pc_turnout.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.pc_res
(
    pc_name character varying(50) COLLATE pg_catalog."default",
    pc_code integer NOT NULL,
    lead_cand text COLLATE pg_catalog."default",
    lead_party character varying(60) COLLATE pg_catalog."default",
    trail_cand text COLLATE pg_catalog."default",
    trail_party character varying(60) COLLATE pg_catalog."default",
    margin integer,
    status character varying(60) COLLATE pg_catalog."default",
    state character varying(50) COLLATE pg_catalog."default",
    state_code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pc_res_pkey PRIMARY KEY (state_code, pc_code)
);

\copy pc_res from 'pc_res.csv' CSV HEADER;

CREATE TABLE public.pc_info
(
    state character varying(50) COLLATE pg_catalog."default" NOT NULL,
    pc_code integer,
    pc_name character varying(60) COLLATE pg_catalog."default",
    pc_type character varying(10) COLLATE pg_catalog."default",
    ac_code integer NOT NULL,
    ac_name character varying(60) COLLATE pg_catalog."default",
    ac_type character varying(10) COLLATE pg_catalog."default",
    m_18_19 integer,
    f_18_19 integer,
    o_18_19 integer,
    m_18_ integer,
    f_18_ integer,
    o_18_ integer,
    gen_ratio integer,
    elec_wd_id integer,
    elec_wd_photi integer,
    CONSTRAINT pc_info_pkey PRIMARY KEY (state, ac_code)
);
\copy pc_info from 'pc_info.csv' CSV HEADER;

CREATE TABLE public.pc_cand_wise
(
    cand text COLLATE pg_catalog."default",
    party text COLLATE pg_catalog."default",
    votes integer,
    state character varying(50) COLLATE pg_catalog."default",
    pc_name character varying(60) COLLATE pg_catalog."default",
    state_code character varying(10) COLLATE pg_catalog."default",
    pc_code integer
);
\copy pc_cand_wise from 'pc_cand_wise.csv' CSV HEADER;

CREATE TABLE public.affidavits
(
    state character varying(50) COLLATE pg_catalog."default",
    const character varying(60) COLLATE pg_catalog."default",
    id integer,
    cand text COLLATE pg_catalog."default",
    party_abb character varying(50) COLLATE pg_catalog."default",
    crim_case integer,
    educ text COLLATE pg_catalog."default",
    tot_asset bigint,
    tot_liab bigint,
    year integer,
    age integer,
    women integer,
    par_name text COLLATE pg_catalog."default"
);

\copy affidavits from '2004-2019-affidavits.csv' CSV HEADER;

CREATE view pc_res_buff AS 
(
  WITH 
  foo AS
    (
      select distinct on(state,state_code,pc_name,pc_code) state,state_code,pc_name,pc_code,cand,party,votes  
      from pc_cand_wise order by state,state_code,pc_name,pc_code,votes DESC
    ),
  foo2 AS
    (select distinct on(state,state_code,pc_name,pc_code) state,state_code,pc_name,pc_code,cand,party,votes  from
      (
        ( 
          select state,state_code,pc_name,pc_code,cand,party,votes
          from pc_cand_wise 
        )
        EXCEPT 
        (
          select state,state_code,pc_name,pc_code,cand,party,votes   from foo
        )
      ) AS bar ORDER BY state,state_code,pc_name,pc_code,votes DESC
    )

  select foo.state,foo.state_code,foo.pc_name,foo.pc_code,foo.cand AS lead_cand,foo2.cand AS trail_cand,
    foo.party AS lead_party,foo2.party AS trail_party,abs(foo.votes - foo2.votes) AS margin
    from foo2 INNER JOIN foo 
    ON ((foo.state_code = foo2.state_code) and foo.pc_code = foo2.pc_code)
)
;

CREATE TABLE public.users
(
    
    name text,
    email text ,
    password text,
    state text,
    pc_name text,
    CONSTRAINT users_key PRIMARY KEY (email)
)
;

insert into users values('Ansh Prakash','anshprakash1997@gmail.com','1997-07-12','Andhra Pradesh','Adilabad');
insert into users values('Kshitij Gupta','240698kshitij@gmail.com','1998-07-12','NCT OF Delhi','SOUTH DELHI');
insert into users values('Pranjal','coolpranjal.agarwal@gmail.com','1998-06-1','Gujarat','Rajkot');
insert into users values('Haha','abc@hfja.com','1998-06-1','Andhra Pradesh','Adilabad');



-- tests
insert into pc_cand_wise values('GODAM NAGESH','Telangana Rashtra Samithi',430847,'Andhra Pradesh','Adilabad','S01',1)
insert into ge_2019_cand_wise(cand,party,votes,state,pc_name, pc_code) values('GODAM NAGESH','Telangana Rashtra Samithi',430847,'NCT OF Delhi','SOUTH DELHI',7)

