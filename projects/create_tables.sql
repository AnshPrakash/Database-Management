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