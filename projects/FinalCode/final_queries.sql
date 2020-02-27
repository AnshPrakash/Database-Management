CREATE TABLE public.affidavits
(
    state text COLLATE pg_catalog."default",
    pc_name text COLLATE pg_catalog."default",
    id integer,
    cand text COLLATE pg_catalog."default",
    party_abb text COLLATE pg_catalog."default",
    crim_case integer,
    educ text COLLATE pg_catalog."default",
    tot_asset bigint,
    tot_liab bigint,
    year integer,
    age integer,
    gender integer,
    par_name text COLLATE pg_catalog."default"
);
\copy affidavits from '2004_2019_affidavits.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE public.comments
(
    id serial,
    userid text COLLATE pg_catalog."default",
    page text COLLATE pg_catalog."default",
    body text COLLATE pg_catalog."default",
    "time" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.ge_1998_cand_wise
(
    state_code text COLLATE pg_catalog."default" NOT NULL,
    state text COLLATE pg_catalog."default" NOT NULL,
    pc_code integer NOT NULL,
    pc_name text COLLATE pg_catalog."default" NOT NULL,
    pc_type text COLLATE pg_catalog."default",
    el_mon integer,
    el_year integer,
    cand text COLLATE pg_catalog."default" NOT NULL,
    cand_sex text COLLATE pg_catalog."default",
    party_abb text COLLATE pg_catalog."default",
    votes integer,
    party_pos integer NOT NULL,
    party text COLLATE pg_catalog."default",
    CONSTRAINT ge_1998_cand_wise_pkey PRIMARY KEY (state, pc_code, party_pos)
   
);

\copy ge_1998_cand_wise from 'GE_1998_cand_wise.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.ge_1998_electors
(
    state_code text COLLATE pg_catalog."default" NOT NULL,
    state text COLLATE pg_catalog."default" NOT NULL,
    pc_code integer NOT NULL,
    pc_name text COLLATE pg_catalog."default" NOT NULL,
    cat text COLLATE pg_catalog."default",
    el_mon integer,
    el_year integer,
    total_electors integer,
    total_voters integer,
    total_contestant integer,
    total_turnout real
);

\copy ge_1998_electors from 'GE_1998_electors.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.ge_1999_cand_wise
(
    state_code text COLLATE pg_catalog."default" NOT NULL,
    state text COLLATE pg_catalog."default" NOT NULL,
    pc_code integer NOT NULL,
    pc_name text COLLATE pg_catalog."default" NOT NULL,
    pc_type text COLLATE pg_catalog."default",
    el_mon integer,
    el_year integer,
    cand text COLLATE pg_catalog."default" NOT NULL,
    cand_sex text COLLATE pg_catalog."default",
    party_abb text COLLATE pg_catalog."default",
    votes integer,
    party_pos integer NOT NULL,
    party text COLLATE pg_catalog."default",
    CONSTRAINT ge_1999_cand_wise_pkey PRIMARY KEY (state, pc_code, party_pos)
       );

\copy ge_1999_cand_wise from 'GE_1999_cand_wise.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.ge_1999_electors
(
    state_code text COLLATE pg_catalog."default" NOT NULL,
    state text COLLATE pg_catalog."default" NOT NULL,
    pc_code integer NOT NULL,
    pc_name text COLLATE pg_catalog."default" NOT NULL,
    cat text COLLATE pg_catalog."default",
    el_mon integer,
    el_year integer,
    total_electors integer,
    total_voters integer,
    total_contestant integer,
    total_turnout real
);
\copy ge_1999_electors from 'GE_1999_electors.csv' DELIMITER ',' CSV HEADER;




CREATE TABLE public.ge_2004_cand_wise
(
    state_code text COLLATE pg_catalog."default" NOT NULL,
    state text COLLATE pg_catalog."default" NOT NULL,
    pc_code integer NOT NULL,
    pc_name text COLLATE pg_catalog."default" NOT NULL,
    pc_type text COLLATE pg_catalog."default",
    el_mon integer,
    el_year integer,
    cand text COLLATE pg_catalog."default" NOT NULL,
    cand_sex text COLLATE pg_catalog."default",
    cand_cat text COLLATE pg_catalog."default",
    party_abb text COLLATE pg_catalog."default",
    votes integer,
    party_pos integer NOT NULL,
    party text COLLATE pg_catalog."default",
    CONSTRAINT ge_2004_cand_wise_pkey PRIMARY KEY (state, pc_code, party_pos)
        
);

\copy ge_2004_cand_wise from 'GE_2004_cand_wise.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.ge_2004_electors
(
    state_code text COLLATE pg_catalog."default" NOT NULL,
    state text COLLATE pg_catalog."default" NOT NULL,
    pc_code integer NOT NULL,
    pc_name text COLLATE pg_catalog."default" NOT NULL,
    cat text COLLATE pg_catalog."default",
    el_mon integer,
    el_year integer,
    total_electors integer,
    total_voters integer,
    total_contestant integer,
    total_turnout real
);

\copy ge_2004_electors from 'GE_2004_electors.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.ge_2009_cand_wise
(
    state_code text COLLATE pg_catalog."default" NOT NULL,
    state text COLLATE pg_catalog."default" NOT NULL,
    el_mon integer,
    el_year integer,
    pc_code integer NOT NULL,
    pc_name text COLLATE pg_catalog."default" NOT NULL,
    pc_type text COLLATE pg_catalog."default",
    cand text COLLATE pg_catalog."default" NOT NULL,
    cand_sex text COLLATE pg_catalog."default",
    cand_cat text COLLATE pg_catalog."default",
    cand_age integer,
    party_abb text COLLATE pg_catalog."default",
    votes integer,
    party_pos integer NOT NULL,
    party text COLLATE pg_catalog."default",
    CONSTRAINT ge_2009_cand_wise_pkey PRIMARY KEY (state, pc_code, party_pos));

\copy ge_2009_cand_wise from 'GE_2009_cand_wise.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.ge_2009_electors
(
    state_code text COLLATE pg_catalog."default" NOT NULL,
    state text COLLATE pg_catalog."default" NOT NULL,
    pc_code integer NOT NULL,
    pc_name text COLLATE pg_catalog."default" NOT NULL,
    total_voters integer,
    total_electors integer,
    total_contestant integer,
    total_turnout real
);
\copy ge_2009_electors from 'GE_2009_electors.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE public.ge_2014_cand_wise
(
    cand text COLLATE pg_catalog."default",
    party text COLLATE pg_catalog."default",
    votes integer,
    state character varying(50) COLLATE pg_catalog."default",
    pc_name character varying(60) COLLATE pg_catalog."default",
    state_code character varying(10) COLLATE pg_catalog."default",
    pc_code integer
);
\copy ge_2014_cand_wise from 'GE_2014_cand_wise.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.ge_2014_electors
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

\copy ge_2014_electors from 'GE_2014_electors.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.party_abbrev
(
    abb text COLLATE pg_catalog."default" NOT NULL,
    full_name text COLLATE pg_catalog."default",
    CONSTRAINT party_abbrev_pkey PRIMARY KEY (abb)
        );

\copy party_abbrev from 'party_abbreviations.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE public.pc_info_2014
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

\copy pc_info_2014 from 'pc_info_2014.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE public.vil_ac
(
    state text COLLATE pg_catalog."default" NOT NULL,
    district text COLLATE pg_catalog."default",
    tahsil text COLLATE pg_catalog."default" NOT NULL,
    village text COLLATE pg_catalog."default" NOT NULL,
    census_code text COLLATE pg_catalog."default",
    st2 text COLLATE pg_catalog."default",
    ac_code1 integer,
    ac_name1 text COLLATE pg_catalog."default",
    st1 text COLLATE pg_catalog."default",
    ac_code integer,
    ac_name text COLLATE pg_catalog."default"
);

\copy vil_ac from 'villages-to-ac.csv' DELIMITER ',' CSV HEADER;


CREATE OR REPLACE VIEW public.ge_1998_res
 AS
 WITH foo AS (
         SELECT DISTINCT ON (ge_1998_cand_wise.state, ge_1998_cand_wise.state_code, ge_1998_cand_wise.pc_name, ge_1998_cand_wise.pc_code) ge_1998_cand_wise.state,
            ge_1998_cand_wise.state_code,
            ge_1998_cand_wise.pc_name,
            ge_1998_cand_wise.pc_code,
            ge_1998_cand_wise.cand,
            ge_1998_cand_wise.party,
            ge_1998_cand_wise.votes,
            ge_1998_cand_wise.pc_type
           FROM ge_1998_cand_wise
          ORDER BY ge_1998_cand_wise.state, ge_1998_cand_wise.state_code, ge_1998_cand_wise.pc_name, ge_1998_cand_wise.pc_code, ge_1998_cand_wise.votes DESC
        ), foo2 AS (
         SELECT DISTINCT ON (bar.state, bar.state_code, bar.pc_name, bar.pc_code) bar.state,
            bar.state_code,
            bar.pc_name,
            bar.pc_code,
            bar.cand,
            bar.party,
            bar.votes,
            bar.pc_type
           FROM ( SELECT ge_1998_cand_wise.state,
                    ge_1998_cand_wise.state_code,
                    ge_1998_cand_wise.pc_name,
                    ge_1998_cand_wise.pc_code,
                    ge_1998_cand_wise.cand,
                    ge_1998_cand_wise.party,
                    ge_1998_cand_wise.votes,
                    ge_1998_cand_wise.pc_type
                   FROM ge_1998_cand_wise
                EXCEPT
                 SELECT foo_1.state,
                    foo_1.state_code,
                    foo_1.pc_name,
                    foo_1.pc_code,
                    foo_1.cand,
                    foo_1.party,
                    foo_1.votes,
                    foo_1.pc_type
                   FROM foo foo_1) bar
          ORDER BY bar.state, bar.state_code, bar.pc_name, bar.pc_code, bar.votes DESC
        )
 SELECT foo.state,
    foo.state_code,
    foo.pc_name,
    foo.pc_code,
    foo.cand AS lead_cand,
    foo2.cand AS trail_cand,
    foo.party AS lead_party,
    foo2.party AS trail_party,
    abs(foo.votes - foo2.votes) AS margin,
    foo.pc_type
   FROM foo2
     JOIN foo ON foo.state_code = foo2.state_code AND foo.pc_code = foo2.pc_code;


CREATE OR REPLACE VIEW public.ge_1999_res
 AS
 WITH foo AS (
         SELECT DISTINCT ON (ge_1999_cand_wise.state, ge_1999_cand_wise.state_code, ge_1999_cand_wise.pc_name, ge_1999_cand_wise.pc_code) ge_1999_cand_wise.state,
            ge_1999_cand_wise.state_code,
            ge_1999_cand_wise.pc_name,
            ge_1999_cand_wise.pc_code,
            ge_1999_cand_wise.cand,
            ge_1999_cand_wise.party,
            ge_1999_cand_wise.votes,
            ge_1999_cand_wise.pc_type
           FROM ge_1999_cand_wise
          ORDER BY ge_1999_cand_wise.state, ge_1999_cand_wise.state_code, ge_1999_cand_wise.pc_name, ge_1999_cand_wise.pc_code, ge_1999_cand_wise.votes DESC
        ), foo2 AS (
         SELECT DISTINCT ON (bar.state, bar.state_code, bar.pc_name, bar.pc_code) bar.state,
            bar.state_code,
            bar.pc_name,
            bar.pc_code,
            bar.cand,
            bar.party,
            bar.votes,
            bar.pc_type
           FROM ( SELECT ge_1999_cand_wise.state,
                    ge_1999_cand_wise.state_code,
                    ge_1999_cand_wise.pc_name,
                    ge_1999_cand_wise.pc_code,
                    ge_1999_cand_wise.cand,
                    ge_1999_cand_wise.party,
                    ge_1999_cand_wise.votes,
                    ge_1999_cand_wise.pc_type
                   FROM ge_1999_cand_wise
                EXCEPT
                 SELECT foo_1.state,
                    foo_1.state_code,
                    foo_1.pc_name,
                    foo_1.pc_code,
                    foo_1.cand,
                    foo_1.party,
                    foo_1.votes,
                    foo_1.pc_type
                   FROM foo foo_1) bar
          ORDER BY bar.state, bar.state_code, bar.pc_name, bar.pc_code, bar.votes DESC
        )
 SELECT foo.state,
    foo.state_code,
    foo.pc_name,
    foo.pc_code,
    foo.cand AS lead_cand,
    foo2.cand AS trail_cand,
    foo.party AS lead_party,
    foo2.party AS trail_party,
    abs(foo.votes - foo2.votes) AS margin,
    foo.pc_type
   FROM foo2
     JOIN foo ON foo.state_code = foo2.state_code AND foo.pc_code = foo2.pc_code;



CREATE OR REPLACE VIEW public.ge_2004_res
 AS
 WITH foo AS (
         SELECT DISTINCT ON (ge_2004_cand_wise.state, ge_2004_cand_wise.state_code, ge_2004_cand_wise.pc_name, ge_2004_cand_wise.pc_code) ge_2004_cand_wise.state,
            ge_2004_cand_wise.state_code,
            ge_2004_cand_wise.pc_name,
            ge_2004_cand_wise.pc_code,
            ge_2004_cand_wise.cand,
            ge_2004_cand_wise.party,
            ge_2004_cand_wise.votes,
            ge_2004_cand_wise.pc_type
           FROM ge_2004_cand_wise
          ORDER BY ge_2004_cand_wise.state, ge_2004_cand_wise.state_code, ge_2004_cand_wise.pc_name, ge_2004_cand_wise.pc_code, ge_2004_cand_wise.votes DESC
        ), foo2 AS (
         SELECT DISTINCT ON (bar.state, bar.state_code, bar.pc_name, bar.pc_code) bar.state,
            bar.state_code,
            bar.pc_name,
            bar.pc_code,
            bar.cand,
            bar.party,
            bar.votes,
            bar.pc_type
           FROM ( SELECT ge_2004_cand_wise.state,
                    ge_2004_cand_wise.state_code,
                    ge_2004_cand_wise.pc_name,
                    ge_2004_cand_wise.pc_code,
                    ge_2004_cand_wise.cand,
                    ge_2004_cand_wise.party,
                    ge_2004_cand_wise.votes,
                    ge_2004_cand_wise.pc_type
                   FROM ge_2004_cand_wise
                EXCEPT
                 SELECT foo_1.state,
                    foo_1.state_code,
                    foo_1.pc_name,
                    foo_1.pc_code,
                    foo_1.cand,
                    foo_1.party,
                    foo_1.votes,
                    foo_1.pc_type
                   FROM foo foo_1) bar
          ORDER BY bar.state, bar.state_code, bar.pc_name, bar.pc_code, bar.votes DESC
        )
 SELECT foo.state,
    foo.state_code,
    foo.pc_name,
    foo.pc_code,
    foo.cand AS lead_cand,
    foo2.cand AS trail_cand,
    foo.party AS lead_party,
    foo2.party AS trail_party,
    abs(foo.votes - foo2.votes) AS margin,
    foo.pc_type
   FROM foo2
     JOIN foo ON foo.state_code = foo2.state_code AND foo.pc_code = foo2.pc_code;


CREATE OR REPLACE VIEW public.ge_2009_res
 AS
 WITH foo AS (
         SELECT DISTINCT ON (ge_2009_cand_wise.state, ge_2009_cand_wise.state_code, ge_2009_cand_wise.pc_name, ge_2009_cand_wise.pc_code) ge_2009_cand_wise.state,
            ge_2009_cand_wise.state_code,
            ge_2009_cand_wise.pc_name,
            ge_2009_cand_wise.pc_code,
            ge_2009_cand_wise.cand,
            ge_2009_cand_wise.party,
            ge_2009_cand_wise.votes,
            ge_2009_cand_wise.pc_type
           FROM ge_2009_cand_wise
          ORDER BY ge_2009_cand_wise.state, ge_2009_cand_wise.state_code, ge_2009_cand_wise.pc_name, ge_2009_cand_wise.pc_code, ge_2009_cand_wise.votes DESC
        ), foo2 AS (
         SELECT DISTINCT ON (bar.state, bar.state_code, bar.pc_name, bar.pc_code) bar.state,
            bar.state_code,
            bar.pc_name,
            bar.pc_code,
            bar.cand,
            bar.party,
            bar.votes,
            bar.pc_type
           FROM ( SELECT ge_2009_cand_wise.state,
                    ge_2009_cand_wise.state_code,
                    ge_2009_cand_wise.pc_name,
                    ge_2009_cand_wise.pc_code,
                    ge_2009_cand_wise.cand,
                    ge_2009_cand_wise.party,
                    ge_2009_cand_wise.votes,
                    ge_2009_cand_wise.pc_type
                   FROM ge_2009_cand_wise
                EXCEPT
                 SELECT foo_1.state,
                    foo_1.state_code,
                    foo_1.pc_name,
                    foo_1.pc_code,
                    foo_1.cand,
                    foo_1.party,
                    foo_1.votes,
                    foo_1.pc_type
                   FROM foo foo_1) bar
          ORDER BY bar.state, bar.state_code, bar.pc_name, bar.pc_code, bar.votes DESC
        )
 SELECT foo.state,
    foo.state_code,
    foo.pc_name,
    foo.pc_code,
    foo.cand AS lead_cand,
    foo2.cand AS trail_cand,
    foo.party AS lead_party,
    foo2.party AS trail_party,
    abs(foo.votes - foo2.votes) AS margin,
    foo.pc_type
   FROM foo2
     JOIN foo ON foo.state_code = foo2.state_code AND foo.pc_code = foo2.pc_code;


CREATE OR REPLACE VIEW public.ge_2014_res
 AS
 WITH foo AS (
         SELECT DISTINCT ON (ge_2014_cand_wise.state, ge_2014_cand_wise.state_code, ge_2014_cand_wise.pc_name, ge_2014_cand_wise.pc_code) ge_2014_cand_wise.state,
            ge_2014_cand_wise.state_code,
            ge_2014_cand_wise.pc_name,
            ge_2014_cand_wise.pc_code,
            ge_2014_cand_wise.cand,
            ge_2014_cand_wise.party,
            ge_2014_cand_wise.votes
           FROM ge_2014_cand_wise
          ORDER BY ge_2014_cand_wise.state, ge_2014_cand_wise.state_code, ge_2014_cand_wise.pc_name, ge_2014_cand_wise.pc_code, ge_2014_cand_wise.votes DESC
        ), foo2 AS (
         SELECT DISTINCT ON (bar.state, bar.state_code, bar.pc_name, bar.pc_code) bar.state,
            bar.state_code,
            bar.pc_name,
            bar.pc_code,
            bar.cand,
            bar.party,
            bar.votes
           FROM ( SELECT ge_2014_cand_wise.state,
                    ge_2014_cand_wise.state_code,
                    ge_2014_cand_wise.pc_name,
                    ge_2014_cand_wise.pc_code,
                    ge_2014_cand_wise.cand,
                    ge_2014_cand_wise.party,
                    ge_2014_cand_wise.votes
                   FROM ge_2014_cand_wise
                EXCEPT
                 SELECT foo_1.state,
                    foo_1.state_code,
                    foo_1.pc_name,
                    foo_1.pc_code,
                    foo_1.cand,
                    foo_1.party,
                    foo_1.votes
                   FROM foo foo_1) bar
          ORDER BY bar.state, bar.state_code, bar.pc_name, bar.pc_code, bar.votes DESC
        )
 SELECT foo.state,
    foo.state_code,
    foo.pc_name,
    foo.pc_code,
    foo.cand AS lead_cand,
    foo2.cand AS trail_cand,
    foo.party AS lead_party,
    foo2.party AS trail_party,
    abs(foo.votes - foo2.votes) AS margin
   FROM foo2
     JOIN foo ON foo.state_code::text = foo2.state_code::text AND foo.pc_code = foo2.pc_code;

create table ge_2019_cand_wise (state text, pc_name text, pc_code int, cand text, party text, votes int);

\copy ge_2019_cand_wise from 'GE_2019_cand_wise.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.users
(    
    name text,
    email text ,
    password text,
    state text,
    pc_name text,
    CONSTRAINT users_key PRIMARY KEY (email)
);

begin;
create or replace function notifier()
  returns trigger
  language plpgsql
as $$
declare
 channel text := TG_ARGV[0];
begin
  PERFORM(
    with payload(cand,party,votes,state,pc_name,state_code,pc_code) as
    (
      select NEW.cand,NEW.party,NEW.votes,NEW.state,NEW.pc_name,NEW.state_code,NEW.pc_code
    )
    select pg_notify(channel,row_to_json(payload)::text)
         from payload
  );
  RETURN NULL;
end;
$$;


CREATE TRIGGER notify
  AFTER INSERT OR UPDATE OR DELETE ON ge_2019_cand_wise
  FOR EACH ROW
   EXECUTE PROCEDURE notifier('election_updates');

commit;
-- test for trigger
insert into ge_2019_cand_wise(cand,party,votes,state,pc_name, pc_code) values('GODAM NAGESH','Telangana Rashtra Samithi',430847,'NCT OF Delhi','SOUTH DELHI',7)
insert into ge_2019_cand_wise(cand,party,votes,state,pc_name, pc_code) values('Kshitij Gupta','INC',4847,'Uttar Pradesh','allahabad',8)