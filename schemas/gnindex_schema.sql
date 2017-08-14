--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cross_maps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cross_maps (
    data_source_id integer NOT NULL,
    name_string_id uuid NOT NULL,
    cm_local_id character varying(50) NOT NULL,
    cm_data_source_id integer NOT NULL,
    taxon_id character varying(255) NOT NULL
);


ALTER TABLE cross_maps OWNER TO postgres;

--
-- Name: data_sources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE data_sources (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    logo_url character varying(255),
    web_site_url character varying(255),
    data_url character varying(255),
    refresh_period_days integer DEFAULT 14,
    name_strings_count integer DEFAULT 0,
    data_hash character varying(40),
    unique_names_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE data_sources OWNER TO postgres;

--
-- Name: data_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE data_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE data_sources_id_seq OWNER TO postgres;

--
-- Name: data_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE data_sources_id_seq OWNED BY data_sources.id;


--
-- Name: name_string_indices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE name_string_indices (
    data_source_id integer NOT NULL,
    name_string_id uuid NOT NULL,
    url character varying(255),
    taxon_id character varying(255) NOT NULL,
    global_id character varying(255),
    local_id character varying(255),
    nomenclatural_code_id integer,
    rank character varying(255),
    accepted_taxon_id character varying(255),
    classification_path text,
    classification_path_ids text,
    classification_path_ranks text,
    accepted_name_uuid uuid,
    accepted_name character varying(255)
);


ALTER TABLE name_string_indices OWNER TO postgres;

--
-- Name: name_strings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE name_strings (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    canonical_uuid uuid,
    canonical character varying(255),
    surrogate boolean
);


ALTER TABLE name_strings OWNER TO postgres;

--
-- Name: name_strings__author_words; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE name_strings__author_words (
    author_word character varying(100) NOT NULL,
    name_uuid uuid NOT NULL
);


ALTER TABLE name_strings__author_words OWNER TO postgres;

--
-- Name: name_strings__genus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE name_strings__genus (
    genus character varying(50) NOT NULL,
    name_uuid uuid NOT NULL
);


ALTER TABLE name_strings__genus OWNER TO postgres;

--
-- Name: name_strings__species; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE name_strings__species (
    species character varying(50) NOT NULL,
    name_uuid uuid NOT NULL
);


ALTER TABLE name_strings__species OWNER TO postgres;

--
-- Name: name_strings__subspecies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE name_strings__subspecies (
    subspecies character varying(50) NOT NULL,
    name_uuid uuid NOT NULL
);


ALTER TABLE name_strings__subspecies OWNER TO postgres;

--
-- Name: name_strings__uninomial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE name_strings__uninomial (
    uninomial character varying(50) NOT NULL,
    name_uuid uuid NOT NULL
);


ALTER TABLE name_strings__uninomial OWNER TO postgres;

--
-- Name: name_strings__year; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE name_strings__year (
    year character varying(8) NOT NULL,
    name_uuid uuid NOT NULL
);


ALTER TABLE name_strings__year OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO postgres;

--
-- Name: vernacular_string_indices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE vernacular_string_indices (
    data_source_id integer NOT NULL,
    taxon_id character varying(255) NOT NULL,
    vernacular_string_id uuid NOT NULL,
    language character varying(255),
    locality character varying(255),
    country_code character varying(255)
);


ALTER TABLE vernacular_string_indices OWNER TO postgres;

--
-- Name: vernacular_strings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE vernacular_strings (
    id uuid NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE vernacular_strings OWNER TO postgres;

--
-- Name: data_sources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY data_sources ALTER COLUMN id SET DEFAULT nextval('data_sources_id_seq'::regclass);


--
-- Name: data_sources data_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY data_sources
    ADD CONSTRAINT data_sources_pkey PRIMARY KEY (id);


--
-- Name: name_strings name_strings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY name_strings
    ADD CONSTRAINT name_strings_pkey PRIMARY KEY (id);


--
-- Name: vernacular_strings vernacular_strings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vernacular_strings
    ADD CONSTRAINT vernacular_strings_pkey PRIMARY KEY (id);


--
-- Name: canonical_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX canonical_name_index ON name_strings USING btree (canonical text_pattern_ops);


--
-- Name: index__cmdsid_clid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index__cmdsid_clid ON cross_maps USING btree (cm_data_source_id, cm_local_id);


--
-- Name: index__dsid_tid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index__dsid_tid ON vernacular_string_indices USING btree (data_source_id, taxon_id);


--
-- Name: index__nsid_dsid_tid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index__nsid_dsid_tid ON cross_maps USING btree (data_source_id, name_string_id, taxon_id);


--
-- Name: index__vsid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index__vsid ON vernacular_string_indices USING btree (vernacular_string_id);


--
-- Name: index_name_string_indices_on_data_source_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_string_indices_on_data_source_id ON name_string_indices USING btree (data_source_id);


--
-- Name: index_name_string_indices_on_name_string_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_string_indices_on_name_string_id ON name_string_indices USING btree (name_string_id);


--
-- Name: index_name_strings__author_words_on_author_word; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_strings__author_words_on_author_word ON name_strings__author_words USING btree (author_word);


--
-- Name: index_name_strings__genus_on_genus; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_strings__genus_on_genus ON name_strings__genus USING btree (genus);


--
-- Name: index_name_strings__species_on_species; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_strings__species_on_species ON name_strings__species USING btree (species);


--
-- Name: index_name_strings__subspecies_on_subspecies; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_strings__subspecies_on_subspecies ON name_strings__subspecies USING btree (subspecies);


--
-- Name: index_name_strings__uninomial_on_uninomial; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_strings__uninomial_on_uninomial ON name_strings__uninomial USING btree (uninomial);


--
-- Name: index_name_strings__year_on_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_strings__year_on_year ON name_strings__year USING btree (year);


--
-- Name: index_name_strings_on_canonical_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_name_strings_on_canonical_uuid ON name_strings USING btree (canonical_uuid);


--
-- Name: name_string_indices__datasource_taxonid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX name_string_indices__datasource_taxonid ON name_string_indices USING btree (data_source_id, taxon_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

