--
-- PostgreSQL database dump
--

\restrict BjzbQhASedlO775npkZf9y7UbJsdrXcjqxwb3XU3nS2gowFFLJbXAFBijF8wjFT

-- Dumped from database version 17.7 (bdd1736)
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.vehicles DROP CONSTRAINT IF EXISTS vehicles_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS "users_vehicleId_fkey";
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS "users_companyId_fkey";
ALTER TABLE IF EXISTS ONLY public.stops DROP CONSTRAINT IF EXISTS stops_end_client_id_fkey;
ALTER TABLE IF EXISTS ONLY public.stops DROP CONSTRAINT IF EXISTS stops_delivery_id_fkey;
ALTER TABLE IF EXISTS ONLY public.stops DROP CONSTRAINT IF EXISTS stops_address_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_requests DROP CONSTRAINT IF EXISTS delivery_requests_delivery_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_requests DROP CONSTRAINT IF EXISTS delivery_requests_client_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_request_stops DROP CONSTRAINT IF EXISTS delivery_request_stops_request_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_request_stops DROP CONSTRAINT IF EXISTS delivery_request_stops_end_client_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_request_stops DROP CONSTRAINT IF EXISTS delivery_request_stops_delivery_stop_id_fkey;
ALTER TABLE IF EXISTS ONLY public.delivery_request_stops DROP CONSTRAINT IF EXISTS delivery_request_stops_address_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_vehicle_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_driver_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_delivery_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_parent_id_fkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_address_id_fkey;
ALTER TABLE IF EXISTS ONLY public.client_settings DROP CONSTRAINT IF EXISTS client_settings_client_company_id_fkey;
DROP INDEX IF EXISTS public.vehicles_plate_key;
DROP INDEX IF EXISTS public.vehicles_company_id_idx;
DROP INDEX IF EXISTS public.users_external_id_key;
DROP INDEX IF EXISTS public.users_email_key;
DROP INDEX IF EXISTS public."users_companyId_vehicleId_idx";
DROP INDEX IF EXISTS public.stops_status_end_client_id_idx;
DROP INDEX IF EXISTS public.stops_delivery_id_sequence_idx;
DROP INDEX IF EXISTS public.delivery_requests_delivery_company_id_date_idx;
DROP INDEX IF EXISTS public.delivery_requests_client_company_id_date_key;
DROP INDEX IF EXISTS public.delivery_request_stops_request_id_sequence_idx;
DROP INDEX IF EXISTS public.delivery_request_stops_end_client_id_idx;
DROP INDEX IF EXISTS public.delivery_request_stops_delivery_stop_id_key;
DROP INDEX IF EXISTS public.delivery_request_stops_delivery_stop_id_idx;
DROP INDEX IF EXISTS public.deliveries_number_key;
DROP INDEX IF EXISTS public.deliveries_driver_id_vehicle_id_idx;
DROP INDEX IF EXISTS public.deliveries_delivery_company_id_date_idx;
DROP INDEX IF EXISTS public.deliveries_date_delivery_status_idx;
DROP INDEX IF EXISTS public.companies_type_parent_id_idx;
DROP INDEX IF EXISTS public.client_settings_client_company_id_key;
DROP INDEX IF EXISTS public.addresses_latitude_longitude_idx;
DROP INDEX IF EXISTS public."addresses_city_state_postalCode_idx";
ALTER TABLE IF EXISTS ONLY public.vehicles DROP CONSTRAINT IF EXISTS vehicles_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.stops DROP CONSTRAINT IF EXISTS stops_pkey;
ALTER TABLE IF EXISTS ONLY public.delivery_requests DROP CONSTRAINT IF EXISTS delivery_requests_pkey;
ALTER TABLE IF EXISTS ONLY public.delivery_request_stops DROP CONSTRAINT IF EXISTS delivery_request_stops_pkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_pkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_pkey;
ALTER TABLE IF EXISTS ONLY public.client_settings DROP CONSTRAINT IF EXISTS client_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.addresses DROP CONSTRAINT IF EXISTS addresses_pkey;
ALTER TABLE IF EXISTS ONLY public._prisma_migrations DROP CONSTRAINT IF EXISTS _prisma_migrations_pkey;
DROP TABLE IF EXISTS public.vehicles;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.stops;
DROP TABLE IF EXISTS public.delivery_requests;
DROP TABLE IF EXISTS public.delivery_request_stops;
DROP TABLE IF EXISTS public.deliveries;
DROP TABLE IF EXISTS public.companies;
DROP TABLE IF EXISTS public.client_settings;
DROP TABLE IF EXISTS public.addresses;
DROP TABLE IF EXISTS public._prisma_migrations;
DROP TYPE IF EXISTS public.user_roles;
DROP TYPE IF EXISTS public.stop_statuses;
DROP TYPE IF EXISTS public.step_type;
DROP TYPE IF EXISTS public.delivery_statuses;
DROP TYPE IF EXISTS public.company_types;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: company_types; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.company_types AS ENUM (
    'delivery',
    'client',
    'end_client'
);


--
-- Name: delivery_statuses; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.delivery_statuses AS ENUM (
    'scheduled',
    'in_progress',
    'completed',
    'cancelled'
);


--
-- Name: step_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.step_type AS ENUM (
    'pickup',
    'dropoff',
    'both'
);


--
-- Name: stop_statuses; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.stop_statuses AS ENUM (
    'planned',
    'en_route',
    'delivered',
    'failed'
);


--
-- Name: user_roles; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_roles AS ENUM (
    'admin',
    'manager',
    'member'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id text NOT NULL,
    "externalId" text,
    address text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    "postalCode" text NOT NULL,
    country text NOT NULL,
    "formattedAddress" text NOT NULL,
    latitude double precision,
    longitude double precision,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: client_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_settings (
    id text NOT NULL,
    client_company_id text NOT NULL,
    cutoff_time text,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id text NOT NULL,
    name text NOT NULL,
    type public.company_types NOT NULL,
    address_id text NOT NULL,
    parent_id text,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    default_stop_type public.step_type
);


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deliveries (
    id text NOT NULL,
    number text NOT NULL,
    date timestamp(6) with time zone NOT NULL,
    notes text,
    driver_name text,
    vehicle_license_plate text,
    driver_notes text,
    delivery_status public.delivery_statuses DEFAULT 'scheduled'::public.delivery_statuses NOT NULL,
    scheduled_at timestamp(6) with time zone,
    started_at timestamp(6) with time zone,
    finished_at timestamp(6) with time zone,
    delivery_company_id text NOT NULL,
    driver_id text,
    vehicle_id text,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: delivery_request_stops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_request_stops (
    id text NOT NULL,
    sequence integer NOT NULL,
    type public.step_type NOT NULL,
    notes text,
    request_id text NOT NULL,
    address_id text NOT NULL,
    end_client_id text NOT NULL,
    delivery_stop_id text,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: delivery_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delivery_requests (
    id text NOT NULL,
    date timestamp(6) with time zone NOT NULL,
    notes text,
    client_company_id text NOT NULL,
    delivery_company_id text NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: stops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stops (
    id text NOT NULL,
    sequence integer NOT NULL,
    type public.step_type DEFAULT 'dropoff'::public.step_type NOT NULL,
    status public.stop_statuses DEFAULT 'planned'::public.stop_statuses NOT NULL,
    notes text,
    driver_notes text,
    completed_at timestamp(6) with time zone,
    image_url text,
    delivery_id text NOT NULL,
    address_id text NOT NULL,
    end_client_id text NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    email text NOT NULL,
    external_id text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    role public.user_roles NOT NULL,
    "companyId" text NOT NULL,
    "vehicleId" text,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vehicles (
    id text NOT NULL,
    plate text NOT NULL,
    model text,
    company_id text NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
1ae4c7e6-7fcc-45b6-98c8-94b46bfc9b57	cd40a00194513e37bb86bc337a6c1a0500605c2881ad7a367948be139feb1933	2026-01-20 13:20:52.870648+00	20250926131818_baseline	\N	\N	2026-01-20 13:20:52.657232+00	1
27db6ed4-7c6b-4260-9129-24c412321db2	5c7a29800e1b3c77485e7e32a0a0f56a6c6a0300d791cc2bfe7454b0bb0a1f1b	2026-01-20 13:20:53.205265+00	20251027192057_add_driver_relation_to_batches	\N	\N	2026-01-20 13:20:53.021719+00	1
a50f64c0-0780-4159-abfe-4ca87ca1d224	84ff69c6f305c2edf6506d09fd6b9ebf7b0960c09f30c6f891dcf58a14f1be44	2026-01-20 13:20:53.613657+00	20260109200257_remove_batches	\N	\N	2026-01-20 13:20:53.354709+00	1
30a06516-190d-4716-8654-bb1b91555ea5	447ed1a1378aa679938b49d98c95996d9bb3e084445e5f73ec1e65323369e17b	2026-01-20 13:20:53.885179+00	20260113112829_add_delivery_request_system	\N	\N	2026-01-20 13:20:53.680852+00	1
25838890-47d6-4821-ba3c-4eeb92af0eeb	00ad8f2ca84fb52cd846272edd6e1efa1eb25e01ea8f89d7c51ca94d00b0c3c2	2026-01-22 10:13:51.031501+00	20260122094808_remove_client_company_from_delivery	\N	\N	2026-01-22 10:13:50.539849+00	1
f079a538-88c8-417c-8b4d-ae3ab936f126	f43c0e3868aa15b6cca0c2f33c0bd5cca426633921de16d00dc39ebdadf1850d	2026-01-23 16:19:17.670051+00	20260123081306_make_address_coordinates_optional	\N	\N	2026-01-23 16:19:17.187185+00	1
cd515451-f0bf-4a0d-abde-ac011303c02c	4257655ea0b2c0c6658db080b764aafc36a903831273acf2957bca58003af32a	2026-01-26 19:08:52.78358+00	20260123195035_add_default_stop_type_to_companies	\N	\N	2026-01-26 19:08:52.289765+00	1
\.


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.addresses (id, "externalId", address, city, state, "postalCode", country, "formattedAddress", latitude, longitude, created_at, updated_at) FROM stdin;
cmkmmu5h20004pg0bq4c9z7xj	dXJuOm1ieGFkcjozOWQ4YTg2Yi0wZDViLTQ2MzYtOWExNi03OTYzMGZiOTE2NDU	57 Rue Du Dauphiné	Saint-Priest	Rhône	69800	France	57 Rue Du Dauphiné, 69800 Saint-Priest, France	45.713372	4.917427	2026-01-22 08:19:13.166326+00	2026-01-22 08:19:13.166326+00
cmkpinfve0001l204p27o7e8m	dXJuOm1ieGFkcjpjY2Y1NDBjNy02YzM5LTQ1MWEtYjk4MS00ZjM0NDhhMzI2ZWE	52 Impasse Le Platet	Trévignin	Savoie	73100	France	52 Impasse Le Platet, 73100 Trévignin, France	45.699365	5.966245	2026-01-22 13:57:17.979+00	2026-01-22 13:57:17.979+00
cmkpj4hd90005la047z4tult2	dXJuOm1ieGFkcjphYzUzYTNiOS0wZWU5LTQxNzgtOGQ1Ni02MjQ3MzliNGJiZjM	31 Avenue Jean Jaurès	Eybens	Isère	38320	France	31 Avenue Jean Jaurès, 38320 Eybens, France	45.161529	5.744469	2026-01-22 14:10:33.069+00	2026-01-22 14:10:33.069+00
cmkpj6bpv000bl204nyi9pebq	dXJuOm1ieGFkcjpiYTVlMGQwMi1hMDk2LTRjYzctOGNhYi0wZjEwMzc2YTAxNGI	2 Avenue Henri Zanaroli	Annecy	Haute-Savoie	74600	France	2 Avenue Henri Zanaroli, 74600 Annecy, France	45.893759	6.113389	2026-01-22 14:11:59.06+00	2026-01-22 14:11:59.06+00
cmkpj6xk70007la04i7dw2nih	dXJuOm1ieGFkcjpiYTVlMGQwMi1hMDk2LTRjYzctOGNhYi0wZjEwMzc2YTAxNGI	2 Avenue Henri Zanaroli	Annecy	Haute-Savoie	74600	France	2 Avenue Henri Zanaroli, 74600 Annecy, France	45.893759	6.113389	2026-01-22 14:12:27.367+00	2026-01-22 14:12:27.367+00
cmkpj8hrx0005ky04h0vkyie1	dXJuOm1ieGFkcjoxODUzZTcxOC05ZDJiLTQyZDQtODBhMC02YzRmNGY2YjRjMmI	70 Impasse De La Prairie	Sillingy	Haute-Savoie	74330	France	70 Impasse De La Prairie, 74330 Sillingy, France	45.942958	6.071554	2026-01-22 14:13:40.221+00	2026-01-22 14:13:40.221+00
cmkpj9j27000dl2047t182oly	dXJuOm1ieGFkcjplYWI5M2YxNS1jYjNjLTQ3NWQtOTc1NC02YjAyMTgyOWJkNmI	83 Impasse De La Fruitière	Allonzier-la-Caille	Haute-Savoie	74350	France	83 Impasse De La Fruitière, 74350 Allonzier-la-Caille, France	45.994043	6.122266	2026-01-22 14:14:28.543+00	2026-01-22 14:14:28.543+00
cmkpjbb9m000hl204e6qffcd9	dXJuOm1ieGFkcjo4ZDBlN2Q4My1mNDU1LTQ3NzYtYjg0MC05N2NiZmM1NDNmZDM	18 Rue Du Docteur André Chaix	Bourgoin-Jallieu	Isère	38300	France	18 Rue Du Docteur André Chaix, 38300 Bourgoin-Jallieu, France	45.585505	5.281528	2026-01-22 14:15:51.754+00	2026-01-22 14:15:51.754+00
cmkpoh8qx0003jo04vyxiampd	dXJuOm1ieGFkcjo4MTYxYWJhNi0xM2RmLTQ3MWUtYjljNC1hMThjN2E1ZmVlNWU	10 Square Aristide Briand	Thonon-les-Bains	Haute-Savoie	74200	France	10 Square Aristide Briand, 74200 Thonon-les-Bains, France	46.371988	6.4783	2026-01-22 16:40:26.505+00	2026-01-22 16:40:26.505+00
cmkwlqmys0001l704a4ay2d1c	\N	520 rue du Clapet	La Ravoire	Savoie	73490	France	520 rue du Clapet, 73490 La Ravoire, France	\N	\N	2026-01-27 12:58:09.22+00	2026-01-27 12:58:09.22+00
cmkp6quuj0001l404pur8bk1u	dXJuOm1ieGFkcjo3YWZiNGU2MC05Y2MyLTRmYTQtYWJhZC1iYmQ0OTgwMjgxOTc	5 Avenue De La Mandallaz	Annecy	Haute-Savoie	74000	France	5 Avenue De La Mandallaz, 74000 Annecy, France	45.898877	6.115873	2026-01-22 08:24:01.963+00	2026-01-22 08:24:01.963+00
cmkp6u19w0001lb04tm8w3b06	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNtOTFkR2x1WnlJNkluUnlkV1VpTENKMGVYQmxjeUk2SW1Ga1pISmxjM01zWVdSa2NtVnpjeXhqYjNWdWRISjVMSEpsWjJsdmJpeHdiM04wWTI5a1pTeGthWE4wY21samRDeHdiR0ZqWlN4c2IyTmhiR2wwZVN4dVpXbG5hR0p2Y21odmIyUWlMQ0psZUhCdmMyVlFjbTl0YVc1bGJtTmxJam9pZEhKMVpTSXNJblpsY25OcGIyNGlPalVzSW1OaGJHeGlZV05ySWpwdWRXeHNMQ0p4SWpvaU1UYzNJR0YyWlc1MVpTQmtaWE1nYldGemMyVjBkR1Z6SW4wOjA	177 Avenue Des Massettes	Challes-les-Eaux	Savoie	73190	France	177 Avenue Des Massettes, 73190 Challes-les-Eaux, France	45.545499	5.97083	2026-01-22 08:26:30.26+00	2026-01-22 08:26:30.26+00
cmkpishbz0001la04hst3y6dy	dXJuOm1ieGFkcjo3YWZiNGU2MC05Y2MyLTRmYTQtYWJhZC1iYmQ0OTgwMjgxOTc	5 Avenue De La Mandallaz	Annecy	Haute-Savoie	74000	France	5 Avenue De La Mandallaz, 74000 Annecy, France	45.898877	6.115873	2026-01-22 14:01:13.151+00	2026-01-22 14:01:13.151+00
cmkpiu83z0003l204nbpocbby	dXJuOm1ieGFkcjphMDIxNWVhZC1hNWRmLTRlZmUtOWFhZS0wYWVlZjRlYTJmMzg	384 Chemin Des Longs Prés	Lumbin	Isère	38660	France	384 Chemin Des Longs Prés, 38660 Lumbin, France	45.302411	5.908959	2026-01-22 14:02:34.511+00	2026-01-22 14:02:34.511+00
cmkpivrp40001ky04euyawq6a	dXJuOm1ieGFkcjpkNzhmMWNhMy1mMjBkLTRjOWEtOTYyMC0yNmFmOTA3NWU5N2I	23 Rue Génissieu	Grenoble	Isère	38000	France	23 Rue Génissieu, 38000 Grenoble, France	45.186752	5.721308	2026-01-22 14:03:46.552+00	2026-01-22 14:03:46.552+00
cmkpj1yxb0005l204plmjjpk7	dXJuOm1ieGFkcjoxODc5NzA1OC0wNjQyLTQ0ZGUtOTE4NC00OTdjZTUxNTJhNWY	145 Route De Millery	Montagny	Rhône	69700	France	145 Route De Millery, 69700 Montagny, France	45.629611	4.759632	2026-01-22 14:08:35.855+00	2026-01-22 14:08:35.855+00
cmkpj2wnw0003la04whkmizgt	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNtOTFkR2x1WnlJNkluUnlkV1VpTENKMGVYQmxjeUk2SW1Ga1pISmxjM01zWVdSa2NtVnpjeXhqYjNWdWRISjVMSEpsWjJsdmJpeHdiM04wWTI5a1pTeGthWE4wY21samRDeHdiR0ZqWlN4c2IyTmhiR2wwZVN4dVpXbG5hR0p2Y21odmIyUWlMQ0psZUhCdmMyVlFjbTl0YVc1bGJtTmxJam9pZEhKMVpTSXNJblpsY25OcGIyNGlPalVzSW1OaGJHeGlZV05ySWpwdWRXeHNMQ0p4SWpvaU1URWdVblZsSUdSbElHeGhJRkJwWTJGeVpHbkRxSEpsTENCYWIyNWxJR1RpZ0psQlkzUnBjTU8wYkdVZ01ERXpNREFnVm1seWFXZHVhVzRpZlE6MA	11 Rue De La Folatière	Virignin	Ain	01300	France	11 Rue De La Folatière, 01300 Virignin, France	45.720981	5.709904	2026-01-22 14:09:19.58+00	2026-01-22 14:09:19.58+00
cmkpj3tux0001jr040xtzdu1r	dXJuOm1ieGFkcjowMWM1MzIwOS00Mzg1LTQ5ZTEtOTBjYi04MWU2OTQyZjQxZTQ	19 Boulevard De La Rocade	Annecy	Haute-Savoie	74000	France	19 Boulevard De La Rocade, 74000 Annecy, France	45.911106	6.119774	2026-01-22 14:10:02.601+00	2026-01-22 14:10:02.601+00
cmkpj53je0007l204v5sg9l9o	dXJuOm1ieGFkcjpmOWI4YTI5OS0wYTQ4LTRiM2EtYjBhNy1hZDBmZjVlNGM1MmI	4 Rue Vaucanson	Vienne	Isère	38200	France	4 Rue Vaucanson, 38200 Vienne, France	45.524962	4.873611	2026-01-22 14:11:01.802+00	2026-01-22 14:11:01.802+00
cmkpj5sm10009l204ky6cz3ha	dXJuOm1ieGFkcjo0YzE3NzU2OC04ZmRiLTQ2YjUtOGM3Mi1iZTkxYzA0NmJmNzM	1 Rue Vallon	Thonon-les-Bains	Haute-Savoie	74200	France	1 Rue Vallon, 74200 Thonon-les-Bains, France	46.371328	6.479034	2026-01-22 14:11:34.298+00	2026-01-22 14:11:34.298+00
cmkpj7uvs0009la040xj99bmt	dXJuOm1ieGFkcjo3MGRiZTYwMy03N2NlLTQ0Y2EtYWFkYS1hNDZkODJmOTMxMGY	14 Avenue Bouvard	Annecy	Haute-Savoie	74000	France	14 Avenue Bouvard, 74000 Annecy, France	45.903183	6.119981	2026-01-22 14:13:10.552+00	2026-01-22 14:13:10.552+00
cmkpja6ka000bla047z0mprir	dXJuOm1ieGFkcjo5ZGM4MGI0NS1jNjNhLTQ4NDYtYjNmZi01ZGJhNDhkYmQ2M2I	1e Allée Du Romarin	Mions	Rhône	69780	France	1e Allée Du Romarin, 69780 Mions, France	45.679838	4.949847	2026-01-22 14:14:59.003+00	2026-01-22 14:14:59.003+00
cmkpjarhv000fl204osybq92g	dXJuOm1ieGFkcjpjYmE4MWE3Zi1kMTk3LTQzODctYWFkZC0xMDc4NDFmYWMxOWY	295 Chemin Du Langot	Saint-Georges-d'Espéranche	Isère	38790	France	295 Chemin Du Langot, 38790 Saint-Georges-d'Espéranche, France	45.557725	5.125386	2026-01-22 14:15:26.132+00	2026-01-22 14:15:26.132+00
cmkpoipkw003fl404xhcwstv9	dXJuOm1ieGFkcjo0YjgwYjc2Mi02MzU1LTQ5NGItYjAxOS03ZGI0YjU0MjMzNzA	63 Avenue du Général de Gaulle	Saint-Égrève	Isère	38120	France	63 Avenue du Général de Gaulle, 38120 Saint-Égrève, France	45.23335	5.678029	2026-01-22 16:41:34.976+00	2026-01-22 16:41:34.976+00
cmkmmtnzb0001pg0beuabkn2y	dXJuOm1ieGFkcjphYjFhMmVkMC05MzhkLTQ5MjgtYWRkZS1lYTNkY2NiNDYyYmQ	168 Impasse De Lachat	Vimines	Savoie	73160	France	168 Impasse De Lachat, 73160 Vimines, France	45.555925	5.875215	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzb0003pg0bnwqqy4w8	dXJuOm1ieGFkci1zdHI6ZjBjYjUzZDctMTcyYi00YTAzLWExNjUtYTRiOTZjOGRhNGYx	520 Rue Du Clapet	La Ravoire	Savoie	73490	France	520 Rue Du Clapet, 73490 La Ravoire, France	45.556056	5.947237	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd002dpg0bvpq07r77	dXJuOm1ieGFkcjo0OTljMmVkMy0yZTNhLTRiZmUtODk3NS1iMmU3NGU2NzUxYmI	6 Avenue De Savoie	Montmélian	Savoie	73800	France	6 Avenue De Savoie, 73800 Montmélian, France	45.500713	6.049932	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd002bpg0bw3xjvfsb	dXJuOm1ieGFkcjo4OTUxMDgwYy02ZmQ5LTQzYWItYjk4Yi03NWZiZTYxMWZiYzM	23 Avenue Du 8 Mai 1945	Moûtiers	Savoie	73600	France	23 Avenue Du 8 Mai 1945, 73600 Moûtiers, France	45.485429	6.530886	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd0029pg0b9bkziymu	dXJuOm1ieGFkcjpjNDZjZWFhOC1hNTYwLTQ4YmEtYTNlMi00NTRhMDY1NzUwYzk	110 Avenue De La Gare	Pontcharra	Isère	38530	France	110 Avenue De La Gare, 38530 Pontcharra, France	45.432128	6.019905	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd0027pg0b87s1ex9x	dXJuOm1ieGFkcjo2OWRmN2ZlOS00ZGRjLTQyZjUtYTY4Ny1mYmFkYTliZmRlZDE	532 Chemin Des Noyers	Chapareillan	Isère	38530	France	532 Chemin Des Noyers, 38530 Chapareillan, France	45.469725	5.993364	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd0025pg0bbfp4loi1	1s0x478bb216865ca677	Place Albert Serraz	Montmelian	Savoie	73800	France	Place Albert Serraz, 73800 Montmelian, France	45.50232	6.054435	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd0023pg0bvxhgmzn5	dXJuOm1ieGFkcjo0NTkwNjQ0MS05MmQzLTQ2YmItOTU0ZS1hOTNmMTg1ZWNiMGE	345 Rue De La Fin De La Louza	Saint-Pierre-d'Albigny	Savoie	73250	France	345 Rue De La Fin De La Louza, 73250 Saint-Pierre-d'Albigny, France	45.560794	6.152823	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd0021pg0bp5vy2u9p	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJeE1TQkRhR1Z0YVc0Z1pHVWdiR0VnUTJoaGNtVjBkR1VpZlE6Mg	11 Chemin De La Charette	Albertville	Savoie	73200	France	11 Chemin De La Charette, 73200 Albertville, France	45.6758	6.3925	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd001zpg0bzfw50sqa	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJMElGQnNZV05sSUV6RHFXOXVkR2x1WlNCV2FXSmxjblFpZlE6MQ	4 Place Léontine Vibert	Albertville	Savoie	73200	France	4 Place Léontine Vibert, 73200 Albertville, France	45.666727	6.390879	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd001xpg0bap4wue7r	dXJuOm1ieGFkcjo3MGU0N2IwMy0xYjg5LTQ1OTYtODMxNy0xYjk5OWEyZmE4OGI	36 Avenue Des Chasseurs Alpins	Albertville	Savoie	73200	France	36 Avenue Des Chasseurs Alpins, 73200 Albertville, France	45.67168	6.391574	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd001vpg0b0e70lvoi	dXJuOm1ieGFkcjozNThiMTJmMy1mOWE0LTQ4ODAtYjI4OS0zMDg0ZTIwMTI0Mjk	50 Place Du Château De Randens	Beaufort	Savoie	73270	France	50 Place Du Château De Randens, 73270 Beaufort, France	45.71785	6.576055	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd001tpg0b2dny2o7t	dXJuOm1ieGFkcjphZGJiY2U1OS04N2JjLTQwMmEtODZmNS1kZGE3Y2UyZGRkYjY	24 Place Du Marché Au Bois	Moûtiers	Savoie	73600	France	24 Place Du Marché Au Bois, 73600 Moûtiers, France	45.4838	6.53383	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzd001rpg0bw16zjj28	dXJuOm1ieGFkcjo3YWQ2NzY0Zi1jOTk3LTRmNjQtODhkYi1mYjYyMzUxZDU2ZWQ	30 Route Des Moulins	Bozel	Savoie	73350	France	30 Route Des Moulins, 73350 Bozel, France	45.442147	6.648579	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc001ppg0b1ehrgx0r	dXJuOm1ieGFkcjo2NjY0MDQyNS0zOWZhLTRhZGYtYTc3Zi0xYjc3Mzk4ZjY4MTU	81 Rue Charlot Raymond	Grignon	Savoie	73200	France	81 Rue Charlot Raymond, 73200 Grignon, France	45.648241	6.373318	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc001npg0b1uvinjjc	dXJuOm1ieGFkcjo5N2I2NzgxNi1lNDViLTRjNGYtOTYxNS1iNWYxYzUzNGQ5Yjk	86 Rue Des Tribunes	Épierre	Savoie	73220	France	86 Rue Des Tribunes, 73220 Épierre, France	45.453361	6.296925	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc001lpg0blmbi8lcj	dXJuOm1ieGFkcjplNDBiZTZjYS1kOTA4LTQ4YzktYmVhOS1lMDcyODUxNzhkZTE	223 Quai De L'arvan	Saint-Jean-de-Maurienne	Savoie	73300	France	223 Quai De L'arvan, 73300 Saint-Jean-de-Maurienne, France	45.273236	6.352858	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc001jpg0b9q146f1g	dXJuOm1ieGFkcjo1ZDhkYWYyYi02ZjU0LTQ1NDctODRjNi03ZjNjNzJhNzQ5Yzc	8 Avenue Du Centenaire	Valgelon-La Rochette	Savoie	73110	France	8 Avenue Du Centenaire, 73110 Valgelon-La Rochette, France	45.458319	6.117154	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc001hpg0bnmgmtnsi	dXJuOm1ieGFkcjoyMDdkMTQ3MC1lNWUzLTQzYmMtYjBkMi1lMTg4YzY4ZGViMWU	46 Rue Du Lac	Crêts en Belledonne	Isère	38830	France	46 Rue Du Lac, 38830 Crêts en Belledonne, France	45.375099	6.053942	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc001fpg0bdv55hmyz	dXJuOm1ieGFkcjoyZTU5NjVlMy0wZWNkLTQxYmQtOGJiZC0xMmIyMzkyOGQ3MDY	34 Bis Boulevard De La Libération	Villard-Bonnot	Isère	38190	France	34 Bis Boulevard De La Libération, 38190 Villard-Bonnot, France	45.25864	5.907362	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc001dpg0bmg7ikim0	dXJuOm1ieGFkcjo5MWEwZjU4Zi1jN2U3LTQ5NTEtYTIwNC1lZTlmNmI3MmIyYmI	5 Rue Du Bourgamon	Saint-Martin-d'Hères	Isère	38400	France	5 Rue Du Bourgamon, 38400 Saint-Martin-d'Hères, France	45.167128	5.760566	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc001bpg0bmps76b91	dXJuOm1ieGFkcjo4NGIxOThjYy1hYWI3LTQ2ZDktYWFhOS1iOTM3M2Y4ZDRlNDk	14 Rue Paul Langevin	Échirolles	Isère	38130	France	14 Rue Paul Langevin, 38130 Échirolles, France	45.145518	5.724772	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc0019pg0be9sa6wug	dXJuOm1ieGFkcjo0MDMyMjkxNi1iNDIxLTQyNmMtOGUwNS1mOGNjN2UyMjgxOWE	14 Rue Félix Esclangon	Grenoble	Isère	38000	France	14 Rue Félix Esclangon, 38000 Grenoble, France	45.191456	5.706861	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc0017pg0bibpqrqkq	dXJuOm1ieGFkcjo3MzQ5NWFmNy1hMWJhLTQxOTgtYTIyOC0xNThiY2RmMTMzOGQ	8 Rue Du Lieutenant Chanaron	Grenoble	Isère	38000	France	8 Rue Du Lieutenant Chanaron, 38000 Grenoble, France	45.186911	5.723093	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc0015pg0bpmrcbsgy	dXJuOm1ieGFkcjo1ZDFjYzZhNy01MDU5LTQxNTEtYmY4OS0yNjI3OTJjYmMyMWQ	34 Rue Champ Rochas	Meylan	Isère	38240	France	34 Rue Champ Rochas, 38240 Meylan, France	45.207751	5.75951	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc0013pg0bo46voruk	dXJuOm1ieGFkcjo1ZWU1ZTA0YS1jZjliLTQxODgtODU1Yy1hYTFlZjFlYWFlOTg	4 Allée Des Amphores	Meylan	Isère	38240	France	4 Allée Des Amphores, 38240 Meylan, France	45.211336	5.785465	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc0011pg0bk86bbnir	dXJuOm1ieGFkcjo1ZWU1ZTA0YS1jZjliLTQxODgtODU1Yy1hYTFlZjFlYWFlOTg	73 Chemin De La Falaise	Crolles	Isère	38920	France	73 Chemin De La Falaise, 38920 Crolles, France	45.288107	5.885494	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000zpg0bmmqmfdh7	dXJuOm1ieGFkcjphNjAyNWQ5OC1mMmQ1LTRmODQtYTFiOS1hMDk1NzQ3YmFiMzI	21 Montée De Tresserve	Tresserve	Savoie	73100	France	21 Montée De Tresserve, 73100 Tresserve, France	45.678795	5.90123	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000xpg0b8h5uy5lh	dXJuOm1ieGFkcjozNmIwMjU1Ni03MzhiLTQ2NjctYTY5Ni1jZTNhYzUwMmZiMDk	12 Rue De La Chaudanne	Aix-les-Bains	Savoie	73100	France	12 Rue De La Chaudanne, 73100 Aix-les-Bains, France	45.690656	5.913952	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000vpg0ba51a0rf9	dXJuOm1ieGFkcjo4M2Y3YjU4Mi0yNDNlLTQzZDctOTIzNi02ZTI4MmFmZWVmYWE	186 Avenue Du Grand Port	Aix-les-Bains	Savoie	73100	France	186 Avenue Du Grand Port, 73100 Aix-les-Bains, France	45.704344	5.895577	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000tpg0bjdxkto2c	dXJuOm1ieGFkcjowMDg2MDU2NS1hMDE5LTQxM2QtYmZjNC02NGY5YTc4NGFlMzM	40 Route Des Gorges Du Sierroz	Grésy-sur-Aix	Savoie	73100	France	40 Route Des Gorges Du Sierroz, 73100 Grésy-sur-Aix, France	45.722547	5.922847	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000rpg0bsqqfcs7d	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJeU5UVWdVblZsSUVSbElFMXZkWFIwYVN3Z056UTFOREFnUVV4Q1dTQlRWVklnUTBoRlVrRk9JbjA6MA	255 Rue De Moutti	Alby-sur-Chéran	Haute-Savoie	74540	France	255 Rue De Moutti Sud, 74540 Alby-sur-Chéran, France	45.814975	6.003934	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000ppg0b7xfswolz	dXJuOm1ieGFkcjo3ZjBlZjljOS1lZThmLTRlMTMtOTUxZC1kMGRiODEzZjFhOGY	1 Place Du 18 Juin 1940	Annecy	Haute-Savoie	74600	France	1 Place Du 18 Juin 1940, 74600 Annecy, France	45.91514	6.145598	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000npg0b6tewaq4j	dXJuOm1ieGFkcjo4NjQzNWU2Zi05MjRmLTRmOGMtYWI0Zi0yNzEzYjJhOTIwMWU	5 Rue De Vénétie	Annecy	Haute-Savoie	74600	France	5 Rue De Vénétie, 74600 Annecy, France	45.911399	6.149202	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000lpg0b3798nek4	dXJuOm1ieGFkci1zdHI6ZThlNzIwNzUtYjg5Yi00MmRjLWEzZDgtNzQxNzYzNzdlYjJl	34 Bis Avenue De La Mavéria	Annecy	Haute-Savoie	74600	France	34 Bis Avenue De La Mavéria, 74600 Annecy, France	45.908868	6.142433	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000jpg0b4hqk04vp	dXJuOm1ieGFkci1zdHI6M2Y4N2UzOTctMDFjMC00ZGI2LTg3NzQtOTQyNzllYWUwZTRi	168 Rue Des Savoie	Epagny Metz-Tessy	Haute-Savoie	74330	France	168 Rue Des Savoie, 74330 Epagny Metz-Tessy, France	45.923614	6.083546	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000hpg0beqyv1424	dXJuOm1ieGFkcjpkNDA2NjY2MS00MzcwLTQ4MmMtYTExYi0yMjkxYjdjNjkzODI	17 Rue Du Fier	Thoiry	Ain	01710	France	17 Rue Du Fier, 01710 Thoiry, France	46.227932	5.968529	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000fpg0b2fpasfl6	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJMk1TQlNiM1YwWlNCRVpTQldaWEpzYVc5NkxDQTNOREUxTUNCV1FVeEpSVkpGVXlCVFZWSWdSa2xGVWlKOTow	61 Route De Verlioz	Vallières-sur-Fier	Haute-Savoie	74150	France	61 Route De Verlioz, 74150 Vallières-sur-Fier, France	45.900216	5.935386	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000dpg0b04bdsnnz	dXJuOm1ieGFkcjo1ODJkYTM5OS0zY2IyLTQ4OTMtYjhiYi00NmZmMGUxMGJmODQ	13 Boulevard Du Mail	Belley	Ain	01300	France	13 Boulevard Du Mail, 01300 Belley, France	45.760147	5.689724	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc000bpg0biga7imrx	dXJuOm1ieGFkcjpkOWU4NGQ5Yy1lOThlLTQxNWQtOGY2MC1hNzA5MWFhZDY3NDA	24 Impasse De La Levaz Basse	Vézeronce-Curtin	Isère	38510	France	24 Impasse De La Levaz Basse, 38510 Vézeronce-Curtin, France	45.667786	5.470308	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc0009pg0b1j5j3x3d	dXJuOm1ieGFkcjpjOGM3NzhhZi02MzBjLTRlZWItODQ0YS1hZWM4NDU3MGY0M2M	50 Place Blanc Jolicoeur	Aoste	Isère	38490	France	50 Place Blanc Jolicoeur, 38490 Aoste, France	45.586957	5.607554	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc0007pg0broq4rojb	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJNU1DQkRhR1Z0YVc0Z1JHVWdRMlYxY25aaGVpd2dOek0wTnpBZ1RrOVdRVXhCU1ZORkluMDow	90 Chemin De Courvaz	Novalaise	Savoie	73470	France	90 Chemin De Courvaz, 73470 Novalaise, France	45.596294	5.776131	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkmmtnzc0005pg0b7vwihkdv	dXJuOm1ieGFkcjozZWVkMTMzMS1jODczLTQwNmUtOWI5OC01NTIzZGViNDQwMjE	256 Route Du Châtelard	Le Bourget-du-Lac	Savoie	73370	France	256 Route Du Châtelard, 73370 Le Bourget-du-Lac, France	45.646421	5.854933	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00
cmkp6ri900001ju04vp0pmaam	dXJuOm1ieGFkcjo0ZjY1MmQ3MS05MWVmLTQxMWQtYWM3ZS1jNWZmYmFlN2U4NWM	30 Rue Gustave Eiffel	Annecy	Haute-Savoie	74600	France	30 Rue Gustave Eiffel, 74600 Annecy, France	45.883816	6.077826	2026-01-22 08:24:32.292+00	2026-01-22 08:24:32.292+00
cmkp6s1h10001l104qkoaqwag	dXJuOm1ieGFkcjpiYmE5MDE1OS05ZmFiLTRjNmUtOTkxMy0wZTNhY2I4MGM3ZGY	17 Rue Claude Guillermoz	Voiron	Isère	38500	France	17 Rue Claude Guillermoz, 38500 Voiron, France	45.366823	5.586946	2026-01-22 08:24:57.206+00	2026-01-22 08:24:57.206+00
cmkp6tdkd0003l404xmm686b9	dXJuOm1ieGFkcjoyNjMzNTUyNi1kM2QwLTRjY2UtODczNi0zMjQ2MzJlZjNlMGI	4 Rue Joseph Ferdinand Rossat	La Côte-Saint-André	Isère	38260	France	4 Rue Joseph Ferdinand Rossat, 38260 La Côte-Saint-André, France	45.390049	5.248343	2026-01-22 08:25:59.534+00	2026-01-22 08:25:59.534+00
cmkpiwhwe0003ky046yn0ed8x	dXJuOm1ieGFkcjpkMzA1YmVhYy0wMGVkLTQzNTItYjZiNC1jMTBhYmMwMDk2ZWY	26 Chemin De La Côte Linière	Saint-Cassien	Isère	38500	France	26 Chemin De La Côte Linière, 38500 Saint-Cassien, France	45.356585	5.547427	2026-01-22 14:04:20.511+00	2026-01-22 14:04:20.511+00
\.


--
-- Data for Name: client_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_settings (id, client_company_id, cutoff_time, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.companies (id, name, type, address_id, parent_id, created_at, updated_at, default_stop_type) FROM stdin;
cmkmmufqk0009pg0b7a5y9m2d	Dent All Group	client	cmkmmu5h20004pg0bq4c9z7xj	cmkmmtnzb0000pg0b8nz0429u	2026-01-22 08:19:57.259454+00	2026-01-22 08:19:57.259454+00	\N
cmkpinfve0000l204jsys1th6	ABC DENTS	end_client	cmkpinfve0001l204p27o7e8m	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 13:57:17.979+00	2026-01-22 13:57:17.979+00	\N
cmkpj4hd90004la04rj6q2zl9	KAP LABORATOIRE DENTAIRE	end_client	cmkpj4hd90005la047z4tult2	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:10:33.069+00	2026-01-22 14:10:33.069+00	\N
cmkpj6bpv000al2041j5qonho	LABORATOIRE DES ROMAINS	end_client	cmkpj6bpv000bl204nyi9pebq	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:11:59.06+00	2026-01-22 14:11:59.06+00	\N
cmkpj6xk70006la04l1nbeona	LABORATOIRE DES ROMAINS	end_client	cmkpj6xk70007la04i7dw2nih	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:12:27.367+00	2026-01-22 14:12:27.367+00	\N
cmkpj8hrx0004ky04kk74xl6d	LAC DENTAIRE	end_client	cmkpj8hrx0005ky04h0vkyie1	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:13:40.221+00	2026-01-22 14:13:40.221+00	\N
cmkpj9j27000cl2042x8akjni	SIGNATURE DENTAIRE	end_client	cmkpj9j27000dl2047t182oly	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:14:28.543+00	2026-01-22 14:14:28.543+00	\N
cmkpjbb9m000gl2046arrfar1	VIDAL SAR	end_client	cmkpjbb9m000hl204e6qffcd9	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:15:51.754+00	2026-01-22 14:15:51.754+00	\N
cmkpoh8qx0002jo04pr7z8wj3	BALIMA	end_client	cmkpoh8qx0003jo04vyxiampd	cmkmmtnzb0002pg0bqq1nopcy	2026-01-22 16:40:26.505+00	2026-01-22 16:40:26.505+00	\N
cmkwlqmys0000l704htwnpczu	ADEIS	end_client	cmkwlqmys0001l704a4ay2d1c	cmkmmufqk0009pg0b7a5y9m2d	2026-01-27 12:58:09.22+00	2026-01-27 12:58:09.22+00	\N
cmkp6quui0000l404vez9eztk	ARCADENT 74	end_client	cmkp6quuj0001l404pur8bk1u	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 08:24:01.963+00	2026-01-22 08:24:01.963+00	\N
cmkp6u19v0000lb04aw46ghu4	CROWN DENTAL (LABO SB)	end_client	cmkp6u19w0001lb04tm8w3b06	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 08:26:30.26+00	2026-01-22 08:26:30.26+00	\N
cmkpishbz0000la04h16wjn1z	ALTILAB	end_client	cmkpishbz0001la04hst3y6dy	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:01:13.151+00	2026-01-22 14:01:13.151+00	\N
cmkpiu83y0002l204vpxb74j6	BETHON	end_client	cmkpiu83z0003l204nbpocbby	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:02:34.511+00	2026-01-22 14:02:34.511+00	\N
cmkpivrp40000ky04ynl7uisf	CVS	end_client	cmkpivrp40001ky04euyawq6a	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:03:46.552+00	2026-01-22 14:03:46.552+00	\N
cmkpj1yxb0004l204wiypnsku	DUMONT & MONTET	end_client	cmkpj1yxb0005l204plmjjpk7	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:08:35.855+00	2026-01-22 14:08:35.855+00	\N
cmkpj2wnw0002la046k5yp2nd	GERBOUD	end_client	cmkpj2wnw0003la04whkmizgt	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:09:19.58+00	2026-01-22 14:09:19.58+00	\N
cmkpj3tux0000jr04fljezhyg	GMC DENTAIRE ANNECY	end_client	cmkpj3tux0001jr040xtzdu1r	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:10:02.601+00	2026-01-22 14:10:02.601+00	\N
cmkpj53je0006l204xvdz3fr5	LABODENTAL	end_client	cmkpj53je0007l204v5sg9l9o	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:11:01.802+00	2026-01-22 14:11:01.802+00	\N
cmkpj5sm10008l204miol0uyo	LABORATOIRE CHAPUIS	end_client	cmkpj5sm10009l204ky6cz3ha	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:11:34.298+00	2026-01-22 14:11:34.298+00	\N
cmkpj7uvs0008la0433wddlr5	LABORATOIRE FERY BONO	end_client	cmkpj7uvs0009la040xj99bmt	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:13:10.552+00	2026-01-22 14:13:10.552+00	\N
cmkpja6ka000ala043b4izyqi	SMILE DIGITAL SOLUTIONS	end_client	cmkpja6ka000bla047z0mprir	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:14:59.003+00	2026-01-22 14:14:59.003+00	\N
cmkpjarhv000el2043mokndd5	TERRY	end_client	cmkpjarhv000fl204osybq92g	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:15:26.132+00	2026-01-22 14:15:26.132+00	\N
cmkpoipkw003el404a9gjq8tt	BOUTBOUL	end_client	cmkpoipkw003fl404xhcwstv9	cmkmmtnzb0002pg0bqq1nopcy	2026-01-22 16:41:34.976+00	2026-01-22 16:41:34.976+00	\N
cmkmmtnzb0000pg0b8nz0429u	Trans Dental Services	delivery	cmkmmtnzb0001pg0beuabkn2y	\N	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzb0002pg0bqq1nopcy	ADEIS	client	cmkmmtnzb0003pg0bnwqqy4w8	cmkmmtnzb0000pg0b8nz0429u	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd002cpg0b43ylar77	TAREAN	end_client	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd002apg0bnlue5rom	BIRSAN	end_client	cmkmmtnzd002bpg0bw3xjvfsb	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd0028pg0bgetr00sv	CLINIQUE ST HUGUES	end_client	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd0026pg0bedd3795f	GANDON / BERTINOTTI	end_client	cmkmmtnzd0027pg0b87s1ex9x	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd0024pg0bpeprtbs1	GHENO	end_client	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd0022pg0bwjkhy015	GRANGE	end_client	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd0020pg0bk99tiad8	STOIAN	end_client	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd001ypg0bcx0u3qe2	CHEVASSU	end_client	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd001wpg0b8opdootf	MUTUELLE ALBERTVILLE	end_client	cmkmmtnzd001xpg0bap4wue7r	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd001upg0bjnjvz9w8	BEDHET	end_client	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd001spg0b62euz775	SEYE	end_client	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzd001qpg0byzzbxsq6	SOLVET	end_client	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc001opg0bh2fmojqz	ROUSSIN-MOYNIER	end_client	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc001mpg0bik0f98l7	GROSJEAN	end_client	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc001kpg0b01sk2kxs	CHOKOEV / CHAUSHEVA	end_client	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc001ipg0by1go31lb	GIRAUD	end_client	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc001gpg0b30kwtz0g	LAPUSAN / POPA	end_client	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc001epg0blalns7pp	LALO / VALLON	end_client	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc001cpg0buztxte3p	LABORATOIR RASTEIRO	end_client	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc001apg0bdkzb5fyx	BOUCHU / GUNZBURGER	end_client	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc0018pg0b9yh53ptf	ELKAIM	end_client	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc0016pg0bkcilb9eg	MALLET	end_client	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc0014pg0bjfko06na	HEINELEVEQUE	end_client	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc0012pg0b9g2rgur4	MAZEAU	end_client	cmkmmtnzc0013pg0bo46voruk	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc0010pg0bj0tfcetm	DOPFF	end_client	cmkmmtnzc0011pg0bk86bbnir	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000ypg0bscyvt3oh	PUGNALE	end_client	cmkmmtnzc000zpg0bmmqmfdh7	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000wpg0b5nr80khx	BARBONI	end_client	cmkmmtnzc000xpg0b8h5uy5lh	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000upg0bhhvedenk	LABO DES ALPES	end_client	cmkmmtnzc000vpg0ba51a0rf9	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000spg0b3wxsq6ez	WAGNER	end_client	cmkmmtnzc000tpg0bjdxkto2c	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000qpg0bjppqfaf1	CARTIER / LANDREAU	end_client	cmkmmtnzc000rpg0bsqqfcs7d	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000opg0b8qhmdsuc	SUCHEL	end_client	cmkmmtnzc000ppg0b7xfswolz	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000mpg0bm0owaa4z	ALEMANY / GENET	end_client	cmkmmtnzc000npg0b6tewaq4j	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000kpg0bqjgrrw8k	MADIE	end_client	cmkmmtnzc000lpg0b3798nek4	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000ipg0bvf6mh1w5	AUCOUTURIER	end_client	cmkmmtnzc000jpg0b4hqk04vp	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000gpg0bp44hrav7	EMCOLAB	end_client	cmkmmtnzc000hpg0beqyv1424	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000epg0b1ow0h31d	ROMARY / MILLERET	end_client	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000cpg0brqq44zo5	DUMAS	end_client	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc000apg0b2ob9poap	PRUDHOMMME	end_client	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc0008pg0btk75uuae	GUYON	end_client	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc0006pg0bz7juob3v	CHARTIER	end_client	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkmmtnzc0004pg0bnlyen0ou	FOUCAUD	end_client	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzb0002pg0bqq1nopcy	2026-01-20 13:30:48.359+00	2026-01-20 13:30:48.359+00	\N
cmkp6ri900000ju04ere0b180	ARTECAM	end_client	cmkp6ri900001ju04vp0pmaam	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 08:24:32.292+00	2026-01-22 08:24:32.292+00	\N
cmkp6s1h10000l104nwmcuhj9	AXEDENT	end_client	cmkp6s1h10001l104qkoaqwag	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 08:24:57.206+00	2026-01-22 08:24:57.206+00	\N
cmkp6tdkd0002l404xz56pp5s	CÔTÉ DENT	end_client	cmkp6tdkd0003l404xmm686b9	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 08:25:59.534+00	2026-01-22 08:25:59.534+00	\N
cmkpiwhwe0002ky044ol2lgu7	DENTACT	end_client	cmkpiwhwe0003ky046yn0ed8x	cmkmmufqk0009pg0b7a5y9m2d	2026-01-22 14:04:20.511+00	2026-01-22 14:04:20.511+00	\N
\.


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deliveries (id, number, date, notes, driver_name, vehicle_license_plate, driver_notes, delivery_status, scheduled_at, started_at, finished_at, delivery_company_id, driver_id, vehicle_id, created_at, updated_at) FROM stdin;
cmkqwm6ut0001l104r58yeh2w	TDS26-0003	2026-01-22 23:00:00+00	Tournée 1	Oudjedi Chabane	WW-887-GB	Ras	completed	\N	2026-01-23 19:11:08.272+00	2026-01-23 23:45:31.459+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002gpg0b7v5rybu2	cmkmmtrgz002ipg0buu40i13n	2026-01-23 13:16:00.437+00	2026-01-23 23:45:37.853+00
cmkqwmdsz002bl104gfkktuoh	TDS26-0004	2026-01-22 23:00:00+00	Tournée 2	Bilel Mokrane	WW-862-GB	Ras	completed	\N	2026-01-23 23:46:25.44+00	2026-01-23 23:48:45.957+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002fpg0b085wvg34	cmkmmtrgz002hpg0b3rj9nj6h	2026-01-23 13:16:09.443+00	2026-01-23 23:48:52.031+00
cmkrjsfb4000si904wqrp4odf	TDS26-0005	2026-01-23 23:00:00+00	Tournée 1	Bilel Mokrane	WW-862-GB	’	completed	\N	2026-01-24 00:08:59.512+00	2026-01-24 00:12:50.346+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002fpg0b085wvg34	cmkmmtrgz002hpg0b3rj9nj6h	2026-01-24 00:04:42.497+00	2026-01-24 00:12:59.674+00
cmkrjslob002wi904uctl771l	TDS26-0006	2026-01-23 23:00:00+00	Tournée 2	Oudjedi Chabane	WW-887-GB	Ras	completed	\N	2026-01-24 12:30:26.426+00	2026-01-24 12:35:48.911+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002gpg0b7v5rybu2	cmkmmtrgz002ipg0buu40i13n	2026-01-24 00:04:50.747+00	2026-01-24 12:35:53.664+00
cmkv461gx0001l504ljsc6x18	TDS26-0007	2026-01-25 23:00:00+00	Tournée 1	Oudjedi Chabane	WW-887-GB	Ras	completed	\N	2026-01-26 12:00:48.721+00	2026-01-26 12:01:44.879+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002gpg0b7v5rybu2	cmkmmtrgz002ipg0buu40i13n	2026-01-26 11:58:28.593+00	2026-01-26 12:01:49.672+00
cmkpme9wb0001l404rj92vmym	TDS26-0001	2026-01-21 23:00:00+00	Tournée 1	Oudjedi Chabane	WW-887-GB	Ras	completed	\N	2026-01-22 16:50:10.905+00	2026-01-22 17:07:56.721+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002gpg0b7v5rybu2	cmkmmtrgz002ipg0buu40i13n	2026-01-22 15:42:08.795+00	2026-01-22 17:08:01.87+00
cmkpnfv3w002fl804cjkwalav	TDS26-0002	2026-01-21 23:00:00+00	Tournée 2	Bilel Mokrane	WW-862-GB	Ras	completed	\N	2026-01-22 17:16:43.193+00	2026-01-23 01:47:54.458+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002fpg0b085wvg34	cmkmmtrgz002hpg0b3rj9nj6h	2026-01-22 16:11:22.556+00	2026-01-23 01:48:04.01+00
cmkvqjpsa000zjx04akobup3j	TDS26-0008	2026-01-26 12:00:00+00	\N	Oudjedi Chabane	WW-887-GB	Ras	completed	\N	2026-01-26 22:26:40.335+00	2026-01-26 22:29:07.979+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002gpg0b7v5rybu2	cmkmmtrgz002ipg0buu40i13n	2026-01-26 22:24:58.187+00	2026-01-26 22:29:13.229+00
cmkvqju56002bjx04epy9mowp	TDS26-0009	2026-01-26 12:00:00+00	\N	Bilel Mokrane	WW-862-GB	Ras	completed	\N	2026-01-27 09:19:03.892+00	2026-01-27 13:05:28.876+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002fpg0b085wvg34	cmkmmtrgz002hpg0b3rj9nj6h	2026-01-26 22:25:03.833+00	2026-01-27 13:05:33.61+00
cmkwm1zen0001l804z6hssm02	TDS26-0010	2026-01-27 12:00:00+00	\N	Oudjedi Chabane	WW-887-GB	Ras	completed	\N	2026-01-27 13:09:39.464+00	2026-01-27 13:11:52.923+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002gpg0b7v5rybu2	cmkmmtrgz002ipg0buu40i13n	2026-01-27 13:06:58.559+00	2026-01-27 13:11:57.262+00
cmkzil88r0001l8040usa413a	TDS26-0011	2026-01-29 12:00:00+00	\N	Oudjedi Chabane	WW-887-GB	Ras	completed	\N	2026-01-29 13:53:35.557+00	2026-01-29 13:54:35.272+00	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002gpg0b7v5rybu2	cmkmmtrgz002ipg0buu40i13n	2026-01-29 13:53:16.539+00	2026-01-29 13:54:39.472+00
cmkziqp1c0001l8047dx757hi	TDS26-0012	2026-01-29 12:00:00+00	\N	Bilel Mokrane	WW-862-GB	\N	scheduled	\N	\N	\N	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002fpg0b085wvg34	cmkmmtrgz002hpg0b3rj9nj6h	2026-01-29 13:57:31.584+00	2026-01-29 13:57:31.584+00
\.


--
-- Data for Name: delivery_request_stops; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.delivery_request_stops (id, sequence, type, notes, request_id, address_id, end_client_id, delivery_stop_id, created_at, updated_at) FROM stdin;
cmkyihzze0003l604k17594yd	1	both	\N	cmkyihzzd0001l604yowddk0j	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkq8d71g0004ju04e3gh6l23	2	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	cmkqwm7gq0007l104auv0hl35	2026-01-23 01:57:09.987+00	2026-01-23 13:16:01.324+00
cmkq8d71g0007ju04qb4kv295	5	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	cmkqwm7rk000bl10410av7vc8	2026-01-23 01:57:09.987+00	2026-01-23 13:16:01.713+00
cmkq8d71g0008ju04sut6rr6a	6	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	cmkqwm7wx000dl104zaeum6r5	2026-01-23 01:57:09.987+00	2026-01-23 13:16:01.905+00
cmkq8d71g0009ju04b8zoulr7	7	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	cmkqwm829000fl104fe0b2vo7	2026-01-23 01:57:09.987+00	2026-01-23 13:16:02.098+00
cmkq8d71g000bju0468l4e69c	9	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	cmkqwm8cz000jl104d2169dlr	2026-01-23 01:57:09.987+00	2026-01-23 13:16:02.49+00
cmkq8d71g000cju04grw2vqrs	10	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	cmkqwm8ij000ll104xgrmh6fl	2026-01-23 01:57:09.987+00	2026-01-23 13:16:02.687+00
cmkq8d71g000dju04svn43o2a	11	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	cmkqwm8nz000nl104pjn2ynf9	2026-01-23 01:57:09.987+00	2026-01-23 13:16:02.881+00
cmkq8d71g0005ju043ivnck76	3	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	cmkqwme11002fl104qf86ca3d	2026-01-23 01:57:09.987+00	2026-01-23 13:16:09.829+00
cmkq8d71g0006ju04kcrx9vzl	4	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	cmkqwme6e002hl1045bn5z1h8	2026-01-23 01:57:09.987+00	2026-01-23 13:16:10.022+00
cmkpole3q0005jo045y612hxs	1	both	234	cmkp710fv0003ju04qyx10hox	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	cmkpop8qd003pjo040u765hb7	2026-01-22 16:43:40.07+00	2026-01-22 16:46:39.829+00
cmkpjgitm0009ky04kchxspv7	1	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	cmkpop8vo003rjo04d1mi38l5	2026-01-22 14:19:54.826+00	2026-01-22 16:46:40.019+00
cmkpjgitm000aky0483hj7na9	2	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	cmkpop90y003tjo04h084v8r1	2026-01-22 14:19:54.826+00	2026-01-22 16:46:40.209+00
cmkpole8w0007jo04kl288b73	2	both	567	cmkp710fv0003ju04qyx10hox	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	cmkpop967003vjo04rjmlbagj	2026-01-22 16:43:40.257+00	2026-01-22 16:46:40.399+00
cmkpo4b9m0001jo04g69rgc25	3	dropoff	123	cmkp710fv0003ju04qyx10hox	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	cmkpop9gr003zjo04ob24jujp	2026-01-22 16:30:23.243+00	2026-01-22 16:46:40.778+00
cmkpjgitm000dky041215cbvp	5	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	cmkpop9x10045jo04qvezp4z6	2026-01-22 14:19:54.826+00	2026-01-22 16:46:41.364+00
cmkpjgitm000pky04zfu7iyd3	17	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	cmkpopboa004tjo04yxe2baxs	2026-01-22 14:19:54.826+00	2026-01-22 16:46:43.641+00
cmkpjgitm000qky04kh6kxpvl	18	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	cmkpopbyu004xjo04n9rd30ki	2026-01-22 14:19:54.826+00	2026-01-22 16:46:44.022+00
cmkpjgitm000rky04lpb7opco	19	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	cmkpopceo0053jo04yjcu05tf	2026-01-22 14:19:54.826+00	2026-01-22 16:46:44.624+00
cmkpjgitm000sky04a40s87gr	20	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	cmkpopcq40057jo04oot8vqx9	2026-01-22 14:19:54.826+00	2026-01-22 16:46:45.004+00
cmkpjgitm000tky042fenb04k	21	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	cmkpopd0o005bjo04ts3j9v59	2026-01-22 14:19:54.826+00	2026-01-22 16:46:45.383+00
cmkpjgitm000uky04ci7q7ddq	22	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	cmkpopdb8005fjo0440z09bl7	2026-01-22 14:19:54.826+00	2026-01-22 16:46:45.763+00
cmkpjgitm000vky042edmz61q	23	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	cmkpopdlu005jjo04a9c3bqb7	2026-01-22 14:19:54.826+00	2026-01-22 16:46:46.145+00
cmkpjgitm000wky04tb5e57wn	24	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	cmkpopdr3005ljo04j6e1ld8q	2026-01-22 14:19:54.826+00	2026-01-22 16:46:46.334+00
cmkpi1fj1000djr04vf0luhtw	28	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000tpg0bjdxkto2c	cmkmmtnzc000spg0b3wxsq6ez	cmkpopehj005vjo042rvxanm1	2026-01-22 13:40:11.006+00	2026-01-22 16:46:47.286+00
cmkpi1fj1000fjr0457kkvje1	29	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000rpg0bsqqfcs7d	cmkmmtnzc000qpg0bjppqfaf1	cmkpopems005xjo04r5osthid	2026-01-22 13:40:11.006+00	2026-01-22 16:46:47.498+00
cmkpi1fj2000hjr04lil96efg	30	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000ppg0b7xfswolz	cmkmmtnzc000opg0b8qhmdsuc	cmkpopesp005zjo043s9bysb6	2026-01-22 13:40:11.006+00	2026-01-22 16:46:47.688+00
cmkpi1fj2000jjr04eebkwktx	31	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000npg0b6tewaq4j	cmkmmtnzc000mpg0bm0owaa4z	cmkpopexz0061jo04vyedz03b	2026-01-22 13:40:11.006+00	2026-01-22 16:46:47.878+00
cmkpi1fj2000ljr045qom36jo	32	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000lpg0b3798nek4	cmkmmtnzc000kpg0bqjgrrw8k	cmkpopf390063jo04y9qxz7ft	2026-01-22 13:40:11.006+00	2026-01-22 16:46:48.068+00
cmkpi1fj2000njr04m8nx3tjm	33	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000jpg0b4hqk04vp	cmkmmtnzc000ipg0bvf6mh1w5	cmkpopf8j0065jo04lsmkp84h	2026-01-22 13:40:11.006+00	2026-01-22 16:46:48.258+00
cmkpi1fj2000pjr04jhqolwld	34	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000hpg0beqyv1424	cmkmmtnzc000gpg0bp44hrav7	cmkpopfdu0067jo04gegr83yf	2026-01-22 13:40:11.006+00	2026-01-22 16:46:48.45+00
cmkp710fv0009ju04dijc2htx	5	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	cmkpopgmb006djo04zilnr1g4	2026-01-22 08:31:55.771+00	2026-01-22 16:46:50.051+00
cmkp710fv000aju040ssz2zy3	6	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	cmkpopgrl006fjo04abpd7nyy	2026-01-22 08:31:55.771+00	2026-01-22 16:46:50.24+00
cmkp710fv000bju04rsdzrg8u	7	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	cmkpopgwv006hjo0417pc1lwh	2026-01-22 08:31:55.771+00	2026-01-22 16:46:50.431+00
cmkp710fv000cju04teeycvi0	8	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	cmkpoph25006jjo04um9elsm6	2026-01-22 08:31:55.771+00	2026-01-22 16:46:50.621+00
cmkp710fv000eju04h66zjerq	9	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	cmkpoph7f006ljo04jn0ahf4g	2026-01-22 08:31:55.771+00	2026-01-22 16:46:50.81+00
cmkp710fv000fju041a53ao7t	10	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	cmkpophcp006njo04mm1cao6c	2026-01-22 08:31:55.771+00	2026-01-22 16:46:51+00
cmkp710fv000gju04jxg7eg3n	11	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	cmkpophi0006pjo04lp7oqczc	2026-01-22 08:31:55.771+00	2026-01-22 16:46:51.191+00
cmkp710fv000hju04qfa2121g	12	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	cmkpophnb006rjo042d4cltra	2026-01-22 08:31:55.771+00	2026-01-22 16:46:51.382+00
cmkp710fv000iju04p82r4ame	13	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	cmkpophsl006tjo044v7t10o2	2026-01-22 08:31:55.771+00	2026-01-22 16:46:51.572+00
cmkp710fv000jju0416njwyr2	14	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	cmkpophxv006vjo04o7yb2dgs	2026-01-22 08:31:55.771+00	2026-01-22 16:46:51.762+00
cmkyihzze0004l6043uf3d55i	2	both	\N	cmkyihzzd0001l604yowddk0j	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkpjgitm000bky04fhdvec79	3	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	cmkpop9bh003xjo048cksgic9	2026-01-22 14:19:54.826+00	2026-01-22 16:46:40.588+00
cmkpjgitm000cky04awzowlb8	4	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	cmkpop9m10041jo04h4zklpq3	2026-01-22 14:19:54.826+00	2026-01-22 16:46:40.985+00
cmkp710fv0007ju040hpoz4k9	4	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	cmkpop9rr0043jo04kgjbkg7f	2026-01-22 08:31:55.771+00	2026-01-22 16:46:41.174+00
cmkpjgitm000eky04shhadpvq	6	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	cmkpopa2a0047jo045v0o4q0j	2026-01-22 14:19:54.826+00	2026-01-22 16:46:41.553+00
cmkpjgitm000fky04ijew8cyz	7	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	cmkpopa7k0049jo04mk51r8xv	2026-01-22 14:19:54.826+00	2026-01-22 16:46:41.743+00
cmkpjgitm000gky04uteiglef	8	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	cmkpopacu004bjo04wp5ei0yb	2026-01-22 14:19:54.826+00	2026-01-22 16:46:41.933+00
cmkpjgitm000hky04gw5b8xon	9	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	cmkpopai3004djo049s9xxkqa	2026-01-22 14:19:54.826+00	2026-01-22 16:46:42.123+00
cmkpjgitm000iky04ihh8mf4m	10	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	cmkpopane004fjo044d3vq243	2026-01-22 14:19:54.826+00	2026-01-22 16:46:42.313+00
cmkpjgitm000jky04a4k3r3ml	11	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	cmkpopaso004hjo047upwfwul	2026-01-22 14:19:54.826+00	2026-01-22 16:46:42.503+00
cmkpjgitm000kky04a4bi3sy0	12	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	cmkpopaxx004jjo04qgv68ygo	2026-01-22 14:19:54.826+00	2026-01-22 16:46:42.693+00
cmkpjgitm000lky04u50uow0n	13	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	cmkpopb37004ljo04idi451mb	2026-01-22 14:19:54.826+00	2026-01-22 16:46:42.882+00
cmkp710fv000lju049xphm2gk	16	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	cmkpopbj0004rjo04lrfz5zow	2026-01-22 08:31:55.771+00	2026-01-22 16:46:43.451+00
cmkpi1fj2000xjr045em2517y	38	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	cmkpopfj40069jo046d9q9exu	2026-01-22 13:40:11.006+00	2026-01-22 16:46:48.64+00
cmkpi1fj2000zjr049acijyms	39	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	cmkpopfof006bjo041dxjy00d	2026-01-22 13:40:11.006+00	2026-01-22 16:46:48.83+00
cmkpjgitm000mky04r9v88g2i	14	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	cmkpopi35006xjo04vqqlxf92	2026-01-22 14:19:54.826+00	2026-01-22 16:46:51.952+00
cmkp710fv000kju04xs861p7h	15	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	cmkpopi8f006zjo041laxz2z0	2026-01-22 08:31:55.771+00	2026-01-22 16:46:52.143+00
cmkpi1fj2000rjr04kccs7w8r	35	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	cmkpopidq0071jo04xem0i5b1	2026-01-22 13:40:11.006+00	2026-01-22 16:46:52.333+00
cmkpi1fj2000tjr043org9c2z	36	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	cmkpopij10073jo041ktb8599	2026-01-22 13:40:11.006+00	2026-01-22 16:46:52.524+00
cmkpi1fj20011jr049co8ubsi	40	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	cmkpopiw50077jo046xbxamhv	2026-01-22 13:40:11.006+00	2026-01-22 16:46:52.996+00
cmkq8d71g000fju04oefj5uzu	13	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	cmkqwm8yq000rl104n9svy3js	2026-01-23 01:57:09.987+00	2026-01-23 13:16:03.267+00
cmkq8d71g000hju04rzpmgv5g	15	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	cmkqwm943000tl104datuksx8	2026-01-23 01:57:09.987+00	2026-01-23 13:16:03.46+00
cmkq8d71g000lju049qcfb9i0	19	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	cmkqwm99h000vl1044bsincmt	2026-01-23 01:57:09.987+00	2026-01-23 13:16:03.654+00
cmkq8d71g000nju04xgxrjvu8	21	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	cmkqwm9v10013l104lpr5cksr	2026-01-23 01:57:09.987+00	2026-01-23 13:16:04.432+00
cmkq8d71g000oju0408urs5e0	22	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	cmkqwma5s0017l1041vhqptgi	2026-01-23 01:57:09.987+00	2026-01-23 13:16:04.816+00
cmkq8d71g000qju04i03kkle0	24	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	cmkqwmalw001dl10471zgrfgt	2026-01-23 01:57:09.987+00	2026-01-23 13:16:05.397+00
cmkq8lyww000yky041u1l9jk6	32	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000rpg0bsqqfcs7d	cmkmmtnzc000qpg0bjppqfaf1	cmkqwmbye001vl104cncqmosf	2026-01-23 02:03:59.36+00	2026-01-23 13:16:07.143+00
cmkq8lyww000zky04u39rn0aw	33	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000ppg0b7xfswolz	cmkmmtnzc000opg0b8qhmdsuc	cmkqwmc3q001xl104rxw3nrzr	2026-01-23 02:03:59.36+00	2026-01-23 13:16:07.336+00
cmkq8lyww0010ky048i0oymjq	34	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000npg0b6tewaq4j	cmkmmtnzc000mpg0bm0owaa4z	cmkqwmc95001zl104vbt9bgf0	2026-01-23 02:03:59.36+00	2026-01-23 13:16:07.529+00
cmkq8lyww0011ky04z5ipr6x9	35	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000lpg0b3798nek4	cmkmmtnzc000kpg0bqjgrrw8k	cmkqwmceh0021l104ufd60s0w	2026-01-23 02:03:59.36+00	2026-01-23 13:16:07.722+00
cmkq8lyww0012ky04wquuwg0s	36	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000jpg0b4hqk04vp	cmkmmtnzc000ipg0bvf6mh1w5	cmkqwmcju0023l104rpbia9sn	2026-01-23 02:03:59.36+00	2026-01-23 13:16:07.915+00
cmkq8lyww0017ky041sc8vcc1	41	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	cmkqwmcuk0027l104l5tugl8q	2026-01-23 02:03:59.36+00	2026-01-23 13:16:08.301+00
cmkq8lyww0018ky04ombbq17k	42	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	cmkqwmczy0029l104h84ibs7n	2026-01-23 02:03:59.36+00	2026-01-23 13:16:08.495+00
cmkq8d71g000gju04hvl8gqxm	14	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	cmkqwmfz80035l104at2xsnbh	2026-01-23 01:57:09.987+00	2026-01-23 13:16:12.356+00
cmkq8d71g000iju04dnrsn6ae	16	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	cmkqwmg9x0039l104jws2xtq6	2026-01-23 01:57:09.987+00	2026-01-23 13:16:12.741+00
cmkq8d71g000jju04ud3nddvl	17	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	cmkqwmgsi003fl1043wpoklj4	2026-01-23 01:57:09.987+00	2026-01-23 13:16:13.411+00
cmkq8d71g000kju04bvc41y8h	18	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	cmkqwmh37003jl104d1bd1c2q	2026-01-23 01:57:09.987+00	2026-01-23 13:16:13.795+00
cmkq8lyww0014ky04odpdo2w4	38	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	cmkqwmhe0003nl1042t6ocz74	2026-01-23 02:03:59.36+00	2026-01-23 13:16:14.184+00
cmkq8lyww0015ky046j4fw3v0	39	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	cmkqwmhjc003pl104fwmwld1f	2026-01-23 02:03:59.36+00	2026-01-23 13:16:14.376+00
cmkq8lyww0016ky0418v5dvfs	40	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	cmkqwmhoo003rl1043xd58415	2026-01-23 02:03:59.36+00	2026-01-23 13:16:14.568+00
cmkq8lyww0019ky04ng2pdenw	43	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	cmkqwmhu0003tl104j6uvrscg	2026-01-23 02:03:59.36+00	2026-01-23 13:16:14.761+00
cmkyihzze0005l6048vqb3lwz	3	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkpjgitm000nky046d0m5v34	15	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	cmkpopb8h004njo04th7t903l	2026-01-22 14:19:54.826+00	2026-01-22 16:46:43.072+00
cmkpjgitm000oky042kb1pljn	16	both	\N	cmkpjgitl0007ky04n4r7b9lx	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	cmkpopbdq004pjo04s71pqfj6	2026-01-22 14:19:54.826+00	2026-01-22 16:46:43.261+00
cmkp710fv000mju046kuv49oh	17	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	cmkpopbtk004vjo0496lktjm3	2026-01-22 08:31:55.771+00	2026-01-22 16:46:43.832+00
cmkp710fv000nju04j9y07374	18	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	cmkpopc44004zjo04jidn4up7	2026-01-22 08:31:55.771+00	2026-01-22 16:46:44.211+00
cmkp710fv000oju04mope1b2s	19	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	cmkpopc9e0051jo04c6c36gqe	2026-01-22 08:31:55.771+00	2026-01-22 16:46:44.402+00
cmkp710fv000pju04fptmfjcq	20	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	cmkpopcku0055jo04kngu72wv	2026-01-22 08:31:55.771+00	2026-01-22 16:46:44.814+00
cmkp710fv000qju04o35302ap	21	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	cmkpopcve0059jo04jngpao73	2026-01-22 08:31:55.771+00	2026-01-22 16:46:45.193+00
cmkpi1fj10001jr04sktlcyet	22	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	cmkpopd5y005djo042skm5cc1	2026-01-22 13:40:11.006+00	2026-01-22 16:46:45.574+00
cmkpi1fj10003jr04inhsvhhl	23	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc0013pg0bo46voruk	cmkmmtnzc0012pg0b9g2rgur4	cmkpopdgi005hjo04gifh1oyi	2026-01-22 13:40:11.006+00	2026-01-22 16:46:45.953+00
cmkpi1fj10005jr041wlyj1ri	24	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc0011pg0bk86bbnir	cmkmmtnzc0010pg0bj0tfcetm	cmkpopdwd005njo04k34vbkv3	2026-01-22 13:40:11.006+00	2026-01-22 16:46:46.526+00
cmkpi1fj10007jr040u2msvlj	25	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000zpg0bmmqmfdh7	cmkmmtnzc000ypg0bscyvt3oh	cmkpope1p005pjo04bdjvhpi7	2026-01-22 13:40:11.006+00	2026-01-22 16:46:46.716+00
cmkpi1fj10009jr040b8lzdg6	26	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000xpg0b8h5uy5lh	cmkmmtnzc000wpg0b5nr80khx	cmkpope6z005rjo046a1p2ocl	2026-01-22 13:40:11.006+00	2026-01-22 16:46:46.906+00
cmkpi1fj1000bjr04whab6agp	27	both	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000vpg0ba51a0rf9	cmkmmtnzc000upg0bhhvedenk	cmkpopec9005tjo04j8ch2arc	2026-01-22 13:40:11.006+00	2026-01-22 16:46:47.096+00
cmkpi1fj2000vjr043n8k4ip7	37	dropoff	\N	cmkp710fv0003ju04qyx10hox	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	cmkpopiqv0075jo047n9l6iww	2026-01-22 13:40:11.006+00	2026-01-22 16:46:52.806+00
cmkq8lyww0004ky04hytjza18	2	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	cmkqwm7m50009l104rxe3qr59	2026-01-23 02:03:59.36+00	2026-01-23 13:16:01.519+00
cmkq8lyww000lky04jkobzsvg	19	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	cmkqwm9eu000xl104gc3o8m3c	2026-01-23 02:03:59.36+00	2026-01-23 13:16:03.847+00
cmkq8lyww000mky04d0v37mql	20	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	cmkqwm9k8000zl104qvuyzdd0	2026-01-23 02:03:59.36+00	2026-01-23 13:16:04.041+00
cmkq8lyww000oky04km9z6p4c	22	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	cmkqwma0f0015l104qywn20lx	2026-01-23 02:03:59.36+00	2026-01-23 13:16:04.624+00
cmkq8lyww000pky04tm2knxmr	23	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	cmkqwmagi001bl104pdz4yizn	2026-01-23 02:03:59.36+00	2026-01-23 13:16:05.203+00
cmkq8lyww000qky04d1tvweiz	24	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	cmkqwmar9001fl104m1jmkhss	2026-01-23 02:03:59.36+00	2026-01-23 13:16:05.59+00
cmkq8lyww000rky04b95ex8ry	25	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	cmkqwmawn001hl104dlrj4iep	2026-01-23 02:03:59.36+00	2026-01-23 13:16:05.788+00
cmkq8lyww000sky04o7e2eke2	26	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc0013pg0bo46voruk	cmkmmtnzc0012pg0b9g2rgur4	cmkqwmb27001jl104baoz23up	2026-01-23 02:03:59.36+00	2026-01-23 13:16:05.983+00
cmkq8lyww000tky04ostqra4h	27	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc0011pg0bk86bbnir	cmkmmtnzc0010pg0bj0tfcetm	cmkqwmb7k001ll104hhxx5e4e	2026-01-23 02:03:59.36+00	2026-01-23 13:16:06.178+00
cmkq8lyww000vky04lxfedvtd	29	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000xpg0b8h5uy5lh	cmkmmtnzc000wpg0b5nr80khx	cmkqwmbib001pl104auj4v7w2	2026-01-23 02:03:59.36+00	2026-01-23 13:16:06.565+00
cmkq8lyww000wky046139xp36	30	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000vpg0ba51a0rf9	cmkmmtnzc000upg0bhhvedenk	cmkqwmbnp001rl104b4vb3ksm	2026-01-23 02:03:59.36+00	2026-01-23 13:16:06.757+00
cmkq8lyww000xky0444mk40qs	31	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000tpg0bjdxkto2c	cmkmmtnzc000spg0b3wxsq6ez	cmkqwmbt1001tl1048xw2rscc	2026-01-23 02:03:59.36+00	2026-01-23 13:16:06.95+00
cmkq8lyww0005ky04m9e7kneu	3	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	cmkqwmdvn002dl104ews5zb56	2026-01-23 02:03:59.36+00	2026-01-23 13:16:09.636+00
cmkq8lyww0006ky04carxmphc	4	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd002bpg0bw3xjvfsb	cmkmmtnzd002apg0bnlue5rom	cmkqwmebq002jl104bbyq8h11	2026-01-23 02:03:59.36+00	2026-01-23 13:16:10.215+00
cmkq8lyww0007ky04hmw51o78	5	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	cmkqwmeh3002ll10451tfm78l	2026-01-23 02:03:59.36+00	2026-01-23 13:16:10.407+00
cmkq8lyww0009ky04uhrdta0k	7	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	cmkqwmerr002pl104ywlon43u	2026-01-23 02:03:59.36+00	2026-01-23 13:16:10.793+00
cmkq8lyww000aky044rmt43w9	8	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	cmkqwmex5002rl104akkbpxma	2026-01-23 02:03:59.36+00	2026-01-23 13:16:10.985+00
cmkq8lyww000bky04p396mcm6	9	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	cmkqwmf2h002tl104q29grqqp	2026-01-23 02:03:59.36+00	2026-01-23 13:16:11.178+00
cmkq8lyww000cky04254pwhbw	10	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	cmkqwmf7u002vl104uuvmbacs	2026-01-23 02:03:59.36+00	2026-01-23 13:16:11.37+00
cmkq8lyww000dky04cw4aqpkf	11	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd001xpg0bap4wue7r	cmkmmtnzd001wpg0b8opdootf	cmkqwmfd6002xl104u2ic68dj	2026-01-23 02:03:59.36+00	2026-01-23 13:16:11.562+00
cmkq8lyww000eky04hc760coq	12	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	cmkqwmfj5002zl104lgg201zx	2026-01-23 02:03:59.36+00	2026-01-23 13:16:11.778+00
cmkq8lyww000gky04xljglumf	14	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	cmkqwmftu0033l104gp3sdc7m	2026-01-23 02:03:59.36+00	2026-01-23 13:16:12.162+00
cmkq8lyww000hky04gykit30i	15	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	cmkqwmg4k0037l104dht5912s	2026-01-23 02:03:59.36+00	2026-01-23 13:16:12.549+00
cmkq8lyww000iky04s6w3ieu5	16	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	cmkqwmgf9003bl104yqhcnctu	2026-01-23 02:03:59.36+00	2026-01-23 13:16:12.933+00
cmkq8lyww000jky0456t10xwv	17	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	cmkqwmgkk003dl104z07a0tb3	2026-01-23 02:03:59.36+00	2026-01-23 13:16:13.125+00
cmkq8lyww000kky04xxipa22k	18	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	cmkqwmgxu003hl1045t8wrujs	2026-01-23 02:03:59.36+00	2026-01-23 13:16:13.603+00
cmkq8d71g0003ju04tfcvjn3s	1	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	cmkqwm7070003l10491fhw9cw	2026-01-23 01:57:09.987+00	2026-01-23 13:16:00.824+00
cmkq8lyww0003ky04cpwixki5	1	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	cmkqwm7az0005l104unelln4s	2026-01-23 02:03:59.36+00	2026-01-23 13:16:01.118+00
cmkq8d71g000aju04te7nydoe	8	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	cmkqwm87m000hl1049exnika3	2026-01-23 01:57:09.987+00	2026-01-23 13:16:02.291+00
cmkq8d71g000eju04r033wqwb	12	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	cmkqwm8tc000pl1043d3cp98x	2026-01-23 01:57:09.987+00	2026-01-23 13:16:03.073+00
cmkq8lyww000nky04w0t8yipf	21	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	cmkqwm9pn0011l104b8n7nrnt	2026-01-23 02:03:59.36+00	2026-01-23 13:16:04.235+00
cmkq8d71g000pju04afgnbq05	23	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	cmkqwmab50019l104gl6kyina	2026-01-23 01:57:09.987+00	2026-01-23 13:16:05.009+00
cmkq8lyww000uky047f8s5xv4	28	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000zpg0bmmqmfdh7	cmkmmtnzc000ypg0bscyvt3oh	cmkqwmbcz001nl104h8gr0tpw	2026-01-23 02:03:59.36+00	2026-01-23 13:16:06.371+00
cmkq8lyww0013ky04helnxcnd	37	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzc000hpg0beqyv1424	cmkmmtnzc000gpg0bp44hrav7	cmkqwmcp70025l104ib9go5g0	2026-01-23 02:03:59.36+00	2026-01-23 13:16:08.108+00
cmkq8lyww0008ky04fc9pm0nj	6	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd0027pg0b87s1ex9x	cmkmmtnzd0026pg0bedd3795f	cmkqwmeme002nl104y8emzaiw	2026-01-23 02:03:59.36+00	2026-01-23 13:16:10.599+00
cmkq8lyww000fky048d6jjx2z	13	dropoff	\N	cmkq8lyww0001ky049b6mcqcw	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	cmkqwmfoi0031l104y9s1igcx	2026-01-23 02:03:59.36+00	2026-01-23 13:16:11.97+00
cmkq8d71g000mju046xmmd9co	20	dropoff	\N	cmkq8d71f0001ju04cydhx8up	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	cmkqwmh8k003ll104l78kmsgb	2026-01-23 01:57:09.987+00	2026-01-23 13:16:13.988+00
cmkyihzze0006l6048wfiw2m6	4	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd002bpg0bw3xjvfsb	cmkmmtnzd002apg0bnlue5rom	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkrjjefr0004jl04zpmicm81	2	both	Bbbbbb	cmkrjjefr0001jl04mxyx84h3	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	cmkrjsfqt000wi9041ef376wr	2026-01-23 23:57:41.463+00	2026-01-24 00:04:43.156+00
cmkrjjefr000djl04zqkml0ev	11	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd001xpg0bap4wue7r	cmkmmtnzd001wpg0b8opdootf	cmkrjsgc10014i9044yk9kx9z	2026-01-23 23:57:41.463+00	2026-01-24 00:04:43.921+00
cmkrjjefr000ejl04a0s2575b	12	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	cmkrjsghc0016i904jlzx1b7z	2026-01-23 23:57:41.463+00	2026-01-24 00:04:44.111+00
cmkrjjefr000fjl04wb8scn76	13	pickup	Hbvuuj	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	cmkrjsgmm0018i904xty6xhi4	2026-01-23 23:57:41.463+00	2026-01-24 00:04:44.301+00
cmkrjjefr000gjl043pdoh2jv	14	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	cmkrjsgrx001ai904vigfhihw	2026-01-23 23:57:41.463+00	2026-01-24 00:04:44.493+00
cmkrjjefs000ijl04cx8v9yzn	16	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	cmkrjsh2h001ei9044jl3ff4h	2026-01-23 23:57:41.463+00	2026-01-24 00:04:44.872+00
cmkrjjefs000jjl04c8d995nv	17	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	cmkrjsh7r001gi904agk89pkf	2026-01-23 23:57:41.463+00	2026-01-24 00:04:45.062+00
cmkrjjefs000kjl04tpewg7sq	18	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	cmkrjshd1001ii904o32qj4yp	2026-01-23 23:57:41.463+00	2026-01-24 00:04:45.252+00
cmkrjjefs000ljl0493nekbpi	19	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	cmkrjshsw001oi904jj39rpoz	2026-01-23 23:57:41.463+00	2026-01-24 00:04:45.823+00
cmkrjjefs000mjl041j10nsvm	20	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	cmkrjsi3g001si9044axanmzt	2026-01-23 23:57:41.463+00	2026-01-24 00:04:46.204+00
cmkrjjefs000njl044zu5jiq3	21	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	cmkrjsi8q001ui904g4z548v4	2026-01-23 23:57:41.463+00	2026-01-24 00:04:46.393+00
cmkrjjefs000pjl0402a38hk4	23	both	Jggh	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	cmkrjsija001yi904t1mn7dn3	2026-01-23 23:57:41.463+00	2026-01-24 00:04:46.773+00
cmkrjjefs000qjl04pig2pods	24	both	Bvh	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	cmkrjsiok0020i904mwcbe9qt	2026-01-23 23:57:41.463+00	2026-01-24 00:04:46.962+00
cmkrjjefs000rjl04swkjjw7e	25	both	Ggv	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	cmkrjsitt0022i9049h70o5we	2026-01-23 23:57:41.463+00	2026-01-24 00:04:47.153+00
cmkrjjefs000sjl04mu2blpro	26	both	Hhg	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc0013pg0bo46voruk	cmkmmtnzc0012pg0b9g2rgur4	cmkrjsiz30024i904vz54fkx5	2026-01-23 23:57:41.463+00	2026-01-24 00:04:47.342+00
cmkrjjefs000tjl044jxhx7be	27	dropoff	Hbkujhh	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc0011pg0bk86bbnir	cmkmmtnzc0010pg0bj0tfcetm	cmkrjsj4c0026i9041f7d2kao	2026-01-23 23:57:41.463+00	2026-01-24 00:04:47.531+00
cmkrjjefs000ujl04nfunoxwj	28	both	Hvvnj	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000zpg0bmmqmfdh7	cmkmmtnzc000ypg0bscyvt3oh	cmkrjsj9m0028i9040hiogj47	2026-01-23 23:57:41.463+00	2026-01-24 00:04:47.722+00
cmkrjjefs000vjl04onhojoyu	29	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000xpg0b8h5uy5lh	cmkmmtnzc000wpg0b5nr80khx	cmkrjsjew002ai904czbl4jr2	2026-01-23 23:57:41.463+00	2026-01-24 00:04:47.912+00
cmkrjjefs000xjl04m0xdra6r	31	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000tpg0bjdxkto2c	cmkmmtnzc000spg0b3wxsq6ez	cmkrjsjph002ei904hgx0txfw	2026-01-23 23:57:41.463+00	2026-01-24 00:04:48.292+00
cmkrjjefs000yjl04iagoklv6	32	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000rpg0bsqqfcs7d	cmkmmtnzc000qpg0bjppqfaf1	cmkrjsjuq002gi904ek9efhe5	2026-01-23 23:57:41.463+00	2026-01-24 00:04:48.481+00
cmkrjjefs000zjl04fp8a7bxb	33	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000ppg0b7xfswolz	cmkmmtnzc000opg0b8qhmdsuc	cmkrjsk01002ii904xrv6y5sr	2026-01-23 23:57:41.463+00	2026-01-24 00:04:48.672+00
cmkrjjefs0010jl04bv80txkz	34	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000npg0b6tewaq4j	cmkmmtnzc000mpg0bm0owaa4z	cmkrjsk5b002ki904ccgpe1u1	2026-01-23 23:57:41.463+00	2026-01-24 00:04:48.862+00
cmkrjjefr0005jl04lvquw9sa	3	both	Ccc	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	cmkrjsm1h0032i904nj9dj1xc	2026-01-23 23:57:41.463+00	2026-01-24 00:04:51.317+00
cmkrjjefr0006jl0438mj3991	4	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd002bpg0bw3xjvfsb	cmkmmtnzd002apg0bnlue5rom	cmkrjsmha0038i904nbij6t2o	2026-01-23 23:57:41.463+00	2026-01-24 00:04:51.885+00
cmkrjjefr0007jl04gb2ub3xe	5	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	cmkrjsmmk003ai904mfqgi53s	2026-01-23 23:57:41.463+00	2026-01-24 00:04:52.075+00
cmkrjjefr0009jl04x7hlbbn4	7	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	cmkrjsmx2003ei904rdcq9ry5	2026-01-23 23:57:41.463+00	2026-01-24 00:04:52.453+00
cmkrjjefr000ajl04bonh5cdd	8	both	Yhhhg	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	cmkrjsn2j003gi904p4psme8o	2026-01-23 23:57:41.463+00	2026-01-24 00:04:52.65+00
cmkrjjefr000bjl043gk853o0	9	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	cmkrjsnix003mi9048p5uel3d	2026-01-23 23:57:41.463+00	2026-01-24 00:04:53.24+00
cmkrjjefr000cjl04b7xq4cxb	10	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	cmkrjsnth003qi90464q05jxj	2026-01-23 23:57:41.463+00	2026-01-24 00:04:53.62+00
cmkyihzze0007l6047mg5c85m	5	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkv447ry0008la04a738s667	6	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	cmkv462hx000dl504dgnqkb77	2026-01-26 11:57:03.454+00	2026-01-26 11:58:30.021+00
cmkv447ry0009la04iiza03pw	7	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	cmkv462n8000fl504frpj3lw8	2026-01-26 11:57:03.454+00	2026-01-26 11:58:30.212+00
cmkrjjefr0003jl04cb4lun6h	1	both	Aaaaa	cmkrjjefr0001jl04mxyx84h3	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	cmkrjsfgd000ui904c9n685do	2026-01-23 23:57:41.463+00	2026-01-24 00:04:42.873+00
cmkrjnnnh0007i904nbmsxm41	5	dropoff	Jhhh	cmkrjnnnh0001i904o79uo2rm	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	cmkrjsfw2000yi9041xa9bm4r	2026-01-24 00:01:00.029+00	2026-01-24 00:04:43.346+00
cmkrjnnnh0008i904jerjnlet	6	dropoff	Uhhh	cmkrjnnnh0001i904o79uo2rm	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	cmkrjsg1c0010i904trk2uzj4	2026-01-24 00:01:00.029+00	2026-01-24 00:04:43.536+00
cmkrjnnnh0009i904npdct8ht	7	dropoff	Ujjj	cmkrjnnnh0001i904o79uo2rm	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	cmkrjsg6m0012i904jklaxeh3	2026-01-24 00:01:00.029+00	2026-01-24 00:04:43.73+00
cmkrjjefr000hjl04outsv1mn	15	both	Uhhb	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	cmkrjsgx7001ci9045dwixjdd	2026-01-23 23:57:41.463+00	2026-01-24 00:04:44.682+00
cmkrjnnnh000ki904dlo91u9l	18	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	cmkrjshib001ki904n41yuhfk	2026-01-24 00:01:00.029+00	2026-01-24 00:04:45.442+00
cmkrjnnnh000li904q0p0j2x4	19	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	cmkrjshnm001mi904heodi9iu	2026-01-24 00:01:00.029+00	2026-01-24 00:04:45.633+00
cmkrjnnnh000mi904njpdo092	20	dropoff	Jnjjj	cmkrjnnnh0001i904o79uo2rm	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	cmkrjshy6001qi9046wddfh2p	2026-01-24 00:01:00.029+00	2026-01-24 00:04:46.013+00
cmkrjjefs000ojl04a8g1iktd	22	both	Jhhh	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	cmkrjsie1001wi904w6s9fpl5	2026-01-23 23:57:41.463+00	2026-01-24 00:04:46.584+00
cmkrjjefs000wjl046kumx0r9	30	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000vpg0ba51a0rf9	cmkmmtnzc000upg0bhhvedenk	cmkrjsjk7002ci904m1zkya54	2026-01-23 23:57:41.463+00	2026-01-24 00:04:48.102+00
cmkrjjefs0011jl04w1qu63tp	35	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000lpg0b3798nek4	cmkmmtnzc000kpg0bqjgrrw8k	cmkrjskam002mi9045f7k05lv	2026-01-23 23:57:41.463+00	2026-01-24 00:04:49.055+00
cmkrjjefs0012jl04kvrlxoc8	36	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000jpg0b4hqk04vp	cmkmmtnzc000ipg0bvf6mh1w5	cmkrjskfy002oi904ie34h8s6	2026-01-23 23:57:41.463+00	2026-01-24 00:04:49.246+00
cmkrjjefs0013jl040gv7dxi8	37	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000hpg0beqyv1424	cmkmmtnzc000gpg0bp44hrav7	cmkrjskl8002qi904kmm8v5fp	2026-01-23 23:57:41.463+00	2026-01-24 00:04:49.435+00
cmkrjjefs0014jl04u5m3naco	38	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	cmkrjskqi002si904yc0verr5	2026-01-23 23:57:41.463+00	2026-01-24 00:04:49.625+00
cmkrjjefs0015jl04b033ywkx	39	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	cmkrjskvt002ui904sjab0jvt	2026-01-23 23:57:41.463+00	2026-01-24 00:04:49.816+00
cmkrjnnnh0003i904jl2qvtqd	1	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	cmkrjslqy002yi904ukj7c3fn	2026-01-24 00:01:00.029+00	2026-01-24 00:04:50.937+00
cmkrjnnnh0004i90478t8w86o	2	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	cmkrjslw80030i904g29yvlqn	2026-01-24 00:01:00.029+00	2026-01-24 00:04:51.127+00
cmkrjnnnh0005i904fbrhmoie	3	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	cmkrjsm6s0034i90474ao5bb5	2026-01-24 00:01:00.029+00	2026-01-24 00:04:51.506+00
cmkrjnnnh0006i904xcczcyp5	4	dropoff	Yhhh	cmkrjnnnh0001i904o79uo2rm	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	cmkrjsmc10036i904ax5hu215	2026-01-24 00:01:00.029+00	2026-01-24 00:04:51.696+00
cmkrjjefr0008jl04cm9ah7dj	6	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzd0027pg0b87s1ex9x	cmkmmtnzd0026pg0bedd3795f	cmkrjsmrt003ci9042k1zzf6a	2026-01-23 23:57:41.463+00	2026-01-24 00:04:52.264+00
cmkrjnnnh000ai904wbg18mmk	8	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	cmkrjsn7t003ii9041rrg8jix	2026-01-24 00:01:00.029+00	2026-01-24 00:04:52.84+00
cmkrjnnnh000bi904hlcjls06	9	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	cmkrjsndl003ki904zt5gv1c4	2026-01-24 00:01:00.029+00	2026-01-24 00:04:53.049+00
cmkrjnnnh000ci904i19ltd2p	10	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	cmkrjsno7003oi904etq9cfuw	2026-01-24 00:01:00.029+00	2026-01-24 00:04:53.43+00
cmkrjnnnh000di904njfk8kz0	11	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	cmkrjsnyr003si9044wt473gv	2026-01-24 00:01:00.029+00	2026-01-24 00:04:53.81+00
cmkrjnnnh000ei9043p0rossw	12	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	cmkrjso47003ui9042gv7gdcg	2026-01-24 00:01:00.029+00	2026-01-24 00:04:54.006+00
cmkrjnnnh000fi90452170hig	13	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	cmkrjso9i003wi904s2kqkeli	2026-01-24 00:01:00.029+00	2026-01-24 00:04:54.2+00
cmkrjnnnh000gi9044g6h2mmh	14	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	cmkrjsoeu003yi9040xuu147r	2026-01-24 00:01:00.029+00	2026-01-24 00:04:54.389+00
cmkrjnnnh000hi9047vmohz5v	15	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	cmkrjsok40040i9046qz7a17x	2026-01-24 00:01:00.029+00	2026-01-24 00:04:54.58+00
cmkrjnnnh000ii904wc741q8x	16	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	cmkrjsopf0042i904gxv11ojt	2026-01-24 00:01:00.029+00	2026-01-24 00:04:54.772+00
cmkrjnnnh000ji904rs7xabse	17	dropoff	\N	cmkrjnnnh0001i904o79uo2rm	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	cmkrjsouq0044i904ntmlcgzy	2026-01-24 00:01:00.029+00	2026-01-24 00:04:54.961+00
cmkrjnnnh000ni904owyefbpr	21	dropoff	Uhhh	cmkrjnnnh0001i904o79uo2rm	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	cmkrjsozz0046i904gf1gygs5	2026-01-24 00:01:00.029+00	2026-01-24 00:04:55.151+00
cmkrjnnnh000oi904l8bhty9e	22	dropoff	Jjjj	cmkrjnnnh0001i904o79uo2rm	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	cmkrjsp590048i904aj6vxh8l	2026-01-24 00:01:00.029+00	2026-01-24 00:04:55.34+00
cmkrjnnnh000pi904schhrsht	23	dropoff	Jjjiu	cmkrjnnnh0001i904o79uo2rm	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	cmkrjspaj004ai904ggoncg9a	2026-01-24 00:01:00.029+00	2026-01-24 00:04:55.531+00
cmkrjnnnh000qi904gzyjo9tr	24	dropoff	Uhhh	cmkrjnnnh0001i904o79uo2rm	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	cmkrjspid004ci904pc7pr122	2026-01-24 00:01:00.029+00	2026-01-24 00:04:55.812+00
cmkrjjefs0016jl04vpmbk4tb	40	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	cmkrjspnn004ei9043dicgs92	2026-01-23 23:57:41.463+00	2026-01-24 00:04:56.003+00
cmkrjjefs0017jl040ye6gg80	41	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	cmkrjspsx004gi904izet0gkz	2026-01-23 23:57:41.463+00	2026-01-24 00:04:56.192+00
cmkrjjefs0018jl04tora8osu	42	both	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	cmkrjspye004ii904xb4nrwut	2026-01-23 23:57:41.463+00	2026-01-24 00:04:56.389+00
cmkrjjefs0019jl04m96tbpu9	43	dropoff	\N	cmkrjjefr0001jl04mxyx84h3	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	cmkrjsq3p004ki9049vbrwy5f	2026-01-23 23:57:41.463+00	2026-01-24 00:04:56.581+00
cmkv447rx0003la04ki0guyeh	1	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	cmkv461m60003l5043ak0doly	2026-01-26 11:57:03.454+00	2026-01-26 11:58:28.976+00
cmkv447rx0004la04ho3vd6cl	2	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	cmkv461wt0005l504ll5vqvn8	2026-01-26 11:57:03.454+00	2026-01-26 11:58:29.261+00
cmkv447ry0005la04cmy1zu4x	3	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	cmkv462240007l504qfwfsuf2	2026-01-26 11:57:03.454+00	2026-01-26 11:58:29.451+00
cmkv447ry0006la04xavyf6e4	4	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	cmkv4627e0009l504x3zger3w	2026-01-26 11:57:03.454+00	2026-01-26 11:58:29.641+00
cmkv447ry0007la04x461zquw	5	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	cmkv462cn000bl5047lifucby	2026-01-26 11:57:03.454+00	2026-01-26 11:58:29.831+00
cmkv447ry000ala04krccofjh	8	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	cmkv462sk000hl504asr21qs2	2026-01-26 11:57:03.454+00	2026-01-26 11:58:30.405+00
cmkv447ry000bla040i13wzi1	9	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	cmkv462xw000jl504la02jkyi	2026-01-26 11:57:03.454+00	2026-01-26 11:58:30.595+00
cmkv447ry000cla04dg0apx1o	10	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	cmkv46337000ll5044566v61q	2026-01-26 11:57:03.454+00	2026-01-26 11:58:30.786+00
cmkv447ry000dla04w9r7z8ek	11	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	cmkv4638h000nl504kktq4bch	2026-01-26 11:57:03.454+00	2026-01-26 11:58:30.975+00
cmkv447ry000ela04h8hs0qml	12	dropoff	\N	cmkv447rx0001la048yngmn8q	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	cmkv463dq000pl504ngiivmj5	2026-01-26 11:57:03.454+00	2026-01-26 11:58:31.165+00
cmkvqc16d0003jy04bfe3s491	1	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	cmkvqju7s002djx04o2opxgff	2026-01-26 22:18:59.701+00	2026-01-26 22:25:04.023+00
cmkvqetdx0003jx042jn2hdx7	1	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	cmkvqjud3002fjx04yacl9c85	2026-01-26 22:21:09.573+00	2026-01-26 22:25:04.213+00
cmkvqetdx0004jx04fp81ouym	2	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	cmkvqjuib002hjx04dvsmqu45	2026-01-26 22:21:09.573+00	2026-01-26 22:25:04.402+00
cmkvqc16d0004jy040ao5evnd	2	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	cmkvqjunk002jjx04v21fzz2t	2026-01-26 22:18:59.701+00	2026-01-26 22:25:04.591+00
cmkvqc16d0005jy04ip82shca	3	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	cmkvqjust002ljx040n1w85jc	2026-01-26 22:18:59.701+00	2026-01-26 22:25:04.779+00
cmkvqetdx0005jx04ap389ltk	3	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	cmkvqjuy1002njx04m2gkayf8	2026-01-26 22:21:09.573+00	2026-01-26 22:25:04.968+00
cmkvqc16d0006jy04p642ljds	4	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	cmkvqjv3a002pjx042kxjgnyo	2026-01-26 22:18:59.701+00	2026-01-26 22:25:05.159+00
cmkvqetdx0006jx04ndf32kk0	4	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd002bpg0bw3xjvfsb	cmkmmtnzd002apg0bnlue5rom	cmkvqjv8l002rjx04h9oycop4	2026-01-26 22:21:09.573+00	2026-01-26 22:25:05.348+00
cmkvqc16d0007jy04m3gvde35	5	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	cmkvqjvdu002tjx041pzfckex	2026-01-26 22:18:59.701+00	2026-01-26 22:25:05.537+00
cmkvqetdx0007jx04kn9nw4wp	5	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	cmkvqjvk1002vjx04vp3y6t6l	2026-01-26 22:21:09.573+00	2026-01-26 22:25:05.76+00
cmkvqetdx0008jx04di89incl	6	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd0027pg0b87s1ex9x	cmkmmtnzd0026pg0bedd3795f	cmkvqjvp9002xjx046h1u1i24	2026-01-26 22:21:09.573+00	2026-01-26 22:25:05.949+00
cmkvqc16d0008jy04efpsrzbz	6	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	cmkvqjvuj002zjx040v6hsie5	2026-01-26 22:18:59.701+00	2026-01-26 22:25:06.138+00
cmkvqc16d0009jy04zlq5i1p5	7	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	cmkvqjvzs0031jx04ercmqvm6	2026-01-26 22:18:59.701+00	2026-01-26 22:25:06.326+00
cmkvqetdx0009jx04yg9j01s3	7	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	cmkvqjw500033jx04pu0xp5sb	2026-01-26 22:21:09.573+00	2026-01-26 22:25:06.515+00
cmkvqc16d000ajy04y7aek5o7	8	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	cmkvqjwfh0037jx04mpwbiwag	2026-01-26 22:18:59.701+00	2026-01-26 22:25:06.892+00
cmkvqc16d000bjy04gwi6wtsm	9	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	cmkvqjwkw0039jx04bq29r2ik	2026-01-26 22:18:59.701+00	2026-01-26 22:25:07.087+00
cmkvqc16d000cjy04sw7mqgfk	10	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	cmkvqjwq5003bjx04kwl1e3ao	2026-01-26 22:18:59.701+00	2026-01-26 22:25:07.276+00
cmkvqc16d000djy0467cs3kox	11	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	cmkvqjwve003djx04xwkj1b8q	2026-01-26 22:18:59.701+00	2026-01-26 22:25:07.465+00
cmkvqc16d000ejy04ulvd0gnm	12	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	cmkvqjx0n003fjx04180bsck6	2026-01-26 22:18:59.701+00	2026-01-26 22:25:07.654+00
cmkvqc16d000fjy04ttpuh0d5	13	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	cmkvqjx5w003hjx04w1h3fd6f	2026-01-26 22:18:59.701+00	2026-01-26 22:25:07.849+00
cmkvqc16d000gjy042hbl5p5a	14	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	cmkvqjxbc003jjx04vefyhh1k	2026-01-26 22:18:59.701+00	2026-01-26 22:25:08.039+00
cmkvqc16d000hjy04toljvq41	15	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	cmkvqjxgl003ljx046zgsinjb	2026-01-26 22:18:59.701+00	2026-01-26 22:25:08.227+00
cmkvqc16d000ijy049r9kdv74	16	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	cmkvqjxlt003njx04qek7dyp3	2026-01-26 22:18:59.701+00	2026-01-26 22:25:08.416+00
cmkvqc16d000jjy040nswklv0	17	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	cmkvqjxr6003pjx04eup05sb5	2026-01-26 22:18:59.701+00	2026-01-26 22:25:08.608+00
cmkvqc16d000ljy04laqxpjgf	19	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	cmkvqjy1o003tjx04hn4frrn3	2026-01-26 22:18:59.701+00	2026-01-26 22:25:08.986+00
cmkvqc16d000mjy04ig3pa52x	20	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	cmkvqjy6w003vjx04i2xozclx	2026-01-26 22:18:59.701+00	2026-01-26 22:25:09.175+00
cmkvqc16d000njy04l5jjcf06	21	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	cmkvqjyc5003xjx040rg57etz	2026-01-26 22:18:59.701+00	2026-01-26 22:25:09.363+00
cmkvqc16d000ojy04met82414	22	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	cmkvqjyhi003zjx04yni396kv	2026-01-26 22:18:59.701+00	2026-01-26 22:25:09.557+00
cmkvqc16d000pjy04aenzx6ni	23	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	cmkvqjyn00041jx04f0bdm010	2026-01-26 22:18:59.701+00	2026-01-26 22:25:09.754+00
cmkvqc16d000qjy04mp7eisfl	24	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	cmkvqjys90043jx04hnp4yt9y	2026-01-26 22:18:59.701+00	2026-01-26 22:25:09.944+00
cmkyihzze0008l604tdes0xbj	6	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd0027pg0b87s1ex9x	cmkmmtnzd0026pg0bedd3795f	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0009l604hy68jd3o	7	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000al604bbaeuutb	8	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000bl604fp3awpol	9	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000cl604os4mi9hz	10	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000dl604319rcdyt	11	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd001xpg0bap4wue7r	cmkmmtnzd001wpg0b8opdootf	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkvqetdx000bjx04oj5bm0bh	9	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	cmkvqjpxl0011jx04a3koincp	2026-01-26 22:21:09.573+00	2026-01-26 22:24:58.568+00
cmkvqetdx000cjx04d9z8xxip	10	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	cmkvqjq840013jx04al92k1vc	2026-01-26 22:21:09.573+00	2026-01-26 22:24:58.85+00
cmkvqetdx000djx04itk82kal	11	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd001xpg0bap4wue7r	cmkmmtnzd001wpg0b8opdootf	cmkvqjqdd0015jx04z3n74mxu	2026-01-26 22:21:09.573+00	2026-01-26 22:24:59.04+00
cmkvqetdx000ejx04a6ymim0n	12	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	cmkvqjqim0017jx04a8rot5ro	2026-01-26 22:21:09.573+00	2026-01-26 22:24:59.229+00
cmkvqetdx000fjx04zcr3qocf	13	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	cmkvqjqnv0019jx047l0g3ei5	2026-01-26 22:21:09.573+00	2026-01-26 22:24:59.418+00
cmkvqetdx000gjx04kdw100tp	14	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	cmkvqjqt4001bjx04sg0f789a	2026-01-26 22:21:09.573+00	2026-01-26 22:24:59.607+00
cmkvqetdx000hjx04h8wrx6he	15	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	cmkvqjqyd001djx04yf9p0i0o	2026-01-26 22:21:09.573+00	2026-01-26 22:24:59.796+00
cmkvqetdx000ijx04k8inlw5f	16	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	cmkvqjr3m001fjx044c5fxyhw	2026-01-26 22:21:09.573+00	2026-01-26 22:24:59.985+00
cmkvqetdx000jjx04566budyv	17	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	cmkvqjr8w001hjx04oxf4u815	2026-01-26 22:21:09.573+00	2026-01-26 22:25:00.174+00
cmkvqetdx000kjx04gq5wgxrf	18	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	cmkvqjre4001jjx04kydi1gb0	2026-01-26 22:21:09.573+00	2026-01-26 22:25:00.362+00
cmkvqetdx000ljx0484i8agja	19	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	cmkvqjrjc001ljx045tfkcvbg	2026-01-26 22:21:09.573+00	2026-01-26 22:25:00.55+00
cmkvqetdx000mjx04p2kc1okd	20	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	cmkvqjrol001njx040wv3zyah	2026-01-26 22:21:09.573+00	2026-01-26 22:25:00.739+00
cmkvqetdx000njx0482gq9hb6	21	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	cmkvqjrtu001pjx04y90med6x	2026-01-26 22:21:09.573+00	2026-01-26 22:25:00.928+00
cmkvqetdx000ojx0402y5rath	22	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	cmkvqjrz2001rjx04giwp52i6	2026-01-26 22:21:09.573+00	2026-01-26 22:25:01.117+00
cmkvqetdx000pjx04qqzbv1km	23	both	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	cmkvqjs4b001tjx04daety42v	2026-01-26 22:21:09.573+00	2026-01-26 22:25:01.305+00
cmkvqetdx000qjx04l8ui6nib	24	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	cmkvqjs9k001vjx04w8rdd09y	2026-01-26 22:21:09.573+00	2026-01-26 22:25:01.494+00
cmkvqetdx000rjx04f639nvp5	25	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	cmkvqjses001xjx04pejxx1gc	2026-01-26 22:21:09.573+00	2026-01-26 22:25:01.682+00
cmkvqetdx000sjx04cpi9mfot	26	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	cmkvqjsk1001zjx049lhi0caa	2026-01-26 22:21:09.573+00	2026-01-26 22:25:01.872+00
cmkvqetdx000tjx04puqevtww	27	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	cmkvqjspa0021jx04g8isvrtq	2026-01-26 22:21:09.573+00	2026-01-26 22:25:02.06+00
cmkvqetdx000ujx048d0d1gg9	28	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	cmkvqjsuj0023jx04ohq39m8e	2026-01-26 22:21:09.573+00	2026-01-26 22:25:02.249+00
cmkvqetdx000vjx04jpdat0g6	29	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	cmkvqjszr0025jx04h1rxuebr	2026-01-26 22:21:09.573+00	2026-01-26 22:25:02.438+00
cmkvqetdx000wjx04mnhpllme	30	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	cmkvqjt500027jx04g9aemkdz	2026-01-26 22:21:09.573+00	2026-01-26 22:25:02.626+00
cmkvqetdx000xjx04xd5axd05	31	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	cmkvqjta90029jx04hlyzuemk	2026-01-26 22:21:09.573+00	2026-01-26 22:25:02.815+00
cmkvqetdx000ajx04cyge9sg6	8	dropoff	\N	cmkvqetdx0001jx04hvvj4kcc	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	cmkvqjwa90035jx04lk1tofkp	2026-01-26 22:21:09.573+00	2026-01-26 22:25:06.704+00
cmkvqc16d000kjy04wi3fgl4s	18	dropoff	\N	cmkvqc16d0001jy04bnx6l7c4	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	cmkvqjxwe003rjx0496ofmcfu	2026-01-26 22:18:59.701+00	2026-01-26 22:25:08.797+00
cmkwdt41w0007l604ba0kr9pc	4	both	\N	cmkwdt41w0001l604i23lcyak	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	cmkwm4e670001lb046dfhl8kc	2026-01-27 09:16:07.748+00	2026-01-27 13:08:51.195+00
cmkwdt41w0008l604s7yvbbct	5	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	cmkwm4egn0003lb04y9mvlr58	2026-01-27 09:16:07.748+00	2026-01-27 13:08:51.478+00
cmkwdt41w0009l604odar9cwn	6	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	cmkwm4elz0005lb04ryfp6r20	2026-01-27 09:16:07.748+00	2026-01-27 13:08:51.67+00
cmkyihzze000el6044dwkak1i	12	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000fl604utj7j84d	13	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000gl604nu9f7z9w	14	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000hl604eoxcdacq	15	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000il60475iswz3s	16	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000jl6040gu25okp	17	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000kl604ool637sy	18	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000ll6049pk6vpng	19	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000ml6049iza26s2	20	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000nl604nznb3tdm	21	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000ol604ljbowtz9	22	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000pl6044w0h4b55	23	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000ql6043hz9y0p9	24	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000rl604l9e2boov	25	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkwgagei0003kw04hlm8mx1q	1	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei0004kw04lq3e2lgc	2	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei0005kw04hb7x05em	3	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei0006kw041bsuf49s	4	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei0007kw04so5oju5v	5	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei0008kw046rzsio12	6	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei0009kw04tmenvt3h	7	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei000akw04wahiwo7v	8	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei000bkw04rt0urtqd	9	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei000ckw04edyi6wkc	10	dropoff	\N	cmkwgagei0001kw047mf51q3q	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwgagei000dkw04bz701q9x	11	pickup	\N	cmkwgagei0001kw047mf51q3q	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	\N	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkyihzze000sl604ltkg8yqj	26	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc0013pg0bo46voruk	cmkmmtnzc0012pg0b9g2rgur4	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000tl604qjtc9g9e	27	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc0011pg0bk86bbnir	cmkmmtnzc0010pg0bj0tfcetm	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000ul6048h39r9p6	28	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000zpg0bmmqmfdh7	cmkmmtnzc000ypg0bscyvt3oh	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000vl604ug1ngg1m	29	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000xpg0b8h5uy5lh	cmkmmtnzc000wpg0b5nr80khx	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000wl6044pb4e3q6	30	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000vpg0ba51a0rf9	cmkmmtnzc000upg0bhhvedenk	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000xl604v2p29wu4	31	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000tpg0bjdxkto2c	cmkmmtnzc000spg0b3wxsq6ez	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000yl604ilderzy8	32	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000rpg0bsqqfcs7d	cmkmmtnzc000qpg0bjppqfaf1	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze000zl604fcy1n9g5	33	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000ppg0b7xfswolz	cmkmmtnzc000opg0b8qhmdsuc	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0010l604rbxpdso9	34	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000npg0b6tewaq4j	cmkmmtnzc000mpg0bm0owaa4z	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0011l6046i0flmxq	35	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000lpg0b3798nek4	cmkmmtnzc000kpg0bqjgrrw8k	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0012l6047dk5vxnn	36	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000jpg0b4hqk04vp	cmkmmtnzc000ipg0bvf6mh1w5	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0013l604c9jud71g	37	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000hpg0beqyv1424	cmkmmtnzc000gpg0bp44hrav7	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkwlrtpn0001kz047wktz9xx	7	both	\N	cmkwdt41w0001l604i23lcyak	cmkwlqmys0001l704a4ay2d1c	cmkwlqmys0000l704htwnpczu	cmkwm4er90007lb04pbmj1fua	2026-01-27 12:59:04.619+00	2026-01-27 13:08:51.861+00
cmkwdt41w000kl6041k0slgpg	18	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	cmkwm4ewl0009lb04jo9ock9p	2026-01-27 09:16:07.748+00	2026-01-27 13:08:52.053+00
cmkyihzze0014l604eypqibhw	38	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0015l604z0upoyik	39	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0016l6049on9mhm9	40	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0017l604fifrmvje	41	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0018l604ck7g7o2v	42	both	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyihzze0019l604d3syk9c2	43	dropoff	\N	cmkyihzzd0001l604yowddk0j	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	\N	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkwdt41w0004l6046c5ibl0w	1	both	\N	cmkwdt41w0001l604i23lcyak	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:53.274+00
cmkwdt41w0005l6040eeh3pma	2	both	\N	cmkwdt41w0001l604i23lcyak	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:53.466+00
cmkwdt41w0006l6040va7xcwa	3	both	\N	cmkwdt41w0001l604i23lcyak	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:53.656+00
cmkwdt41w000al604tqb3u78x	8	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:53.85+00
cmkwdt41w000bl604fgnzpszm	9	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:54.041+00
cmkwdt41w000cl604zpfd4fhs	10	dropoff	poser sur une table	cmkwdt41w0001l604i23lcyak	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:54.231+00
cmkwdt41w000dl604qci7x7p8	11	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:54.424+00
cmkwdt41w000el6043a7i8dd0	12	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:54.616+00
cmkwdt41w000fl604462w9dg3	13	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:54.807+00
cmkwdt41w000gl604mo3msl20	14	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:54.998+00
cmkwdt41w000hl6045rubw5ho	15	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:55.19+00
cmkwdt41w000il6046ezqltvy	16	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:55.381+00
cmkwdt41w000jl60474komjxq	17	dropoff	\N	cmkwdt41w0001l604i23lcyak	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	\N	2026-01-27 09:16:07.748+00	2026-01-27 13:08:55.572+00
cmkyijtdz0008ie04fz30nwdx	6	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	cmkzil8e50003l804fn1cwqct	2026-01-28 21:04:24.455+00	2026-01-29 13:53:16.927+00
cmkyijtdz0009ie04t6ncjf0x	7	both	\N	cmkyijtdz0001ie0491u0zobl	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	cmkzil8ow0005l804df53y4nm	2026-01-28 21:04:24.455+00	2026-01-29 13:53:17.216+00
cmkyijtdz000aie04e6gtiglp	8	both	\N	cmkyijtdz0001ie0491u0zobl	cmkwlqmys0001l704a4ay2d1c	cmkwlqmys0000l704htwnpczu	cmkzil8u80007l804ka3srjwd	2026-01-28 21:04:24.455+00	2026-01-29 13:53:17.409+00
cmkyijtdz000mie04nsn25grw	20	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	cmkzil8zl0009l804lcpbuw63	2026-01-28 21:04:24.455+00	2026-01-29 13:53:17.603+00
cmkyijtdz000nie04h41tef3k	21	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	cmkzil94z000bl8046c663adm	2026-01-28 21:04:24.455+00	2026-01-29 13:53:17.796+00
cmkyijtdz0003ie0440wf8s64	1	both	\N	cmkyijtdz0001ie0491u0zobl	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	cmkziqp6l0003l8042sylxxyh	2026-01-28 21:04:24.455+00	2026-01-29 13:57:31.961+00
cmkyijtdz0004ie04555fxi20	2	both	\N	cmkyijtdz0001ie0491u0zobl	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	cmkziqph10005l804ya1kdykv	2026-01-28 21:04:24.455+00	2026-01-29 13:57:32.245+00
cmkyijtdz0005ie04yl0lvir3	3	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	cmkziqpmc0007l8046602ljx7	2026-01-28 21:04:24.455+00	2026-01-29 13:57:32.435+00
cmkyijtdz0006ie04jxu9sigt	4	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	cmkziqprm0009l804znbxxzy3	2026-01-28 21:04:24.455+00	2026-01-29 13:57:32.626+00
cmkyijtdz0007ie04oupbcyf4	5	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	cmkziqpwx000bl804u3xe5hrs	2026-01-28 21:04:24.455+00	2026-01-29 13:57:32.816+00
cmkyijtdz000bie04b7jkd8ue	9	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	cmkziqq27000dl8047xp06rgj	2026-01-28 21:04:24.455+00	2026-01-29 13:57:33.007+00
cmkyijtdz000cie04w9vcfi6y	10	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	cmkziqq7i000fl8047apx3cdc	2026-01-28 21:04:24.455+00	2026-01-29 13:57:33.198+00
cmkyijtdz000die04ixsd00sk	11	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	cmkziqqcs000hl804htmh155y	2026-01-28 21:04:24.455+00	2026-01-29 13:57:33.388+00
cmkyijtdz000eie047dfelxat	12	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	cmkziqqi3000jl80480edou3v	2026-01-28 21:04:24.455+00	2026-01-29 13:57:33.579+00
cmkyijtdz000fie04s6fqpvk5	13	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	cmkziqqnf000ll8048zjv1odl	2026-01-28 21:04:24.455+00	2026-01-29 13:57:33.77+00
cmkyijtdz000gie04gw0n02u6	14	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	cmkziqqsp000nl8041g51bly0	2026-01-28 21:04:24.455+00	2026-01-29 13:57:33.962+00
cmkyijtdz000hie043iuzx6f9	15	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	cmkziqqy1000pl804tas12j9j	2026-01-28 21:04:24.455+00	2026-01-29 13:57:34.152+00
cmkyijtdz000iie04khopyu3z	16	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	cmkziqr3b000rl8041mmsvlbq	2026-01-28 21:04:24.455+00	2026-01-29 13:57:34.342+00
cmkyijtdz000jie04z9d7odqe	17	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	cmkziqr8l000tl80473se0mtz	2026-01-28 21:04:24.455+00	2026-01-29 13:57:34.533+00
cmkyijtdz000kie049j16kadh	18	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	cmkziqrdv000vl804hpf87uvy	2026-01-28 21:04:24.455+00	2026-01-29 13:57:34.723+00
cmkyijtdz000lie04ep308c5g	19	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	cmkziqrj6000xl804rpiuln7m	2026-01-28 21:04:24.455+00	2026-01-29 13:57:34.914+00
cmkyijtdz000pie04ngcnk0ep	23	both	\N	cmkyijtdz0001ie0491u0zobl	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	cmkziqrtt0011l804172riwvg	2026-01-28 21:04:24.455+00	2026-01-29 13:57:35.296+00
cmkyijtdz000qie04zoc2b7j3	24	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	cmkziqrz40013l804ol1dbqk5	2026-01-28 21:04:24.455+00	2026-01-29 13:57:35.487+00
cmkyijtdz000rie046kxfr88r	25	dropoff	\N	cmkyijtdz0001ie0491u0zobl	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	cmkziqs4e0015l804wpqqbfcd	2026-01-28 21:04:24.455+00	2026-01-29 13:57:35.677+00
cmkyijtdz000oie04tpjeerc4	22	both	\N	cmkyijtdz0001ie0491u0zobl	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	cmkziqroh000zl804knot5il2	2026-01-28 21:04:24.455+00	2026-01-29 13:57:35.105+00
\.


--
-- Data for Name: delivery_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.delivery_requests (id, date, notes, client_company_id, delivery_company_id, created_at, updated_at) FROM stdin;
cmkpjgitl0007ky04n4r7b9lx	2026-01-21 23:00:00+00		cmkmmufqk0009pg0b7a5y9m2d	cmkmmtnzb0000pg0b8nz0429u	2026-01-22 14:19:54.826+00	2026-01-22 14:19:54.826+00
cmkp710fv0003ju04qyx10hox	2026-01-21 23:00:00+00		cmkmmtnzb0002pg0bqq1nopcy	cmkmmtnzb0000pg0b8nz0429u	2026-01-22 08:31:55.771+00	2026-01-22 16:43:44.12+00
cmkq8d71f0001ju04cydhx8up	2026-01-22 23:00:00+00		cmkmmufqk0009pg0b7a5y9m2d	cmkmmtnzb0000pg0b8nz0429u	2026-01-23 01:57:09.987+00	2026-01-23 01:57:09.987+00
cmkq8lyww0001ky049b6mcqcw	2026-01-22 23:00:00+00		cmkmmtnzb0002pg0bqq1nopcy	cmkmmtnzb0000pg0b8nz0429u	2026-01-23 02:03:59.36+00	2026-01-23 02:03:59.36+00
cmkrjjefr0001jl04mxyx84h3	2026-01-23 23:00:00+00	Bon courage	cmkmmtnzb0002pg0bqq1nopcy	cmkmmtnzb0000pg0b8nz0429u	2026-01-23 23:57:41.463+00	2026-01-23 23:57:41.463+00
cmkrjnnnh0001i904o79uo2rm	2026-01-23 23:00:00+00		cmkmmufqk0009pg0b7a5y9m2d	cmkmmtnzb0000pg0b8nz0429u	2026-01-24 00:01:00.029+00	2026-01-24 00:01:00.029+00
cmkv447rx0001la048yngmn8q	2026-01-25 23:00:00+00	Bon courage	cmkmmufqk0009pg0b7a5y9m2d	cmkmmtnzb0000pg0b8nz0429u	2026-01-26 11:57:03.454+00	2026-01-26 11:57:03.454+00
cmkvqc16d0001jy04bnx6l7c4	2026-01-26 12:00:00+00	+ Collecte Annecy	cmkmmufqk0009pg0b7a5y9m2d	cmkmmtnzb0000pg0b8nz0429u	2026-01-26 22:18:59.701+00	2026-01-26 22:18:59.701+00
cmkvqetdx0001jx04hvvj4kcc	2026-01-26 12:00:00+00	+ Collecte Thonon les bains 	cmkmmtnzb0002pg0bqq1nopcy	cmkmmtnzb0000pg0b8nz0429u	2026-01-26 22:21:09.573+00	2026-01-26 22:21:09.573+00
cmkwgagei0001kw047mf51q3q	2026-01-28 12:00:00+00		cmkmmufqk0009pg0b7a5y9m2d	cmkmmtnzb0000pg0b8nz0429u	2026-01-27 10:25:36.138+00	2026-01-27 10:25:36.138+00
cmkwdt41w0001l604i23lcyak	2026-01-27 12:00:00+00		cmkmmufqk0009pg0b7a5y9m2d	cmkmmtnzb0000pg0b8nz0429u	2026-01-27 09:16:07.748+00	2026-01-27 12:59:05.956+00
cmkyihzzd0001l604yowddk0j	2026-01-28 12:00:00+00	Salut	cmkmmtnzb0002pg0bqq1nopcy	cmkmmtnzb0000pg0b8nz0429u	2026-01-28 21:02:59.69+00	2026-01-28 21:02:59.69+00
cmkyijtdz0001ie0491u0zobl	2026-01-29 12:00:00+00	Bonjour !	cmkmmufqk0009pg0b7a5y9m2d	cmkmmtnzb0000pg0b8nz0429u	2026-01-28 21:04:24.455+00	2026-01-28 21:04:24.455+00
\.


--
-- Data for Name: stops; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stops (id, sequence, type, status, notes, driver_notes, completed_at, image_url, delivery_id, address_id, end_client_id, created_at, updated_at) FROM stdin;
cmkqwmgxu003hl1045t8wrujs	21	dropoff	delivered	\N		2026-01-23 23:48:04.326+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	2026-01-23 13:16:13.507+00	2026-01-23 23:48:04.327+00
cmkqwmab50019l104gl6kyina	22	dropoff	delivered	\N		2026-01-23 23:44:05.309+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	2026-01-23 13:16:04.913+00	2026-01-23 23:44:05.31+00
cmkqwmagi001bl104pdz4yizn	23	dropoff	delivered	\N		2026-01-23 23:44:09.21+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	2026-01-23 13:16:05.106+00	2026-01-23 23:44:09.211+00
cmkqwmalw001dl10471zgrfgt	24	dropoff	delivered	\N		2026-01-23 23:44:13.368+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	2026-01-23 13:16:05.3+00	2026-01-23 23:44:13.37+00
cmkqwmar9001fl104m1jmkhss	25	dropoff	delivered	\N		2026-01-23 23:44:19.671+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	2026-01-23 13:16:05.494+00	2026-01-23 23:44:19.673+00
cmkqwmawn001hl104dlrj4iep	26	dropoff	delivered	\N		2026-01-23 23:44:23.354+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	2026-01-23 13:16:05.687+00	2026-01-23 23:44:23.355+00
cmkqwmb27001jl104baoz23up	27	dropoff	delivered	\N		2026-01-23 23:44:27.056+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc0013pg0bo46voruk	cmkmmtnzc0012pg0b9g2rgur4	2026-01-23 13:16:05.887+00	2026-01-23 23:44:27.057+00
cmkqwmb7k001ll104hhxx5e4e	28	dropoff	delivered	\N		2026-01-23 23:44:31.005+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc0011pg0bk86bbnir	cmkmmtnzc0010pg0bj0tfcetm	2026-01-23 13:16:06.08+00	2026-01-23 23:44:31.007+00
cmkqwmbcz001nl104h8gr0tpw	29	dropoff	delivered	\N		2026-01-23 23:44:34.85+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000zpg0bmmqmfdh7	cmkmmtnzc000ypg0bscyvt3oh	2026-01-23 13:16:06.275+00	2026-01-23 23:44:34.851+00
cmkqwmbib001pl104auj4v7w2	30	dropoff	delivered	\N		2026-01-23 23:44:38.869+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000xpg0b8h5uy5lh	cmkmmtnzc000wpg0b5nr80khx	2026-01-23 13:16:06.468+00	2026-01-23 23:44:38.871+00
cmkqwmbnp001rl104b4vb3ksm	31	dropoff	delivered	\N		2026-01-23 23:44:45.441+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000vpg0ba51a0rf9	cmkmmtnzc000upg0bhhvedenk	2026-01-23 13:16:06.661+00	2026-01-23 23:44:45.443+00
cmkqwm7az0005l104unelln4s	2	dropoff	delivered	\N		2026-01-23 19:12:01.246+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	2026-01-23 13:16:01.019+00	2026-01-23 19:12:01.248+00
cmkqwmbye001vl104cncqmosf	33	dropoff	delivered	\N		2026-01-23 23:44:56.016+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000rpg0bsqqfcs7d	cmkmmtnzc000qpg0bjppqfaf1	2026-01-23 13:16:07.047+00	2026-01-23 23:44:56.018+00
cmkqwm7gq0007l104auv0hl35	3	dropoff	delivered	\N		2026-01-23 19:12:07.619+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	2026-01-23 13:16:01.227+00	2026-01-23 19:12:07.621+00
cmkqwm7m50009l104rxe3qr59	4	dropoff	delivered	\N		2026-01-23 19:12:12.26+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	2026-01-23 13:16:01.422+00	2026-01-23 19:12:12.262+00
cmkqwmc3q001xl104rxw3nrzr	34	dropoff	delivered	\N		2026-01-23 23:44:59.443+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000ppg0b7xfswolz	cmkmmtnzc000opg0b8qhmdsuc	2026-01-23 13:16:07.239+00	2026-01-23 23:44:59.444+00
cmkqwm7wx000dl104zaeum6r5	6	dropoff	delivered	\N		2026-01-23 19:13:29.669+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	2026-01-23 13:16:01.809+00	2026-01-23 19:13:29.671+00
cmkqwmc95001zl104vbt9bgf0	35	dropoff	delivered	\N		2026-01-23 23:45:06.86+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000npg0b6tewaq4j	cmkmmtnzc000mpg0bm0owaa4z	2026-01-23 13:16:07.433+00	2026-01-23 23:45:06.861+00
cmkqwm829000fl104fe0b2vo7	7	dropoff	delivered	\N		2026-01-23 19:13:34.961+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	2026-01-23 13:16:02.001+00	2026-01-23 19:13:34.963+00
cmkqwm87m000hl1049exnika3	8	dropoff	delivered	\N		2026-01-23 19:13:43.459+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	2026-01-23 13:16:02.194+00	2026-01-23 19:13:43.461+00
cmkqwmceh0021l104ufd60s0w	36	dropoff	delivered	\N		2026-01-23 23:45:10.465+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000lpg0b3798nek4	cmkmmtnzc000kpg0bqjgrrw8k	2026-01-23 13:16:07.626+00	2026-01-23 23:45:10.466+00
cmkqwm8cz000jl104d2169dlr	9	dropoff	delivered	\N		2026-01-23 23:42:59.192+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	2026-01-23 13:16:02.388+00	2026-01-23 23:42:59.194+00
cmkqwm8ij000ll104xgrmh6fl	10	dropoff	delivered	\N		2026-01-23 23:43:07.591+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	2026-01-23 13:16:02.588+00	2026-01-23 23:43:07.594+00
cmkqwmcju0023l104rpbia9sn	37	dropoff	delivered	\N		2026-01-23 23:45:14.343+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000jpg0b4hqk04vp	cmkmmtnzc000ipg0bvf6mh1w5	2026-01-23 13:16:07.818+00	2026-01-23 23:45:14.344+00
cmkqwm8nz000nl104pjn2ynf9	11	dropoff	delivered	\N		2026-01-23 23:43:14.214+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	2026-01-23 13:16:02.784+00	2026-01-23 23:43:14.216+00
cmkqwm8tc000pl1043d3cp98x	12	dropoff	delivered	\N		2026-01-23 23:43:18.252+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	2026-01-23 13:16:02.977+00	2026-01-23 23:43:18.254+00
cmkqwmcp70025l104ib9go5g0	38	dropoff	delivered	\N		2026-01-23 23:45:20.084+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000hpg0beqyv1424	cmkmmtnzc000gpg0bp44hrav7	2026-01-23 13:16:08.012+00	2026-01-23 23:45:20.085+00
cmkqwm943000tl104datuksx8	14	dropoff	delivered	\N		2026-01-23 23:43:26.295+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	2026-01-23 13:16:03.364+00	2026-01-23 23:43:26.296+00
cmkqwmcuk0027l104l5tugl8q	39	dropoff	delivered	\N		2026-01-23 23:45:24.826+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	2026-01-23 13:16:08.204+00	2026-01-23 23:45:24.827+00
cmkqwm99h000vl1044bsincmt	15	dropoff	delivered	\N		2026-01-23 23:43:34.208+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	2026-01-23 13:16:03.558+00	2026-01-23 23:43:34.209+00
cmkqwm9eu000xl104gc3o8m3c	16	dropoff	delivered	\N		2026-01-23 23:43:38.675+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	2026-01-23 13:16:03.75+00	2026-01-23 23:43:38.676+00
cmkqwmczy0029l104h84ibs7n	40	dropoff	delivered	\N		2026-01-23 23:45:28.629+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	2026-01-23 13:16:08.398+00	2026-01-23 23:45:28.63+00
cmkqwm9k8000zl104qvuyzdd0	17	dropoff	delivered	\N		2026-01-23 23:43:45.994+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	2026-01-23 13:16:03.944+00	2026-01-23 23:43:45.996+00
cmkqwm9pn0011l104b8n7nrnt	18	dropoff	delivered	\N		2026-01-23 23:43:50.133+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	2026-01-23 13:16:04.139+00	2026-01-23 23:43:50.134+00
cmkqwmdvn002dl104ews5zb56	1	dropoff	delivered	\N		2026-01-23 23:46:30.036+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	2026-01-23 13:16:09.539+00	2026-01-23 23:46:30.039+00
cmkqwm9v10013l104lpr5cksr	19	dropoff	delivered	\N		2026-01-23 23:43:53.738+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	2026-01-23 13:16:04.333+00	2026-01-23 23:43:53.74+00
cmkqwma0f0015l104qywn20lx	20	dropoff	delivered	\N		2026-01-23 23:43:57.211+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	2026-01-23 13:16:04.528+00	2026-01-23 23:43:57.213+00
cmkqwme11002fl104qf86ca3d	2	dropoff	delivered	\N		2026-01-23 23:46:42.315+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	2026-01-23 13:16:09.734+00	2026-01-23 23:46:42.317+00
cmkqwmebq002jl104bbyq8h11	4	dropoff	delivered	\N		2026-01-23 23:46:49.679+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd002bpg0bw3xjvfsb	cmkmmtnzd002apg0bnlue5rom	2026-01-23 13:16:10.118+00	2026-01-23 23:46:49.68+00
cmkqwmeh3002ll10451tfm78l	5	dropoff	delivered	\N		2026-01-23 23:46:55.873+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	2026-01-23 13:16:10.311+00	2026-01-23 23:46:55.875+00
cmkqwmeme002nl104y8emzaiw	6	dropoff	delivered	\N		2026-01-23 23:47:01.047+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd0027pg0b87s1ex9x	cmkmmtnzd0026pg0bedd3795f	2026-01-23 13:16:10.503+00	2026-01-23 23:47:01.049+00
cmkqwmerr002pl104ywlon43u	7	dropoff	delivered	\N		2026-01-23 23:47:05.075+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	2026-01-23 13:16:10.695+00	2026-01-23 23:47:05.076+00
cmkpop90y003tjo04h084v8r1	4	both	delivered	\N		2026-01-22 16:55:17.863+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	2026-01-22 16:46:40.114+00	2026-01-22 16:55:17.864+00
cmkpop967003vjo04rjmlbagj	5	both	delivered	567		2026-01-22 16:55:33.508+00	\N	cmkpme9wb0001l404rj92vmym	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	2026-01-22 16:46:40.304+00	2026-01-22 16:55:33.509+00
cmkpop9bh003xjo048cksgic9	6	both	delivered	\N	1	2026-01-22 16:55:55.017+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	2026-01-22 16:46:40.494+00	2026-01-22 16:55:55.019+00
cmkpop9gr003zjo04ob24jujp	7	dropoff	delivered	123		2026-01-22 16:56:01.192+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	2026-01-22 16:46:40.683+00	2026-01-22 16:56:01.193+00
cmkpop9m10041jo04h4zklpq3	8	both	delivered	\N		2026-01-22 16:56:12.049+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	2026-01-22 16:46:40.874+00	2026-01-22 16:56:12.051+00
cmkpop9rr0043jo04kgjbkg7f	9	both	delivered	\N		2026-01-22 16:56:16.793+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	2026-01-22 16:46:41.079+00	2026-01-22 16:56:16.795+00
cmkpop9x10045jo04qvezp4z6	10	both	delivered	\N		2026-01-22 16:56:27.221+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	2026-01-22 16:46:41.269+00	2026-01-22 16:56:27.223+00
cmkpopa2a0047jo045v0o4q0j	11	both	delivered	\N		2026-01-22 16:56:42.661+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	2026-01-22 16:46:41.459+00	2026-01-22 16:56:42.663+00
cmkqwmf2h002tl104q29grqqp	9	dropoff	delivered	\N		2026-01-23 23:47:12.953+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	2026-01-23 13:16:11.081+00	2026-01-23 23:47:12.954+00
cmkqwmf7u002vl104uuvmbacs	10	dropoff	delivered	\N		2026-01-23 23:47:16.867+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	2026-01-23 13:16:11.274+00	2026-01-23 23:47:16.869+00
cmkqwmfd6002xl104u2ic68dj	11	dropoff	delivered	\N		2026-01-23 23:47:20.493+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd001xpg0bap4wue7r	cmkmmtnzd001wpg0b8opdootf	2026-01-23 13:16:11.466+00	2026-01-23 23:47:20.497+00
cmkqwmfj5002zl104lgg201zx	12	dropoff	delivered	\N		2026-01-23 23:47:27.415+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	2026-01-23 13:16:11.682+00	2026-01-23 23:47:27.416+00
cmkqwmfoi0031l104y9s1igcx	13	dropoff	delivered	\N		2026-01-23 23:47:30.99+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	2026-01-23 13:16:11.874+00	2026-01-23 23:47:30.992+00
cmkpopa7k0049jo04mk51r8xv	12	both	delivered	\N		2026-01-22 16:57:25.011+00	https://www.storage.tds-transports.fr/1012123d-c73e-4e76-b20d-052527fcdf4f.avif	cmkpme9wb0001l404rj92vmym	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	2026-01-22 16:46:41.649+00	2026-01-22 16:57:25.013+00
cmkqwmftu0033l104gp3sdc7m	14	dropoff	delivered	\N		2026-01-23 23:47:35.218+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	2026-01-23 13:16:12.066+00	2026-01-23 23:47:35.22+00
cmkpopacu004bjo04wp5ei0yb	13	both	delivered	\N		2026-01-22 16:58:07.199+00	\N	cmkpme9wb0001l404rj92vmym	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	2026-01-22 16:46:41.838+00	2026-01-22 16:58:07.2+00
cmkpopai3004djo049s9xxkqa	14	both	delivered	\N		2026-01-22 16:58:32.833+00	\N	cmkpme9wb0001l404rj92vmym	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	2026-01-22 16:46:42.028+00	2026-01-22 16:58:32.835+00
cmkqwmfz80035l104at2xsnbh	15	dropoff	delivered	\N		2026-01-23 23:47:38.976+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	2026-01-23 13:16:12.26+00	2026-01-23 23:47:38.977+00
cmkpopane004fjo044d3vq243	15	both	delivered	\N		2026-01-22 16:59:45.099+00	\N	cmkpme9wb0001l404rj92vmym	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	2026-01-22 16:46:42.218+00	2026-01-22 16:59:45.1+00
cmkpopaso004hjo047upwfwul	16	both	delivered	\N		2026-01-22 17:00:52.047+00	\N	cmkpme9wb0001l404rj92vmym	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	2026-01-22 16:46:42.408+00	2026-01-22 17:00:52.049+00
cmkqwmg4k0037l104dht5912s	16	dropoff	delivered	\N		2026-01-23 23:47:42.52+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	2026-01-23 13:16:12.452+00	2026-01-23 23:47:42.522+00
cmkpopaxx004jjo04qgv68ygo	17	both	delivered	\N		2026-01-22 17:01:03.418+00	\N	cmkpme9wb0001l404rj92vmym	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	2026-01-22 16:46:42.597+00	2026-01-22 17:01:03.419+00
cmkpopb37004ljo04idi451mb	18	both	delivered	\N	2	2026-01-22 17:01:55.762+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	2026-01-22 16:46:42.787+00	2026-01-22 17:01:55.763+00
cmkqwmg9x0039l104jws2xtq6	17	dropoff	delivered	\N		2026-01-23 23:47:45.856+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	2026-01-23 13:16:12.645+00	2026-01-23 23:47:45.858+00
cmkpopb8h004njo04th7t903l	19	both	delivered	\N		2026-01-22 17:02:08.431+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	2026-01-22 16:46:42.977+00	2026-01-22 17:02:08.432+00
cmkpopbdq004pjo04s71pqfj6	20	both	delivered	\N		2026-01-22 17:02:22.307+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	2026-01-22 16:46:43.167+00	2026-01-22 17:02:22.308+00
cmkpop8qd003pjo040u765hb7	2	both	delivered	234		2026-01-22 16:54:04.055+00	\N	cmkpme9wb0001l404rj92vmym	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	2026-01-22 16:46:39.734+00	2026-01-22 16:54:04.056+00
cmkpopbj0004rjo04lrfz5zow	21	dropoff	delivered	\N		2026-01-22 17:02:28.102+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	2026-01-22 16:46:43.356+00	2026-01-22 17:02:28.103+00
cmkpop8vo003rjo04d1mi38l5	3	both	delivered	\N		2026-01-22 16:54:29.066+00	\N	cmkpme9wb0001l404rj92vmym	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	2026-01-22 16:46:39.924+00	2026-01-22 16:54:29.067+00
cmkpopboa004tjo04yxe2baxs	22	both	delivered	\N		2026-01-22 17:02:32.95+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	2026-01-22 16:46:43.546+00	2026-01-22 17:02:32.951+00
cmkpopbtk004vjo0496lktjm3	23	dropoff	delivered	\N		2026-01-22 17:02:37.035+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	2026-01-22 16:46:43.737+00	2026-01-22 17:02:37.036+00
cmkpopbyu004xjo04n9rd30ki	24	both	delivered	\N		2026-01-22 17:02:43.411+00	\N	cmkpme9wb0001l404rj92vmym	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	2026-01-22 16:46:43.927+00	2026-01-22 17:02:43.413+00
cmkpopc44004zjo04jidn4up7	25	dropoff	delivered	\N		2026-01-22 17:02:48.96+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	2026-01-22 16:46:44.117+00	2026-01-22 17:02:48.961+00
cmkpopc9e0051jo04c6c36gqe	26	dropoff	delivered	\N		2026-01-22 17:02:53.969+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	2026-01-22 16:46:44.306+00	2026-01-22 17:02:53.97+00
cmkpopceo0053jo04yjcu05tf	27	both	delivered	\N		2026-01-22 17:02:58.555+00	\N	cmkpme9wb0001l404rj92vmym	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	2026-01-22 16:46:44.497+00	2026-01-22 17:02:58.557+00
cmkpopcku0055jo04kngu72wv	28	dropoff	delivered	\N		2026-01-22 17:03:03.941+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	2026-01-22 16:46:44.719+00	2026-01-22 17:03:03.943+00
cmkpopcq40057jo04oot8vqx9	29	both	delivered	\N		2026-01-22 17:03:11.813+00	\N	cmkpme9wb0001l404rj92vmym	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	2026-01-22 16:46:44.908+00	2026-01-22 17:03:11.815+00
cmkpopcve0059jo04jngpao73	30	dropoff	delivered	\N		2026-01-22 17:03:21.074+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	2026-01-22 16:46:45.098+00	2026-01-22 17:03:21.075+00
cmkpopd0o005bjo04ts3j9v59	31	both	delivered	\N		2026-01-22 17:03:26.403+00	\N	cmkpme9wb0001l404rj92vmym	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	2026-01-22 16:46:45.288+00	2026-01-22 17:03:26.405+00
cmkpopd5y005djo042skm5cc1	32	both	delivered	\N		2026-01-22 17:03:30.41+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	2026-01-22 16:46:45.478+00	2026-01-22 17:03:30.412+00
cmkpopdb8005fjo0440z09bl7	33	both	delivered	\N		2026-01-22 17:03:34.571+00	\N	cmkpme9wb0001l404rj92vmym	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	2026-01-22 16:46:45.668+00	2026-01-22 17:03:34.572+00
cmkpopdr3005ljo04j6e1ld8q	36	both	delivered	\N		2026-01-22 17:05:20.026+00	\N	cmkpme9wb0001l404rj92vmym	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	2026-01-22 16:46:46.24+00	2026-01-22 17:05:20.028+00
cmkpopdgi005hjo04gifh1oyi	34	both	delivered	\N		2026-01-22 17:04:09.396+00	https://www.storage.tds-transports.fr/af8d2ff7-e5b6-40a2-bb08-3660afcf8e7d.avif	cmkpme9wb0001l404rj92vmym	cmkmmtnzc0013pg0bo46voruk	cmkmmtnzc0012pg0b9g2rgur4	2026-01-22 16:46:45.858+00	2026-01-22 17:04:09.398+00
cmkqwma5s0017l1041vhqptgi	21	dropoff	delivered	\N		2026-01-23 23:44:01.539+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	2026-01-23 13:16:04.72+00	2026-01-23 23:44:01.54+00
cmkpopdlu005jjo04a9c3bqb7	35	both	delivered	\N		2026-01-22 17:04:18.186+00	\N	cmkpme9wb0001l404rj92vmym	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	2026-01-22 16:46:46.05+00	2026-01-22 17:04:18.187+00
cmkvqjta90029jx04hlyzuemk	23	dropoff	delivered	\N		2026-01-26 22:29:04.467+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	2026-01-26 22:25:02.721+00	2026-01-26 22:29:04.469+00
cmkpopdwd005njo04k34vbkv3	37	both	delivered	\N		2026-01-22 17:05:39.372+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc0011pg0bk86bbnir	cmkmmtnzc0010pg0bj0tfcetm	2026-01-22 16:46:46.43+00	2026-01-22 17:05:39.373+00
cmkqwmgkk003dl104z07a0tb3	19	dropoff	delivered	\N		2026-01-23 23:47:53.571+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	2026-01-23 13:16:13.029+00	2026-01-23 23:47:53.572+00
cmkpope1p005pjo04bdjvhpi7	38	both	delivered	\N		2026-01-22 17:05:56.512+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000zpg0bmmqmfdh7	cmkmmtnzc000ypg0bscyvt3oh	2026-01-22 16:46:46.621+00	2026-01-22 17:05:56.514+00
cmkqwmh37003jl104d1bd1c2q	22	dropoff	delivered	\N		2026-01-23 23:48:18.108+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	2026-01-23 13:16:13.699+00	2026-01-23 23:48:18.11+00
cmkpope6z005rjo046a1p2ocl	39	both	delivered	\N		2026-01-22 17:06:00.585+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000xpg0b8h5uy5lh	cmkmmtnzc000wpg0b5nr80khx	2026-01-22 16:46:46.811+00	2026-01-22 17:06:00.586+00
cmkqwmgsi003fl1043wpoklj4	20	dropoff	delivered	\N		2026-01-23 23:47:58.073+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	2026-01-23 13:16:13.221+00	2026-01-23 23:47:58.075+00
cmkpopec9005tjo04j8ch2arc	40	both	delivered	\N		2026-01-22 17:06:07.781+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000vpg0ba51a0rf9	cmkmmtnzc000upg0bhhvedenk	2026-01-22 16:46:47.001+00	2026-01-22 17:06:07.782+00
cmkpopehj005vjo042rvxanm1	41	dropoff	delivered	\N		2026-01-22 17:07:11.407+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000tpg0bjdxkto2c	cmkmmtnzc000spg0b3wxsq6ez	2026-01-22 16:46:47.191+00	2026-01-22 17:07:11.408+00
cmkpopems005xjo04r5osthid	42	dropoff	delivered	\N		2026-01-22 17:07:24.512+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000rpg0bsqqfcs7d	cmkmmtnzc000qpg0bjppqfaf1	2026-01-22 16:46:47.381+00	2026-01-22 17:07:24.513+00
cmkqwmh8k003ll104l78kmsgb	23	dropoff	delivered	\N		2026-01-23 23:48:24.994+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	2026-01-23 13:16:13.892+00	2026-01-23 23:48:24.995+00
cmkpopi35006xjo04vqqlxf92	12	both	delivered	\N		2026-01-23 01:47:36.794+00	\N	cmkpnfv3w002fl804cjkwalav	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	2026-01-22 16:46:51.857+00	2026-01-23 01:47:36.795+00
cmkqwmhe0003nl1042t6ocz74	24	dropoff	delivered	\N		2026-01-23 23:48:30.197+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	2026-01-23 13:16:14.088+00	2026-01-23 23:48:30.198+00
cmkqwmhjc003pl104fwmwld1f	25	dropoff	delivered	\N		2026-01-23 23:48:34.998+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	2026-01-23 13:16:14.28+00	2026-01-23 23:48:34.999+00
cmkpophnb006rjo042d4cltra	3	dropoff	delivered	\N		2026-01-22 23:02:37.543+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	2026-01-22 16:46:51.287+00	2026-01-22 23:02:37.547+00
cmkqwmhoo003rl1043xd58415	26	dropoff	delivered	\N		2026-01-23 23:48:39.108+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	2026-01-23 13:16:14.472+00	2026-01-23 23:48:39.11+00
cmkpopesp005zjo043s9bysb6	43	dropoff	delivered	\N		2026-01-22 17:07:32.438+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000ppg0b7xfswolz	cmkmmtnzc000opg0b8qhmdsuc	2026-01-22 16:46:47.593+00	2026-01-22 17:07:32.439+00
cmkpoph7f006ljo04jn0ahf4g	6	both	delivered	\N		2026-01-23 01:30:06.188+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	2026-01-22 16:46:50.716+00	2026-01-23 01:30:06.191+00
cmkpopexz0061jo04vyedz03b	44	dropoff	delivered	\N		2026-01-22 17:07:40.875+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000npg0b6tewaq4j	cmkmmtnzc000mpg0bm0owaa4z	2026-01-22 16:46:47.783+00	2026-01-22 17:07:40.876+00
cmkpopf390063jo04y9qxz7ft	45	dropoff	delivered	\N		2026-01-22 17:07:45.059+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000lpg0b3798nek4	cmkmmtnzc000kpg0bqjgrrw8k	2026-01-22 16:46:47.973+00	2026-01-22 17:07:45.06+00
cmkpopfof006bjo041dxjy00d	0	dropoff	delivered	\N	+ Collecte	2026-01-22 16:52:56.205+00	https://www.storage.tds-transports.fr/7ed386e2-a2e6-4069-b40e-9d7b84a895c3.avif	cmkpme9wb0001l404rj92vmym	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	2026-01-22 16:46:48.735+00	2026-01-22 16:52:56.206+00
cmkpopf8j0065jo04lsmkp84h	46	dropoff	delivered	\N		2026-01-22 17:07:48.913+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000jpg0b4hqk04vp	cmkmmtnzc000ipg0bvf6mh1w5	2026-01-22 16:46:48.163+00	2026-01-22 17:07:48.914+00
cmkpopfdu0067jo04gegr83yf	47	dropoff	delivered	\N		2026-01-22 17:07:53.944+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc000hpg0beqyv1424	cmkmmtnzc000gpg0bp44hrav7	2026-01-22 16:46:48.354+00	2026-01-22 17:07:53.945+00
cmkpopi8f006zjo041laxz2z0	0	dropoff	delivered	\N		2026-01-22 17:16:56.461+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	2026-01-22 16:46:52.047+00	2026-01-22 17:16:56.463+00
cmkpopgrl006fjo04abpd7nyy	9	both	delivered	\N		2026-01-23 01:47:21.235+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	2026-01-22 16:46:50.146+00	2026-01-23 01:47:21.237+00
cmkpopfj40069jo046d9q9exu	1	dropoff	delivered	\N		2026-01-22 16:53:42.851+00	\N	cmkpme9wb0001l404rj92vmym	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	2026-01-22 16:46:48.544+00	2026-01-22 16:53:42.852+00
cmkpophxv006vjo04o7yb2dgs	1	dropoff	delivered	\N		2026-01-22 21:37:29.249+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	2026-01-22 16:46:51.667+00	2026-01-22 21:37:29.252+00
cmkpophsl006tjo044v7t10o2	2	dropoff	delivered	\N		2026-01-22 21:37:38.977+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	2026-01-22 16:46:51.477+00	2026-01-22 21:37:38.98+00
cmkpophi0006pjo04lp7oqczc	4	dropoff	delivered	\N		2026-01-22 23:03:01.676+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	2026-01-22 16:46:51.097+00	2026-01-22 23:03:01.679+00
cmkpophcp006njo04mm1cao6c	5	both	delivered	\N		2026-01-22 23:03:30.786+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	2026-01-22 16:46:50.906+00	2026-01-22 23:03:30.787+00
cmkpoph25006jjo04um9elsm6	7	both	delivered	\N		2026-01-23 01:30:13.551+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	2026-01-22 16:46:50.526+00	2026-01-23 01:30:13.553+00
cmkpopgwv006hjo0417pc1lwh	8	both	delivered	\N		2026-01-23 01:30:18.224+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	2026-01-22 16:46:50.336+00	2026-01-23 01:30:18.227+00
cmkpopgmb006djo04zilnr1g4	10	both	delivered	\N		2026-01-23 01:47:27.181+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	2026-01-22 16:46:49.955+00	2026-01-23 01:47:27.182+00
cmkpopiw50077jo046xbxamhv	11	dropoff	delivered	\N		2026-01-23 01:47:32.832+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	2026-01-22 16:46:52.901+00	2026-01-23 01:47:32.834+00
cmkpopiqv0075jo047n9l6iww	13	dropoff	delivered	\N		2026-01-23 01:47:41.934+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	2026-01-22 16:46:52.619+00	2026-01-23 01:47:41.935+00
cmkpopij10073jo041ktb8599	14	dropoff	delivered	\N		2026-01-23 01:47:47.038+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	2026-01-22 16:46:52.428+00	2026-01-23 01:47:47.039+00
cmkpopidq0071jo04xem0i5b1	15	dropoff	delivered	\N		2026-01-23 01:47:51.831+00	\N	cmkpnfv3w002fl804cjkwalav	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	2026-01-22 16:46:52.238+00	2026-01-23 01:47:51.833+00
cmkvqjuy1002njx04m2gkayf8	6	dropoff	delivered	\N		2026-01-27 13:03:23.848+00	\N	cmkvqju56002bjx04epy9mowp	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	2026-01-26 22:25:04.874+00	2026-01-27 13:03:23.849+00
cmkqwmbt1001tl1048xw2rscc	32	dropoff	delivered	\N		2026-01-23 23:44:52.337+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkmmtnzc000tpg0bjdxkto2c	cmkmmtnzc000spg0b3wxsq6ez	2026-01-23 13:16:06.854+00	2026-01-23 23:44:52.339+00
cmkqwm7070003l10491fhw9cw	1	dropoff	delivered	\N		2026-01-23 19:11:14.381+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	2026-01-23 13:16:00.631+00	2026-01-23 19:11:14.383+00
cmkqwm7rk000bl10410av7vc8	5	dropoff	delivered	\N		2026-01-23 19:13:21.367+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	2026-01-23 13:16:01.616+00	2026-01-23 19:13:21.369+00
cmkqwm8yq000rl104n9svy3js	13	dropoff	delivered	\N		2026-01-23 23:43:22.475+00	\N	cmkqwm6ut0001l104r58yeh2w	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	2026-01-23 13:16:03.17+00	2026-01-23 23:43:22.477+00
cmkqwme6e002hl1045bn5z1h8	3	dropoff	delivered	\N		2026-01-23 23:46:46.163+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	2026-01-23 13:16:09.926+00	2026-01-23 23:46:46.165+00
cmkqwmex5002rl104akkbpxma	8	dropoff	delivered	\N		2026-01-23 23:47:08.73+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	2026-01-23 13:16:10.889+00	2026-01-23 23:47:08.731+00
cmkqwmhu0003tl104j6uvrscg	27	dropoff	delivered	\N		2026-01-23 23:48:43.108+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	2026-01-23 13:16:14.665+00	2026-01-23 23:48:43.11+00
cmkqwmgf9003bl104yqhcnctu	18	dropoff	delivered	\N		2026-01-23 23:47:49.95+00	\N	cmkqwmdsz002bl104gfkktuoh	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	2026-01-23 13:16:12.837+00	2026-01-23 23:47:49.951+00
cmkrjsfw2000yi9041xa9bm4r	3	dropoff	delivered	Jhhh		2026-01-24 00:09:17.314+00	\N	cmkrjsfb4000si904wqrp4odf	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	2026-01-24 00:04:43.251+00	2026-01-24 00:09:17.316+00
cmkrjsg1c0010i904trk2uzj4	4	dropoff	delivered	Uhhh		2026-01-24 00:09:20.687+00	\N	cmkrjsfb4000si904wqrp4odf	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	2026-01-24 00:04:43.441+00	2026-01-24 00:09:20.688+00
cmkrjsg6m0012i904jklaxeh3	5	dropoff	delivered	Ujjj		2026-01-24 00:09:25.093+00	\N	cmkrjsfb4000si904wqrp4odf	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	2026-01-24 00:04:43.631+00	2026-01-24 00:09:25.094+00
cmkrjsgc10014i9044yk9kx9z	6	both	delivered	\N		2026-01-24 00:09:29.692+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzd001xpg0bap4wue7r	cmkmmtnzd001wpg0b8opdootf	2026-01-24 00:04:43.825+00	2026-01-24 00:09:29.693+00
cmkrjsghc0016i904jlzx1b7z	7	both	delivered	\N		2026-01-24 00:09:33.894+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	2026-01-24 00:04:44.016+00	2026-01-24 00:09:33.895+00
cmkrjsgmm0018i904xty6xhi4	8	pickup	delivered	Hbvuuj		2026-01-24 00:09:38.259+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	2026-01-24 00:04:44.206+00	2026-01-24 00:09:38.26+00
cmkrjsgrx001ai904vigfhihw	9	dropoff	delivered	\N		2026-01-24 00:09:42.634+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	2026-01-24 00:04:44.397+00	2026-01-24 00:09:42.635+00
cmkrjsgx7001ci9045dwixjdd	10	both	delivered	Uhhb		2026-01-24 00:09:48.191+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	2026-01-24 00:04:44.588+00	2026-01-24 00:09:48.192+00
cmkrjsh2h001ei9044jl3ff4h	11	both	delivered	\N		2026-01-24 00:09:52.02+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	2026-01-24 00:04:44.777+00	2026-01-24 00:09:52.022+00
cmkrjshd1001ii904o32qj4yp	13	both	delivered	\N		2026-01-24 00:10:13.566+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	2026-01-24 00:04:45.157+00	2026-01-24 00:10:13.568+00
cmkrjshib001ki904n41yuhfk	14	dropoff	delivered	\N		2026-01-24 00:10:17.522+00	\N	cmkrjsfb4000si904wqrp4odf	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	2026-01-24 00:04:45.347+00	2026-01-24 00:10:17.524+00
cmkrjshnm001mi904heodi9iu	15	dropoff	delivered	\N		2026-01-24 00:10:21.394+00	\N	cmkrjsfb4000si904wqrp4odf	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	2026-01-24 00:04:45.538+00	2026-01-24 00:10:21.395+00
cmkrjshsw001oi904jj39rpoz	16	both	delivered	\N		2026-01-24 00:10:25.081+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	2026-01-24 00:04:45.728+00	2026-01-24 00:10:25.083+00
cmkrjshy6001qi9046wddfh2p	17	dropoff	delivered	Jnjjj		2026-01-24 00:10:28.788+00	\N	cmkrjsfb4000si904wqrp4odf	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	2026-01-24 00:04:45.918+00	2026-01-24 00:10:28.789+00
cmkrjsi3g001si9044axanmzt	18	both	delivered	\N		2026-01-24 00:10:32.729+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	2026-01-24 00:04:46.109+00	2026-01-24 00:10:32.731+00
cmkrjsi8q001ui904g4z548v4	19	both	delivered	\N		2026-01-24 00:10:40.291+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	2026-01-24 00:04:46.299+00	2026-01-24 00:10:40.292+00
cmkrjsija001yi904t1mn7dn3	21	both	delivered	Jggh		2026-01-24 00:10:50.184+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	2026-01-24 00:04:46.678+00	2026-01-24 00:10:50.185+00
cmkrjsiok0020i904mwcbe9qt	22	both	delivered	Bvh		2026-01-24 00:10:55.855+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	2026-01-24 00:04:46.868+00	2026-01-24 00:10:55.857+00
cmkrjsitt0022i9049h70o5we	23	both	delivered	Ggv		2026-01-24 00:11:02.546+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	2026-01-24 00:04:47.058+00	2026-01-24 00:11:02.547+00
cmkrjsiz30024i904vz54fkx5	24	both	delivered	Hhg		2026-01-24 00:11:09.021+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc0013pg0bo46voruk	cmkmmtnzc0012pg0b9g2rgur4	2026-01-24 00:04:47.247+00	2026-01-24 00:11:09.022+00
cmkrjsj4c0026i9041f7d2kao	25	dropoff	delivered	Hbkujhh		2026-01-24 00:11:12.716+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc0011pg0bk86bbnir	cmkmmtnzc0010pg0bj0tfcetm	2026-01-24 00:04:47.437+00	2026-01-24 00:11:12.717+00
cmkrjsj9m0028i9040hiogj47	26	both	delivered	Hvvnj		2026-01-24 00:11:18.486+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000zpg0bmmqmfdh7	cmkmmtnzc000ypg0bscyvt3oh	2026-01-24 00:04:47.626+00	2026-01-24 00:11:18.487+00
cmkrjsjew002ai904czbl4jr2	27	dropoff	delivered	\N		2026-01-24 00:11:22.679+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000xpg0b8h5uy5lh	cmkmmtnzc000wpg0b5nr80khx	2026-01-24 00:04:47.816+00	2026-01-24 00:11:22.681+00
cmkrjsjk7002ci904m1zkya54	28	both	delivered	\N		2026-01-24 00:11:26.464+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000vpg0ba51a0rf9	cmkmmtnzc000upg0bhhvedenk	2026-01-24 00:04:48.007+00	2026-01-24 00:11:26.465+00
cmkrjsjph002ei904hgx0txfw	29	dropoff	delivered	\N		2026-01-24 00:11:35.008+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000tpg0bjdxkto2c	cmkmmtnzc000spg0b3wxsq6ez	2026-01-24 00:04:48.197+00	2026-01-24 00:11:35.009+00
cmkrjsk01002ii904xrv6y5sr	31	both	delivered	\N		2026-01-24 00:11:52.38+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000ppg0b7xfswolz	cmkmmtnzc000opg0b8qhmdsuc	2026-01-24 00:04:48.577+00	2026-01-24 00:11:52.381+00
cmkrjsk5b002ki904ccgpe1u1	32	both	delivered	\N		2026-01-24 00:11:56.44+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000npg0b6tewaq4j	cmkmmtnzc000mpg0bm0owaa4z	2026-01-24 00:04:48.768+00	2026-01-24 00:11:56.442+00
cmkrjskam002mi9045f7k05lv	33	dropoff	delivered	\N		2026-01-24 00:12:00.566+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000lpg0b3798nek4	cmkmmtnzc000kpg0bqjgrrw8k	2026-01-24 00:04:48.959+00	2026-01-24 00:12:00.567+00
cmkrjskfy002oi904ie34h8s6	34	dropoff	delivered	\N		2026-01-24 00:12:04.446+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000jpg0b4hqk04vp	cmkmmtnzc000ipg0bvf6mh1w5	2026-01-24 00:04:49.151+00	2026-01-24 00:12:04.448+00
cmkrjskl8002qi904kmm8v5fp	35	dropoff	delivered	\N		2026-01-24 00:12:29.144+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000hpg0beqyv1424	cmkmmtnzc000gpg0bp44hrav7	2026-01-24 00:04:49.341+00	2026-01-24 00:12:29.145+00
cmkrjskqi002si904yc0verr5	36	both	delivered	\N		2026-01-24 00:12:32.646+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	2026-01-24 00:04:49.53+00	2026-01-24 00:12:32.648+00
cmkrjskvt002ui904sjab0jvt	37	dropoff	delivered	\N		2026-01-24 00:12:47.355+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	2026-01-24 00:04:49.721+00	2026-01-24 00:12:47.356+00
cmkrjsndl003ki904zt5gv1c4	12	dropoff	delivered	\N		2026-01-24 12:31:43.186+00	\N	cmkrjslob002wi904uctl771l	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	2026-01-24 00:04:52.954+00	2026-01-24 12:31:43.188+00
cmkrjsnix003mi9048p5uel3d	13	both	delivered	\N		2026-01-24 12:31:49.606+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	2026-01-24 00:04:53.145+00	2026-01-24 12:31:49.607+00
cmkrjsno7003oi904etq9cfuw	14	dropoff	delivered	\N		2026-01-24 12:31:57.684+00	\N	cmkrjslob002wi904uctl771l	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	2026-01-24 00:04:53.335+00	2026-01-24 12:31:57.686+00
cmkrjsnth003qi90464q05jxj	15	both	delivered	\N		2026-01-24 12:32:25.652+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	2026-01-24 00:04:53.525+00	2026-01-24 12:32:25.654+00
cmkrjsnyr003si9044wt473gv	16	dropoff	delivered	\N		2026-01-24 12:32:33.175+00	\N	cmkrjslob002wi904uctl771l	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	2026-01-24 00:04:53.715+00	2026-01-24 12:32:33.177+00
cmkrjso47003ui9042gv7gdcg	17	dropoff	delivered	\N		2026-01-24 12:33:24.366+00	\N	cmkrjslob002wi904uctl771l	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	2026-01-24 00:04:53.912+00	2026-01-24 12:33:24.367+00
cmkrjsfgd000ui904c9n685do	1	both	delivered	Aaaaa		2026-01-24 00:09:07.814+00	\N	cmkrjsfb4000si904wqrp4odf	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	2026-01-24 00:04:42.685+00	2026-01-24 00:09:07.816+00
cmkrjso9i003wi904s2kqkeli	18	dropoff	delivered	\N		2026-01-24 12:33:42.529+00	\N	cmkrjslob002wi904uctl771l	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	2026-01-24 00:04:54.103+00	2026-01-24 12:33:42.531+00
cmkrjsfqt000wi9041ef376wr	2	both	delivered	Bbbbbb		2026-01-24 00:09:12.522+00	\N	cmkrjsfb4000si904wqrp4odf	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	2026-01-24 00:04:43.061+00	2026-01-24 00:09:12.523+00
cmkrjsh7r001gi904agk89pkf	12	both	delivered	\N		2026-01-24 00:10:06.402+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	2026-01-24 00:04:44.967+00	2026-01-24 00:10:06.403+00
cmkrjsie1001wi904w6s9fpl5	20	both	delivered	Jhhh		2026-01-24 00:10:46.005+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	2026-01-24 00:04:46.489+00	2026-01-24 00:10:46.007+00
cmkrjsjuq002gi904ek9efhe5	30	both	failed	\N	P	2026-01-24 00:11:47.904+00	\N	cmkrjsfb4000si904wqrp4odf	cmkmmtnzc000rpg0bsqqfcs7d	cmkmmtnzc000qpg0bjppqfaf1	2026-01-24 00:04:48.386+00	2026-01-24 00:11:47.906+00
cmkrjslqy002yi904ukj7c3fn	1	dropoff	delivered	\N		2026-01-24 12:30:31.34+00	\N	cmkrjslob002wi904uctl771l	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	2026-01-24 00:04:50.843+00	2026-01-24 12:30:31.342+00
cmkrjslw80030i904g29yvlqn	2	dropoff	delivered	\N		2026-01-24 12:30:37.225+00	\N	cmkrjslob002wi904uctl771l	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	2026-01-24 00:04:51.032+00	2026-01-24 12:30:37.227+00
cmkrjsoeu003yi9040xuu147r	19	dropoff	delivered	\N		2026-01-24 12:33:49.715+00	\N	cmkrjslob002wi904uctl771l	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	2026-01-24 00:04:54.294+00	2026-01-24 12:33:49.717+00
cmkrjsm1h0032i904nj9dj1xc	3	both	delivered	Ccc		2026-01-24 12:30:41.369+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzd002dpg0bvpq07r77	cmkmmtnzd002cpg0b43ylar77	2026-01-24 00:04:51.222+00	2026-01-24 12:30:41.371+00
cmkrjsm6s0034i90474ao5bb5	4	dropoff	delivered	\N		2026-01-24 12:30:45.456+00	\N	cmkrjslob002wi904uctl771l	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	2026-01-24 00:04:51.412+00	2026-01-24 12:30:45.458+00
cmkrjsok40040i9046qz7a17x	20	dropoff	delivered	\N		2026-01-24 12:33:53.848+00	\N	cmkrjslob002wi904uctl771l	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	2026-01-24 00:04:54.484+00	2026-01-24 12:33:53.85+00
cmkrjsmc10036i904ax5hu215	5	dropoff	delivered	Yhhh		2026-01-24 12:30:49.075+00	\N	cmkrjslob002wi904uctl771l	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	2026-01-24 00:04:51.601+00	2026-01-24 12:30:49.077+00
cmkrjsmha0038i904nbij6t2o	6	both	delivered	\N		2026-01-24 12:30:55.953+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzd002bpg0bw3xjvfsb	cmkmmtnzd002apg0bnlue5rom	2026-01-24 00:04:51.791+00	2026-01-24 12:30:55.955+00
cmkrjsopf0042i904gxv11ojt	21	dropoff	delivered	\N		2026-01-24 12:34:03.068+00	\N	cmkrjslob002wi904uctl771l	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	2026-01-24 00:04:54.676+00	2026-01-24 12:34:03.07+00
cmkrjsmmk003ai904mfqgi53s	7	both	delivered	\N		2026-01-24 12:31:05.358+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	2026-01-24 00:04:51.98+00	2026-01-24 12:31:05.359+00
cmkrjsmrt003ci9042k1zzf6a	8	dropoff	delivered	\N		2026-01-24 12:31:09.597+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzd0027pg0b87s1ex9x	cmkmmtnzd0026pg0bedd3795f	2026-01-24 00:04:52.169+00	2026-01-24 12:31:09.599+00
cmkrjsouq0044i904ntmlcgzy	22	dropoff	delivered	\N		2026-01-24 12:34:08.616+00	\N	cmkrjslob002wi904uctl771l	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	2026-01-24 00:04:54.866+00	2026-01-24 12:34:08.618+00
cmkrjsmx2003ei904rdcq9ry5	9	both	delivered	\N		2026-01-24 12:31:20.757+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	2026-01-24 00:04:52.359+00	2026-01-24 12:31:20.759+00
cmkrjsn2j003gi904p4psme8o	10	both	delivered	Yhhhg		2026-01-24 12:31:26.491+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	2026-01-24 00:04:52.555+00	2026-01-24 12:31:26.493+00
cmkrjsozz0046i904gf1gygs5	23	dropoff	delivered	Uhhh		2026-01-24 12:34:16.609+00	\N	cmkrjslob002wi904uctl771l	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	2026-01-24 00:04:55.056+00	2026-01-24 12:34:16.61+00
cmkrjsn7t003ii9041rrg8jix	11	dropoff	delivered	\N		2026-01-24 12:31:32.422+00	\N	cmkrjslob002wi904uctl771l	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	2026-01-24 00:04:52.745+00	2026-01-24 12:31:32.424+00
cmkrjsp590048i904aj6vxh8l	24	dropoff	delivered	Jjjj		2026-01-24 12:34:32.098+00	\N	cmkrjslob002wi904uctl771l	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	2026-01-24 00:04:55.246+00	2026-01-24 12:34:32.099+00
cmkrjspaj004ai904ggoncg9a	25	dropoff	delivered	Jjjiu		2026-01-24 12:34:37.145+00	\N	cmkrjslob002wi904uctl771l	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	2026-01-24 00:04:55.436+00	2026-01-24 12:34:37.147+00
cmkrjspid004ci904pc7pr122	26	dropoff	delivered	Uhhh		2026-01-24 12:34:44.141+00	\N	cmkrjslob002wi904uctl771l	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	2026-01-24 00:04:55.718+00	2026-01-24 12:34:44.142+00
cmkrjspnn004ei9043dicgs92	27	dropoff	delivered	\N		2026-01-24 12:35:31.707+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	2026-01-24 00:04:55.907+00	2026-01-24 12:35:31.708+00
cmkrjspsx004gi904izet0gkz	28	both	delivered	\N		2026-01-24 12:35:38.627+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	2026-01-24 00:04:56.098+00	2026-01-24 12:35:38.629+00
cmkrjspye004ii904xb4nrwut	29	both	delivered	\N		2026-01-24 12:35:42.254+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	2026-01-24 00:04:56.295+00	2026-01-24 12:35:42.256+00
cmkrjsq3p004ki9049vbrwy5f	30	dropoff	delivered	\N		2026-01-24 12:35:46.211+00	\N	cmkrjslob002wi904uctl771l	cmkmmtnzc0005pg0b7vwihkdv	cmkmmtnzc0004pg0bnlyen0ou	2026-01-24 00:04:56.485+00	2026-01-24 12:35:46.212+00
cmkv462cn000bl5047lifucby	5	dropoff	delivered	\N		2026-01-26 12:01:08.975+00	\N	cmkv461gx0001l504ljsc6x18	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	2026-01-26 11:58:29.736+00	2026-01-26 12:01:08.977+00
cmkv462hx000dl504dgnqkb77	6	dropoff	delivered	\N		2026-01-26 12:01:12.396+00	\N	cmkv461gx0001l504ljsc6x18	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	2026-01-26 11:58:29.926+00	2026-01-26 12:01:12.398+00
cmkv462sk000hl504asr21qs2	8	dropoff	delivered	\N		2026-01-26 12:01:18.534+00	\N	cmkv461gx0001l504ljsc6x18	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	2026-01-26 11:58:30.308+00	2026-01-26 12:01:18.536+00
cmkv462xw000jl504la02jkyi	9	dropoff	delivered	\N		2026-01-26 12:01:23.573+00	\N	cmkv461gx0001l504ljsc6x18	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	2026-01-26 11:58:30.501+00	2026-01-26 12:01:23.575+00
cmkv46337000ll5044566v61q	10	dropoff	delivered	\N		2026-01-26 12:01:27.778+00	\N	cmkv461gx0001l504ljsc6x18	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	2026-01-26 11:58:30.692+00	2026-01-26 12:01:27.78+00
cmkv4638h000nl504kktq4bch	11	dropoff	delivered	\N		2026-01-26 12:01:34.795+00	\N	cmkv461gx0001l504ljsc6x18	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	2026-01-26 11:58:30.881+00	2026-01-26 12:01:34.797+00
cmkvqju7s002djx04o2opxgff	1	dropoff	delivered	\N		2026-01-27 09:28:17.165+00	https://www.storage.tds-transports.fr/4d5db93c-e733-4ac8-951a-608828d1b856.avif	cmkvqju56002bjx04epy9mowp	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	2026-01-26 22:25:03.928+00	2026-01-27 09:28:17.166+00
cmkv461m60003l5043ak0doly	1	dropoff	delivered	\N		2026-01-26 12:00:54.493+00	\N	cmkv461gx0001l504ljsc6x18	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	2026-01-26 11:58:28.783+00	2026-01-26 12:00:54.494+00
cmkv461wt0005l504ll5vqvn8	2	dropoff	delivered	\N		2026-01-26 12:00:58.324+00	\N	cmkv461gx0001l504ljsc6x18	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	2026-01-26 11:58:29.166+00	2026-01-26 12:00:58.326+00
cmkv462240007l504qfwfsuf2	3	dropoff	delivered	\N		2026-01-26 12:01:01.573+00	\N	cmkv461gx0001l504ljsc6x18	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	2026-01-26 11:58:29.356+00	2026-01-26 12:01:01.574+00
cmkvqjud3002fjx04yacl9c85	2	dropoff	delivered	\N		2026-01-27 13:03:07.604+00	\N	cmkvqju56002bjx04epy9mowp	cmkpoh8qx0003jo04vyxiampd	cmkpoh8qx0002jo04pr7z8wj3	2026-01-26 22:25:04.119+00	2026-01-27 13:03:07.607+00
cmkv4627e0009l504x3zger3w	4	dropoff	delivered	\N		2026-01-26 12:01:05.397+00	\N	cmkv461gx0001l504ljsc6x18	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	2026-01-26 11:58:29.546+00	2026-01-26 12:01:05.399+00
cmkv462n8000fl504frpj3lw8	7	dropoff	delivered	\N		2026-01-26 12:01:15.59+00	\N	cmkv461gx0001l504ljsc6x18	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	2026-01-26 11:58:30.116+00	2026-01-26 12:01:15.592+00
cmkv463dq000pl504ngiivmj5	12	dropoff	delivered	\N		2026-01-26 12:01:42.004+00	\N	cmkv461gx0001l504ljsc6x18	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	2026-01-26 11:58:31.07+00	2026-01-26 12:01:42.005+00
cmkvqjuib002hjx04dvsmqu45	3	dropoff	delivered	\N		2026-01-27 13:03:12.714+00	\N	cmkvqju56002bjx04epy9mowp	cmkpoipkw003fl404xhcwstv9	cmkpoipkw003el404a9gjq8tt	2026-01-26 22:25:04.308+00	2026-01-27 13:03:12.716+00
cmkvqjunk002jjx04v21fzz2t	4	dropoff	delivered	\N		2026-01-27 13:03:16.048+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	2026-01-26 22:25:04.497+00	2026-01-27 13:03:16.05+00
cmkvqjust002ljx040n1w85jc	5	dropoff	delivered	\N		2026-01-27 13:03:20.056+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	2026-01-26 22:25:04.685+00	2026-01-27 13:03:20.058+00
cmkvqjv3a002pjx042kxjgnyo	7	dropoff	delivered	\N		2026-01-27 13:03:27.673+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	2026-01-26 22:25:05.063+00	2026-01-27 13:03:27.675+00
cmkvqjv8l002rjx04h9oycop4	8	dropoff	delivered	\N		2026-01-27 13:03:31.412+00	\N	cmkvqju56002bjx04epy9mowp	cmkmmtnzd002bpg0bw3xjvfsb	cmkmmtnzd002apg0bnlue5rom	2026-01-26 22:25:05.254+00	2026-01-27 13:03:31.414+00
cmkvqjvdu002tjx041pzfckex	9	dropoff	delivered	\N		2026-01-27 13:03:38.026+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	2026-01-26 22:25:05.443+00	2026-01-27 13:03:38.027+00
cmkvqjvk1002vjx04vp3y6t6l	10	both	delivered	\N		2026-01-27 13:03:41.787+00	\N	cmkvqju56002bjx04epy9mowp	cmkmmtnzd0029pg0b9bkziymu	cmkmmtnzd0028pg0bgetr00sv	2026-01-26 22:25:05.665+00	2026-01-27 13:03:41.789+00
cmkvqjvp9002xjx046h1u1i24	11	both	delivered	\N		2026-01-27 13:03:45.523+00	\N	cmkvqju56002bjx04epy9mowp	cmkmmtnzd0027pg0b87s1ex9x	cmkmmtnzd0026pg0bedd3795f	2026-01-26 22:25:05.854+00	2026-01-27 13:03:45.525+00
cmkvqjvuj002zjx040v6hsie5	12	dropoff	delivered	\N		2026-01-27 13:03:48.898+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	2026-01-26 22:25:06.044+00	2026-01-27 13:03:48.9+00
cmkvqjvzs0031jx04ercmqvm6	13	dropoff	delivered	\N		2026-01-27 13:03:52.221+00	\N	cmkvqju56002bjx04epy9mowp	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	2026-01-26 22:25:06.232+00	2026-01-27 13:03:52.223+00
cmkvqjw500033jx04pu0xp5sb	14	both	delivered	\N		2026-01-27 13:03:55.609+00	\N	cmkvqju56002bjx04epy9mowp	cmkmmtnzd0025pg0bbfp4loi1	cmkmmtnzd0024pg0bpeprtbs1	2026-01-26 22:25:06.421+00	2026-01-27 13:03:55.61+00
cmkvqjwa90035jx04lk1tofkp	15	dropoff	delivered	\N		2026-01-27 13:03:59.074+00	\N	cmkvqju56002bjx04epy9mowp	cmkmmtnzd0023pg0bvxhgmzn5	cmkmmtnzd0022pg0bwjkhy015	2026-01-26 22:25:06.609+00	2026-01-27 13:03:59.076+00
cmkvqjq840013jx04al92k1vc	2	dropoff	delivered	\N		2026-01-26 22:27:00.616+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzd001zpg0bzfw50sqa	cmkmmtnzd001ypg0bcx0u3qe2	2026-01-26 22:24:58.756+00	2026-01-26 22:27:00.618+00
cmkvqjqdd0015jx04z3n74mxu	3	dropoff	delivered	\N		2026-01-26 22:27:05.074+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzd001xpg0bap4wue7r	cmkmmtnzd001wpg0b8opdootf	2026-01-26 22:24:58.945+00	2026-01-26 22:27:05.076+00
cmkvqjwfh0037jx04mpwbiwag	16	dropoff	delivered	\N		2026-01-27 13:04:02.664+00	\N	cmkvqju56002bjx04epy9mowp	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	2026-01-26 22:25:06.798+00	2026-01-27 13:04:02.666+00
cmkvqjqim0017jx04a8rot5ro	4	dropoff	delivered	\N		2026-01-26 22:27:08.908+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzd001vpg0b0e70lvoi	cmkmmtnzd001upg0bjnjvz9w8	2026-01-26 22:24:59.134+00	2026-01-26 22:27:08.91+00
cmkvqjqnv0019jx047l0g3ei5	5	dropoff	delivered	\N		2026-01-26 22:27:13.589+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzd001tpg0b2dny2o7t	cmkmmtnzd001spg0b62euz775	2026-01-26 22:24:59.323+00	2026-01-26 22:27:13.59+00
cmkvqjwkw0039jx04bq29r2ik	17	dropoff	delivered	\N		2026-01-27 13:04:06.301+00	\N	cmkvqju56002bjx04epy9mowp	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	2026-01-26 22:25:06.993+00	2026-01-27 13:04:06.302+00
cmkvqjqt4001bjx04sg0f789a	6	dropoff	delivered	\N		2026-01-26 22:27:25.414+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzd001rpg0bw16zjj28	cmkmmtnzd001qpg0byzzbxsq6	2026-01-26 22:24:59.513+00	2026-01-26 22:27:25.416+00
cmkvqjr3m001fjx044c5fxyhw	8	both	delivered	\N		2026-01-26 22:27:33.379+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc001npg0b1uvinjjc	cmkmmtnzc001mpg0bik0f98l7	2026-01-26 22:24:59.891+00	2026-01-26 22:27:33.381+00
cmkvqjr8w001hjx04oxf4u815	9	both	delivered	\N		2026-01-26 22:27:37.573+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc001lpg0blmbi8lcj	cmkmmtnzc001kpg0b01sk2kxs	2026-01-26 22:25:00.08+00	2026-01-26 22:27:37.575+00
cmkvqjre4001jjx04kydi1gb0	10	both	delivered	\N		2026-01-26 22:27:41.8+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc001jpg0b9q146f1g	cmkmmtnzc001ipg0by1go31lb	2026-01-26 22:25:00.268+00	2026-01-26 22:27:41.801+00
cmkvqjrjc001ljx045tfkcvbg	11	both	delivered	\N		2026-01-26 22:27:45.803+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc001hpg0bnmgmtnsi	cmkmmtnzc001gpg0b30kwtz0g	2026-01-26 22:25:00.456+00	2026-01-26 22:27:45.805+00
cmkvqjrol001njx040wv3zyah	12	both	delivered	\N		2026-01-26 22:27:50.838+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc001fpg0bdv55hmyz	cmkmmtnzc001epg0blalns7pp	2026-01-26 22:25:00.645+00	2026-01-26 22:27:50.84+00
cmkvqjrtu001pjx04y90med6x	13	dropoff	delivered	\N		2026-01-26 22:28:00.833+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc001dpg0bmg7ikim0	cmkmmtnzc001cpg0buztxte3p	2026-01-26 22:25:00.834+00	2026-01-26 22:28:00.834+00
cmkvqjrz2001rjx04giwp52i6	14	both	delivered	\N		2026-01-26 22:28:04.872+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc001bpg0bmps76b91	cmkmmtnzc001apg0bdkzb5fyx	2026-01-26 22:25:01.022+00	2026-01-26 22:28:04.874+00
cmkvqjs9k001vjx04w8rdd09y	16	dropoff	delivered	\N		2026-01-26 22:28:16.756+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc0017pg0bibpqrqkq	cmkmmtnzc0016pg0bkcilb9eg	2026-01-26 22:25:01.4+00	2026-01-26 22:28:16.757+00
cmkvqjses001xjx04pejxx1gc	17	dropoff	delivered	\N		2026-01-26 22:28:21.036+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc0015pg0bpmrcbsgy	cmkmmtnzc0014pg0bjfko06na	2026-01-26 22:25:01.588+00	2026-01-26 22:28:21.038+00
cmkvqjsk1001zjx049lhi0caa	18	dropoff	delivered	\N		2026-01-26 22:28:44.325+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc000fpg0b2fpasfl6	cmkmmtnzc000epg0b1ow0h31d	2026-01-26 22:25:01.777+00	2026-01-26 22:28:44.326+00
cmkvqjspa0021jx04g8isvrtq	19	dropoff	delivered	\N		2026-01-26 22:28:49.559+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc000dpg0b04bdsnnz	cmkmmtnzc000cpg0brqq44zo5	2026-01-26 22:25:01.966+00	2026-01-26 22:28:49.561+00
cmkvqjsuj0023jx04ohq39m8e	20	dropoff	delivered	\N		2026-01-26 22:28:53.195+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc000bpg0biga7imrx	cmkmmtnzc000apg0b2ob9poap	2026-01-26 22:25:02.155+00	2026-01-26 22:28:53.196+00
cmkvqjszr0025jx04h1rxuebr	21	dropoff	delivered	\N		2026-01-26 22:28:56.868+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc0009pg0b1j5j3x3d	cmkmmtnzc0008pg0btk75uuae	2026-01-26 22:25:02.343+00	2026-01-26 22:28:56.869+00
cmkvqjt500027jx04g9aemkdz	22	dropoff	delivered	\N		2026-01-26 22:29:00.49+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc0007pg0broq4rojb	cmkmmtnzc0006pg0bz7juob3v	2026-01-26 22:25:02.532+00	2026-01-26 22:29:00.492+00
cmkvqjpxl0011jx04a3koincp	1	dropoff	delivered	\N		2026-01-26 22:26:55.366+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzd0021pg0bp5vy2u9p	cmkmmtnzd0020pg0bk99tiad8	2026-01-26 22:24:58.377+00	2026-01-26 22:26:55.368+00
cmkvqjqyd001djx04yf9p0i0o	7	dropoff	delivered	\N		2026-01-26 22:27:29.435+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc001ppg0b1ehrgx0r	cmkmmtnzc001opg0bh2fmojqz	2026-01-26 22:24:59.702+00	2026-01-26 22:27:29.436+00
cmkvqjs4b001tjx04daety42v	15	both	delivered	\N		2026-01-26 22:28:13.317+00	\N	cmkvqjpsa000zjx04akobup3j	cmkmmtnzc0019pg0be9sa6wug	cmkmmtnzc0018pg0b9yh53ptf	2026-01-26 22:25:01.211+00	2026-01-26 22:28:13.319+00
cmkvqjwq5003bjx04kwl1e3ao	18	dropoff	delivered	\N		2026-01-27 13:04:09.695+00	\N	cmkvqju56002bjx04epy9mowp	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	2026-01-26 22:25:07.181+00	2026-01-27 13:04:09.696+00
cmkvqjwve003djx04xwkj1b8q	19	dropoff	delivered	\N		2026-01-27 13:04:13.857+00	\N	cmkvqju56002bjx04epy9mowp	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	2026-01-26 22:25:07.37+00	2026-01-27 13:04:13.859+00
cmkvqjx0n003fjx04180bsck6	20	dropoff	delivered	\N		2026-01-27 13:04:17.348+00	\N	cmkvqju56002bjx04epy9mowp	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	2026-01-26 22:25:07.559+00	2026-01-27 13:04:17.35+00
cmkvqjx5w003hjx04w1h3fd6f	21	dropoff	delivered	\N		2026-01-27 13:04:25.403+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	2026-01-26 22:25:07.749+00	2026-01-27 13:04:25.406+00
cmkvqjxbc003jjx04vefyhh1k	22	dropoff	delivered	\N		2026-01-27 13:04:28.844+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	2026-01-26 22:25:07.944+00	2026-01-27 13:04:28.845+00
cmkvqjxgl003ljx046zgsinjb	23	dropoff	delivered	\N		2026-01-27 13:04:32.001+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	2026-01-26 22:25:08.133+00	2026-01-27 13:04:32.003+00
cmkvqjxlt003njx04qek7dyp3	24	dropoff	delivered	\N		2026-01-27 13:04:35.209+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	2026-01-26 22:25:08.321+00	2026-01-27 13:04:35.212+00
cmkvqjxr6003pjx04eup05sb5	25	dropoff	delivered	\N		2026-01-27 13:04:38.604+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	2026-01-26 22:25:08.514+00	2026-01-27 13:04:38.605+00
cmkvqjxwe003rjx0496ofmcfu	26	dropoff	delivered	\N		2026-01-27 13:04:42.289+00	\N	cmkvqju56002bjx04epy9mowp	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	2026-01-26 22:25:08.702+00	2026-01-27 13:04:42.291+00
cmkvqjy1o003tjx04hn4frrn3	27	dropoff	delivered	\N		2026-01-27 13:04:45.743+00	\N	cmkvqju56002bjx04epy9mowp	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	2026-01-26 22:25:08.892+00	2026-01-27 13:04:45.745+00
cmkvqjy6w003vjx04i2xozclx	28	dropoff	delivered	\N		2026-01-27 13:04:49.012+00	\N	cmkvqju56002bjx04epy9mowp	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	2026-01-26 22:25:09.081+00	2026-01-27 13:04:49.013+00
cmkvqjyc5003xjx040rg57etz	29	dropoff	delivered	\N		2026-01-27 13:05:04.663+00	\N	cmkvqju56002bjx04epy9mowp	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	2026-01-26 22:25:09.269+00	2026-01-27 13:05:04.664+00
cmkvqjyhi003zjx04yni396kv	30	dropoff	delivered	\N		2026-01-27 13:05:09.117+00	\N	cmkvqju56002bjx04epy9mowp	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	2026-01-26 22:25:09.462+00	2026-01-27 13:05:09.118+00
cmkvqjyn00041jx04f0bdm010	31	dropoff	delivered	\N		2026-01-27 13:05:15.635+00	\N	cmkvqju56002bjx04epy9mowp	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	2026-01-26 22:25:09.66+00	2026-01-27 13:05:15.637+00
cmkvqjys90043jx04hnp4yt9y	32	dropoff	failed	\N	Pas de boite	2026-01-27 13:05:26.333+00	\N	cmkvqju56002bjx04epy9mowp	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	2026-01-26 22:25:09.849+00	2026-01-27 13:05:26.334+00
cmkwm4e670001lb046dfhl8kc	1	both	delivered	\N		2026-01-27 13:09:46.413+00	\N	cmkwm1zen0001l804z6hssm02	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	2026-01-27 13:08:51.008+00	2026-01-27 13:09:46.415+00
cmkwm4egn0003lb04y9mvlr58	2	dropoff	delivered	\N		2026-01-27 13:09:50.686+00	\N	cmkwm1zen0001l804z6hssm02	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	2026-01-27 13:08:51.383+00	2026-01-27 13:09:50.687+00
cmkwm4elz0005lb04ryfp6r20	3	dropoff	delivered	\N		2026-01-27 13:09:54.526+00	\N	cmkwm1zen0001l804z6hssm02	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	2026-01-27 13:08:51.575+00	2026-01-27 13:09:54.528+00
cmkwm4er90007lb04pbmj1fua	4	both	delivered	\N		2026-01-27 13:11:45.027+00	\N	cmkwm1zen0001l804z6hssm02	cmkwlqmys0001l704a4ay2d1c	cmkwlqmys0000l704htwnpczu	2026-01-27 13:08:51.766+00	2026-01-27 13:11:45.029+00
cmkwm4ewl0009lb04jo9ock9p	5	dropoff	delivered	\N		2026-01-27 13:11:49.643+00	\N	cmkwm1zen0001l804z6hssm02	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	2026-01-27 13:08:51.957+00	2026-01-27 13:11:49.646+00
cmkzil8e50003l804fn1cwqct	1	dropoff	delivered	\N		2026-01-29 13:53:43.434+00	\N	cmkzil88r0001l8040usa413a	cmkpj9j27000dl2047t182oly	cmkpj9j27000cl2042x8akjni	2026-01-29 13:53:16.733+00	2026-01-29 13:53:43.436+00
cmkzil8ow0005l804df53y4nm	2	both	delivered	\N		2026-01-29 13:53:47.316+00	\N	cmkzil88r0001l8040usa413a	cmkpjbb9m000hl204e6qffcd9	cmkpjbb9m000gl2046arrfar1	2026-01-29 13:53:17.12+00	2026-01-29 13:53:47.317+00
cmkzil8u80007l804ka3srjwd	3	both	delivered	\N		2026-01-29 13:54:23.448+00	\N	cmkzil88r0001l8040usa413a	cmkwlqmys0001l704a4ay2d1c	cmkwlqmys0000l704htwnpczu	2026-01-29 13:53:17.313+00	2026-01-29 13:54:23.449+00
cmkzil8zl0009l804lcpbuw63	4	dropoff	delivered	\N		2026-01-29 13:54:27.352+00	\N	cmkzil88r0001l8040usa413a	cmkpja6ka000bla047z0mprir	cmkpja6ka000ala043b4izyqi	2026-01-29 13:53:17.506+00	2026-01-29 13:54:27.353+00
cmkzil94z000bl8046c663adm	5	dropoff	delivered	\N		2026-01-29 13:54:32.275+00	\N	cmkzil88r0001l8040usa413a	cmkpjarhv000fl204osybq92g	cmkpjarhv000el2043mokndd5	2026-01-29 13:53:17.699+00	2026-01-29 13:54:32.277+00
cmkziqprm0009l804znbxxzy3	4	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj6xk70007la04i7dw2nih	cmkpj6xk70006la04l1nbeona	2026-01-29 13:57:32.531+00	2026-01-29 14:20:11.972+00
cmkziqpwx000bl804u3xe5hrs	5	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj8hrx0005ky04h0vkyie1	cmkpj8hrx0004ky04kk74xl6d	2026-01-29 13:57:32.721+00	2026-01-29 14:20:12.069+00
cmkziqq27000dl8047xp06rgj	6	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkp6quuj0001l404pur8bk1u	cmkp6quui0000l404vez9eztk	2026-01-29 13:57:32.912+00	2026-01-29 14:20:12.166+00
cmkziqq7i000fl8047apx3cdc	7	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkp6u19w0001lb04tm8w3b06	cmkp6u19v0000lb04aw46ghu4	2026-01-29 13:57:33.102+00	2026-01-29 14:20:12.263+00
cmkziqqi3000jl80480edou3v	8	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpiu83z0003l204nbpocbby	cmkpiu83y0002l204vpxb74j6	2026-01-29 13:57:33.483+00	2026-01-29 14:20:12.36+00
cmkziqqnf000ll8048zjv1odl	12	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpivrp40001ky04euyawq6a	cmkpivrp40000ky04ynl7uisf	2026-01-29 13:57:33.675+00	2026-01-29 14:20:12.75+00
cmkziqqcs000hl804htmh155y	10	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpishbz0001la04hst3y6dy	cmkpishbz0000la04h16wjn1z	2026-01-29 13:57:33.292+00	2026-01-29 14:20:12.554+00
cmkziqpmc0007l8046602ljx7	3	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj6bpv000bl204nyi9pebq	cmkpj6bpv000al2041j5qonho	2026-01-29 13:57:32.34+00	2026-01-29 14:20:11.875+00
cmkziqp6l0003l8042sylxxyh	2	both	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpinfve0001l204p27o7e8m	cmkpinfve0000l204jsys1th6	2026-01-29 13:57:31.773+00	2026-01-29 14:20:11.778+00
cmkziqqsp000nl8041g51bly0	13	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj1yxb0005l204plmjjpk7	cmkpj1yxb0004l204wiypnsku	2026-01-29 13:57:33.866+00	2026-01-29 14:20:12.847+00
cmkziqqy1000pl804tas12j9j	14	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj2wnw0003la04whkmizgt	cmkpj2wnw0002la046k5yp2nd	2026-01-29 13:57:34.057+00	2026-01-29 14:20:12.944+00
cmkziqr3b000rl8041mmsvlbq	15	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj3tux0001jr040xtzdu1r	cmkpj3tux0000jr04fljezhyg	2026-01-29 13:57:34.247+00	2026-01-29 14:20:13.041+00
cmkziqrdv000vl804hpf87uvy	17	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj5sm10009l204ky6cz3ha	cmkpj5sm10008l204miol0uyo	2026-01-29 13:57:34.628+00	2026-01-29 14:20:13.234+00
cmkziqs4e0015l804wpqqbfcd	0	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpiwhwe0003ky046yn0ed8x	cmkpiwhwe0002ky044ol2lgu7	2026-01-29 13:57:35.582+00	2026-01-29 14:20:11.58+00
cmkziqph10005l804ya1kdykv	1	both	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj4hd90005la047z4tult2	cmkpj4hd90004la04rj6q2zl9	2026-01-29 13:57:32.149+00	2026-01-29 14:20:11.678+00
cmkziqrtt0011l804172riwvg	9	both	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkp6s1h10001l104qkoaqwag	cmkp6s1h10000l104nwmcuhj9	2026-01-29 13:57:35.201+00	2026-01-29 14:20:12.457+00
cmkziqroh000zl804knot5il2	11	both	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkp6ri900001ju04vp0pmaam	cmkp6ri900000ju04ere0b180	2026-01-29 13:57:35.01+00	2026-01-29 14:20:12.651+00
cmkziqr8l000tl80473se0mtz	16	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj53je0007l204v5sg9l9o	cmkpj53je0006l204xvdz3fr5	2026-01-29 13:57:34.437+00	2026-01-29 14:20:13.137+00
cmkziqrj6000xl804rpiuln7m	18	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkpj7uvs0009la040xj99bmt	cmkpj7uvs0008la0433wddlr5	2026-01-29 13:57:34.819+00	2026-01-29 14:20:13.331+00
cmkziqrz40013l804ol1dbqk5	19	dropoff	planned	\N	\N	\N	\N	cmkziqp1c0001l8047dx757hi	cmkp6tdkd0003l404xmm686b9	cmkp6tdkd0002l404xz56pp5s	2026-01-29 13:57:35.392+00	2026-01-29 14:20:13.428+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, external_id, first_name, last_name, role, "companyId", "vehicleId", created_at, updated_at) FROM stdin;
cmkmmtrgz002gpg0b7v5rybu2	oudjedi.chabane@tds-transports.fr	user_2zYJTzmaVUCbfIN66MN9qlSJ9Xa	Oudjedi	Chabane	admin	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002ipg0buu40i13n	2026-01-20 13:30:52.54+00	2026-01-20 13:30:52.54+00
cmkmmtrgz002fpg0b085wvg34	bilel-du-73@hotmail.fr	user_31pgVb3VShRLcjzFRLNUei6JQn9	Bilel	Mokrane	member	cmkmmtnzb0000pg0b8nz0429u	cmkmmtrgz002hpg0b3rj9nj6h	2026-01-20 13:30:52.54+00	2026-01-20 13:30:52.54+00
cmkmmtr7g002epg0biqhchvry	m.culoma@adeis.org	user_30gVjZQQJmrXuh0OAcT5keXGAhw	Maeva	Culoma	manager	cmkmmtnzb0002pg0bqq1nopcy	\N	2026-01-20 13:30:52.54+00	2026-01-20 13:30:52.54+00
cmkmmu9w10006pg0b5kq3h8yc	expedition@dentallgroup.eu	user_38LOrjB42QeajtfdXmH6Z1z0idX	Annie	Vongsouthi	manager	cmkmmufqk0009pg0b7a5y9m2d	\N	2026-01-22 08:21:14.070415+00	2026-01-22 08:21:14.070415+00
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vehicles (id, plate, model, company_id, created_at, updated_at) FROM stdin;
cmkmmtrgz002ipg0buu40i13n	WW-887-GB	2025 Explorer EV	cmkmmtnzb0000pg0b8nz0429u	2026-01-20 13:30:52.54+00	2026-01-20 13:30:52.54+00
cmkmmtrgz002hpg0b3rj9nj6h	WW-862-GB	2025 Explorer EV	cmkmmtnzb0000pg0b8nz0429u	2026-01-20 13:30:52.54+00	2026-01-20 13:30:52.54+00
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: client_settings client_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_settings
    ADD CONSTRAINT client_settings_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- Name: delivery_request_stops delivery_request_stops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_request_stops
    ADD CONSTRAINT delivery_request_stops_pkey PRIMARY KEY (id);


--
-- Name: delivery_requests delivery_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_requests
    ADD CONSTRAINT delivery_requests_pkey PRIMARY KEY (id);


--
-- Name: stops stops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stops
    ADD CONSTRAINT stops_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: addresses_city_state_postalCode_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "addresses_city_state_postalCode_idx" ON public.addresses USING btree (city, state, "postalCode");


--
-- Name: addresses_latitude_longitude_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX addresses_latitude_longitude_idx ON public.addresses USING btree (latitude, longitude);


--
-- Name: client_settings_client_company_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX client_settings_client_company_id_key ON public.client_settings USING btree (client_company_id);


--
-- Name: companies_type_parent_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX companies_type_parent_id_idx ON public.companies USING btree (type, parent_id);


--
-- Name: deliveries_date_delivery_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deliveries_date_delivery_status_idx ON public.deliveries USING btree (date, delivery_status);


--
-- Name: deliveries_delivery_company_id_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deliveries_delivery_company_id_date_idx ON public.deliveries USING btree (delivery_company_id, date);


--
-- Name: deliveries_driver_id_vehicle_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deliveries_driver_id_vehicle_id_idx ON public.deliveries USING btree (driver_id, vehicle_id);


--
-- Name: deliveries_number_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX deliveries_number_key ON public.deliveries USING btree (number);


--
-- Name: delivery_request_stops_delivery_stop_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delivery_request_stops_delivery_stop_id_idx ON public.delivery_request_stops USING btree (delivery_stop_id);


--
-- Name: delivery_request_stops_delivery_stop_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX delivery_request_stops_delivery_stop_id_key ON public.delivery_request_stops USING btree (delivery_stop_id);


--
-- Name: delivery_request_stops_end_client_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delivery_request_stops_end_client_id_idx ON public.delivery_request_stops USING btree (end_client_id);


--
-- Name: delivery_request_stops_request_id_sequence_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delivery_request_stops_request_id_sequence_idx ON public.delivery_request_stops USING btree (request_id, sequence);


--
-- Name: delivery_requests_client_company_id_date_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX delivery_requests_client_company_id_date_key ON public.delivery_requests USING btree (client_company_id, date);


--
-- Name: delivery_requests_delivery_company_id_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delivery_requests_delivery_company_id_date_idx ON public.delivery_requests USING btree (delivery_company_id, date);


--
-- Name: stops_delivery_id_sequence_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stops_delivery_id_sequence_idx ON public.stops USING btree (delivery_id, sequence);


--
-- Name: stops_status_end_client_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stops_status_end_client_id_idx ON public.stops USING btree (status, end_client_id);


--
-- Name: users_companyId_vehicleId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "users_companyId_vehicleId_idx" ON public.users USING btree ("companyId", "vehicleId");


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: users_external_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_external_id_key ON public.users USING btree (external_id);


--
-- Name: vehicles_company_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX vehicles_company_id_idx ON public.vehicles USING btree (company_id);


--
-- Name: vehicles_plate_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX vehicles_plate_key ON public.vehicles USING btree (plate);


--
-- Name: client_settings client_settings_client_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_settings
    ADD CONSTRAINT client_settings_client_company_id_fkey FOREIGN KEY (client_company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: companies companies_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: companies companies_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: deliveries deliveries_delivery_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_delivery_company_id_fkey FOREIGN KEY (delivery_company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: deliveries deliveries_driver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: deliveries deliveries_vehicle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: delivery_request_stops delivery_request_stops_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_request_stops
    ADD CONSTRAINT delivery_request_stops_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: delivery_request_stops delivery_request_stops_delivery_stop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_request_stops
    ADD CONSTRAINT delivery_request_stops_delivery_stop_id_fkey FOREIGN KEY (delivery_stop_id) REFERENCES public.stops(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: delivery_request_stops delivery_request_stops_end_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_request_stops
    ADD CONSTRAINT delivery_request_stops_end_client_id_fkey FOREIGN KEY (end_client_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: delivery_request_stops delivery_request_stops_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_request_stops
    ADD CONSTRAINT delivery_request_stops_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.delivery_requests(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: delivery_requests delivery_requests_client_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_requests
    ADD CONSTRAINT delivery_requests_client_company_id_fkey FOREIGN KEY (client_company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: delivery_requests delivery_requests_delivery_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delivery_requests
    ADD CONSTRAINT delivery_requests_delivery_company_id_fkey FOREIGN KEY (delivery_company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stops stops_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stops
    ADD CONSTRAINT stops_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stops stops_delivery_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stops
    ADD CONSTRAINT stops_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.deliveries(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stops stops_end_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stops
    ADD CONSTRAINT stops_end_client_id_fkey FOREIGN KEY (end_client_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users users_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users users_vehicleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES public.vehicles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vehicles vehicles_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict BjzbQhASedlO775npkZf9y7UbJsdrXcjqxwb3XU3nS2gowFFLJbXAFBijF8wjFT

