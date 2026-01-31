--
-- PostgreSQL database dump
--

\restrict EU7hTEB4Ho2qhcEUmgUF0K9nxaLBVagD4IIn2B4yu5TYj1XZaVY3fYWHO99jmZy

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
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_vehicle_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_driver_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_delivery_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_delivery_batch_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_client_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_parent_id_fkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_address_id_fkey;
ALTER TABLE IF EXISTS ONLY public.batches DROP CONSTRAINT IF EXISTS batches_driver_id_fkey;
ALTER TABLE IF EXISTS ONLY public.batches DROP CONSTRAINT IF EXISTS batches_delivery_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.batches DROP CONSTRAINT IF EXISTS "batches_companyId_fkey";
ALTER TABLE IF EXISTS ONLY public.batches DROP CONSTRAINT IF EXISTS batches_client_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.batch_items DROP CONSTRAINT IF EXISTS batch_items_company_id_fkey;
ALTER TABLE IF EXISTS ONLY public.batch_items DROP CONSTRAINT IF EXISTS batch_items_batch_id_fkey;
DROP INDEX IF EXISTS public.vehicles_plate_key;
DROP INDEX IF EXISTS public.vehicles_company_id_idx;
DROP INDEX IF EXISTS public.users_external_id_key;
DROP INDEX IF EXISTS public.users_email_key;
DROP INDEX IF EXISTS public."users_companyId_vehicleId_idx";
DROP INDEX IF EXISTS public.stops_status_end_client_id_idx;
DROP INDEX IF EXISTS public.stops_delivery_id_sequence_idx;
DROP INDEX IF EXISTS public.deliveries_driver_id_vehicle_id_idx;
DROP INDEX IF EXISTS public.deliveries_date_delivery_status_idx;
DROP INDEX IF EXISTS public.companies_type_parent_id_idx;
DROP INDEX IF EXISTS public.batches_delivery_company_id_client_company_id_name_key;
DROP INDEX IF EXISTS public.batches_delivery_company_id_client_company_id_idx;
DROP INDEX IF EXISTS public.batch_items_batch_id_company_id_key;
DROP INDEX IF EXISTS public.addresses_latitude_longitude_idx;
DROP INDEX IF EXISTS public."addresses_city_state_postalCode_idx";
ALTER TABLE IF EXISTS ONLY public.vehicles DROP CONSTRAINT IF EXISTS vehicles_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.stops DROP CONSTRAINT IF EXISTS stops_pkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_pkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_pkey;
ALTER TABLE IF EXISTS ONLY public.batches DROP CONSTRAINT IF EXISTS batches_pkey;
ALTER TABLE IF EXISTS ONLY public.batch_items DROP CONSTRAINT IF EXISTS batch_items_pkey;
ALTER TABLE IF EXISTS ONLY public.addresses DROP CONSTRAINT IF EXISTS addresses_pkey;
ALTER TABLE IF EXISTS ONLY public._prisma_migrations DROP CONSTRAINT IF EXISTS _prisma_migrations_pkey;
DROP TABLE IF EXISTS public.vehicles;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.stops;
DROP TABLE IF EXISTS public.deliveries;
DROP TABLE IF EXISTS public.companies;
DROP TABLE IF EXISTS public.batches;
DROP TABLE IF EXISTS public.batch_items;
DROP TABLE IF EXISTS public.addresses;
DROP TABLE IF EXISTS public._prisma_migrations;
DROP TYPE IF EXISTS public.user_roles;
DROP TYPE IF EXISTS public.stop_statuses;
DROP TYPE IF EXISTS public.step_type;
DROP TYPE IF EXISTS public.request_statuses;
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
-- Name: request_statuses; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.request_statuses AS ENUM (
    'pending',
    'accepted',
    'declined',
    'expired'
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
    "externalId" text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    "postalCode" text NOT NULL,
    country text NOT NULL,
    "formattedAddress" text NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: batch_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_items (
    id text NOT NULL,
    batch_id text NOT NULL,
    company_id text NOT NULL,
    default_sequence integer,
    default_notes text,
    default_type public.step_type,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batches (
    id text NOT NULL,
    name text NOT NULL,
    delivery_company_id text NOT NULL,
    client_company_id text NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    "companyId" text,
    driver_id text
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
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deliveries (
    id text NOT NULL,
    number text,
    date timestamp(6) with time zone NOT NULL,
    notes text,
    batch_name text NOT NULL,
    driver_name text,
    vehicle_license_plate text,
    driver_notes text,
    request_status public.request_statuses DEFAULT 'pending'::public.request_statuses NOT NULL,
    delivery_status public.delivery_statuses,
    scheduled_at timestamp(6) with time zone,
    started_at timestamp(6) with time zone,
    finished_at timestamp(6) with time zone,
    delivery_batch_id text NOT NULL,
    delivery_company_id text NOT NULL,
    client_company_id text NOT NULL,
    driver_id text,
    vehicle_id text,
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
5984f31b-7353-4ace-a0a7-9bf1aab96af0	cd40a00194513e37bb86bc337a6c1a0500605c2881ad7a367948be139feb1933	2025-09-26 14:04:48.003863+00	20250926131818_baseline	\N	\N	2025-09-26 14:04:47.744806+00	1
30b6bd16-7489-4545-a558-f9e24a9ecfc9	5c7a29800e1b3c77485e7e32a0a0f56a6c6a0300d791cc2bfe7454b0bb0a1f1b	2025-10-27 19:29:36.607878+00	20251027192057_add_driver_relation_to_batches	\N	\N	2025-10-27 19:29:36.574421+00	1
\.


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.addresses (id, "externalId", address, city, state, "postalCode", country, "formattedAddress", latitude, longitude, created_at, updated_at) FROM stdin;
cmfxz4zwr0001z0l6ax20h0eu	dXJuOm1ieGFkcjphYjFhMmVkMC05MzhkLTQ5MjgtYWRkZS1lYTNkY2NiNDYyYmQ	168 Impasse De Lachat	Vimines	Savoie	73160	France	168 Impasse De Lachat, 73160 Vimines, France	45.555925	5.875215	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zws0003z0l6w5sfl0s9	dXJuOm1ieGFkci1zdHI6ZjBjYjUzZDctMTcyYi00YTAzLWExNjUtYTRiOTZjOGRhNGYx	520 Rue Du Clapet	La Ravoire	Savoie	73490	France	520 Rue Du Clapet, 73490 La Ravoire, France	45.556056	5.947237	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv002dz0l6gahroelv	dXJuOm1ieGFkcjo0OTljMmVkMy0yZTNhLTRiZmUtODk3NS1iMmU3NGU2NzUxYmI	6 Avenue De Savoie	Montmélian	Savoie	73800	France	6 Avenue De Savoie, 73800 Montmélian, France	45.500713	6.049932	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv002bz0l65kx21hd9	dXJuOm1ieGFkcjo4OTUxMDgwYy02ZmQ5LTQzYWItYjk4Yi03NWZiZTYxMWZiYzM	23 Avenue Du 8 Mai 1945	Moûtiers	Savoie	73600	France	23 Avenue Du 8 Mai 1945, 73600 Moûtiers, France	45.485429	6.530886	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0029z0l6eswn432w	dXJuOm1ieGFkcjpjNDZjZWFhOC1hNTYwLTQ4YmEtYTNlMi00NTRhMDY1NzUwYzk	110 Avenue De La Gare	Pontcharra	Isère	38530	France	110 Avenue De La Gare, 38530 Pontcharra, France	45.432128	6.019905	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0027z0l6brs1boyd	dXJuOm1ieGFkcjo2OWRmN2ZlOS00ZGRjLTQyZjUtYTY4Ny1mYmFkYTliZmRlZDE	532 Chemin Des Noyers	Chapareillan	Isère	38530	France	532 Chemin Des Noyers, 38530 Chapareillan, France	45.469725	5.993364	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0025z0l6p6fal4j9	1s0x478bb216865ca677	Place Albert Serraz	Montmelian	Savoie	73800	France	Place Albert Serraz, 73800 Montmelian, France	45.50232	6.054435	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0023z0l60za498k4	dXJuOm1ieGFkcjo0NTkwNjQ0MS05MmQzLTQ2YmItOTU0ZS1hOTNmMTg1ZWNiMGE	345 Rue De La Fin De La Louza	Saint-Pierre-d'Albigny	Savoie	73250	France	345 Rue De La Fin De La Louza, 73250 Saint-Pierre-d'Albigny, France	45.560794	6.152823	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0021z0l6dlwf7doq	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJeE1TQkRhR1Z0YVc0Z1pHVWdiR0VnUTJoaGNtVjBkR1VpZlE6Mg	11 Chemin De La Charette	Albertville	Savoie	73200	France	11 Chemin De La Charette, 73200 Albertville, France	45.6758	6.3925	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv001zz0l65qqq9usa	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJMElGQnNZV05sSUV6RHFXOXVkR2x1WlNCV2FXSmxjblFpZlE6MQ	4 Place Léontine Vibert	Albertville	Savoie	73200	France	4 Place Léontine Vibert, 73200 Albertville, France	45.666727	6.390879	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv001xz0l6ta9ckbnm	dXJuOm1ieGFkcjo3MGU0N2IwMy0xYjg5LTQ1OTYtODMxNy0xYjk5OWEyZmE4OGI	36 Avenue Des Chasseurs Alpins	Albertville	Savoie	73200	France	36 Avenue Des Chasseurs Alpins, 73200 Albertville, France	45.67168	6.391574	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001vz0l6smmcx7dy	dXJuOm1ieGFkcjozNThiMTJmMy1mOWE0LTQ4ODAtYjI4OS0zMDg0ZTIwMTI0Mjk	50 Place Du Château De Randens	Beaufort	Savoie	73270	France	50 Place Du Château De Randens, 73270 Beaufort, France	45.71785	6.576055	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001tz0l6lih8lryx	dXJuOm1ieGFkcjphZGJiY2U1OS04N2JjLTQwMmEtODZmNS1kZGE3Y2UyZGRkYjY	24 Place Du Marché Au Bois	Moûtiers	Savoie	73600	France	24 Place Du Marché Au Bois, 73600 Moûtiers, France	45.4838	6.53383	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001rz0l6zsw1krxj	dXJuOm1ieGFkcjo3YWQ2NzY0Zi1jOTk3LTRmNjQtODhkYi1mYjYyMzUxZDU2ZWQ	30 Route Des Moulins	Bozel	Savoie	73350	France	30 Route Des Moulins, 73350 Bozel, France	45.442147	6.648579	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001pz0l6qnbahf8g	dXJuOm1ieGFkcjo2NjY0MDQyNS0zOWZhLTRhZGYtYTc3Zi0xYjc3Mzk4ZjY4MTU	81 Rue Charlot Raymond	Grignon	Savoie	73200	France	81 Rue Charlot Raymond, 73200 Grignon, France	45.648241	6.373318	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001nz0l6phnv13ya	dXJuOm1ieGFkcjo5N2I2NzgxNi1lNDViLTRjNGYtOTYxNS1iNWYxYzUzNGQ5Yjk	86 Rue Des Tribunes	Épierre	Savoie	73220	France	86 Rue Des Tribunes, 73220 Épierre, France	45.453361	6.296925	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001lz0l660mpkd0r	dXJuOm1ieGFkcjplNDBiZTZjYS1kOTA4LTQ4YzktYmVhOS1lMDcyODUxNzhkZTE	223 Quai De L'arvan	Saint-Jean-de-Maurienne	Savoie	73300	France	223 Quai De L'arvan, 73300 Saint-Jean-de-Maurienne, France	45.273236	6.352858	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001hz0l6bs46doc7	dXJuOm1ieGFkcjoyMDdkMTQ3MC1lNWUzLTQzYmMtYjBkMi1lMTg4YzY4ZGViMWU	46 Rue Du Lac	Crêts en Belledonne	Isère	38830	France	46 Rue Du Lac, 38830 Crêts en Belledonne, France	45.375099	6.053942	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001fz0l6t4ipmm4j	dXJuOm1ieGFkcjoyZTU5NjVlMy0wZWNkLTQxYmQtOGJiZC0xMmIyMzkyOGQ3MDY	34 Bis Boulevard De La Libération	Villard-Bonnot	Isère	38190	France	34 Bis Boulevard De La Libération, 38190 Villard-Bonnot, France	45.25864	5.907362	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001dz0l6jrju1qt7	dXJuOm1ieGFkcjo5MWEwZjU4Zi1jN2U3LTQ5NTEtYTIwNC1lZTlmNmI3MmIyYmI	5 Rue Du Bourgamon	Saint-Martin-d'Hères	Isère	38400	France	5 Rue Du Bourgamon, 38400 Saint-Martin-d'Hères, France	45.167128	5.760566	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001bz0l6v7xbgn16	dXJuOm1ieGFkcjo4NGIxOThjYy1hYWI3LTQ2ZDktYWFhOS1iOTM3M2Y4ZDRlNDk	14 Rue Paul Langevin	Échirolles	Isère	38130	France	14 Rue Paul Langevin, 38130 Échirolles, France	45.145518	5.724772	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0019z0l6zp0crwh8	dXJuOm1ieGFkcjo0MDMyMjkxNi1iNDIxLTQyNmMtOGUwNS1mOGNjN2UyMjgxOWE	14 Rue Félix Esclangon	Grenoble	Isère	38000	France	14 Rue Félix Esclangon, 38000 Grenoble, France	45.191456	5.706861	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0017z0l6ub68avv8	dXJuOm1ieGFkcjo3MzQ5NWFmNy1hMWJhLTQxOTgtYTIyOC0xNThiY2RmMTMzOGQ	8 Rue Du Lieutenant Chanaron	Grenoble	Isère	38000	France	8 Rue Du Lieutenant Chanaron, 38000 Grenoble, France	45.186911	5.723093	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0015z0l6yk4ftah0	dXJuOm1ieGFkcjo1ZDFjYzZhNy01MDU5LTQxNTEtYmY4OS0yNjI3OTJjYmMyMWQ	34 Rue Champ Rochas	Meylan	Isère	38240	France	34 Rue Champ Rochas, 38240 Meylan, France	45.207751	5.75951	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0013z0l6a38aqbd4	dXJuOm1ieGFkcjo1ZWU1ZTA0YS1jZjliLTQxODgtODU1Yy1hYTFlZjFlYWFlOTg	4 Allée Des Amphores	Meylan	Isère	38240	France	4 Allée Des Amphores, 38240 Meylan, France	45.211336	5.785465	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0011z0l6mxi3uvv6	dXJuOm1ieGFkcjo1ZWU1ZTA0YS1jZjliLTQxODgtODU1Yy1hYTFlZjFlYWFlOTg	73 Chemin De La Falaise	Crolles	Isère	38920	France	73 Chemin De La Falaise, 38920 Crolles, France	45.288107	5.885494	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000zz0l6ke2so588	dXJuOm1ieGFkcjphNjAyNWQ5OC1mMmQ1LTRmODQtYTFiOS1hMDk1NzQ3YmFiMzI	21 Montée De Tresserve	Tresserve	Savoie	73100	France	21 Montée De Tresserve, 73100 Tresserve, France	45.678795	5.90123	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000xz0l6virvjlx8	dXJuOm1ieGFkcjozNmIwMjU1Ni03MzhiLTQ2NjctYTY5Ni1jZTNhYzUwMmZiMDk	12 Rue De La Chaudanne	Aix-les-Bains	Savoie	73100	France	12 Rue De La Chaudanne, 73100 Aix-les-Bains, France	45.690656	5.913952	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000vz0l6ejbrh7fe	dXJuOm1ieGFkcjo4M2Y3YjU4Mi0yNDNlLTQzZDctOTIzNi02ZTI4MmFmZWVmYWE	186 Avenue Du Grand Port	Aix-les-Bains	Savoie	73100	France	186 Avenue Du Grand Port, 73100 Aix-les-Bains, France	45.704344	5.895577	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000tz0l6za4gmxhm	dXJuOm1ieGFkcjowMDg2MDU2NS1hMDE5LTQxM2QtYmZjNC02NGY5YTc4NGFlMzM	40 Route Des Gorges Du Sierroz	Grésy-sur-Aix	Savoie	73100	France	40 Route Des Gorges Du Sierroz, 73100 Grésy-sur-Aix, France	45.722547	5.922847	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000rz0l67swnwr7w	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJeU5UVWdVblZsSUVSbElFMXZkWFIwYVN3Z056UTFOREFnUVV4Q1dTQlRWVklnUTBoRlVrRk9JbjA6MA	255 Rue De Moutti	Alby-sur-Chéran	Haute-Savoie	74540	France	255 Rue De Moutti Sud, 74540 Alby-sur-Chéran, France	45.814975	6.003934	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000pz0l66llbzvxl	dXJuOm1ieGFkcjo3ZjBlZjljOS1lZThmLTRlMTMtOTUxZC1kMGRiODEzZjFhOGY	1 Place Du 18 Juin 1940	Annecy	Haute-Savoie	74600	France	1 Place Du 18 Juin 1940, 74600 Annecy, France	45.91514	6.145598	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000nz0l6vptvuhz7	dXJuOm1ieGFkcjo4NjQzNWU2Zi05MjRmLTRmOGMtYWI0Zi0yNzEzYjJhOTIwMWU	5 Rue De Vénétie	Annecy	Haute-Savoie	74600	France	5 Rue De Vénétie, 74600 Annecy, France	45.911399	6.149202	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000lz0l6owoi6g7u	dXJuOm1ieGFkci1zdHI6ZThlNzIwNzUtYjg5Yi00MmRjLWEzZDgtNzQxNzYzNzdlYjJl	34 Bis Avenue De La Mavéria	Annecy	Haute-Savoie	74600	France	34 Bis Avenue De La Mavéria, 74600 Annecy, France	45.908868	6.142433	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000jz0l6uk09y3b6	dXJuOm1ieGFkci1zdHI6M2Y4N2UzOTctMDFjMC00ZGI2LTg3NzQtOTQyNzllYWUwZTRi	168 Rue Des Savoie	Epagny Metz-Tessy	Haute-Savoie	74330	France	168 Rue Des Savoie, 74330 Epagny Metz-Tessy, France	45.923614	6.083546	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000hz0l6khrgmt7o	dXJuOm1ieGFkcjpkNDA2NjY2MS00MzcwLTQ4MmMtYTExYi0yMjkxYjdjNjkzODI	17 Rue Du Fier	Thoiry	Ain	01710	France	17 Rue Du Fier, 01710 Thoiry, France	46.227932	5.968529	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000fz0l6iax5t11k	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJMk1TQlNiM1YwWlNCRVpTQldaWEpzYVc5NkxDQTNOREUxTUNCV1FVeEpSVkpGVXlCVFZWSWdSa2xGVWlKOTow	61 Route De Verlioz	Vallières-sur-Fier	Haute-Savoie	74150	France	61 Route De Verlioz, 74150 Vallières-sur-Fier, France	45.900216	5.935386	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000dz0l6t3nwdm9u	dXJuOm1ieGFkcjo1ODJkYTM5OS0zY2IyLTQ4OTMtYjhiYi00NmZmMGUxMGJmODQ	13 Boulevard Du Mail	Belley	Ain	01300	France	13 Boulevard Du Mail, 01300 Belley, France	45.760147	5.689724	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000bz0l61lev0d5m	dXJuOm1ieGFkcjpkOWU4NGQ5Yy1lOThlLTQxNWQtOGY2MC1hNzA5MWFhZDY3NDA	24 Impasse De La Levaz Basse	Vézeronce-Curtin	Isère	38510	France	24 Impasse De La Levaz Basse, 38510 Vézeronce-Curtin, France	45.667786	5.470308	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt0009z0l6ja0s4dxo	dXJuOm1ieGFkcjpjOGM3NzhhZi02MzBjLTRlZWItODQ0YS1hZWM4NDU3MGY0M2M	50 Place Blanc Jolicoeur	Aoste	Isère	38490	France	50 Place Blanc Jolicoeur, 38490 Aoste, France	45.586957	5.607554	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt0007z0l6tsu4632a	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNISnZlR2x0YVhSNUlqb2lMVGN6TGprNU1EVTVNeXcwTUM0M05EQXhNakVpTENKeWIzVjBhVzVuSWpvaWRISjFaU0lzSW5SNWNHVnpJam9pWVdSa2NtVnpjeXhoWkdSeVpYTnpMR052ZFc1MGNua3NjbVZuYVc5dUxIQnZjM1JqYjJSbExHUnBjM1J5YVdOMExIQnNZV05sTEd4dlkyRnNhWFI1TEc1bGFXZG9ZbTl5YUc5dlpDSXNJbVY0Y0c5elpWQnliMjFwYm1WdVkyVWlPaUowY25WbElpd2lkbVZ5YzJsdmJpSTZOU3dpWTJGc2JHSmhZMnNpT201MWJHd3NJbkVpT2lJNU1DQkRhR1Z0YVc0Z1JHVWdRMlYxY25aaGVpd2dOek0wTnpBZ1RrOVdRVXhCU1ZORkluMDow	90 Chemin De Courvaz	Novalaise	Savoie	73470	France	90 Chemin De Courvaz, 73470 Novalaise, France	45.596294	5.776131	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt0005z0l6377zbls6	dXJuOm1ieGFkcjozZWVkMTMzMS1jODczLTQwNmUtOWI5OC01NTIzZGViNDQwMjE	256 Route Du Châtelard	Le Bourget-du-Lac	Savoie	73370	France	256 Route Du Châtelard, 73370 Le Bourget-du-Lac, France	45.646421	5.854933	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmiaos1hs0001ky0rmvj0x5q1	dXJuOm1ieGFkcjpjNGMxYTdhNS0zMGI3LTRiODktYWRlZi1lMzk4ZmUzODQwOTE	24 Rue Du Docteur Grange	Saint-Jean-de-Maurienne	Savoie	73300	France	24 Rue Du Docteur Grange, 73300 Saint-Jean-de-Maurienne, France	45.278103	6.343807	2025-11-22 19:32:53.006+00	2025-11-22 19:32:53.006+00
cmj8fy13701e6gr0rzan7pd7n	dXJuOm1ieGFkcjo4MTYxYWJhNi0xM2RmLTQ3MWUtYjljNC1hMThjN2E1ZmVlNWU	10 Square Aristide Briand	Thonon-les-Bains	Haute-Savoie	74200	France	10 Square Aristide Briand, 74200 Thonon-les-Bains, France	46.371988	6.4783	2025-12-16 10:29:45.859+00	2025-12-16 10:29:45.859+00
cmfxz4zwu001jz0l6qz399lde	dXJuOm1ieGFkci1pdHA6ZXlKaGRYUnZZMjl0Y0d4bGRHVWlPaUowY25WbElpd2lablY2ZW5sTllYUmphQ0k2SW5SeWRXVWlMQ0pzYVcxcGRDSTZJak13SWl3aWNtOTFkR2x1WnlJNkluUnlkV1VpTENKMGVYQmxjeUk2SW1Ga1pISmxjM01zWVdSa2NtVnpjeXhqYjNWdWRISjVMSEpsWjJsdmJpeHdiM04wWTI5a1pTeGthWE4wY21samRDeHdiR0ZqWlN4c2IyTmhiR2wwZVN4dVpXbG5hR0p2Y21odmIyUWlMQ0psZUhCdmMyVlFjbTl0YVc1bGJtTmxJam9pZEhKMVpTSXNJblpsY25OcGIyNGlPalVzSW1OaGJHeGlZV05ySWpwdWRXeHNMQ0p4SWpvaU9Ea2djblZsSUdSbElHeGhJR1p5ZFdsMGFXVnlaU0EzTXpNNU1DSjk6MA	89 Rue De La Fruitière	Châteauneuf	Savoie	73390	France	89 Rue De La Fruitière, 73390 Châteauneuf, France	45.545552	6.180739	2025-09-24 12:42:28.683+00	2025-12-29 08:51:27.552+00
cmkmapsx70117gr0rv8bwx2n8	dXJuOm1ieGFkcjo0YjgwYjc2Mi02MzU1LTQ5NGItYjAxOS03ZGI0YjU0MjMzNzA	63 Avenue Du Général De Gaulle	Saint-Égrève	Isère	38120	France	63 Avenue Du Général De Gaulle, 38120 Saint-Égrève, France	45.23335	5.678029	2026-01-20 07:51:52.747+00	2026-01-20 12:23:09.436+00
\.


--
-- Data for Name: batch_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.batch_items (id, batch_id, company_id, default_sequence, default_notes, default_type, created_at, updated_at) FROM stdin;
cmfxz530z002rz0l67kqlq0zy	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt000az0l6a8g0jvfx	3		pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z002tz0l6cgfdmeyf	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt000cz0l63jopkl86	4		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z002xz0l6rl5f2nbf	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt000gz0l6c4hu1zfe	5		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z0031z0l6m03f3dbm	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt000kz0l6o7lrq20g	7		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z0034z0l6y05bv78i	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt000mz0l6pwecpw20	8	Boite au lettre du haut	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z0036z0l6q7pkc41h	cmfxz530y002jz0l6fdvndz70	cmfxz4zwu000oz0l6aj2tgboj	9	2306 placard étage	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z002zz0l6i14wkqv7	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt000iz0l6shrzls03	10	3ème étage CODE: 2606	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z002vz0l6j1fzw5vz	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt000ez0l6haauf9ol	11	La porte de gauche	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z0038z0l6ps8hvk6f	cmfxz530y002jz0l6fdvndz70	cmfxz4zwu000qz0l6k4qx5gcg	12		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z003az0l62puippeq	cmfxz530y002jz0l6fdvndz70	cmfxz4zwu000sz0l6ciblpcl8	13	Fermé mercredi & jeudi	pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z003cz0l6nmm7cbp4	cmfxz530y002jz0l6fdvndz70	cmfxz4zwu000uz0l6unuyenon	14		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z003ez0l6nzatwg1v	cmfxz530y002jz0l6fdvndz70	cmfxz4zwu000wz0l62zksqdrp	15	À l'étage dans le placard	pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530z003gz0l6uc41upfu	cmfxz530y002jz0l6fdvndz70	cmfxz4zwu000yz0l6ldp5p81b	16		pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530y002mz0l6ujed9464	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu0010z0l60d4hr8gn	0		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530y002oz0l6f8al86r6	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu0012z0l61iqy8ovm	1		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530y002qz0l68x710ini	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu0014z0l6m7wtycqr	2		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z002sz0l6py4iccn9	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu0016z0l6b3qq7nz5	3	753B Fermé Lundi aprèm et Vendredi	pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z002uz0l6ooz1ogzf	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu0018z0l6dronn9u9	4		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z002wz0l6k5bxant9	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001az0l6zkwsszng	5		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z002yz0l6zxs69ldp	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001cz0l631u4zru7	6		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z0030z0l66zk6iwsh	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001ez0l6qvd3idqv	7		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z0032z0l679gubjhz	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001gz0l6d9nsn8j4	8		pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z0033z0l6so5a6cv5	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001iz0l6b70uwclc	9		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z0035z0l6eegnor5d	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001kz0l6g65kmde2	11		pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z0037z0l6hf0p4j4r	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001mz0l6r4dmbx2m	12		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z0039z0l6m85hbbsw	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001oz0l6iz9xe6e9	13	Fermé les Mercredi	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003bz0l65iturl46	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001qz0l6ey1vznej	14	Fermé les jeudi	pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003dz0l6qazjn2c2	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001sz0l64myqptrd	15	Fermé les Vendredi	pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003fz0l6q7g3vxbb	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwu001uz0l65paxy9cb	16		pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530y002lz0l6o20xhzt8	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt0004z0l6zqng8yuq	0	x 3612 🔔 Devant la porte	pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530y002nz0l6bn4y8pb0	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt0006z0l6yr9euw2m	1		pickup	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmfxz530y002pz0l6vd4eb78b	cmfxz530y002jz0l6fdvndz70	cmfxz4zwt0008z0l62f3uvk3y	2	Devant le porte parapluie	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00
cmg0a1f3b0002z0l6p4r8m2jw	cmfxz530y002jz0l6fdvndz70	cmj8fy13701e5gr0reelcb512	6		\N	2026-01-20 12:03:20.627379+00	2026-01-20 13:19:54.553+00
cmiag2hx00028z0it5apcv6nl	cmfxz530y002kz0l6m3xy5o3x	cmiaos1hq0000ky0rdqb761bd	10		\N	2025-11-22 19:35:45.05916+00	2026-01-20 13:20:20.918+00
cmfxz530z003iz0l6xj1gjkj0	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwv001yz0l6sidgj4lq	17		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003jz0l6j6e1hyet	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwv0020z0l6xoe8ii70	18	Fermé les Mercredi	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003kz0l6pt7w3z3x	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwv0022z0l6kl4987n9	19		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003lz0l6z64by96g	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwv0024z0l6xpkgmdf9	20		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003mz0l6egu0ahtg	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwv0026z0l6tiwbbdnj	21	ETS ACTIPOLE	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003nz0l6tvb52meg	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwv0028z0l6epzpj7sc	22		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003oz0l652pq8vx3	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwv002az0l6wm6zh6wh	23	CODE: 1945	\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmfxz530z003pz0l6fk3vk24q	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwv002cz0l6jwfd3idb	24		\N	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00
cmg0a1f3b0004z0l6k2x8w9m1	cmfxz530y002kz0l6m3xy5o3x	cmkmapsx60116gr0rbvqa8zx2	25		\N	2026-01-20 12:04:50.897227+00	2026-01-20 13:20:20.918+00
\.


--
-- Data for Name: batches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.batches (id, name, delivery_company_id, client_company_id, created_at, updated_at, "companyId", driver_id) FROM stdin;
cmfxz530y002jz0l6fdvndz70	Annecy (CHABANE)	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:32.722+00	2026-01-20 13:19:54.553+00	\N	cmfxz52gt002ez0l6ekycmz55
cmfxz530y002kz0l6m3xy5o3x	3 Vallées (BILAL)	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:32.722+00	2026-01-20 13:20:20.918+00	\N	cmfxz52nl002hz0l6bk088s1e
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.companies (id, name, type, address_id, parent_id, created_at, updated_at) FROM stdin;
cmfxz4zwr0000z0l67js09uij	Trans Dental Services	delivery	cmfxz4zwr0001z0l6ax20h0eu	\N	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zws0002z0l6x67s4cw9	ADEIS	client	cmfxz4zws0003z0l6w5sfl0s9	cmfxz4zwr0000z0l67js09uij	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv002cz0l6jwfd3idb	TAREAN	end_client	cmfxz4zwv002dz0l6gahroelv	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv002az0l6wm6zh6wh	BIRSAN	end_client	cmfxz4zwv002bz0l65kx21hd9	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0028z0l6epzpj7sc	CLINIQUE ST HUGUES	end_client	cmfxz4zwv0029z0l6eswn432w	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0026z0l6tiwbbdnj	GANDON / BERTINOTTI	end_client	cmfxz4zwv0027z0l6brs1boyd	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0024z0l6xpkgmdf9	GHENO	end_client	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0022z0l6kl4987n9	GRANGE	end_client	cmfxz4zwv0023z0l60za498k4	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv0020z0l6xoe8ii70	STOIAN	end_client	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv001yz0l6sidgj4lq	CHEVASSU	end_client	cmfxz4zwv001zz0l65qqq9usa	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwv001wz0l63nt00330	MUTUELLE ALBERTVILLE	end_client	cmfxz4zwv001xz0l6ta9ckbnm	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001uz0l65paxy9cb	BEDHET	end_client	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001sz0l64myqptrd	SEYE	end_client	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001qz0l6ey1vznej	SOLVET	end_client	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001oz0l6iz9xe6e9	ROUSSIN-MOYNIER	end_client	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001mz0l6r4dmbx2m	GROSJEAN	end_client	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001kz0l6g65kmde2	CHOKOEV / CHAUSHEVA	end_client	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001gz0l6d9nsn8j4	LAPUSAN / POPA	end_client	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001ez0l6qvd3idqv	LALO / VALLON	end_client	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001cz0l631u4zru7	LABORATOIR RASTEIRO	end_client	cmfxz4zwu001dz0l6jrju1qt7	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu001az0l6zkwsszng	BOUCHU / GUNZBURGER	end_client	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0018z0l6dronn9u9	ELKAIM	end_client	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0016z0l6b3qq7nz5	MALLET	end_client	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0014z0l6m7wtycqr	HEINELEVEQUE	end_client	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0012z0l61iqy8ovm	MAZEAU	end_client	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu0010z0l60d4hr8gn	DOPFF	end_client	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000yz0l6ldp5p81b	PUGNALE	end_client	cmfxz4zwu000zz0l6ke2so588	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000wz0l62zksqdrp	BARBONI	end_client	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000uz0l6unuyenon	LABO DES ALPES	end_client	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000sz0l6ciblpcl8	WAGNER	end_client	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000qz0l6k4qx5gcg	CARTIER / LANDREAU	end_client	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwu000oz0l6aj2tgboj	SUCHEL	end_client	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000mz0l6pwecpw20	ALEMANY / GENET	end_client	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000kz0l6o7lrq20g	MADIE	end_client	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000iz0l6shrzls03	AUCOUTURIER	end_client	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000gz0l6c4hu1zfe	EMCOLAB	end_client	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000ez0l6haauf9ol	ROMARY / MILLERET	end_client	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000cz0l63jopkl86	DUMAS	end_client	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt000az0l6a8g0jvfx	PRUDHOMMME	end_client	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt0008z0l62f3uvk3y	GUYON	end_client	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt0006z0l6yr9euw2m	CHARTIER	end_client	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmfxz4zwt0004z0l6zqng8yuq	FOUCAUD	end_client	cmfxz4zwt0005z0l6377zbls6	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-09-24 12:42:28.683+00
cmiaos1hq0000ky0rdqb761bd	HRICZAK	client	cmiaos1hs0001ky0rmvj0x5q1	cmfxz4zws0002z0l6x67s4cw9	2025-11-22 19:32:53.006+00	2025-11-22 19:32:53.006+00
cmj8fy13701e5gr0reelcb512	BALIMA	client	cmj8fy13701e6gr0rzan7pd7n	cmfxz4zws0002z0l6x67s4cw9	2025-12-16 10:29:45.859+00	2025-12-16 10:29:45.859+00
cmfxz4zwu001iz0l6b70uwclc	GIRAUD	end_client	cmfxz4zwu001jz0l6qz399lde	cmfxz4zws0002z0l6x67s4cw9	2025-09-24 12:42:28.683+00	2025-12-29 08:51:27.552+00
cmkmapsx60116gr0rbvqa8zx2	BOUTBOUL	client	cmkmapsx70117gr0rv8bwx2n8	cmfxz4zws0002z0l6x67s4cw9	2026-01-20 07:51:52.747+00	2026-01-20 12:23:09.436+00
\.


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deliveries (id, number, date, notes, batch_name, driver_name, vehicle_license_plate, driver_notes, request_status, delivery_status, scheduled_at, started_at, finished_at, delivery_batch_id, delivery_company_id, client_company_id, driver_id, vehicle_id, created_at, updated_at) FROM stdin;
cmfy3cizz000ef20r353i1c1y	TDS25-0001	2025-09-24 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	WW-887-GB	RAS	accepted	completed	\N	2025-09-24 16:21:17.362+00	2025-09-24 21:56:11.441+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-09-24 14:40:18.479+00	2025-09-24 21:56:43.328+00
cmfzhnsoe001if20r7st3b141	TDS25-0003	2025-09-25 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	WW-887-GB	+ Collecte Dr Suchel.	accepted	completed	\N	2025-09-25 15:16:25.087+00	2025-09-25 20:54:27.588+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-09-25 14:08:45.034+00	2025-09-25 20:55:10.701+00
cmfzhsbvq0027f20r3d80eti9	TDS25-0004	2025-09-25 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	WW-862-GB	RAS	accepted	completed	\N	2025-09-25 16:08:24.106+00	2025-09-25 21:57:11.697+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-09-25 14:12:16.549+00	2025-09-25 21:57:23.458+00
cmfy0qzay0000f20ruwkhp9gz	TDS25-0002	2025-09-24 00:00:00+00	Pas chez solvet	3 Vallées (BILAL)	Bilel Mokrane	WW-862-GB	RAS	accepted	completed	\N	2025-09-24 15:20:22.945+00	2025-09-24 20:47:41.645+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-09-24 13:27:33.946+00	2025-09-24 20:47:55.021+00
cmgjk8dfo005iis0q1371xnru	TDS25-0024	2025-10-09 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS	accepted	completed	\N	2025-10-09 16:30:30.152+00	2025-10-09 21:25:21.398+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-09 15:16:07.812+00	2025-10-09 21:25:29.154+00
cmg0vp07w0000cj0qollhlkgd	\N	2025-09-26 00:00:00+00		3 Vallées (BILAL)	\N	Unknown Vehicle	\N	pending	\N	\N	\N	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	\N	\N	2025-09-26 13:29:22.268+00	2025-09-26 15:00:48.168+00
cmgjjuv8k004vis0qa374hswk	TDS25-0025	2025-10-09 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-09 17:44:11.178+00	2025-10-09 23:25:07.46+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-09 15:05:37.7+00	2025-10-09 23:25:15.179+00
cmg0vrcat000hcj0qyy3de76r	TDS25-0005	2025-09-26 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	WW-887-GB	Y’a 3 boîtes dans la boite au lettre du DR Cartier, si non RAS.	accepted	completed	\N	2025-09-26 15:27:22.821+00	2025-09-26 21:28:02.902+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-09-26 13:31:11.238+00	2025-09-26 21:28:56.798+00
cmg57m585001mis0rti544b8u	TDS25-0007	2025-09-29 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-09-29 16:04:14.501+00	2025-09-29 20:07:22.518+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-09-29 14:14:08.885+00	2025-09-29 20:07:30.66+00
cmg56kvj4000gis0rylpjjfiu	TDS25-0006	2025-09-29 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS	accepted	completed	\N	2025-09-29 15:17:54.202+00	2025-09-29 21:19:20.152+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-09-29 13:45:10.048+00	2025-09-29 21:19:35.252+00
cmg6p9vpc000iis0qpy624zae	TDS25-0009	2025-09-30 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-09-30 16:18:08.084+00	2025-09-30 21:25:07.151+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-09-30 15:16:15.936+00	2025-09-30 21:25:23.008+00
cmg6p5u0k0000is0qc0o3lub7	TDS25-0008	2025-09-30 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	- 1 problème 	accepted	completed	\N	2025-09-30 16:10:53.688+00	2025-09-30 22:02:48.619+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-09-30 15:13:07.124+00	2025-09-30 22:03:18.453+00
cmg81dl2b000vis0qpf0yip8f	TDS25-0011	2025-10-01 00:00:00+00	Jai appelé barboni elle ne ma pas rep	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-01 15:14:05.894+00	2025-10-01 19:58:20.155+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-01 13:42:50.339+00	2025-10-01 19:58:24.756+00
cmg81iijk0018is0ql9my10cz	TDS25-0010	2025-10-01 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+1 Ramasse laboratoire Rasteiro	accepted	completed	\N	2025-10-01 15:24:47.631+00	2025-10-01 21:31:23.003+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-01 13:46:40.352+00	2025-10-01 21:31:46.543+00
cmg9kmdbd001lis0qw2qv4ios	TDS25-0012	2025-10-02 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS	accepted	completed	\N	2025-10-02 15:48:21.492+00	2025-10-02 21:36:24.16+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-02 15:29:19.081+00	2025-10-02 21:36:32.141+00
cmg9ldbxl002qis0qbqoucb41	\N	2025-10-02 00:00:00+00		Annecy (CHABANE)	\N	\N	\N	declined	\N	\N	\N	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	\N	\N	2025-10-02 15:50:17.001+00	2025-10-02 16:13:12.903+00
cmg9ldaju002gis0qmykfljm3	TDS25-0013	2025-10-02 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Y’avais des trucs bizarres la boîte aux lettres du docteur Dumas.	accepted	completed	\N	2025-10-02 20:53:30.97+00	2025-10-02 20:53:53.18+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-02 15:50:15.211+00	2025-10-02 20:54:59.458+00
cmgaxfsay0030is0qyjj1m5s2	TDS25-0014	2025-10-03 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	scheduled	\N	\N	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-03 14:15:53.098+00	2025-10-03 14:40:29.21+00
cmgayh66o004eis0qxldd48vj	TDS25-0016	2025-10-03 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	scheduled	\N	\N	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-03 14:44:57.36+00	2025-10-03 14:52:28.599+00
cmgay3vsf003gis0qgkeb2sis	TDS25-0015	2025-10-03 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-03 16:36:07.39+00	2025-10-03 21:51:03.808+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-03 14:34:37.36+00	2025-10-03 21:51:09.33+00
cmgazgrwf004jis0q364itdcd	TDS25-0017	2025-10-03 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	scheduled	\N	\N	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-03 15:12:38.464+00	2025-10-03 22:30:10.507+00
cmgf7qi5c0000is0qcq7ilu99	TDS25-0018	2025-10-06 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS	accepted	completed	\N	2025-10-06 15:51:01.513+00	2025-10-06 21:54:10.479+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-06 14:15:14.017+00	2025-10-06 21:54:16.807+00
cmgf7sogf000eis0qyuumu9db	TDS25-0019	2025-10-06 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	RAS	accepted	completed	\N	2025-10-06 15:37:30.791+00	2025-10-06 22:06:44.908+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-06 14:16:55.504+00	2025-10-06 22:06:54.042+00
cmggocnvp002tis0qfvo5g4cc	TDS25-0020	2025-10-07 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+1 R Elkaim\n+1 R Lalot	accepted	completed	\N	2025-10-07 16:50:23.499+00	2025-10-07 21:16:44.7+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-07 14:48:07.909+00	2025-10-07 21:17:03.44+00
cmggmvc1f002fis0q7raqef1f	TDS25-0021	2025-10-07 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte chez ALEMANY\n+ Collecte chez AUCOUTURIER	accepted	completed	\N	2025-10-07 16:26:13.255+00	2025-10-07 23:37:42.409+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-07 14:06:39.795+00	2025-10-07 23:39:03.017+00
cmgi1qwbo004gis0ql62qve5m	TDS25-0022	2025-10-08 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS	accepted	completed	\N	2025-10-08 15:15:34.896+00	2025-10-08 20:50:58.327+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-08 13:50:53.22+00	2025-10-08 20:51:03.7+00
cmgi1mc47003ris0q7sv0zmti	TDS25-0023	2025-10-08 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-08 16:28:16.971+00	2025-10-08 20:55:28.256+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-08 13:47:20.407+00	2025-10-08 20:55:58.808+00
cmh1srsf40003g90ssnkl7dsf	TDS25-0044	2025-10-22 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-22 15:47:38.918+00	2025-10-22 19:48:49.157+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-22 09:35:01.792+00	2025-10-22 19:50:10.977+00
cmgqnw35u0000jl0r4b06dlef	TDS25-0032	2025-10-14 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-10-14 18:41:41.403+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-14 14:32:56.322+00	2025-10-14 18:41:41.44+00
cmh1rj09b0000g90s6tpxhddz	TDS25-0045	2025-10-22 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	in_progress	\N	2025-10-22 20:06:50.365+00	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-22 09:00:12.431+00	2025-10-22 20:06:50.387+00
cmgkv7cmb006pis0qpm34dwwu	TDS25-0026	2025-10-10 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-10 16:38:04.579+00	2025-10-10 20:59:35.561+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-10 13:11:02.051+00	2025-10-10 20:59:42.567+00
cmgkv2sla006bis0qvvocb1v3	TDS25-0027	2025-10-10 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+1 R Bouchu	accepted	completed	\N	2025-10-10 15:28:30.756+00	2025-10-10 22:02:40.981+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-10 13:07:29.47+00	2025-10-10 22:02:51.123+00
cmh360t7o0000gc0rbfpn0unt	TDS25-0047	2025-10-23 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	RAS	accepted	completed	\N	2025-10-23 15:17:12.923+00	2025-10-23 19:32:55.872+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-23 08:33:43.908+00	2025-10-23 19:33:18.068+00
cmgmhpw4c0000is0q19l2t6ad	TDS25-0028	2025-10-11 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-11 16:30:12.689+00	2025-10-11 16:46:44.383+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-11 16:29:04.86+00	2025-10-11 16:46:55.325+00
cmh38m3x50003gc0ru8xskh3c	TDS25-0046	2025-10-23 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-10-23 16:37:29.467+00	2025-10-23 21:07:30.665+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-23 09:46:16.793+00	2025-10-23 21:07:34.032+00
cmgmoe938000iis0qvy26tye3	TDS25-0029	2025-10-11 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-10-11 19:37:07.195+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-11 19:35:59.108+00	2025-10-11 19:37:07.206+00
cmgqo00vw000ejl0r6s6l0jfx	TDS25-0033	2025-10-14 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS	accepted	completed	\N	2025-10-14 16:32:36.499+00	2025-10-14 21:48:29.937+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-14 14:35:59.996+00	2025-10-14 21:48:39.161+00
cmh4nv3nu0033gc0rfqkxuv4m	TDS25-0048	2025-10-24 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-10-24 15:40:58.676+00	2025-10-24 21:02:18.416+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-24 09:40:56.778+00	2025-10-24 21:02:21.735+00
cmgp99tva000tjl0rpiufw0t7	TDS25-0031	2025-10-13 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-10-13 18:25:31.27+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-13 14:55:57.047+00	2025-10-13 18:25:31.299+00
cmgp90qpr0000jl0rk9ogb5vi	TDS25-0030	2025-10-13 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS	accepted	completed	\N	2025-10-13 17:11:14.524+00	2025-10-13 22:14:41.341+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-13 14:48:53.056+00	2025-10-13 22:14:45.427+00
cmh4t2nhd0036gc0r09zei2e8	TDS25-0049	2025-10-24 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte chez Dr Suchel	accepted	completed	\N	2025-10-24 15:37:24.36+00	2025-10-24 22:23:46.503+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-24 12:06:47.137+00	2025-10-24 22:24:08.304+00
cmh9008p10000im0rwpf8as0i	TDS25-0050	2025-10-27 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte dr Suchel	accepted	completed	\N	2025-10-27 16:18:31.732+00	2025-10-27 19:50:22.873+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-27 10:31:56.677+00	2025-10-27 19:51:29.05+00
cmh96eo5q0003im0rrejuncs7	TDS25-0051	2025-10-27 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-10-27 17:04:04.916+00	2025-10-27 22:16:42.868+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-27 13:31:07.599+00	2025-10-27 22:16:45.721+00
cmgs3y49l0021jl0rntnrpbpt	TDS25-0035	2025-10-15 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-10-15 18:36:44.907+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-15 14:50:11.097+00	2025-10-15 18:36:44.965+00
cmgth97we003sjl0rvpe4twot	TDS25-0037	2025-10-16 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-10-16 18:40:34.716+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-16 13:50:30.206+00	2025-10-16 18:40:34.742+00
cmgth4gzh003fjl0ru47bcukx	TDS25-0036	2025-10-16 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+1 R Elkaim	accepted	completed	\N	2025-10-16 16:33:51.588+00	2025-10-16 21:30:27.227+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-16 13:46:48.701+00	2025-10-16 21:30:40.1+00
cmgs2y8ew001ljl0r5e0vsy6s	TDS25-0034	2025-10-15 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS\n	accepted	completed	\N	2025-10-15 16:52:31.248+00	2025-10-15 21:40:44.657+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-15 14:22:16.856+00	2025-10-15 21:41:14.496+00
cmha9d9o80000jj0r0fye3b7p	TDS25-0052	2025-10-28 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte Wagner	accepted	completed	\N	2025-10-28 16:41:28.849+00	2025-10-28 19:07:54.456+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-28 07:41:47.193+00	2025-10-28 19:08:13.391+00
cmguwuv13005ljl0rl5rcc4lo	TDS25-0039	2025-10-17 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-17 18:32:06.689+00	2025-10-17 20:53:15.722+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-17 13:55:00.376+00	2025-10-17 20:53:28.433+00
cmgux38ot005xjl0rjn1ch8mn	TDS25-0038	2025-10-17 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	RAS	accepted	completed	\N	2025-10-17 16:35:26.836+00	2025-10-17 21:54:09.954+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-17 14:01:31.325+00	2025-10-17 21:54:20.407+00
cmgz8cg5r006cjl0ruwimgl4x	TDS25-0040	2025-10-20 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-10-20 15:31:58.039+00	2025-10-20 19:38:23.046+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-20 14:27:41.391+00	2025-10-20 19:38:36.621+00
cmgz8hh6h006ojl0rwbj6rx0d	TDS25-0041	2025-10-20 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-10-20 16:14:22.197+00	2025-10-20 22:34:37.235+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-20 14:31:35.993+00	2025-10-20 22:34:44.49+00
cmh0sg64b001pjl0rroasqpu4	\N	2025-10-25 00:00:00+00		Annecy (CHABANE)	\N	\N	\N	pending	\N	\N	\N	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	\N	\N	2025-10-21 16:38:13.499+00	2025-10-21 16:38:13.499+00
cmh0nk1ko0000jl0rlql4yl58	TDS25-0042	2025-10-21 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	RAS	accepted	completed	\N	2025-10-21 15:57:09.188+00	2025-10-21 20:12:04.437+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-21 14:21:16.152+00	2025-10-21 20:12:16.386+00
cmh0parb7000ljl0rsvib843d	TDS25-0043	2025-10-21 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-10-21 16:32:12.302+00	2025-10-21 21:20:14.2+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-21 15:10:02.179+00	2025-10-21 21:20:17.449+00
cmhivrvby004jdj0r7dr1lph0	TDS25-0060	2025-11-03 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+R Docteur Hriczak	accepted	completed	\N	2025-11-03 16:02:10.812+00	2025-11-03 22:51:00.821+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-03 08:31:09.406+00	2025-11-03 22:51:34.231+00
cmhx5yg9l00gldj0r114wp2uh	TDS25-0074	2025-11-13 00:00:00+00	Ramasse et dépose chez Dr Hriczak	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	in_progress	\N	2025-11-13 16:09:29.104+00	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-13 08:24:59.097+00	2025-11-13 16:09:29.212+00
cmhab9xxe0004jj0r1q1mdmnh	TDS25-0053	2025-10-28 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+R ELKAIM	accepted	completed	\N	2025-10-28 16:35:08.6+00	2025-10-28 21:32:45.412+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-28 08:35:11.234+00	2025-10-28 21:33:01.191+00
cmhw1mgyk00fadj0re3vvbzef	TDS25-0072	2025-11-12 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-11-12 17:24:38.237+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-12 13:35:55.484+00	2025-11-12 17:24:38.266+00
cmhw2fxg200fddj0r23nos47a	TDS25-0073	2025-11-12 00:00:00+00	Livraison et ramasse chez Hriczak	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-11-12 16:15:44.804+00	2025-11-12 23:27:03.711+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-12 13:58:49.874+00	2025-11-12 23:27:09.967+00
cmhx8gt2o00grdj0rs94a2zya	TDS25-0075	2025-11-13 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-13 19:38:49.596+00	2025-11-14 16:02:52.994+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-13 09:35:14.736+00	2025-11-14 16:02:58.55+00
cmhc0lg5u000odj0rgduqledl	TDS25-0054	2025-10-29 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte Dr Cartier	accepted	completed	\N	2025-10-29 15:44:13.367+00	2025-10-29 20:20:52.504+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-29 13:11:44.658+00	2025-10-29 20:22:15.361+00
cmhc1japm000sdj0rgfk97tq3	TDS25-0055	2025-10-29 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-10-29 16:28:54.968+00	2025-10-29 21:04:49.908+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-29 13:38:03.899+00	2025-10-29 21:04:52.472+00
cmhemvcgk003fdj0rsbqm8l3s	TDS25-0058	2025-10-31 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Pas de boite chez BARBONI	accepted	completed	\N	2025-10-31 15:56:36.93+00	2025-10-31 21:17:05.351+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-31 09:10:50.325+00	2025-10-31 21:17:22.063+00
cmhewydm5003idj0r56nvat9x	TDS25-0059	2025-10-31 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-10-31 16:02:39.673+00	2025-10-31 21:30:30.777+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-31 13:53:07.95+00	2025-10-31 21:30:38.296+00
cmhyxkxhy00jmdj0rx181cbq9	TDS25-0077	2025-11-14 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-14 17:42:54.212+00	2025-11-14 21:09:55.621+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-14 14:06:03.67+00	2025-11-14 21:10:22.006+00
cmhypl9hd00j3dj0riyi7ufc3	TDS25-0076	2025-11-14 00:00:00+00	Ramasse chez Hriczack	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-11-14 15:26:36.865+00	2025-11-14 21:11:32.643+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-14 10:22:22.273+00	2025-11-14 21:11:37.653+00
cmhd4bzn3001kdj0ra4fl24zp	TDS25-0057	2025-10-30 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-10-30 17:01:23.216+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-10-30 07:44:07.983+00	2025-10-30 17:01:23.243+00
cmhd3oifd001hdj0r0a64wdqo	TDS25-0056	2025-10-30 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-10-30 14:52:10.922+00	2025-10-30 20:23:56.918+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-10-30 07:25:52.586+00	2025-10-30 20:24:15.916+00
cmi2triel00jzdj0rtervhwnv	TDS25-0078	2025-11-17 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-17 17:31:21.087+00	2025-11-17 22:57:38.575+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-17 07:30:16.942+00	2025-11-17 22:57:45.992+00
cmhm3yvvk00a7dj0r2teiumiu	TDS25-0065	2025-11-05 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Pas de boite chez dr Chartier !	accepted	completed	\N	2025-11-05 19:56:06.029+00	2025-11-05 21:43:51.95+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-05 14:43:52.16+00	2025-11-05 21:44:15.736+00
cmhlt7a47009tdj0rbj4b37qf	TDS25-0064	2025-11-05 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+R DOPFF\n+ HRICZAK\n+ SEYE\nPas de ramasse SOLVET 	accepted	completed	\N	2025-11-05 15:36:30.459+00	2025-11-05 22:59:38.27+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-05 09:42:28.087+00	2025-11-05 23:00:24.787+00
cmi4p9wnr00m1dj0r38w3xx51	TDS25-0081	2025-11-18 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	in_progress	\N	2025-11-18 16:03:59.443+00	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-18 15:00:09.495+00	2025-11-18 16:03:59.479+00
cmhixkakh004tdj0rha13vrrl	TDS25-0061	2025-11-03 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-03 16:56:38.328+00	2025-11-03 22:44:32.955+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-03 09:21:15.137+00	2025-11-03 22:44:41.944+00
cmhk9mzd50077dj0r0711rkgg	TDS25-0062	2025-11-04 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-04 16:45:51.093+00	2025-11-04 22:01:45.197+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-04 07:47:02.153+00	2025-11-04 22:01:50.054+00
cmhkc68fm007ddj0ro1rhs0n2	TDS25-0063	2025-11-04 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+R Hriczak	accepted	completed	\N	2025-11-04 16:43:55.726+00	2025-11-04 23:16:50.083+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-04 08:57:59.603+00	2025-11-04 23:17:18.648+00
cmhn5dgz900amdj0r2kh3uhm4	TDS25-0066	2025-11-06 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+Hriczak	accepted	completed	\N	2025-11-06 15:36:43.827+00	2025-11-06 21:49:35.605+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-06 08:10:58.485+00	2025-11-06 21:50:01.355+00
cmhn9qn8i00asdj0rx4yfeyzf	TDS25-0067	2025-11-06 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-06 18:54:01.634+00	2025-11-06 22:58:46.015+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-06 10:13:11.586+00	2025-11-06 22:58:53.653+00
cmhohy0fg00ckdj0rh8l8f1oi	TDS25-0068	2025-11-07 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-07 17:29:40.905+00	2025-11-07 20:00:46.806+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-07 06:50:38.38+00	2025-11-07 20:00:52.627+00
cmhon0nfo00cndj0rskph88a8	TDS25-0069	2025-11-07 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+HRICZAK\nPas de colis MALLET	accepted	completed	\N	2025-11-07 15:29:39.404+00	2025-11-07 21:40:40.052+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-07 09:12:39.589+00	2025-11-07 21:41:51.14+00
cmhsvlz7700dudj0r699s2gg6	TDS25-0070	2025-11-10 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-10 16:07:42.302+00	2025-11-10 20:29:30.008+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-10 08:24:16.243+00	2025-11-10 20:29:35.696+00
cmhsy900u00dzdj0r5z611ms8	TDS25-0071	2025-11-10 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-11-10 15:53:10.053+00	2025-11-10 21:53:59.11+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-10 09:38:09.63+00	2025-11-10 21:54:03.666+00
cmi2wx3s700k5dj0rhh8pmp29	TDS25-0079	2025-11-17 00:00:00+00	Ramasse et depose chez Hriczack	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+ Hriczak	accepted	completed	\N	2025-11-17 16:00:58.757+00	2025-11-17 21:32:59.628+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-17 08:58:36.775+00	2025-11-17 21:33:31.521+00
cmjtxnoxu0007gr0rdmc2emcr	TDS25-0145	2025-12-31 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	scheduled	\N	\N	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-31 11:28:46.339+00	2025-12-31 11:28:53.336+00
cmixa05bo00uxgr0rzsaez8tv	TDS25-0113	2025-12-08 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-08 16:10:09.397+00	2025-12-09 15:33:25.265+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-08 14:57:59.029+00	2025-12-09 15:33:29.457+00
cmj2l37mw0182gr0rwtrw4him	TDS25-0121	2025-12-12 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-12 16:53:17.373+00	2025-12-12 23:45:04.041+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-12 08:07:08.648+00	2025-12-12 23:45:06.659+00
cmiskw0gb00regr0rzgjxztof	TDS25-0110	2025-12-05 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-05 18:12:30.374+00	2025-12-05 23:25:50.055+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-05 08:03:50.988+00	2025-12-05 23:25:58.007+00
cmisnnrzx00smgr0rki30riax	TDS25-0111	2025-12-05 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-05 16:57:45.796+00	2025-12-05 23:47:44.426+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-05 09:21:25.63+00	2025-12-05 23:47:47.11+00
cmizqrzf9011cgr0r091vzsvr	TDS25-0116	2025-12-10 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-10 17:16:35.887+00	2025-12-10 22:34:03.525+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-10 08:23:03.957+00	2025-12-10 22:34:10.345+00
cmix8rpfi00uugr0rpbz68k5w	TDS25-0112	2025-12-08 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-08 16:45:30.166+00	2025-12-08 20:01:24.369+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-08 14:23:25.567+00	2025-12-08 20:01:28.098+00
cmizqvbe0011jgr0r6u8nd7iv	TDS25-0117	2025-12-10 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-10 17:20:48.338+00	2025-12-11 00:10:15.737+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-10 08:25:39.432+00	2025-12-11 00:10:20.249+00
cmiybqd5w00w3gr0r1sq2gfnp	TDS25-0115	2025-12-09 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-09 17:21:32.859+00	2025-12-09 22:59:03.878+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-09 08:34:08.036+00	2025-12-09 22:59:07.016+00
cmiybp5eh00vugr0ri6xopbff	TDS25-0114	2025-12-09 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	Récup chèque DOPFF	accepted	completed	\N	2025-12-09 16:07:37.671+00	2025-12-09 23:42:17.408+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-09 08:33:11.321+00	2025-12-09 23:42:32.361+00
cmj186uog014tgr0rl57u5t4o	TDS25-0119	2025-12-11 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte Suchel\n+ Collecte Alemany	accepted	completed	\N	2025-12-11 18:26:55.391+00	2025-12-11 22:31:25.087+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-11 09:18:17.297+00	2025-12-11 22:32:00.056+00
cmj16fh7d014dgr0rcnqd3oxy	TDS25-0118	2025-12-11 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-11 16:44:54.344+00	2025-12-11 22:57:42.747+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-11 08:29:00.506+00	2025-12-11 22:57:46.428+00
cmj2jkkj9017ugr0rmbs0h6ao	TDS25-0120	2025-12-12 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-12 18:24:20.756+00	2025-12-13 00:33:48.831+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-12 07:24:39.285+00	2025-12-13 00:33:58.229+00
cmj6xbo4001aygr0rtr8157a3	TDS25-0123	2025-12-15 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-15 16:41:52.083+00	2025-12-15 21:55:45.873+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-15 09:00:43.345+00	2025-12-15 21:55:49.271+00
cmj6x9psy01ahgr0r71j3cpaw	TDS25-0122	2025-12-15 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-15 16:16:38.908+00	2025-12-15 23:28:38.573+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-15 08:59:12.226+00	2025-12-15 23:28:43.199+00
cmj9uh3uo01gegr0ripjmhxga	TDS25-0126	2025-12-17 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-17 17:06:36.342+00	2025-12-17 22:35:28.655+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-17 10:04:16.704+00	2025-12-17 22:35:33.25+00
cmja655zb01h1gr0rgbtm3o07	TDS25-0127	2025-12-17 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-17 16:04:04.265+00	2025-12-17 22:41:49.06+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-17 15:30:54.984+00	2025-12-17 22:41:53.455+00
cmj8bkb3m01d5gr0rknqf6duh	TDS25-0124	2025-12-16 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-16 18:44:39.751+00	2025-12-16 22:32:07.703+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-16 08:27:07.186+00	2025-12-16 22:32:11.97+00
cmj8bo34z01degr0r9n5aktqx	TDS25-0125	2025-12-16 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-16 15:56:56.52+00	2025-12-16 22:38:36.451+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-16 08:30:03.491+00	2025-12-16 22:38:39.232+00
cmjbc89wq01jxgr0rme0b1vn7	TDS25-0130	2025-12-18 00:00:00+00	Depose chez Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-18 19:02:18.278+00	2025-12-19 00:01:04.448+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-18 11:09:03.914+00	2025-12-19 00:01:08.175+00
cmjb9bhgd01j2gr0rdxffr3i6	TDS25-0128	2025-12-18 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-18 18:08:47.878+00	2025-12-19 01:45:28.649+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-18 09:47:34.814+00	2025-12-19 01:45:31.04+00
cmjcrukbt01mqgr0rtha1l1lc	TDS25-0131	2025-12-19 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-19 16:06:59.505+00	2025-12-19 22:35:30.877+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-19 11:14:04.265+00	2025-12-19 22:35:35.736+00
cmjbc7at401jigr0rw12k19ee	TDS25-0129	2025-12-19 00:00:00+00	Ramasse chez Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte Balima	accepted	completed	\N	2025-12-19 17:09:47.679+00	2025-12-20 00:49:39.98+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-18 11:08:18.424+00	2025-12-20 00:50:28.266+00
cmjh970pm01qhgr0rewmh0mtp	TDS25-0133	2025-12-22 00:00:00+00	Livraison dr Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Livraison Dr Balima\n+ Collecte Dr Cartier	accepted	completed	\N	2025-12-22 16:40:36.139+00	2025-12-22 22:13:26.537+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-22 14:30:43.546+00	2025-12-22 22:14:16.425+00
cmjguxyb601p4gr0r7631du3f	TDS25-0132	2025-12-22 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-22 16:14:14.382+00	2025-12-22 22:58:30.961+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-22 07:51:45.906+00	2025-12-22 22:58:35.062+00
cmjif84mr01regr0ru28hcgon	TDS25-0135	2025-12-23 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+ GHENO 	accepted	completed	\N	2025-12-23 14:50:32.256+00	2025-12-23 21:08:02.951+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-23 10:07:19.155+00	2025-12-23 21:08:16.532+00
cmi7imjq500pzdj0roya4jk8o	TDS25-0085	2025-11-20 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Pas de boite chez Foucaud !	accepted	completed	\N	2025-11-20 16:59:08.525+00	2025-11-20 22:04:26.337+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-20 14:17:20.477+00	2025-11-20 22:04:50.855+00
cmi4bslg000lydj0rgmxye3fk	TDS25-0080	2025-11-18 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-11-18 18:33:35.168+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-18 08:42:46.8+00	2025-11-18 18:33:35.181+00
cmi76p72000pkdj0rpadkyd97	TDS25-0084	2025-11-20 00:00:00+00	Livraison Dr Hriczack	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+ Hriczak	accepted	completed	\N	2025-11-20 16:37:46.553+00	2025-11-20 22:57:02.111+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-20 08:43:28.633+00	2025-11-20 22:57:19.711+00
cmji9ykrt01r8gr0rdlxsatpd	TDS25-0134	2025-12-23 00:00:00+00	Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Livraison Balima	accepted	completed	\N	2025-12-23 15:54:22.86+00	2025-12-23 20:46:36.837+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-23 07:39:55.433+00	2025-12-23 20:46:51.83+00
cmi65m3pt00nxdj0rs4eu2o3a	TDS25-0083	2025-11-19 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-19 17:26:36.034+00	2025-11-19 23:17:17.062+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-19 15:25:18.545+00	2025-11-19 23:17:22.828+00
cmi5sbzi200n0dj0rhja3cwgy	TDS25-0082	2025-11-19 00:00:00+00	Ramasse et depose dr Hriczack	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+ Hriczak	accepted	completed	\N	2025-11-19 16:42:30.154+00	2025-11-19 23:17:41.91+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-19 09:13:31.515+00	2025-11-19 23:17:57.865+00
cmicw5zeo0064gr0rnksycwyo	TDS25-0093	2025-11-24 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	Ras	accepted	completed	\N	2025-11-24 15:57:58.112+00	2025-11-24 22:29:31.592+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-24 08:35:13.151+00	2025-11-24 22:29:41.494+00
cmicugzsr0061gr0r62hcgtka	TDS25-0092	2025-11-24 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-24 21:54:00.664+00	2025-11-25 03:11:47.65+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-24 07:47:47.644+00	2025-11-25 03:12:01.951+00
cmibrnj7c0007f00ruoxciowt	TDS25-0091	2025-11-23 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	scheduled	\N	\N	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-23 13:41:07.704+00	2025-11-23 19:43:06.79+00
cmi8qdq2k0006dj0r1pgmfn6t	TDS25-0087	2025-11-21 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-11-21 18:34:42.099+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-21 10:42:11.9+00	2025-11-21 18:34:42.13+00
cmi8k0fbi0000dj0rrgw3jvwn	TDS25-0086	2025-11-21 00:00:00+00	Depose chez dr Hriczack	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+Hriczak	accepted	completed	\N	2025-11-21 16:13:16.919+00	2025-11-21 21:59:36.98+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-21 07:43:53.742+00	2025-11-21 21:59:49.298+00
cmiarj2zj0002ky0r4ykq83a6	TDS25-0088	2025-11-22 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	scheduled	\N	\N	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-22 20:49:53.888+00	2025-11-22 20:52:54.384+00
cmiarorip000mky0roagf6izm	TDS25-0089	2025-11-22 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	scheduled	\N	\N	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-22 20:54:18.961+00	2025-11-22 20:54:18.961+00
cmieelrjt008ngr0rrhenvaod	TDS25-0095	2025-11-25 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	Ras	accepted	completed	\N	2025-11-25 16:35:27.462+00	2025-11-25 22:29:07.972+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-25 09:59:08.73+00	2025-11-25 22:29:14.162+00
cmihb6h5x00d7gr0rvsbp8eqi	TDS25-0099	2025-11-27 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	Ras	accepted	completed	\N	2025-11-27 16:39:10.838+00	2025-11-27 22:37:18.227+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-27 10:46:35.11+00	2025-11-27 22:37:21.436+00
cmie9gao8008kgr0r2rxqgrlm	TDS25-0094	2025-11-25 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-25 22:22:00.302+00	2025-11-26 02:15:05.226+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-25 07:34:55.496+00	2025-11-26 02:15:09.148+00
cmigzkcdu00d4gr0r8kce8ay8	TDS25-0098	2025-11-27 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-27 16:46:37.521+00	2025-11-28 03:56:26.99+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-27 05:21:26.707+00	2025-11-28 03:56:32.752+00
cmibrlsa00000f00recsfqhyt	TDS25-0090	2025-11-23 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	scheduled	\N	\N	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-23 13:39:46.152+00	2025-11-23 19:40:30.572+00
cmifqukfd00b5gr0rj6hcutyc	TDS25-0096	2025-11-26 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	Ras	accepted	completed	\N	2025-11-26 16:14:49.422+00	2025-11-26 22:48:40.892+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-26 08:29:40.97+00	2025-11-26 22:48:45.173+00
cmifwzg5700bfgr0r579zi3p4	TDS25-0097	2025-11-26 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-26 16:06:45.077+00	2025-11-27 02:47:32.485+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-26 11:21:26.396+00	2025-11-27 02:47:42.469+00
cmiilp5t000f5gr0rtuc9h863	TDS25-0100	2025-11-28 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	Ras	accepted	completed	\N	2025-11-28 16:22:48.224+00	2025-11-28 22:52:26.203+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-11-28 08:28:49.188+00	2025-11-28 22:52:30.083+00
cmiitd69w00fbgr0r995o2ou9	TDS25-0101	2025-11-28 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-11-28 22:52:44.562+00	2025-11-29 04:29:00.371+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-11-28 12:03:26.852+00	2025-11-29 04:29:05.119+00
cmiocj3xp00ikgr0rkzs27tzq	TDS25-0104	2025-12-02 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-02 16:42:21.648+00	2025-12-02 22:22:52.723+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-02 08:58:47.341+00	2025-12-02 22:23:10.326+00
cmimugqs500gxgr0rpr1haed8	TDS25-0102	2025-12-01 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	in_progress	\N	2025-12-01 16:40:35.629+00	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-01 07:45:17.717+00	2025-12-01 16:40:35.69+00
cmimwe7wk00h0gr0rsu47z600	TDS25-0103	2025-12-01 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-01 17:20:38.97+00	2025-12-01 22:28:59.657+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-01 08:39:19.172+00	2025-12-01 22:29:05.892+00
cmiof29ye00itgr0ro4mnbi3h	TDS25-0105	2025-12-02 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-02 16:02:15.443+00	2025-12-02 22:53:14.507+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-02 10:09:40.838+00	2025-12-02 22:53:18.788+00
cmipuyh4a00m2gr0rwwernp8k	TDS25-0107	2025-12-03 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-03 17:24:47.566+00	2025-12-03 22:28:11.617+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-03 10:22:23.531+00	2025-12-03 22:28:23.432+00
cmipus7zt00lugr0r7c0emmc1	TDS25-0106	2025-12-03 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	in_progress	\N	2025-12-03 16:35:19.554+00	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-03 10:17:31.769+00	2025-12-03 16:35:19.67+00
cmir6008c00oigr0rxquzrbtu	TDS25-0108	2025-12-04 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-04 16:33:53.593+00	2025-12-04 22:50:49.225+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-04 08:19:16.909+00	2025-12-04 22:50:51.823+00
cmjju9up901u1gr0r5226isq3	TDS25-0136	2025-12-24 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-24 14:14:20.376+00	2025-12-24 14:14:44.65+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-24 09:56:20.013+00	2025-12-24 14:14:51.168+00
cmjskt4f701vggr0rpvtasbnj	TDS25-0142	2025-12-30 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-30 14:41:21.742+00	2025-12-30 17:37:35.957+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-30 12:41:18.499+00	2025-12-30 17:37:41.543+00
cmjjufdiq01u4gr0rf2r26r8j	TDS25-0137	2025-12-24 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-24 16:15:52.764+00	2025-12-24 16:16:03.041+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-24 10:00:37.682+00	2025-12-24 16:16:07.383+00
cmjslrwey01vogr0raubff1en	TDS25-0143	2025-12-30 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-30 17:03:29.023+00	2025-12-30 18:34:01.552+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-30 13:08:21.082+00	2025-12-30 18:34:06.095+00
cmjtq23qo0000gr0rlyrityqs	TDS25-0144	2025-12-31 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	.	accepted	completed	\N	2025-12-31 13:03:35.902+00	2025-12-31 16:46:59.74+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-31 07:56:01.776+00	2025-12-31 16:47:04.685+00
cmjmqw93101u7gr0r8j1ijxro	TDS25-0138	2025-12-26 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-26 11:45:39.945+00	2025-12-26 16:14:14.338+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-26 10:45:05.149+00	2025-12-26 16:15:00.26+00
cmir7ums400p0gr0r3q2n7ur7	TDS25-0109	2025-12-04 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-04 19:36:34.714+00	2025-12-04 21:55:47.245+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-04 09:11:05.429+00	2025-12-04 21:56:26.516+00
cmjmrfhdv01udgr0rr7r8ap9e	TDS25-0139	2025-12-26 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2025-12-26 18:11:47.833+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-26 11:00:02.372+00	2025-12-26 18:11:47.969+00
cmk3q6baj0063gr0ry2rlufv1	TDS26-0006	2026-01-07 00:00:00+00	Ramasse er depose chez Balima\nDepose  et prendre une enveloppe chez mme Milon 47 chemin du martinet 74600 vieugy Annecy	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-07 16:11:44.342+00	2026-01-07 23:03:12.089+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-07 07:56:59.947+00	2026-01-07 23:03:35.257+00
cmjr37ano01ukgr0rtwo61dpd	TDS25-0140	2025-12-29 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2025-12-29 13:34:58.559+00	2025-12-29 17:36:17.145+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-29 11:40:40.5+00	2025-12-29 17:36:20.434+00
cmjr3hfa901uvgr0r0wpcb9gp	TDS25-0141	2025-12-29 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2025-12-29 17:51:37.065+00	2025-12-29 18:52:35.15+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2025-12-29 11:48:33.057+00	2025-12-29 18:52:41.264+00
cmjwnbc1l000kgr0rbducazkw	TDS26-0001	2026-01-02 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-02 15:14:42.471+00	2026-01-02 20:18:19.053+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-02 09:02:32.122+00	2026-01-02 20:18:31.435+00
cmjtzzyiq000cgr0r7mjjg6xr	TDS25-0146	2026-01-02 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-02 14:23:00.166+00	2026-01-02 21:06:54.739+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2025-12-31 12:34:17.858+00	2026-01-02 21:06:57.328+00
cmk0w36kk002xgr0rrgbxgco1	TDS26-0002	2026-01-05 00:00:00+00	Ramasse chez Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-05 16:56:53.685+00	2026-01-05 22:29:25.741+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-05 08:19:13.028+00	2026-01-05 22:29:36.216+00
cmk16u5j40034gr0r0u5fs8ih	TDS26-0003	2026-01-05 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-05 15:07:06.212+00	2026-01-05 22:54:49.269+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-05 13:20:07.552+00	2026-01-05 22:54:53.639+00
cmk41rplm006jgr0rfwcj9bl4	TDS26-0007	2026-01-07 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-07 15:44:44.972+00	2026-01-07 23:09:01.548+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-07 13:21:34.043+00	2026-01-07 23:09:04.665+00
cmk2d2oh6004agr0ry04b70g5	TDS26-0005	2026-01-06 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-06 19:23:50.079+00	2026-01-06 22:27:50.85+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-06 09:02:29.226+00	2026-01-06 22:27:59.83+00
cmk2d1exv0041gr0rcpnzmxbr	TDS26-0004	2026-01-06 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-06 15:43:02.357+00	2026-01-06 22:45:48.483+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-06 09:01:30.211+00	2026-01-06 22:45:56.06+00
cmk5c3fi3008ugr0rdn3e8o0x	TDS26-0008	2026-01-08 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+ Heineleveque	accepted	completed	\N	2026-01-08 15:40:21.59+00	2026-01-08 21:06:31.16+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-08 10:58:23.163+00	2026-01-08 21:06:39.746+00
cmk5ip0sa009ngr0ro91xmoba	TDS26-0009	2026-01-08 00:00:00+00	Ramasse chez Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-08 18:10:50.986+00	2026-01-08 23:00:17.435+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-08 14:03:08.218+00	2026-01-08 23:00:27.001+00
cmk6xs55100cigr0rqb6lku4c	TDS26-0011	2026-01-09 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-09 17:02:14.432+00	2026-01-10 00:27:07.077+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-09 13:53:14.245+00	2026-01-10 00:27:11.304+00
cmk6ubdvh00c8gr0r7t8oxjub	TDS26-0010	2026-01-09 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-09 17:17:48.72+00	2026-01-10 01:33:43.459+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-09 12:16:13.566+00	2026-01-10 01:33:51.07+00
cmkawir0x00dxgr0rcxp7zz7r	TDS26-0013	2026-01-12 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	BARBONI impossible d’ouvrir la porte d'entrée !!!	accepted	completed	\N	2026-01-12 16:58:54.499+00	2026-01-12 22:57:23.168+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-12 08:29:01.137+00	2026-01-12 22:57:52.958+00
cmkawib3500dogr0rj3dxrlp9	TDS26-0012	2026-01-12 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-12 16:09:03.755+00	2026-01-13 15:00:41.275+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-12 08:28:40.481+00	2026-01-13 15:00:44.028+00
cmkcdkeld00iugr0rn927pqrs	TDS26-0014	2026-01-13 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-13 19:03:42.444+00	2026-01-13 21:57:59.761+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-13 09:13:57.985+00	2026-01-13 21:58:03.222+00
cmkce0g1h00jbgr0rkdzbprp6	TDS26-0015	2026-01-13 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-13 15:45:30.409+00	2026-01-13 22:43:53.477+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-13 09:26:26.357+00	2026-01-13 22:43:56.674+00
cmkxumrww0086h90rb8rbdxv6	TDS26-0036	2026-01-28 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras \n	accepted	completed	\N	2026-01-28 18:40:19.949+00	2026-01-28 22:30:14.139+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-28 09:54:51.728+00	2026-01-28 22:31:26.137+00
cmky59106008fh90rb0kjwky7	TDS26-0037	2026-01-28 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+ BOUTBOUL	accepted	completed	\N	2026-01-28 16:03:55.975+00	2026-01-28 23:41:45.538+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-28 14:52:06.102+00	2026-01-28 23:41:51.93+00
cmkgm7rte00rugr0rq4ip9gum	TDS26-0020	2026-01-16 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-16 16:46:52.327+00	2026-01-17 00:00:22.433+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-16 08:27:09.843+00	2026-01-17 00:00:25.712+00
cmkf5wb7000oagr0rn09vs99s	TDS26-0018	2026-01-15 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+ GRANGE	accepted	completed	\N	2026-01-15 16:02:34.842+00	2026-01-15 21:58:03.233+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-15 08:02:35.052+00	2026-01-15 21:58:53.713+00
cmkf5xl1c00oigr0rw6rm4od3	TDS26-0019	2026-01-15 00:00:00+00	Ramasse chez Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte Balima	accepted	completed	\N	2026-01-15 18:46:03.069+00	2026-01-16 00:37:51.43+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-15 08:03:34.465+00	2026-01-16 00:38:14.633+00
cmkz7rjj50000h90q219ycnlp	TDS26-0038	2026-01-29 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-29 15:37:33.991+00	2026-01-29 23:23:26.636+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-29 08:50:15.33+00	2026-01-29 23:23:29.238+00
cmkz7wvoi0014h90qizjcxhp6	TDS26-0039	2026-01-29 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-29 19:09:40.138+00	2026-01-30 02:18:28.18+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-29 08:54:24.355+00	2026-01-30 02:18:35.464+00
cmkdv1fp700lhgr0rsxhsrqrb	TDS26-0017	2026-01-14 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-14 15:35:25.861+00	2026-01-14 22:36:50.782+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-14 10:10:52.219+00	2026-01-14 22:36:58.755+00
cmkduj7ae00l0gr0rhykttdca	TDS26-0016	2026-01-14 00:00:00+00	Ramasse et depose chez Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-14 17:44:42.89+00	2026-01-14 23:28:39.441+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-14 09:56:41.511+00	2026-01-14 23:28:45.129+00
cml0qavtr005hh90q547cl0jn	TDS26-0040	2026-01-30 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-30 21:48:01.089+00	2026-01-30 23:40:55.853+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-30 10:16:56.991+00	2026-01-30 23:41:02.784+00
cml0qbq11005ph90qvcnk0o5e	TDS26-0041	2026-01-30 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	\N	accepted	in_progress	\N	2026-01-30 15:56:16.99+00	\N	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-30 10:17:36.134+00	2026-01-30 15:56:17.018+00
cmkmbuj1f0118gr0rr4s29a34	TDS26-0025	2026-01-20 00:00:00+00	Depose chez dr Boutboul	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	Ras	accepted	completed	\N	2026-01-20 17:14:48.113+00	2026-01-21 01:00:44.142+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-20 08:23:32.836+00	2026-01-21 01:00:57.333+00
cmkqr8pf4001ih90qihkju1wc	TDS26-0031	2026-01-23 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-23 17:10:12.83+00	2026-01-23 21:48:39.264+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-23 10:45:33.232+00	2026-01-23 21:48:43.44+00
cmkuwsxl30000h90r00c40gsk	TDS26-0032	2026-01-26 00:00:00+00	Chez Dr Grange 2 boites a prendre !!!	3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-26 16:12:58.43+00	2026-01-26 22:38:33.992+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-26 08:32:19.72+00	2026-01-26 22:38:36.685+00
cmknqhkf90000gr0rq3249ivb	TDS26-0026	2026-01-21 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-21 17:19:00.127+00	2026-01-21 22:44:05.434+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-21 08:01:08.518+00	2026-01-21 22:44:10.072+00
cmkgo7o1100s3gr0rrxxus2dk	TDS26-0021	2026-01-16 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-16 17:59:51.536+00	2026-01-16 22:49:39.276+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-16 09:23:04.165+00	2026-01-16 22:49:43.392+00
cmkkx4y5e00whgr0r70jh5znv	TDS26-0022	2026-01-19 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	+ ELKAIM	accepted	completed	\N	2026-01-19 15:52:34.688+00	2026-01-19 23:08:07.881+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-19 08:43:58.563+00	2026-01-19 23:08:15.153+00
cmkkzo2n000wqgr0rcy4agnxq	TDS26-0023	2026-01-19 00:00:00+00	Ramasse chez Balima	Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	+ Collecte Allemany	accepted	completed	\N	2026-01-19 18:17:09.711+00	2026-01-19 23:51:50.472+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-19 09:54:50.077+00	2026-01-19 23:52:02.667+00
cmko3ax5d000fgr0rezbvuzpz	TDS26-0027	2026-01-21 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-21 15:56:58.885+00	2026-01-21 23:00:47.239+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-21 13:59:53.425+00	2026-01-21 23:00:50.808+00
cmkmag8ua010xgr0rnorw43s0	TDS26-0024	2026-01-20 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	\N	accepted	in_progress	\N	2026-01-20 15:54:49.836+00	\N	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-20 07:44:26.818+00	2026-01-20 15:54:49.857+00
cmkp9nrly002ugr0rr7nevk92	TDS26-0029	2026-01-22 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-22 16:25:09.726+00	2026-01-22 22:45:58.898+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-22 09:45:36.647+00	2026-01-22 22:46:08.478+00
cmkp9m8yb002hgr0rzte4hmju	TDS26-0028	2026-01-22 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-22 18:54:53.325+00	2026-01-23 01:27:49.277+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-22 09:44:25.812+00	2026-01-23 01:27:55.157+00
cmkqnfvmt001ah90q7wgvjg4r	TDS26-0030	2026-01-23 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-23 15:43:56.818+00	2026-01-23 21:22:28.944+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-23 08:59:09.413+00	2026-01-23 21:22:34.602+00
cmkwan8n6003ph90rgltflhui	TDS26-0034	2026-01-27 00:00:00+00		3 Vallées (BILAL)	Bilel Mokrane	HF-559-PB	.	accepted	completed	\N	2026-01-27 16:27:02.539+00	2026-01-27 23:37:09.954+00	cmfxz530y002kz0l6m3xy5o3x	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52nl002hz0l6bk088s1e	\N	2026-01-27 07:47:34.915+00	2026-01-27 23:37:16.914+00
cmkux08xd0009h90ru4ekqry4	TDS26-0033	2026-01-26 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-26 17:22:05.719+00	2026-01-26 22:16:35.128+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-26 08:38:01.01+00	2026-01-26 22:16:39.064+00
cmkwbbk4b003xh90rjvbjs14g	TDS26-0035	2026-01-27 00:00:00+00		Annecy (CHABANE)	Oudjedi Chabane	HF-584-PB	Ras	accepted	completed	\N	2026-01-27 17:31:25.627+00	2026-01-28 00:34:45.741+00	cmfxz530y002jz0l6fdvndz70	cmfxz4zwr0000z0l67js09uij	cmfxz4zws0002z0l6x67s4cw9	cmfxz52gt002ez0l6ekycmz55	\N	2026-01-27 08:06:29.532+00	2026-01-28 00:34:51.947+00
\.


--
-- Data for Name: stops; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stops (id, sequence, type, status, notes, driver_notes, completed_at, image_url, delivery_id, address_id, end_client_id, created_at, updated_at) FROM stdin;
cmfy0qzb30002f20rplsrfh6m	15	both	delivered	\N		2025-09-24 20:23:02.259+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-09-24 13:27:33.946+00	2025-09-24 20:23:02.259+00
cmfzho1pd0022f20rh7q1dter	0	both	delivered	x 3612 🔔 Devant la porte		2025-09-25 16:03:17.639+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-09-25 14:08:56.737+00	2025-09-25 16:03:17.639+00
cmfy0qzb30004f20rrimv5cm7	17	pickup	delivered	\N		2025-09-24 20:43:08.589+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwv001zz0l65qqq9usa	cmfxz4zwv001yz0l6sidgj4lq	2025-09-24 13:27:33.946+00	2025-09-24 20:43:08.589+00
cmfy0qzb4000df20r5uosi9zm	18	pickup	delivered	Fermé les Mercredi		2025-09-24 20:47:40.961+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-09-24 13:27:33.946+00	2025-09-24 20:47:40.961+00
cmfy3v8tm0016f20rbis0abfx	7	pickup	delivered	3ème étage CODE: 2606		2025-09-24 21:04:55.003+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-09-24 14:54:51.754+00	2025-09-24 21:04:55.003+00
cmfzho1pd001zf20r8b7er5ie	1	both	delivered			2025-09-25 16:03:20.44+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-09-25 14:08:56.737+00	2025-09-25 16:03:20.44+00
cmfy3v8tm0017f20ryu2cudfp	11	pickup	delivered			2025-09-24 21:23:19.665+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-09-24 14:54:51.754+00	2025-09-24 21:23:19.665+00
cmfy3v8tm001cf20r9idg8bjw	13	both	delivered			2025-09-24 21:45:51.862+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-09-24 14:54:51.754+00	2025-09-24 21:45:51.862+00
cmfzho1pd0024f20rz09lakd9	3	both	delivered			2025-09-25 16:50:00.314+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-09-25 14:08:56.737+00	2025-09-25 16:50:00.314+00
cmfzho1pd0020f20rgt84uqyy	4	pickup	delivered			2025-09-25 17:18:55.829+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-09-25 14:08:56.737+00	2025-09-25 17:18:55.829+00
cmfzho1pd0021f20rz4f1euqp	6	both	delivered			2025-09-25 18:40:44.567+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-09-25 14:08:56.737+00	2025-09-25 18:40:44.567+00
cmfzho1pd001xf20rex42r0i3	7	pickup	delivered	3ème étage CODE: 2606		2025-09-25 19:35:03.228+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-09-25 14:08:56.737+00	2025-09-25 19:35:03.228+00
cmfzho1pd001wf20rdx2mz5e1	9	both	delivered	Boite au lettre du haut		2025-09-25 19:48:55.705+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-09-25 14:08:56.737+00	2025-09-25 19:48:55.705+00
cmfzho1pd001yf20rjrunt84w	11	pickup	delivered		Il y en avait déjà une autre dans la boîte aux lettres, que j’ai ouverte pour vérifier.✅	2025-09-25 20:24:45.221+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-09-25 14:08:56.737+00	2025-09-25 20:24:45.221+00
cmfzho1pd0026f20r3ik4z6w8	12	both	delivered	Fermé mercredi & jeudi		2025-09-25 20:36:57.555+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-09-25 14:08:56.737+00	2025-09-25 20:36:57.555+00
cmfzho1pd0023f20ryw5x2ns7	13	dropoff	delivered			2025-09-25 20:44:46.34+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-09-25 14:08:56.737+00	2025-09-25 20:44:46.34+00
cmfzho1pd0025f20rjdk1rh6l	15	both	delivered			2025-09-25 20:54:26.943+00	\N	cmfzhnsoe001if20r7st3b141	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-09-25 14:08:56.737+00	2025-09-25 20:54:26.943+00
cmiarmy9c000jky0rgh9zjvns	14	pickup	planned	À l'étage dans le placard	\N	\N	\N	cmiarj2zj0002ky0r4ykq83a6	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-22 20:52:54.384+00	2025-11-22 20:52:54.384+00
cmg6p5u0l0004is0q2wx7nug7	10	both	delivered	\N		2025-09-30 19:16:55.243+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-09-30 15:13:07.124+00	2025-09-30 19:16:55.243+00
cmg6p5u0l0002is0qtauil8cc	15	both	delivered	\N		2025-09-30 21:16:11.837+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-09-30 15:13:07.124+00	2025-09-30 21:16:11.837+00
cmfy0qzb40006f20rdmdwywor	0	both	delivered	\N		2025-09-24 16:04:25.316+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-09-24 13:27:33.946+00	2025-09-24 16:04:25.316+00
cmfy0qzb4000af20r80204bht	1	dropoff	delivered	\N		2025-09-24 16:19:51.725+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-09-24 13:27:33.946+00	2025-09-24 16:19:51.725+00
cmfy3v8tm001af20rla4boape	0	both	delivered	x 3612 🔔 Devant la porte		2025-09-24 16:21:22.459+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-09-24 14:54:51.754+00	2025-09-24 16:21:22.459+00
cmfy0qzb40007f20r6tu5jvxk	2	pickup	delivered	\N		2025-09-24 16:28:44.121+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-09-24 13:27:33.946+00	2025-09-24 16:28:44.121+00
cmfy0qzb40009f20rldqlb895	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-09-24 16:43:49.163+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-09-24 13:27:33.946+00	2025-09-24 16:43:49.163+00
cmfy0qzb30003f20rhlzpmuhz	5	pickup	delivered	\N		2025-09-24 17:03:20.057+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-09-24 13:27:33.946+00	2025-09-24 17:03:20.057+00
cmfy3v8tm0018f20rqr46eet5	1	both	delivered			2025-09-24 17:27:15.712+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-09-24 14:54:51.754+00	2025-09-24 17:27:15.712+00
cmfy3v8tm001bf20r4zlke8zp	2	pickup	delivered			2025-09-24 17:27:18.447+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-09-24 14:54:51.754+00	2025-09-24 17:27:18.447+00
cmfy0qzb40008f20rvz886vz4	8	both	delivered	\N	Pas de scotch	2025-09-24 17:44:17.175+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-09-24 13:27:33.946+00	2025-09-24 17:44:17.175+00
cmfy0qzb40005f20rttrgllfq	10	both	delivered	\N		2025-09-24 18:41:54.191+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-09-24 13:27:33.946+00	2025-09-24 18:41:54.191+00
cmfy3v8tm0019f20r2z9hfxgz	6	pickup	delivered			2025-09-24 19:25:20.92+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-09-24 14:54:51.754+00	2025-09-24 19:25:20.92+00
cmfy0qzb4000bf20ruswrc2bw	12	pickup	delivered	Fermé les Mercredi		2025-09-24 19:27:48.879+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-09-24 13:27:33.946+00	2025-09-24 19:27:48.879+00
cmfy0qzb4000cf20rbjyo0or1	14	both	delivered	Fermé les Vendredi		2025-09-24 19:47:04.367+00	\N	cmfy0qzay0000f20ruwkhp9gz	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-09-24 13:27:33.946+00	2025-09-24 19:47:04.367+00
cmfzieevw002of20r70atzdim	0	dropoff	delivered		Voir pour badge	2025-09-25 16:52:41.565+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-09-25 14:29:26.876+00	2025-09-25 16:52:41.565+00
cmfy3v8tm001df20rfardbb3p	8	pickup	delivered			2025-09-24 21:04:57.225+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-09-24 14:54:51.754+00	2025-09-24 21:04:57.225+00
cmfzieevw002uf20reytmc7cg	1	dropoff	delivered			2025-09-25 17:08:52.058+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-09-25 14:29:26.876+00	2025-09-25 17:08:52.058+00
cmfy3v8tm001ef20rat3qykix	3	both	delivered			2025-09-24 17:42:14.624+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-09-24 14:54:51.754+00	2025-09-24 17:42:14.625+00
cmfy3v8tn001hf20rd9iuh0yl	10	both	delivered	2306 placard étage		2025-09-24 21:04:59.202+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-09-24 14:54:51.754+00	2025-09-24 21:04:59.202+00
cmfy3v8tn001gf20rg04h5t4f	5	dropoff	delivered	La porte de gauche		2025-09-24 19:25:16.657+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-09-24 14:54:51.754+00	2025-09-24 19:25:16.657+00
cmg6p5u0l0006is0q4qa5524t	4	dropoff	delivered	\N		2025-09-30 17:31:54.881+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-09-30 15:13:07.124+00	2025-09-30 17:31:54.881+00
cmg6p5u0l0003is0qd79suwti	5	both	delivered	\N		2025-09-30 17:42:52.828+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-09-30 15:13:07.124+00	2025-09-30 17:42:52.828+00
cmfzieevw002tf20rqlmth70l	2	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-09-25 17:24:22.885+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-09-25 14:29:26.876+00	2025-09-25 17:24:22.885+00
cmfy3v8tn001ff20r1rf0d7ea	15	both	delivered			2025-09-24 21:56:10.619+00	\N	cmfy3cizz000ef20r353i1c1y	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-09-24 14:54:51.754+00	2025-09-24 21:56:10.619+00
cmfzieevw002rf20rnl9zpv0y	3	both	delivered			2025-09-25 17:46:18.708+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-09-25 14:29:26.876+00	2025-09-25 17:46:18.708+00
cmfzieevw002sf20rnyjfezd0	4	both	delivered			2025-09-25 18:14:58.958+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-09-25 14:29:26.876+00	2025-09-25 18:14:58.958+00
cmfzieevw002nf20r726oyc6k	5	both	delivered			2025-09-25 19:12:31.313+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-09-25 14:29:26.876+00	2025-09-25 19:12:31.313+00
cmfzieevw002qf20r0lg929nf	6	dropoff	delivered			2025-09-25 19:32:17.884+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-09-25 14:29:26.876+00	2025-09-25 19:32:17.884+00
cmfzieevw002vf20rv9az1d7a	7	both	delivered	Fermé les Mercredi		2025-09-25 19:59:24.801+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-09-25 14:29:26.876+00	2025-09-25 19:59:24.801+00
cmfzieevw002xf20rrlavizih	8	both	delivered	Fermé les jeudi		2025-09-25 20:29:21.123+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-09-25 14:29:26.876+00	2025-09-25 20:29:21.123+00
cmfzieevw002wf20r5u2590iv	9	both	delivered	Fermé les Vendredi		2025-09-25 20:42:37.28+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-09-25 14:29:26.876+00	2025-09-25 20:42:37.28+00
cmfzieevw002mf20r3f5ztxd3	10	both	delivered			2025-09-25 21:17:03.166+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-09-25 14:29:26.876+00	2025-09-25 21:17:03.166+00
cmfzieevw002yf20rs7rk0jzj	11	pickup	delivered	Fermé les Mercredi		2025-09-25 21:38:27.648+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-09-25 14:29:26.876+00	2025-09-25 21:38:27.648+00
cmfzieevw002pf20rv2hi12ll	12	both	delivered			2025-09-25 21:57:11.03+00	\N	cmfzhsbvq0027f20r3d80eti9	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-09-25 14:29:26.876+00	2025-09-25 21:57:11.03+00
cmiarmy9c000kky0royoz60at	1	pickup	planned		\N	\N	\N	cmiarj2zj0002ky0r4ykq83a6	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-22 20:52:54.384+00	2025-11-22 20:52:54.384+00
cmg6p5u0l0009is0qc0blvua7	11	dropoff	delivered	\N		2025-09-30 19:36:18.334+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-09-30 15:13:07.124+00	2025-09-30 19:36:18.334+00
cmg6p5u0l000eis0qjzcnv560	12	both	delivered	Fermé les Mercredi		2025-09-30 20:01:01.598+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-09-30 15:13:07.124+00	2025-09-30 20:01:01.598+00
cmg6p5u0l000gis0qcyf8ofx9	13	both	delivered	Fermé les jeudi		2025-09-30 20:28:58.067+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-09-30 15:13:07.124+00	2025-09-30 20:28:58.067+00
cmg6p5u0l000ais0qcmmwuhvz	6	dropoff	failed	\N	Pas de colis en boîte au lettre 	2025-09-30 17:51:50.918+00	https://www.storage.tds-transports.fr/941e1d6e-8160-44b2-96a8-30ffbb4fc6e2.avif	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001dz0l6jrju1qt7	cmfxz4zwu001cz0l631u4zru7	2025-09-30 15:13:07.124+00	2025-09-30 17:51:50.918+00
cmg6p5u0l000bis0questy3oh	8	both	delivered	\N		2025-09-30 18:22:45.704+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-09-30 15:13:07.124+00	2025-09-30 18:22:45.704+00
cmg6p5u0l000fis0qcak028fy	14	both	delivered	Fermé les Vendredi		2025-09-30 20:40:39.395+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-09-30 15:13:07.124+00	2025-09-30 20:40:39.395+00
cmg0yyl610001is0r02qqkv4t	15	both	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl610002is0racx13k2y	10	both	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl610003is0rhn5nqa5a	0	pickup	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl610004is0rng6383be	4	pickup	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl610005is0rfs65j4zo	9	pickup	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl610006is0rvko4cb0z	19	pickup	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl610007is0r9kxk3akg	2	pickup	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl610008is0r54u21kct	7	pickup	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl610009is0rfgrf6d7n	8	both	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl61000ais0r88pzjqiq	3	dropoff	planned	753B Fermé Lundi aprèm et Vendredi	\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl61000bis0rmjw23h6k	1	pickup	planned		\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl61000cis0rbts1ykst	12	pickup	planned	Fermé les Mercredi	\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl61000dis0rm46dd0yl	14	both	planned	Fermé les Vendredi	\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg0yyl61000eis0r7yh9gqjy	13	both	planned	Fermé les jeudi	\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg6p5u0l0008is0qsb1yym70	19	both	delivered	\N		2025-09-30 21:51:02.683+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-09-30 15:13:07.124+00	2025-09-30 21:51:02.683+00
cmg0vrcau000mcj0q2w6px51e	0	both	delivered	x 3612 🔔 Devant la porte		2025-09-26 15:40:15.877+00	\N	cmg0vrcat000hcj0qyy3de76r	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-09-26 13:31:11.238+00	2025-09-26 15:40:15.877+00
cmg0vrcau000lcj0qu2pd2ado	1	both	delivered	\N		2025-09-26 16:29:12.421+00	\N	cmg0vrcat000hcj0qyy3de76r	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-09-26 13:31:11.238+00	2025-09-26 16:29:12.421+00
cmg6p5u0l0007is0qnbn4r88n	20	pickup	delivered	\N		2025-09-30 22:02:47.738+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-09-30 15:13:07.124+00	2025-09-30 22:02:47.738+00
cmg0vrcau000ncj0q0km2ryp2	3	both	delivered	\N		2025-09-26 16:56:50.993+00	\N	cmg0vrcat000hcj0qyy3de76r	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-09-26 13:31:11.238+00	2025-09-26 16:56:50.993+00
cmg0vrcau000jcj0qzsrogzwf	9	pickup	delivered	Boite au lettre du haut		2025-09-26 18:45:48.987+00	\N	cmg0vrcat000hcj0qyy3de76r	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-09-26 13:31:11.238+00	2025-09-26 18:45:48.987+00
cmg0vrcau000pcj0q1hq8jlqg	10	pickup	delivered	2306 placard étage		2025-09-26 18:45:53.099+00	\N	cmg0vrcat000hcj0qyy3de76r	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-09-26 13:31:11.238+00	2025-09-26 18:45:53.099+00
cmg0vrcau000kcj0qmiqvlkwx	11	pickup	delivered	\N		2025-09-26 18:46:12.333+00	\N	cmg0vrcat000hcj0qyy3de76r	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-09-26 13:31:11.238+00	2025-09-26 18:46:12.333+00
cmg0vrcau000ocj0qaou86scr	15	both	delivered	\N		2025-09-26 21:28:02.498+00	\N	cmg0vrcat000hcj0qyy3de76r	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-09-26 13:31:11.238+00	2025-09-26 21:28:02.498+00
cmg0yyl61000fis0r9bx8ho7i	18	both	planned	Fermé les Mercredi	\N	\N	\N	cmg0vp07w0000cj0qollhlkgd	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-09-26 15:00:48.168+00	2025-09-26 15:00:48.168+00
cmg57m585001sis0r8g222kwy	0	both	delivered	x 3612 🔔 Devant la porte		2025-09-29 16:04:19.15+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-09-29 14:14:08.885+00	2025-09-29 16:04:19.15+00
cmg6p5u0l000his0qewscrf1g	18	both	delivered	Fermé les Mercredi		2025-09-30 21:34:14.7+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-09-30 15:13:07.124+00	2025-09-30 21:34:14.701+00
cmg57m585001ris0r2opznfxl	1	both	delivered	\N		2025-09-29 16:34:12.107+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-09-29 14:14:08.885+00	2025-09-29 16:34:12.107+00
cmg57m585001ois0rz1mgyyf2	9	pickup	delivered	Boite au lettre du haut		2025-09-29 18:51:30.412+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-09-29 14:14:08.885+00	2025-09-29 18:51:30.412+00
cmg57m585001qis0re5hvlk8j	11	pickup	delivered	\N		2025-09-29 19:20:35.011+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-09-29 14:14:08.885+00	2025-09-29 19:20:35.011+00
cmg57m585001pis0rbovm7a7s	14	both	delivered	À l'étage dans le placard		2025-09-29 19:55:15.966+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-09-29 14:14:08.885+00	2025-09-29 19:55:15.966+00
cmg9ldbxm002sis0qc9adxufl	14	both	planned	À l'étage dans le placard	\N	\N	\N	cmg9ldbxl002qis0qbqoucb41	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-02 15:50:17.001+00	2025-10-02 15:50:17.001+00
cmg9ldbxm002tis0qq38icclb	1	both	planned	\N	\N	\N	\N	cmg9ldbxl002qis0qbqoucb41	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-02 15:50:17.001+00	2025-10-02 15:50:17.001+00
cmg9ldbxm002uis0qepfr8ktp	4	dropoff	planned	\N	\N	\N	\N	cmg9ldbxl002qis0qbqoucb41	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-02 15:50:17.001+00	2025-10-02 15:50:17.001+00
cmg9ldbxm002vis0quxd1ad28	6	pickup	planned	\N	\N	\N	\N	cmg9ldbxl002qis0qbqoucb41	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-02 15:50:17.001+00	2025-10-02 15:50:17.001+00
cmg9ldbxm002wis0q9u54pes5	0	both	planned	x 3612 🔔 Devant la porte	\N	\N	\N	cmg9ldbxl002qis0qbqoucb41	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-02 15:50:17.001+00	2025-10-02 15:50:17.001+00
cmg9ldbxm002xis0qaq81ngld	13	dropoff	planned	\N	\N	\N	\N	cmg9ldbxl002qis0qbqoucb41	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-02 15:50:17.001+00	2025-10-02 15:50:17.001+00
cmg9ldbxm002yis0q7ty89wsd	3	both	planned	\N	\N	\N	\N	cmg9ldbxl002qis0qbqoucb41	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-02 15:50:17.001+00	2025-10-02 15:50:17.001+00
cmg9ldbxm002zis0qt8c4qtna	15	both	planned	\N	\N	\N	\N	cmg9ldbxl002qis0qbqoucb41	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-02 15:50:17.001+00	2025-10-02 15:50:17.001+00
cmg9ksw3h0024is0q95un5bow	10	both	delivered			2025-10-02 19:00:58.801+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-02 15:34:23.357+00	2025-10-02 19:00:58.801+00
cmg81dl2c0013is0q2umgtpfy	0	both	delivered	x 3612 🔔 Devant la porte	Y’avais encore la boite de la veille.	2025-10-01 15:33:33.487+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-01 13:42:50.339+00	2025-10-01 15:33:33.487+00
cmg81dl2c0011is0qgzakd3ki	1	both	delivered	\N		2025-10-01 16:00:39.417+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-01 13:42:50.339+00	2025-10-01 16:00:39.417+00
cmg9ldajv002mis0qisd0i1es	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-02 20:53:35.289+00	\N	cmg9ldaju002gis0qmykfljm3	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-02 15:50:15.211+00	2025-10-02 20:53:35.289+00
cmg81iijl001iis0qh74co73o	1	dropoff	delivered	\N		2025-10-01 16:27:58.464+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-10-01 13:46:40.352+00	2025-10-01 16:27:58.464+00
cmg81iijl001his0qb1m73r2t	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-01 16:43:19.357+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-01 13:46:40.352+00	2025-10-01 16:43:19.357+00
cmg81dl2c0015is0qjg5ok9pj	3	both	delivered	\N		2025-10-01 16:56:19.111+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-01 13:42:50.339+00	2025-10-01 16:56:19.111+00
cmg9ldajv002ois0qxh55itsa	3	both	delivered	\N		2025-10-02 20:53:41.159+00	\N	cmg9ldaju002gis0qmykfljm3	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-02 15:50:15.211+00	2025-10-02 20:53:41.159+00
cmg81dl2c0012is0qfju2ugtc	4	pickup	delivered	\N		2025-10-01 17:16:01.773+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-01 13:42:50.339+00	2025-10-01 17:16:01.773+00
cmg9ldajv002kis0qc3v4d16f	4	dropoff	delivered	\N		2025-10-02 20:53:44.05+00	\N	cmg9ldaju002gis0qmykfljm3	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-02 15:50:15.211+00	2025-10-02 20:53:44.05+00
cmg81iijl001gis0qu5pa2svo	8	both	delivered	\N		2025-10-01 18:08:51.461+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-01 13:46:40.352+00	2025-10-01 18:08:51.461+00
cmg81dl2b000yis0quvxkl3vx	7	pickup	delivered	3ème étage CODE: 2606		2025-10-01 18:21:59.808+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-01 13:42:50.339+00	2025-10-01 18:21:59.808+00
cmg81dl2b000xis0qvzd7awv3	9	pickup	delivered	Boite au lettre du haut		2025-10-01 18:22:40.947+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-01 13:42:50.339+00	2025-10-01 18:22:40.947+00
cmg9ldajv002lis0qkloexm6v	6	pickup	delivered	\N		2025-10-02 20:53:46.093+00	\N	cmg9ldaju002gis0qmykfljm3	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-02 15:50:15.211+00	2025-10-02 20:53:46.093+00
cmg81dl2c0017is0qiwc9s52g	10	pickup	delivered	2306 placard étage		2025-10-01 18:35:54.895+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-01 13:42:50.339+00	2025-10-01 18:35:54.895+00
cmg81dl2c0010is0qdeaszwr9	11	both	delivered	\N		2025-10-01 18:53:52.286+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-01 13:42:50.339+00	2025-10-01 18:53:52.286+00
cmg9ldajv002nis0qb5o3wace	13	dropoff	delivered	\N		2025-10-02 20:53:48.097+00	\N	cmg9ldaju002gis0qmykfljm3	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-02 15:50:15.211+00	2025-10-02 20:53:48.097+00
cmg81iijl001eis0qlaxf9i50	11	pickup	delivered	\N		2025-10-01 19:23:15.253+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-01 13:46:40.352+00	2025-10-01 19:23:15.253+00
cmg81dl2c0014is0qm8xlvlp6	13	dropoff	delivered	\N		2025-10-01 19:28:30.493+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-01 13:42:50.339+00	2025-10-01 19:28:30.493+00
cmg9ldajv002pis0qkvo8argb	15	both	delivered	\N		2025-10-02 20:53:52.801+00	\N	cmg9ldaju002gis0qmykfljm3	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-02 15:50:15.211+00	2025-10-02 20:53:52.801+00
cmg81dl2c000zis0qgul8e3hs	14	dropoff	failed	À l'étage dans le placard	Fermé le mercredi	2025-10-01 19:28:54.215+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-01 13:42:50.339+00	2025-10-01 19:28:54.215+00
cmg9ksw3h0022is0qfy9ti18n	15	both	delivered			2025-10-02 20:58:47.792+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-02 15:34:23.357+00	2025-10-02 20:58:47.792+00
cmg81dl2c0016is0q41yy3qwo	15	both	delivered	\N		2025-10-01 19:58:19.155+00	\N	cmg81dl2b000vis0qpf0yip8f	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-01 13:42:50.339+00	2025-10-01 19:58:19.155+00
cmg81iijl001kis0qct5tjsx5	13	dropoff	delivered	Fermé les jeudi		2025-10-01 20:11:59.94+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-01 13:46:40.352+00	2025-10-01 20:11:59.94+00
cmgaxfsaz0032is0qu6ze9la3	15	both	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmg81iijl001jis0qd25pa2wj	14	both	delivered	Fermé les Vendredi		2025-10-01 20:24:38.22+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-01 13:46:40.352+00	2025-10-01 20:24:38.22+00
cmg6p9vpd000lis0qrkrddvau	7	dropoff	delivered	3ème étage CODE: 2606		2025-09-30 20:08:10.969+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-09-30 15:16:15.936+00	2025-09-30 20:08:10.969+00
cmg9ksw3h0023is0quzvglq2n	5	pickup	delivered			2025-10-02 17:31:15.465+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-02 15:34:23.357+00	2025-10-02 17:31:15.465+00
cmg6p9vpd000kis0q4fity0li	9	pickup	delivered	Boite au lettre du haut		2025-09-30 20:29:52.395+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-09-30 15:16:15.936+00	2025-09-30 20:29:52.395+00
cmg6p9vpd000tis0q4wi0uu0l	10	both	delivered	2306 placard étage		2025-09-30 20:29:55.489+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-09-30 15:16:15.936+00	2025-09-30 20:29:55.489+00
cmg6p9vpd000uis0qqz9yle23	12	dropoff	delivered	Fermé mercredi & jeudi		2025-09-30 21:02:55.351+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-09-30 15:16:15.936+00	2025-09-30 21:02:55.351+00
cmg6p9vpd000qis0qcewyh1yw	13	both	delivered	\N		2025-09-30 21:08:19.669+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-09-30 15:16:15.936+00	2025-09-30 21:08:19.669+00
cmg6p9vpd000mis0q653w1a1z	14	both	delivered	À l'étage dans le placard		2025-09-30 21:23:59.264+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-09-30 15:16:15.936+00	2025-09-30 21:23:59.264+00
cmg6p9vpd000sis0qrxkly779	15	dropoff	delivered	\N		2025-09-30 21:25:06.817+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-09-30 15:16:15.936+00	2025-09-30 21:25:06.817+00
cmg81iijl001cis0qgvtjgvlw	0	dropoff	delivered	\N		2025-10-01 16:11:27.991+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-01 13:46:40.352+00	2025-10-01 16:11:27.991+00
cmg59cw1z0029is0reir95thk	1	pickup	delivered			2025-09-29 16:15:48.034+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-09-29 15:02:56.325+00	2025-09-29 16:15:48.034+00
cmg81iijl001fis0qn8qaitzc	7	both	delivered	\N		2025-10-01 18:08:47.436+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-01 13:46:40.352+00	2025-10-01 18:08:47.436+00
cmg59cw1z0028is0rao0zwotl	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-09-29 16:35:26.908+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-09-29 15:02:56.325+00	2025-09-29 16:35:26.908+00
cmg59cw1y0024is0rf3r2j4sx	4	both	delivered		Scotch adeis sur ramasse 	2025-09-29 16:48:57.365+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-09-29 15:02:56.325+00	2025-09-29 16:48:57.365+00
cmg81iijl001bis0qlcjqb9gc	10	both	delivered	\N		2025-10-01 19:04:22.451+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-01 13:46:40.352+00	2025-10-01 19:04:22.451+00
cmg57m585001tis0rnwk5v9xg	2	dropoff	delivered	\N		2025-09-29 16:58:42.718+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-09-29 14:14:08.885+00	2025-09-29 16:58:42.718+00
cmg59cw1y0022is0rpnjbymi0	5	pickup	delivered			2025-09-29 17:00:41.223+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-09-29 15:02:56.325+00	2025-09-29 17:00:41.223+00
cmg57m585001vis0rruq3to3i	3	both	delivered	\N		2025-09-29 17:16:57.904+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-09-29 14:14:08.885+00	2025-09-29 17:16:57.904+00
cmg81iijl001ais0q803fvcgt	15	both	delivered	\N		2025-10-01 20:57:16.367+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-01 13:46:40.352+00	2025-10-01 20:57:16.367+00
cmg59cw1y0026is0rzjzloja7	7	both	delivered			2025-09-29 17:19:57.02+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-09-29 15:02:56.325+00	2025-09-29 17:19:57.02+00
cmg59cw1y0027is0rly6qwfri	8	both	delivered			2025-09-29 17:47:47.133+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-09-29 15:02:56.325+00	2025-09-29 17:47:47.133+00
cmg81iijl001dis0q7zfhifv1	19	pickup	delivered	\N		2025-10-01 21:31:22.683+00	\N	cmg81iijk0018is0ql9my10cz	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-01 13:46:40.352+00	2025-10-01 21:31:22.683+00
cmg57m585001xis0rn32mgb5i	5	pickup	delivered	La porte de gauche		2025-09-29 18:20:11.363+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-09-29 14:14:08.885+00	2025-09-29 18:20:11.363+00
cmg59cw1y0023is0rvd1d3i9y	10	both	delivered			2025-09-29 18:45:03.32+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-09-29 15:02:56.325+00	2025-09-29 18:45:03.32+00
cmg57m585001yis0r0sme7jpq	10	pickup	delivered	2306 placard étage		2025-09-29 18:52:38.815+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-09-29 14:14:08.885+00	2025-09-29 18:52:38.815+00
cmg59cw1z002ais0rui1rca20	12	both	delivered	Fermé les Mercredi		2025-09-29 19:29:14.789+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-09-29 15:02:56.325+00	2025-09-29 19:29:14.789+00
cmg57m585001zis0rru27idz9	12	both	delivered	Fermé mercredi & jeudi		2025-09-29 19:40:35.472+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-09-29 14:14:08.885+00	2025-09-29 19:40:35.472+00
cmg57m585001uis0r0sqzb0kh	13	both	delivered	\N		2025-09-29 19:47:34.821+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-09-29 14:14:08.885+00	2025-09-29 19:47:34.822+00
cmg59cw1z002cis0rzvy4do85	13	both	delivered	Fermé les jeudi		2025-09-29 19:58:22.223+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-09-29 15:02:56.325+00	2025-09-29 19:58:22.223+00
cmg57m585001wis0ro4exqif5	15	dropoff	delivered	\N		2025-09-29 20:07:21.945+00	\N	cmg57m585001mis0rti544b8u	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-09-29 14:14:08.885+00	2025-09-29 20:07:21.945+00
cmg59cw1z002bis0rxzf0jimi	14	dropoff	delivered	Fermé les Vendredi		2025-09-29 20:09:56.408+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-09-29 15:02:56.325+00	2025-09-29 20:09:56.408+00
cmg59cw1y0021is0r6tegcyop	15	both	delivered			2025-09-29 20:42:19.184+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-09-29 15:02:56.325+00	2025-09-29 20:42:19.184+00
cmg59cw1z002dis0ri08uvfft	18	both	delivered	Fermé les Mercredi		2025-09-29 21:02:17.792+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-09-29 15:02:56.325+00	2025-09-29 21:02:17.792+00
cmg59cw1y0025is0r9ufroqq6	19	both	delivered			2025-09-29 21:19:19.177+00	\N	cmg56kvj4000gis0rylpjjfiu	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-09-29 15:02:56.325+00	2025-09-29 21:19:19.177+00
cmg6p9vpd000pis0qyh0mwas7	0	both	delivered	x 3612 🔔 Devant la porte		2025-09-30 16:38:56.689+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-09-30 15:16:15.936+00	2025-09-30 16:38:56.689+00
cmg6p5u0l0005is0qbpf5q1ko	0	pickup	delivered	\N		2025-09-30 16:52:36.802+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-09-30 15:13:07.124+00	2025-09-30 16:52:36.802+00
cmg6p9vpd000nis0qax0df5jy	1	both	delivered	\N		2025-09-30 17:02:08.837+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-09-30 15:16:15.936+00	2025-09-30 17:02:08.837+00
cmg6p5u0l000dis0qlf6ntvf7	1	pickup	delivered	\N		2025-09-30 17:08:18.191+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-09-30 15:13:07.124+00	2025-09-30 17:08:18.191+00
cmg6p5u0l000cis0q7cq19b82	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-09-30 17:23:18.078+00	\N	cmg6p5u0k0000is0qc0o3lub7	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-09-30 15:13:07.124+00	2025-09-30 17:23:18.078+00
cmg6p9vpd000ris0q9g3etb03	3	both	delivered	\N		2025-09-30 17:37:17.524+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-09-30 15:16:15.936+00	2025-09-30 17:37:17.524+00
cmg6p9vpd000ois0qs0wt6vu2	6	pickup	delivered	\N		2025-09-30 19:11:48.419+00	\N	cmg6p9vpc000iis0qpy624zae	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-09-30 15:16:15.936+00	2025-09-30 19:11:48.419+00
cmiarmy9c000lky0rrt5rv0qo	0	pickup	planned	x 3612 🔔 Devant la porte	\N	\N	\N	cmiarj2zj0002ky0r4ykq83a6	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-22 20:52:54.384+00	2025-11-22 20:52:54.384+00
cmg9ksw3h0025is0qwzigsk2u	0	pickup	delivered			2025-10-02 16:31:25.132+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-02 15:34:23.357+00	2025-10-02 16:31:25.132+00
cmg9ksw3h002bis0qc5t45wlb	1	pickup	delivered			2025-10-02 16:49:35.952+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-10-02 15:34:23.357+00	2025-10-02 16:49:35.952+00
cmg9ksw3h0028is0qqvnvma8z	2	pickup	delivered			2025-10-02 16:59:32.859+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-02 15:34:23.357+00	2025-10-02 16:59:32.859+00
cmg9ksw3h002ais0qarfqhfv2	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-02 17:15:05.046+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-02 15:34:23.357+00	2025-10-02 17:15:05.046+00
cmg9ksw3h0029is0q784vs8hw	8	both	delivered			2025-10-02 18:07:53.401+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-02 15:34:23.357+00	2025-10-02 18:07:53.401+00
cmg9ksw3h0027is0qqnfz9uay	11	both	delivered			2025-10-02 19:18:49.001+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-02 15:34:23.357+00	2025-10-02 19:18:49.001+00
cmg9ksw3h002cis0qqsfhgwgk	12	both	delivered	Fermé les Mercredi		2025-10-02 19:44:42.885+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-02 15:34:23.357+00	2025-10-02 19:44:42.885+00
cmg9ksw3h002eis0qc6f8zqgb	13	both	delivered	Fermé les jeudi		2025-10-02 20:13:43.125+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-02 15:34:23.357+00	2025-10-02 20:13:43.125+00
cmg9ksw3h002dis0q6ug0t4nf	14	dropoff	delivered	Fermé les Vendredi		2025-10-02 20:26:26.239+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-02 15:34:23.357+00	2025-10-02 20:26:26.239+00
cmg9ldajv002jis0qkjt62y82	1	both	delivered	\N		2025-10-02 20:53:38.627+00	\N	cmg9ldaju002gis0qmykfljm3	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-02 15:50:15.211+00	2025-10-02 20:53:38.627+00
cmg9ldajv002iis0qe8mdkdre	14	both	delivered	À l'étage dans le placard		2025-10-02 20:53:49.986+00	\N	cmg9ldaju002gis0qmykfljm3	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-02 15:50:15.211+00	2025-10-02 20:53:49.986+00
cmg9ksw3h002fis0q1h1qhu7i	18	dropoff	delivered	Fermé les Mercredi		2025-10-02 21:19:08.451+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-02 15:34:23.357+00	2025-10-02 21:19:08.451+00
cmg9ksw3h0026is0q0b1dtnuc	19	dropoff	delivered			2025-10-02 21:36:23.597+00	\N	cmg9kmdbd001lis0qw2qv4ios	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-02 15:34:23.357+00	2025-10-02 21:36:23.597+00
cmgaxfsaz0033is0qu1lg9x8g	17	pickup	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwv001zz0l65qqq9usa	cmfxz4zwv001yz0l6sidgj4lq	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz0034is0q9qe6wo1a	10	both	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz0035is0q67411lup	4	pickup	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz0036is0q70m4x3xx	20	pickup	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz0037is0qo0kawute	19	pickup	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz0038is0qc8gw0dmu	11	pickup	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgfa7lex0024is0q9a2nkuri	1	both	delivered			2025-10-06 16:00:39.858+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-06 15:24:30.633+00	2025-10-06 16:00:39.858+00
cmgfa7lex0028is0qahpe2ufe	2	pickup	delivered			2025-10-06 16:46:20.663+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-06 15:24:30.633+00	2025-10-06 16:46:20.664+00
cmgfa7ley002ais0qh89g11fw	3	both	delivered			2025-10-06 16:46:43.497+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-06 15:24:30.633+00	2025-10-06 16:46:43.498+00
cmgf8tvlf001his0q8ibes2ko	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-06 16:57:39.811+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-06 14:45:51.026+00	2025-10-06 16:57:39.811+00
cmgf8tvlf001dis0qte804mmu	4	pickup	delivered			2025-10-06 17:07:43.139+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-06 14:45:51.026+00	2025-10-06 17:07:43.139+00
cmgf8tvlf001fis0qyv1zvilx	7	dropoff	delivered			2025-10-06 17:37:22.022+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-06 14:45:51.026+00	2025-10-06 17:37:22.022+00
cmgfa7lex0025is0qlxy6mp7q	4	pickup	delivered			2025-10-06 17:51:40.361+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-06 15:24:30.633+00	2025-10-06 17:51:40.361+00
cmgf8tvlf001gis0qvfjw1ny9	8	both	delivered			2025-10-06 18:08:20.881+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-06 14:45:51.026+00	2025-10-06 18:08:20.881+00
cmgf8tvlf001bis0qlvcdolnd	10	both	delivered			2025-10-06 19:03:06.792+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-06 14:45:51.026+00	2025-10-06 19:03:06.792+00
cmgfa7lex0026is0qvqpjkr2k	6	dropoff	delivered			2025-10-06 19:15:21.406+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-06 15:24:30.633+00	2025-10-06 19:15:21.406+00
cmgf8tvlf001jis0qewqwc9um	13	both	delivered	Fermé les jeudi		2025-10-06 20:15:04.581+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-06 14:45:51.026+00	2025-10-06 20:15:04.581+00
cmgf8tvlf001iis0qdz4gqix0	14	both	delivered	Fermé les Vendredi		2025-10-06 20:28:40.041+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-06 14:45:51.026+00	2025-10-06 20:28:40.041+00
cmgfa7lex0021is0q31359tp1	9	pickup	delivered	Boite au lettre du haut		2025-10-06 20:50:17.355+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-06 15:24:30.633+00	2025-10-06 20:50:17.355+00
cmgfa7ley002dis0q8hv6friq	10	pickup	delivered	2306 placard étage		2025-10-06 20:50:34.059+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-06 15:24:30.633+00	2025-10-06 20:50:34.059+00
cmgfa7lex0023is0qbh3gmjnz	11	pickup	delivered			2025-10-06 21:13:13.825+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-06 15:24:30.633+00	2025-10-06 21:13:13.825+00
cmgfa7ley002eis0qptm5008v	12	both	delivered	Fermé mercredi & jeudi		2025-10-06 21:24:55.227+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-06 15:24:30.633+00	2025-10-06 21:24:55.227+00
cmgfa7ley0029is0qdyqydzir	13	dropoff	delivered			2025-10-06 21:36:12.127+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-06 15:24:30.633+00	2025-10-06 21:36:12.127+00
cmgf8tvlf001ais0qjj7a4kyi	17	pickup	delivered			2025-10-06 21:53:59.765+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwv001zz0l65qqq9usa	cmfxz4zwv001yz0l6sidgj4lq	2025-10-06 14:45:51.026+00	2025-10-06 21:53:59.765+00
cmgf8tvlf001kis0qwidjx9su	18	dropoff	delivered	Fermé les Mercredi		2025-10-06 21:54:06.623+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-06 14:45:51.026+00	2025-10-06 21:54:06.623+00
cmgf8tvlf001eis0q3apjnz02	19	dropoff	delivered			2025-10-06 21:54:09.866+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-06 14:45:51.026+00	2025-10-06 21:54:09.866+00
cmgfa7ley002bis0qph29lcxm	15	both	delivered			2025-10-06 22:06:44.526+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-06 15:24:30.633+00	2025-10-06 22:06:44.526+00
cmgaxfsaz0039is0q1xqjficc	7	pickup	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz003ais0qiin8kxrn	8	both	planned	\N	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz003bis0qsjmnhujn	3	both	planned	753B Fermé Lundi aprèm et Vendredi	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz003cis0ql2unviai	12	both	planned	Fermé les Mercredi	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz003dis0qjzp2iafm	14	both	planned	Fermé les Vendredi	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz003eis0q9jle4j2w	13	both	planned	Fermé les jeudi	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgaxfsaz003fis0qvkmc3uzk	18	pickup	planned	Fermé les Mercredi	\N	\N	\N	cmgaxfsay0030is0qyjj1m5s2	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-03 14:15:53.098+00	2025-10-03 14:15:53.098+00
cmgi1qwbo004iis0quksykunh	15	both	delivered	\N		2025-10-08 20:10:45.832+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-08 13:50:53.22+00	2025-10-08 20:10:45.832+00
cmiarorip000oky0rxycfm2mo	3	both	planned	753B Fermé Lundi aprèm et Vendredi	\N	\N	\N	cmiarorip000mky0roagf6izm	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-22 20:54:18.961+00	2025-11-22 20:54:18.961+00
cmggp377b003kis0qoiaqelbz	0	dropoff	delivered	x 3612 🔔 Devant la porte		2025-10-07 16:27:03.802+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-07 15:08:46.007+00	2025-10-07 16:27:03.802+00
cmgmhpw4e0006is0qz7frf2hp	1	both	delivered	\N		2025-10-11 16:35:50.416+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-11 16:29:04.86+00	2025-10-11 16:35:50.417+00
cmggp377b003mis0qiee0az72	3	both	delivered			2025-10-07 19:34:59.069+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-07 15:08:46.007+00	2025-10-07 19:34:59.069+00
cmggp377b003iis0q0g36oyqj	4	dropoff	delivered			2025-10-07 19:35:03.501+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-07 15:08:46.007+00	2025-10-07 19:35:03.501+00
cmgmhpw4e000ais0q6w9o825o	2	pickup	delivered	\N		2025-10-11 16:36:13.051+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-11 16:29:04.86+00	2025-10-11 16:36:13.051+00
cmggp377b003ois0qqx5yjyt7	5	pickup	delivered	La porte de gauche		2025-10-07 22:49:38.895+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-07 15:08:46.007+00	2025-10-07 22:49:38.895+00
cmggp377b003jis0qtic5ycag	6	pickup	delivered			2025-10-07 22:49:41.262+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-07 15:08:46.007+00	2025-10-07 22:49:41.262+00
cmgmhpw4e0007is0qdviy1d3y	4	pickup	delivered	\N		2025-10-11 16:36:26.999+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-11 16:29:04.86+00	2025-10-11 16:36:26.999+00
cmggp377b003pis0qnhkbcnjx	10	pickup	delivered	2306 placard étage		2025-10-07 22:49:49.443+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-07 15:08:46.007+00	2025-10-07 22:49:49.443+00
cmggp377b003qis0qiy0wk52q	12	dropoff	failed	Fermé mercredi & jeudi	Pas de travail, juste une boite vide	2025-10-07 23:15:05.7+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-07 15:08:46.007+00	2025-10-07 23:15:05.7+00
cmgmhpw4e0008is0qtp4kcw73	6	pickup	delivered	\N		2025-10-11 16:37:51.692+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-11 16:29:04.86+00	2025-10-11 16:37:51.692+00
cmggp377b003lis0qwyt4l6c5	13	dropoff	delivered			2025-10-07 23:32:35.411+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-07 15:08:46.007+00	2025-10-07 23:32:35.411+00
cmggp377b003nis0qmfbepijy	15	dropoff	delivered			2025-10-07 23:37:41.383+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-07 15:08:46.007+00	2025-10-07 23:37:41.383+00
cmgmhpw4e000cis0q5mhdfp5a	8	pickup	delivered	\N		2025-10-11 16:39:28.368+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-10-11 16:29:04.86+00	2025-10-11 16:39:28.368+00
cmgmhpw4e0005is0qy31w9kqg	11	pickup	delivered	\N		2025-10-11 16:41:26.43+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-11 16:29:04.86+00	2025-10-11 16:41:26.43+00
cmgayhbw3004iis0q1z558a2w	9	pickup	planned		\N	\N	\N	cmgayh66o004eis0qxldd48vj	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2025-10-03 14:45:04.755+00	2025-10-03 14:45:04.755+00
cmgazgrwg004lis0qjji02rgx	5	dropoff	planned	\N	\N	\N	\N	cmgazgrwf004jis0q364itdcd	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-03 15:12:38.464+00	2025-10-03 15:12:38.464+00
cmgazgrwg004mis0q5l1odt7a	2	dropoff	planned	\N	\N	\N	\N	cmgazgrwf004jis0q364itdcd	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-03 15:12:38.464+00	2025-10-03 15:12:38.464+00
cmgmhpw4e000bis0qg9zf4nhu	13	pickup	delivered	\N		2025-10-11 16:45:22.507+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-11 16:29:04.86+00	2025-10-11 16:45:22.507+00
cmgay4ab30048is0qtswgimpm	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-03 16:48:33.519+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-03 14:34:56.175+00	2025-10-03 16:48:33.519+00
cmgay4ab30046is0q4wm6fa2x	1	both	delivered			2025-10-03 17:45:56.184+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-03 14:34:56.175+00	2025-10-03 17:45:56.185+00
cmgi1qwbp004lis0qw6cz2tt1	0	pickup	delivered	\N		2025-10-08 15:24:12.026+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-08 13:50:53.22+00	2025-10-08 15:24:12.026+00
cmgay4ab3004bis0qs6dzqsrc	3	both	delivered			2025-10-03 17:46:01.656+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-03 14:34:56.175+00	2025-10-03 17:46:01.656+00
cmgay4ab30047is0qmchpsa39	6	pickup	delivered			2025-10-03 19:35:52.802+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-03 14:34:56.175+00	2025-10-03 19:35:52.802+00
cmgi1qwbp004mis0qimkraaxy	4	pickup	delivered	\N		2025-10-08 16:09:29.561+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-08 13:50:53.22+00	2025-10-08 16:09:29.561+00
cmgay4ab3004ais0q24m3bfga	8	pickup	delivered			2025-10-03 20:38:02.954+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-10-03 14:34:56.175+00	2025-10-03 20:38:02.954+00
cmgay4ab30044is0qj1ukit1p	9	pickup	delivered	Boite au lettre du haut		2025-10-03 20:39:57.596+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-03 14:34:56.175+00	2025-10-03 20:39:57.596+00
cmgi1qwbp004jis0qik20l4la	5	pickup	delivered	\N		2025-10-08 16:27:36.825+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-08 13:50:53.22+00	2025-10-08 16:27:36.825+00
cmgay4ab30045is0qzsufmorc	11	pickup	delivered			2025-10-03 21:08:22.356+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-03 14:34:56.175+00	2025-10-03 21:08:22.356+00
cmgay4ab3004dis0qlbgjaczn	12	both	delivered	Fermé mercredi & jeudi		2025-10-03 21:14:59.36+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-03 14:34:56.175+00	2025-10-03 21:14:59.36+00
cmgi1qwbp004kis0q83ijsqud	10	both	delivered	\N		2025-10-08 18:12:53.391+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-08 13:50:53.22+00	2025-10-08 18:12:53.391+00
cmgay4ab30049is0q3fc47jri	13	both	delivered			2025-10-03 21:27:16.459+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-03 14:34:56.175+00	2025-10-03 21:27:16.459+00
cmgay4ab3004cis0qvbh9gb4u	15	both	delivered			2025-10-03 21:51:03.206+00	\N	cmgay3vsf003gis0qgkeb2sis	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-03 14:34:56.175+00	2025-10-03 21:51:03.206+00
cmgkv2slb006lis0quv009dox	12	pickup	delivered	Fermé les Mercredi		2025-10-10 20:20:44.555+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-10 13:07:29.47+00	2025-10-10 20:20:44.555+00
cmggp377b003his0qpvamrq3n	1	both	delivered			2025-10-07 17:47:34.742+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-07 15:08:46.007+00	2025-10-07 17:47:34.743+00
cmgi1qwbp004uis0q4mefsopq	18	pickup	delivered	Fermé les Mercredi		2025-10-08 20:32:24.639+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-08 13:50:53.22+00	2025-10-08 20:32:24.639+00
cmggp377b003gis0qu3p7cdky	11	pickup	delivered			2025-10-07 23:14:25.008+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-07 15:08:46.007+00	2025-10-07 23:14:25.008+00
cmiarorip000pky0r7vit07o3	8	both	planned		\N	\N	\N	cmiarorip000mky0roagf6izm	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-22 20:54:18.961+00	2025-11-22 20:54:18.961+00
cmggp377b003fis0qhs7yn7n3	14	dropoff	delivered	À l'étage dans le placard		2025-10-07 23:32:43.542+00	\N	cmggmvc1f002fis0q7raqef1f	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-07 15:08:46.007+00	2025-10-07 23:32:43.542+00
cmgi1qwbp004nis0qlz7x4379	19	both	delivered	\N		2025-10-08 20:50:57.874+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-08 13:50:53.22+00	2025-10-08 20:50:57.874+00
cmgkv2slb006dis0q9dcoleew	15	both	delivered	\N		2025-10-10 20:55:39.124+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-10 13:07:29.47+00	2025-10-10 20:55:39.124+00
cmgkv2slb006his0ql7ns1b4a	19	pickup	delivered	\N		2025-10-10 22:02:40.061+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-10 13:07:29.47+00	2025-10-10 22:02:40.061+00
cmgmhpw4f000dis0qcwml4c9t	3	both	delivered	\N		2025-10-11 16:36:24.719+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-11 16:29:04.86+00	2025-10-11 16:36:24.719+00
cmgfa7lex0027is0q5yyyr54j	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-06 15:51:10.687+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-06 15:24:30.633+00	2025-10-06 15:51:10.687+00
cmgf8tvlf001cis0q0kxw9u6s	0	both	delivered			2025-10-06 16:33:29.465+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-06 14:45:51.026+00	2025-10-06 16:33:29.465+00
cmgf8tvlf0019is0qst7k1ll2	5	pickup	delivered			2025-10-06 17:19:35.8+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-06 14:45:51.026+00	2025-10-06 17:19:35.8+00
cmgfa7ley002cis0qdufdx1pg	5	both	delivered	La porte de gauche		2025-10-06 18:26:54.933+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-06 15:24:30.633+00	2025-10-06 18:26:54.933+00
cmgmhpw4f000fis0qcgno00f8	5	pickup	delivered	La porte de gauche		2025-10-11 16:37:43.628+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-11 16:29:04.86+00	2025-10-11 16:37:43.628+00
cmgf8tvlf0018is0qyu5y2rq3	15	both	delivered			2025-10-06 21:05:46.721+00	\N	cmgf7qi5c0000is0qcq7ilu99	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-06 14:45:51.026+00	2025-10-06 21:05:46.721+00
cmgfa7lex0022is0qchdros10	14	both	delivered	À l'étage dans le placard		2025-10-06 21:41:47.332+00	\N	cmgf7sogf000eis0qyuumu9db	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-06 15:24:30.633+00	2025-10-06 21:41:47.332+00
cmgmhpw4d0003is0q709ahqsl	7	pickup	delivered	3ème étage CODE: 2606		2025-10-11 16:39:09.87+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-11 16:29:04.86+00	2025-10-11 16:39:09.87+00
cmgmhpw4f000gis0qneilqiid	10	pickup	delivered	2306 placard étage		2025-10-11 16:40:09.302+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-11 16:29:04.86+00	2025-10-11 16:40:09.302+00
cmgmhpw4f000his0q6rmyw941	12	both	delivered	Fermé mercredi & jeudi		2025-10-11 16:43:58.468+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-11 16:29:04.86+00	2025-10-11 16:43:58.468+00
cmgmhpw4e0004is0qs7p5ptg1	14	both	delivered	À l'étage dans le placard		2025-10-11 16:46:34.989+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-11 16:29:04.86+00	2025-10-11 16:46:34.989+00
cmgjk8hzu0066is0quqnfoyny	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-09 16:50:47.535+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-09 15:16:13.722+00	2025-10-09 16:50:47.535+00
cmgmhpw4f000eis0qjsz0z5p0	15	both	delivered	\N		2025-10-11 16:46:43.885+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-11 16:29:04.86+00	2025-10-11 16:46:43.885+00
cmgjk8hzu0067is0qqk2o9jll	12	both	delivered	Fermé les Mercredi		2025-10-09 19:33:02.892+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-09 15:16:13.722+00	2025-10-09 19:33:02.892+00
cmgmoe939000tis0qfq4j7dxq	13	both	planned	\N	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmgjk8hzu0069is0quqlncsyg	13	both	delivered	Fermé les jeudi		2025-10-09 20:03:04.139+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-09 15:16:13.722+00	2025-10-09 20:03:04.139+00
cmgjk8hzu0068is0qge74j6dv	14	dropoff	delivered	Fermé les Vendredi		2025-10-09 20:13:26.757+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-09 15:16:13.722+00	2025-10-09 20:13:26.757+00
cmgjk8hzu006ais0q1r8i9ev8	18	both	delivered	Fermé les Mercredi		2025-10-09 21:05:36.974+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-09 15:16:13.722+00	2025-10-09 21:05:36.974+00
cmgi1qwbp004qis0qhwbv04na	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-08 15:57:14.197+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-08 13:50:53.22+00	2025-10-08 15:57:14.197+00
cmgi1qwbp004ois0qgqkin1e6	7	pickup	delivered	\N		2025-10-08 16:51:23.125+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-08 13:50:53.22+00	2025-10-08 16:51:23.125+00
cmgi1qwbp004pis0qkmio3f2i	8	both	delivered	\N		2025-10-08 17:15:05.943+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-08 13:50:53.22+00	2025-10-08 17:15:05.943+00
cmgi1qwbp004ris0qs9hl12rg	12	pickup	delivered	Fermé les Mercredi		2025-10-08 18:55:01.044+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-08 13:50:53.22+00	2025-10-08 18:55:01.044+00
cmgi1qwbp004tis0qnchnrty9	13	dropoff	delivered	Fermé les jeudi		2025-10-08 19:24:19.276+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-08 13:50:53.22+00	2025-10-08 19:24:19.276+00
cmgi1qwbp004sis0q9tvz8l1f	14	both	delivered	Fermé les Vendredi		2025-10-08 19:43:23.863+00	\N	cmgi1qwbo004gis0ql62qve5m	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-08 13:50:53.22+00	2025-10-08 19:43:23.863+00
cmgkv2slb006fis0ql7xuy2h8	0	pickup	delivered	\N		2025-10-10 16:11:14.493+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-10 13:07:29.47+00	2025-10-10 16:11:14.493+00
cmgkv2slb006kis0qqhfjn32z	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-10 16:40:21.398+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-10 13:07:29.47+00	2025-10-10 16:40:21.399+00
cmgkv2slb006gis0q17cjqf3o	4	both	delivered	\N		2025-10-10 16:55:06.093+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-10 13:07:29.47+00	2025-10-10 16:55:06.093+00
cmgkv2slb006iis0q5c0q98sn	7	pickup	delivered	\N		2025-10-10 17:30:34.582+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-10 13:07:29.47+00	2025-10-10 17:30:34.582+00
cmgkv2slb006jis0qvgy2ha9x	8	both	delivered	\N		2025-10-10 18:21:37.586+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-10 13:07:29.47+00	2025-10-10 18:21:37.586+00
cmgkv2slb006eis0qf6e87b50	10	both	delivered	\N		2025-10-10 19:07:54.385+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-10 13:07:29.47+00	2025-10-10 19:07:54.385+00
cmgi1mjl40048is0q80nmuam8	11	pickup	delivered			2025-10-08 20:24:37.617+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-08 13:47:30.087+00	2025-10-08 20:24:37.617+00
cmggod1nb003ais0qwssa67t0	3	dropoff	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-07 16:50:27.773+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-07 14:48:25.751+00	2025-10-07 16:50:27.773+00
cmggod1nb0036is0qi4tdr1lc	5	both	delivered			2025-10-07 17:02:57.638+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-07 14:48:25.751+00	2025-10-07 17:02:57.638+00
cmgi1mjl4004dis0qapcqa683	13	dropoff	delivered			2025-10-08 20:55:25.883+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-08 13:47:30.087+00	2025-10-08 20:55:25.883+00
cmgmhpw4e0009is0qgrb16m5u	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-11 16:34:44.027+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-11 16:29:04.86+00	2025-10-11 16:34:44.027+00
cmgi1mjl30047is0qbi7b30ny	14	both	delivered	À l'étage dans le placard		2025-10-08 20:55:27.858+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-08 13:47:30.087+00	2025-10-08 20:55:27.858+00
cmgmoe939000kis0qhl1qoc74	9	pickup	planned	Boite au lettre du haut	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmggod1nb0039is0qj9i0kj45	8	both	delivered			2025-10-07 17:47:11.465+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-07 14:48:25.751+00	2025-10-07 17:47:11.465+00
cmggod1nb0037is0q84nusx6x	10	both	delivered			2025-10-07 18:43:28.363+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-07 14:48:25.751+00	2025-10-07 18:43:28.363+00
cmggod1nb003bis0q8h5hg0l4	12	dropoff	delivered	Fermé les Mercredi		2025-10-07 19:25:09.679+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-07 14:48:25.751+00	2025-10-07 19:25:09.679+00
cmggod1nb003dis0qrt2ohx6m	13	both	delivered	Fermé les jeudi		2025-10-07 19:56:13.669+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-07 14:48:25.751+00	2025-10-07 19:56:13.669+00
cmggod1nb003cis0q5r43744u	14	both	delivered	Fermé les Vendredi		2025-10-07 20:07:02.085+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-07 14:48:25.751+00	2025-10-07 20:07:02.085+00
cmggod1nb0035is0qnmgw19ud	15	both	delivered			2025-10-07 20:41:10.81+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-07 14:48:25.751+00	2025-10-07 20:41:10.81+00
cmggod1nb0038is0qhowy18wc	19	both	delivered			2025-10-07 21:16:44.158+00	\N	cmggocnvp002tis0qfvo5g4cc	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-07 14:48:25.751+00	2025-10-07 21:16:44.158+00
cmgjk8hzu0063is0q5189puhw	2	pickup	delivered			2025-10-09 16:30:32.712+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-09 15:16:13.722+00	2025-10-09 16:30:32.712+00
cmgjk8hzt005zis0qbfqk3xk1	5	dropoff	delivered			2025-10-09 17:09:53.337+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-09 15:16:13.722+00	2025-10-09 17:09:53.337+00
cmgi1mjl4004cis0qkl5qy8f5	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-08 16:28:21.551+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-08 13:47:30.087+00	2025-10-08 16:28:21.551+00
cmgjk8hzu0064is0qjrtk6glf	7	pickup	delivered			2025-10-09 17:31:03.196+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-09 15:16:13.722+00	2025-10-09 17:31:03.196+00
cmgi1mjl40049is0qchv5vy30	1	both	delivered			2025-10-08 16:28:32.559+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-08 13:47:30.087+00	2025-10-08 16:28:32.559+00
cmgi1mjl4004eis0qd37ose5b	3	both	delivered			2025-10-08 17:02:54.83+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-08 13:47:30.087+00	2025-10-08 17:02:54.83+00
cmgi1mjl4004ais0qkt0b2f1g	4	pickup	delivered			2025-10-08 17:35:10.341+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-08 13:47:30.087+00	2025-10-08 17:35:10.341+00
cmgjjuywb005eis0qf6ezg95c	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-09 17:44:14.715+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-09 15:05:42.443+00	2025-10-09 17:44:14.715+00
cmgi1mjl4004bis0q26rf2afi	6	pickup	delivered			2025-10-08 18:53:36.599+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-08 13:47:30.087+00	2025-10-08 18:53:36.6+00
cmgi1mjl30046is0qsfpgf16u	7	pickup	delivered	3ème étage CODE: 2606		2025-10-08 19:40:49.607+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-08 13:47:30.087+00	2025-10-08 19:40:49.608+00
cmgjk8hzu0065is0qqot270vz	8	dropoff	delivered			2025-10-09 17:54:08.071+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-09 15:16:13.722+00	2025-10-09 17:54:08.071+00
cmgi1mjl30045is0q34jm1q3d	9	pickup	delivered	Boite au lettre du haut		2025-10-08 19:40:56.322+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-08 13:47:30.087+00	2025-10-08 19:40:56.322+00
cmgi1mjl4004fis0qfbmie1wl	10	both	delivered	2306 placard étage		2025-10-08 19:56:55.908+00	\N	cmgi1mc47003ris0q7sv0zmti	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-08 13:47:30.087+00	2025-10-08 19:56:55.908+00
cmgjjuywb005bis0qwgrrsd6p	1	both	delivered			2025-10-09 18:20:51.917+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-09 15:05:42.443+00	2025-10-09 18:20:51.917+00
cmgjk8hzu0060is0qikrs359y	10	both	delivered			2025-10-09 18:50:11.211+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-09 15:16:13.722+00	2025-10-09 18:50:11.211+00
cmgjk8hzu0062is0qqfhiw2hm	11	pickup	delivered			2025-10-09 19:08:51.171+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-09 15:16:13.722+00	2025-10-09 19:08:51.171+00
cmgjjuywb005fis0qlefxgx6g	3	both	delivered			2025-10-09 19:13:36.404+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-09 15:05:42.443+00	2025-10-09 19:13:36.404+00
cmgjjuywb005cis0qrw7fc88d	4	both	delivered			2025-10-09 19:31:57.628+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-09 15:05:42.443+00	2025-10-09 19:31:57.628+00
cmgjjuywb005dis0qeb8ydy5e	6	pickup	delivered			2025-10-09 20:36:48.255+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-09 15:05:42.443+00	2025-10-09 20:36:48.255+00
cmgjk8hzt005yis0qpcrn8c1i	15	both	delivered			2025-10-09 20:45:59.226+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-09 15:16:13.722+00	2025-10-09 20:45:59.226+00
cmgjk8hzu0061is0qtzm86br9	19	both	delivered			2025-10-09 21:25:20.892+00	\N	cmgjk8dfo005iis0q1371xnru	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-09 15:16:13.722+00	2025-10-09 21:25:20.892+00
cmgjjuywb0058is0qn78b4un0	9	pickup	delivered	Boite au lettre du haut		2025-10-09 21:44:45.833+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-09 15:05:42.443+00	2025-10-09 21:44:45.833+00
cmgjjuywb005ais0qx8vx0siz	11	both	delivered			2025-10-09 22:24:59.117+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-09 15:05:42.443+00	2025-10-09 22:24:59.117+00
cmgjjuywb005his0q3idm48ze	12	both	delivered	Fermé mercredi & jeudi		2025-10-09 22:25:03.993+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-09 15:05:42.443+00	2025-10-09 22:25:03.993+00
cmgjjuywb0059is0qn2tm0j8v	14	both	delivered	À l'étage dans le placard		2025-10-09 22:35:10.46+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-09 15:05:42.443+00	2025-10-09 22:35:10.46+00
cmgjjuywb005gis0qhrlug0uu	15	both	delivered			2025-10-09 23:25:06.938+00	\N	cmgjjuv8k004vis0qa374hswk	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-09 15:05:42.443+00	2025-10-09 23:25:06.938+00
cmgkwjank0073is0qht8knvlw	7	pickup	delivered	3ème étage CODE: 2606		2025-10-10 19:30:57.9+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-10 13:48:18.992+00	2025-10-10 19:30:57.9+00
cmgkwjank0072is0qdkqzcbce	9	pickup	delivered	Boite au lettre du haut		2025-10-10 19:51:06.517+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-10 13:48:18.992+00	2025-10-10 19:51:06.517+00
cmgkwjank007bis0q2itzbvbt	10	pickup	delivered	2306 placard étage		2025-10-10 19:51:15.573+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-10 13:48:18.992+00	2025-10-10 19:51:15.573+00
cmgz8cg5s006kjl0rgz53g9l6	11	pickup	delivered	\N		2025-10-20 19:07:57.508+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-20 14:27:41.391+00	2025-10-20 19:07:57.508+00
cmgkv2slb006nis0qwrujdksg	13	both	delivered	Fermé les jeudi		2025-10-10 20:20:53.439+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-10 13:07:29.47+00	2025-10-10 20:20:53.439+00
cmgkv2slb006mis0qosy6r8vw	14	dropoff	failed	Fermé les Vendredi	Pas de colis en boîte au lettre 	2025-10-10 20:21:42.001+00	https://www.storage.tds-transports.fr/1bb07287-e1ba-4a38-bdbd-0214010fe8c9.avif	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-10 13:07:29.47+00	2025-10-10 20:21:42.002+00
cmgz8cg5s006ljl0r39hz0f32	12	both	delivered	Fermé mercredi & jeudi		2025-10-20 19:18:37.668+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-20 14:27:41.391+00	2025-10-20 19:18:37.668+00
cmgkwjank0074is0qt8mezg0f	11	dropoff	delivered			2025-10-10 20:40:37.006+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-10 13:48:18.992+00	2025-10-10 20:40:37.006+00
cmgz8cg5s006mjl0rlxgpb0s5	13	pickup	delivered	\N		2025-10-20 19:28:44.432+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-20 14:27:41.391+00	2025-10-20 19:28:44.432+00
cmgkwjank007cis0qldfkryra	12	both	delivered	Fermé mercredi & jeudi		2025-10-10 20:40:42.599+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-10 13:48:18.992+00	2025-10-10 20:40:42.599+00
cmgz8cg5s006njl0royini02t	14	both	delivered	À l'étage dans le placard		2025-10-20 19:38:22.547+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-20 14:27:41.391+00	2025-10-20 19:38:22.547+00
cmgkwjank0077is0qvensupb2	13	both	delivered			2025-10-10 20:45:49.855+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-10 13:48:18.992+00	2025-10-10 20:45:49.855+00
cmgkwjank0076is0q25fviv4c	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-10 16:50:23.803+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-10 13:48:18.992+00	2025-10-10 16:50:23.803+00
cmgkwjank0075is0qenlzy8yn	1	both	delivered			2025-10-10 17:19:06.874+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-10 13:48:18.992+00	2025-10-10 17:19:06.874+00
cmgkwjank0079is0qvqlqf34u	15	both	delivered			2025-10-10 20:59:35.061+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-10 13:48:18.992+00	2025-10-10 20:59:35.062+00
cmgkwjank0078is0q0qox8dyb	3	both	delivered			2025-10-10 18:03:11.129+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-10 13:48:18.992+00	2025-10-10 18:03:11.13+00
cmgkv2slb006ois0qunxfoj20	18	pickup	delivered	Fermé les Mercredi		2025-10-10 21:44:41.435+00	\N	cmgkv2sla006bis0qvvocb1v3	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-10 13:07:29.47+00	2025-10-10 21:44:41.435+00
cmgkwjank007ais0q7nupv197	5	pickup	delivered	La porte de gauche		2025-10-10 19:03:37.392+00	\N	cmgkv7cmb006pis0qpm34dwwu	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-10 13:48:18.992+00	2025-10-10 19:03:37.392+00
cmgmhpw4d0002is0qhgi209o4	9	pickup	delivered	Boite au lettre du haut		2025-10-11 16:39:31.912+00	\N	cmgmhpw4c0000is0q19l2t6ad	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-11 16:29:04.86+00	2025-10-11 16:39:31.912+00
cmgmoe939000lis0qjlep0pvi	7	both	planned	3ème étage CODE: 2606	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmgmoe939000mis0qfks6zghi	14	dropoff	planned	À l'étage dans le placard	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmgmoe939000nis0qcm94hl4r	11	pickup	planned	\N	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmgmoe939000ois0q4yf1hbbs	1	dropoff	planned	\N	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmgmoe939000pis0qwi21mcsg	4	both	planned	\N	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmgmoe939000qis0qrzd32y4a	6	both	planned	\N	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmgmoe939000sis0qskm0a8m8	2	dropoff	planned	\N	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-11 19:35:59.108+00	2025-10-11 19:35:59.108+00
cmgmoe939000ris0q3frlh9jg	0	dropoff	en_route	x 3612 🔔 Devant la porte	\N	\N	\N	cmgmoe938000iis0qvy26tye3	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-11 19:35:59.108+00	2025-10-11 19:37:07.206+00
cmgqozvuo001cjl0r0cko13s7	0	dropoff	delivered	x 3612 🔔 Devant la porte		2025-10-14 19:00:12.778+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-14 15:03:53.088+00	2025-10-14 19:00:12.778+00
cmgqozvuo001bjl0r7ohdh5os	1	both	delivered			2025-10-14 19:29:20.534+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-14 15:03:53.088+00	2025-10-14 19:29:20.534+00
cmgqozvuo001djl0rfo4s9jh7	2	dropoff	delivered			2025-10-14 19:56:13.3+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-14 15:03:53.088+00	2025-10-14 19:56:13.3+00
cmgqozvuo001gjl0rd6lfrnqu	3	both	delivered			2025-10-14 20:16:46.589+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-14 15:03:53.088+00	2025-10-14 20:16:46.589+00
cmgqozvuo001ijl0rll869bf9	5	pickup	delivered	La porte de gauche		2025-10-14 21:21:34.96+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-14 15:03:53.088+00	2025-10-14 21:21:34.96+00
cmgqozvuo001fjl0rerzw2dr3	8	dropoff	delivered			2025-10-14 21:55:51.947+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-10-14 15:03:53.088+00	2025-10-14 21:55:51.947+00
cmgqozvuo0018jl0rwnk6lhis	9	both	delivered	Boite au lettre du haut	Pas de colis à ramasser 	2025-10-14 22:01:57.605+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-14 15:03:53.088+00	2025-10-14 22:01:57.605+00
cmgqozvuo001jjl0rnq0kash1	10	pickup	delivered	2306 placard étage		2025-10-14 22:07:25.772+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-14 15:03:53.088+00	2025-10-14 22:07:25.772+00
cmgqozvuo001ajl0r3hnivi3t	11	pickup	delivered			2025-10-14 22:32:40.024+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-14 15:03:53.088+00	2025-10-14 22:32:40.024+00
cmgqozvuo001ejl0r8agwe6rk	13	both	delivered			2025-10-14 22:55:33.694+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-14 15:03:53.088+00	2025-10-14 22:55:33.694+00
cmgqozvuo0019jl0rwuiw5s62	14	dropoff	delivered	À l'étage dans le placard	Pas de colis à ramasser 	2025-10-14 23:02:47.953+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-14 15:03:53.088+00	2025-10-14 23:02:47.953+00
cmgqozvuo001hjl0r7mezg3hi	15	both	delivered			2025-10-14 23:09:39.848+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-14 15:03:53.088+00	2025-10-14 23:09:39.848+00
cmgp99x4i001ajl0ramw77zlj	11	pickup	delivered			2025-10-14 00:20:21.114+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-13 14:56:01.266+00	2025-10-14 00:20:21.114+00
cmgp99x4i001ejl0r0tcvvqc3	13	dropoff	delivered			2025-10-14 00:44:46.406+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-13 14:56:01.266+00	2025-10-14 00:44:46.406+00
cmgp99x4i0019jl0rhox03q1k	14	both	delivered	À l'étage dans le placard	Pas de colis a ramasser dans le placard	2025-10-14 00:54:44.982+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-13 14:56:01.266+00	2025-10-14 00:54:44.982+00
cmh1zjo42000eg90s13zsjbhk	19	both	planned		\N	\N	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-22 12:44:40.274+00	2025-10-22 12:44:40.274+00
cmh1zjo42000fg90ss189debx	2	dropoff	delivered			2025-10-22 20:06:55.514+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-22 12:44:40.274+00	2025-10-22 20:06:55.514+00
cmh1zjo42000dg90sxz4ll8tm	4	dropoff	delivered			2025-10-22 20:06:59.354+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-22 12:44:40.274+00	2025-10-22 20:06:59.354+00
cmh1zjo42000gg90skmremd71	7	dropoff	delivered			2025-10-22 20:07:02.877+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-22 12:44:40.274+00	2025-10-22 20:07:02.877+00
cmgtk42rv0059jl0r9yf6v1am	5	both	delivered			2025-10-16 17:10:27.934+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-16 15:10:29.131+00	2025-10-16 17:10:27.934+00
cmgtk42rv005djl0ro9fwqntk	7	both	delivered			2025-10-16 17:30:19.19+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-16 15:10:29.131+00	2025-10-16 17:30:19.19+00
cmgtk42rv005ejl0rbpk9zq03	8	both	delivered			2025-10-16 17:54:26.128+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-16 15:10:29.131+00	2025-10-16 17:54:26.128+00
cmgtk42rv005bjl0rprq87wgr	9	pickup	delivered			2025-10-16 18:08:38.962+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2025-10-16 15:10:29.131+00	2025-10-16 18:08:38.962+00
cmgtk42rv005ajl0rl4smk4xk	10	both	delivered			2025-10-16 18:50:54.238+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-16 15:10:29.131+00	2025-10-16 18:50:54.238+00
cmgtk42rv0058jl0rzhktdxgp	15	both	delivered			2025-10-16 20:52:47.949+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-16 15:10:29.131+00	2025-10-16 20:52:47.949+00
cmgqow5yp0012jl0rjhxxabqm	3	dropoff	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-14 16:32:38.708+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-14 15:00:59.569+00	2025-10-14 16:32:38.708+00
cmgtk42rv005cjl0rlt9r4ngd	19	pickup	delivered			2025-10-16 21:30:26.702+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-16 15:10:29.131+00	2025-10-16 21:30:26.702+00
cmgqow5yp000wjl0r8pux5yj0	4	pickup	delivered			2025-10-14 16:36:26.986+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-14 15:00:59.569+00	2025-10-14 16:36:26.986+00
cmgqow5yp0010jl0rtl30jke9	7	both	delivered			2025-10-14 17:04:52.846+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-14 15:00:59.569+00	2025-10-14 17:04:52.846+00
cmgqow5yp0011jl0rb83j06kk	8	both	delivered			2025-10-14 17:38:27.313+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-14 15:00:59.569+00	2025-10-14 17:38:27.313+00
cmgqow5yp000vjl0r7r1kugoq	10	both	delivered			2025-10-14 18:34:37.63+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-14 15:00:59.569+00	2025-10-14 18:34:37.63+00
cmgqow5yp000zjl0rxsi2ea8m	11	dropoff	delivered			2025-10-14 18:55:19.175+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-14 15:00:59.569+00	2025-10-14 18:55:19.175+00
cmgqow5yp000ujl0r8h5jknpj	15	both	delivered			2025-10-14 20:45:58.189+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-14 15:00:59.569+00	2025-10-14 20:45:58.189+00
cmgqow5yp000yjl0rg9n0a3xi	19	dropoff	delivered			2025-10-14 21:35:55.804+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-14 15:00:59.569+00	2025-10-14 21:35:55.804+00
cmgp90u9h000kjl0r89ibmrgo	2	dropoff	delivered			2025-10-13 17:11:17.047+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-13 14:48:57.653+00	2025-10-13 17:11:17.047+00
cmgp90u9h000ojl0rcgxb333z	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-13 17:23:20.406+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-13 14:48:57.653+00	2025-10-13 17:23:20.406+00
cmgqow5yp000xjl0rmz3qvc2y	20	pickup	delivered			2025-10-14 21:48:29.592+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-10-14 15:00:59.569+00	2025-10-14 21:48:29.592+00
cmgp90u9h000jjl0rjiypl0ol	4	pickup	delivered			2025-10-13 17:33:09.698+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-13 14:48:57.653+00	2025-10-13 17:33:09.698+00
cmgp90u9h000hjl0rtdnbea7k	5	pickup	delivered			2025-10-13 17:43:33.777+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-13 14:48:57.653+00	2025-10-13 17:43:33.777+00
cmgp90u9h000ljl0rwarmwcc7	6	pickup	delivered			2025-10-13 17:53:48.177+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001dz0l6jrju1qt7	cmfxz4zwu001cz0l631u4zru7	2025-10-13 14:48:57.653+00	2025-10-13 17:53:48.177+00
cmgp90u9h000mjl0rxyzslj09	7	pickup	delivered			2025-10-13 18:12:42.453+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-13 14:48:57.653+00	2025-10-13 18:12:42.453+00
cmgp90u9h000njl0r2z03k6w7	8	both	delivered			2025-10-13 18:34:29.168+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-13 14:48:57.653+00	2025-10-13 18:34:29.168+00
cmgp99x4i001djl0rmdd6afvr	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-13 18:52:46.215+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-13 14:56:01.266+00	2025-10-13 18:52:46.215+00
cmgp90u9h000ijl0rcsnr842a	10	dropoff	delivered			2025-10-13 19:27:54.325+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-13 14:48:57.653+00	2025-10-13 19:27:54.325+00
cmgp99x4i001bjl0rspxadlf7	1	both	delivered			2025-10-13 19:28:59.961+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-13 14:56:01.266+00	2025-10-13 19:28:59.961+00
cmgp90u9h000pjl0rh466ahgu	12	both	delivered	Fermé les Mercredi		2025-10-13 20:10:13.123+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-13 14:48:57.653+00	2025-10-13 20:10:13.123+00
cmgp90u9h000rjl0r4oolxo2t	13	both	delivered	Fermé les jeudi		2025-10-13 20:38:26.666+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-13 14:48:57.653+00	2025-10-13 20:38:26.666+00
cmgp90u9h000qjl0rir8dpm0u	14	both	delivered	Fermé les Vendredi		2025-10-13 20:50:26.564+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-13 14:48:57.653+00	2025-10-13 20:50:26.564+00
cmgp90u9h000gjl0rku8a17zh	15	both	delivered			2025-10-13 21:41:36.309+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-13 14:48:57.653+00	2025-10-13 21:41:36.31+00
cmgp90u9h000sjl0rl31ymfrs	18	pickup	delivered	Fermé les Mercredi		2025-10-13 22:14:40.897+00	\N	cmgp90qpr0000jl0rk9ogb5vi	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-13 14:48:57.653+00	2025-10-13 22:14:40.897+00
cmgp99x4i001cjl0r7enutfa0	6	pickup	delivered			2025-10-13 22:35:18.259+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-13 14:56:01.266+00	2025-10-13 22:35:18.259+00
cmgp99x4i0018jl0r2gfjj0h8	9	pickup	delivered	Boite au lettre du haut		2025-10-13 23:46:50.999+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-13 14:56:01.266+00	2025-10-13 23:46:50.999+00
cmh0nk7z9000kjl0rbdei3s2o	12	dropoff	delivered	Fermé mercredi & jeudi		2025-10-21 19:37:51.703+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-21 14:21:24.453+00	2025-10-21 19:37:51.703+00
cmgp99x4i001jjl0ryxiqjfe4	12	dropoff	delivered	Fermé mercredi & jeudi		2025-10-14 00:37:31.814+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-13 14:56:01.266+00	2025-10-14 00:37:31.814+00
cmh0nk7z9000ijl0rggeb126t	13	dropoff	delivered			2025-10-21 20:12:02.088+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-21 14:21:24.453+00	2025-10-21 20:12:02.088+00
cmgp99x4i001gjl0r3s3g3j8g	15	both	delivered			2025-10-14 01:02:07.098+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-13 14:56:01.266+00	2025-10-14 01:02:07.098+00
cmgp99x4i001fjl0rb5lo4v6j	3	both	delivered			2025-10-13 20:12:30.822+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-13 14:56:01.266+00	2025-10-13 20:12:30.822+00
cmgp99x4i001hjl0r4rirsu41	5	pickup	delivered	La porte de gauche		2025-10-13 21:30:28.568+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-13 14:56:01.266+00	2025-10-13 21:30:28.569+00
cmgp99x4i001ijl0rhtomdsfa	10	pickup	delivered	2306 placard étage		2025-10-13 23:54:12.545+00	\N	cmgp99tva000tjl0rpiufw0t7	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-13 14:56:01.266+00	2025-10-13 23:54:12.545+00
cmgqow5yp0013jl0rc25bsum6	12	dropoff	delivered	Fermé les Mercredi		2025-10-14 19:20:48.183+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-14 15:00:59.569+00	2025-10-14 19:20:48.183+00
cmgqow5yp0015jl0rc4g3ykyi	13	both	delivered	Fermé les jeudi		2025-10-14 19:50:10.995+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-14 15:00:59.569+00	2025-10-14 19:50:10.995+00
cmgz8cg5s006jjl0rpdf32enk	10	pickup	delivered	2306 placard étage		2025-10-20 18:43:24.705+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-20 14:27:41.391+00	2025-10-20 18:43:24.706+00
cmgqow5yp0014jl0rzcd9hdni	14	both	delivered	Fermé les Vendredi		2025-10-14 20:01:48.778+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-14 15:00:59.569+00	2025-10-14 20:01:48.778+00
cmgqow5yp0016jl0rd9452o49	18	dropoff	delivered	Fermé les Mercredi		2025-10-14 21:17:14.238+00	\N	cmgqo00vw000ejl0r6s6l0jfx	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-14 15:00:59.569+00	2025-10-14 21:17:14.239+00
cmgqozvuo001kjl0rrfkwjmol	12	dropoff	delivered	Fermé mercredi & jeudi		2025-10-14 22:47:35.531+00	\N	cmgqnw35u0000jl0r4b06dlef	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-14 15:03:53.088+00	2025-10-14 22:47:35.531+00
cmh21fsf8000zg90s1k5hgr1r	1	both	delivered			2025-10-22 16:31:32.304+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-22 13:37:38.468+00	2025-10-22 16:31:32.304+00
cmh21fsf80011g90s1jtk1r23	2	dropoff	delivered			2025-10-22 16:55:20.566+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-22 13:37:38.468+00	2025-10-22 16:55:20.566+00
cmh21fsf90013g90sfb3j0824	3	both	delivered			2025-10-22 17:15:02.018+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-22 13:37:38.468+00	2025-10-22 17:15:02.018+00
cmh21fsf80010g90sce1kbrz5	4	dropoff	delivered			2025-10-22 17:38:32.876+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-22 13:37:38.468+00	2025-10-22 17:38:32.877+00
cmh21fsf90014g90so77347ca	10	both	delivered	2306 placard étage		2025-10-22 19:11:26.271+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-22 13:37:38.468+00	2025-10-22 19:11:26.271+00
cmh21fsf90012g90sr3d8qkco	13	pickup	delivered			2025-10-22 19:48:09.554+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-22 13:37:38.468+00	2025-10-22 19:48:09.554+00
cmh21fsf8000yg90sjww7v46w	14	both	delivered	À l'étage dans le placard		2025-10-22 19:48:48.597+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-22 13:37:38.468+00	2025-10-22 19:48:48.597+00
cmh1zjo42000ig90srs1ltjrl	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-22 20:06:57.215+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-22 12:44:40.274+00	2025-10-22 20:06:57.215+00
cmgth97we003ujl0rutuixpgy	0	both	delivered	x 3612 🔔 Devant la porte	Pas de ramasse	2025-10-16 18:59:59.32+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-16 13:50:30.206+00	2025-10-16 18:59:59.32+00
cmh0nk7z9000hjl0rg3xd977o	2	dropoff	delivered			2025-10-21 16:53:32.36+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-21 14:21:24.453+00	2025-10-21 16:53:32.36+00
cmgth97we003vjl0r1ibabtbz	1	both	delivered	\N		2025-10-16 19:30:57.15+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-16 13:50:30.206+00	2025-10-16 19:30:57.15+00
cmgth97we003wjl0r8uzi2e4b	3	both	delivered	\N		2025-10-16 20:10:35.929+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-16 13:50:30.206+00	2025-10-16 20:10:35.929+00
cmh0nk7z9000jjl0rp5r0iox3	3	both	delivered			2025-10-21 17:09:54.936+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-21 14:21:24.453+00	2025-10-21 17:09:54.936+00
cmgth97we003xjl0rtfkyz6uv	4	dropoff	delivered	\N		2025-10-16 20:40:06.232+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-16 13:50:30.206+00	2025-10-16 20:40:06.232+00
cmh1zjo42000bg90skia29urp	5	dropoff	delivered			2025-10-22 20:07:01.19+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-22 12:44:40.274+00	2025-10-22 20:07:01.19+00
cmgth97we003yjl0rdkdvaet2	6	both	delivered	\N		2025-10-16 21:56:50.201+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-16 13:50:30.206+00	2025-10-16 21:56:50.201+00
cmh0nk7z9000gjl0r57kxn5y9	4	pickup	delivered			2025-10-21 17:47:53.01+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-21 14:21:24.453+00	2025-10-21 17:47:53.01+00
cmgth97we003zjl0rbhr18jcx	8	pickup	delivered	\N		2025-10-16 23:06:35.952+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-10-16 13:50:30.206+00	2025-10-16 23:06:35.952+00
cmgth97we0040jl0rplzayet1	9	both	delivered	Boite au lettre du haut		2025-10-16 23:11:03.472+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-16 13:50:30.206+00	2025-10-16 23:11:03.472+00
cmh1zjo42000hg90sthg38j3v	8	both	delivered			2025-10-22 20:07:04.51+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-22 12:44:40.274+00	2025-10-22 20:07:04.51+00
cmgth97we0041jl0rkm330hz9	10	pickup	delivered	2306 placard étage		2025-10-16 23:17:56.877+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-16 13:50:30.206+00	2025-10-16 23:17:56.877+00
cmgth97wf0042jl0r7e7vf4t4	13	dropoff	delivered	\N		2025-10-16 23:56:39.701+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-16 13:50:30.206+00	2025-10-16 23:56:39.701+00
cmh1zjo42000jg90scl08w2vl	14	both	delivered	Fermé les Vendredi		2025-10-22 20:07:06.181+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-22 12:44:40.274+00	2025-10-22 20:07:06.181+00
cmgth97wf0043jl0rzlivqo9b	14	both	delivered	À l'étage dans le placard		2025-10-17 00:04:32.289+00	\N	cmgth97we003sjl0rvpe4twot	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-16 13:50:30.206+00	2025-10-17 00:04:32.289+00
cmh1zjo42000ag90s57ved8im	15	both	delivered			2025-10-22 20:07:07.707+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-22 12:44:40.274+00	2025-10-22 20:07:07.707+00
cmh1zjo42000kg90sial3u069	18	dropoff	en_route	Fermé les Mercredi	\N	\N	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-22 12:44:40.274+00	2025-10-22 20:07:07.741+00
cmgs4erp8002vjl0r5qz2f1q7	11	both	delivered			2025-10-15 19:13:01.313+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-15 15:03:07.963+00	2025-10-15 19:13:01.313+00
cmgs55c3e0036jl0rq6t848qm	1	both	delivered			2025-10-15 19:23:41.263+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-15 15:23:47.45+00	2025-10-15 19:23:41.263+00
cmgs4erp8002zjl0rswcfuy7d	12	pickup	delivered	Fermé les Mercredi		2025-10-15 19:38:02.065+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-15 15:03:07.963+00	2025-10-15 19:38:02.065+00
cmgs55c3e003ajl0rw6l63vki	2	pickup	delivered			2025-10-15 19:50:18.13+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-15 15:23:47.45+00	2025-10-15 19:50:18.13+00
cmgs4erp80031jl0ri4rk84ye	13	dropoff	delivered	Fermé les jeudi		2025-10-15 20:05:52.599+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-15 15:03:07.963+00	2025-10-15 20:05:52.599+00
cmgs55c3e003cjl0rd52pyah3	3	both	delivered			2025-10-15 20:10:16.377+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-15 15:23:47.45+00	2025-10-15 20:10:16.377+00
cmgs4erp80030jl0raz1bx12e	14	both	delivered	Fermé les Vendredi		2025-10-15 20:17:07.572+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-15 15:03:07.963+00	2025-10-15 20:17:07.572+00
cmgs55c3e0037jl0rrn8gd6qt	4	pickup	delivered			2025-10-15 20:39:07.732+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-15 15:23:47.45+00	2025-10-15 20:39:07.732+00
cmgs4erp7002pjl0r6l8khwih	15	both	delivered			2025-10-15 20:49:58.401+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-15 15:03:07.963+00	2025-10-15 20:49:58.401+00
cmgs4erp80032jl0rcm8636k8	18	pickup	delivered	Fermé les Mercredi		2025-10-15 21:10:59.912+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-15 15:03:07.963+00	2025-10-15 21:10:59.912+00
cmgs4erp8002ujl0rd4odi36p	19	pickup	delivered			2025-10-15 21:28:39.045+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-15 15:03:07.963+00	2025-10-15 21:28:39.045+00
cmgz8kqcr0079jl0rjgsgjnbt	0	pickup	delivered			2025-10-20 16:54:29.107+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-20 14:34:07.851+00	2025-10-20 16:54:29.108+00
cmgz8kqcr007ejl0rr36i03tu	2	both	delivered			2025-10-20 17:13:05.41+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-20 14:34:07.851+00	2025-10-20 17:13:05.41+00
cmgs4erp8002tjl0r8wh8mpbz	20	dropoff	delivered			2025-10-15 21:40:44.315+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-10-15 15:03:07.963+00	2025-10-15 21:40:44.315+00
cmgz8kqcr007ajl0ra1guzjk2	4	both	delivered		NE PAS REMETTRE SCOTCH ADEIS 	2025-10-20 17:47:18.891+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-20 14:34:07.851+00	2025-10-20 17:47:18.891+00
cmgs55c3e0038jl0rx8pjcanu	6	pickup	delivered			2025-10-15 21:56:33.132+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-15 15:23:47.45+00	2025-10-15 21:56:33.132+00
cmgz8kqcr0077jl0rj8fwt3f4	5	both	delivered			2025-10-20 17:58:45.556+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-20 14:34:07.851+00	2025-10-20 17:58:45.557+00
cmgz8kqcr007fjl0rbh5h6wya	7	dropoff	delivered			2025-10-20 18:17:15.629+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-20 14:34:07.851+00	2025-10-20 18:17:15.629+00
cmgz8kqcr007gjl0ro5ya6pr2	8	both	delivered			2025-10-20 18:37:36.115+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-20 14:34:07.851+00	2025-10-20 18:37:36.115+00
cmgs4erp8002yjl0roqv7ev6j	3	dropoff	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-15 16:52:33.433+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-15 15:03:07.963+00	2025-10-15 16:52:33.433+00
cmgs55c3e0035jl0rqbjuw5iy	7	dropoff	delivered	3ème étage CODE: 2606		2025-10-15 22:58:36.907+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-15 15:23:47.45+00	2025-10-15 22:58:36.907+00
cmgs4erp8002sjl0r7ewhtqzl	4	dropoff	delivered			2025-10-15 16:52:35.785+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-15 15:03:07.963+00	2025-10-15 16:52:35.785+00
cmgs4erp7002qjl0raw9z1bw5	5	pickup	delivered			2025-10-15 17:09:02.266+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-15 15:03:07.963+00	2025-10-15 17:09:02.266+00
cmgs55c3d0034jl0reu2gdymg	9	both	delivered	Boite au lettre du haut		2025-10-15 23:14:55.552+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-15 15:23:47.45+00	2025-10-15 23:14:55.552+00
cmgs4erp8002wjl0rwykjsk3d	7	pickup	delivered			2025-10-15 17:28:40.899+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-15 15:03:07.963+00	2025-10-15 17:28:40.899+00
cmgz8kqcr0078jl0ru79yf4xl	10	both	delivered			2025-10-20 19:32:52.177+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-20 14:34:07.851+00	2025-10-20 19:32:52.177+00
cmgs4erp8002xjl0rurjtoak9	8	both	delivered			2025-10-15 17:59:51.409+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-15 15:03:07.963+00	2025-10-15 17:59:51.409+00
cmgs55c3e003ejl0r6syxjegq	10	both	delivered	2306 placard étage		2025-10-15 23:23:03.387+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-15 15:23:47.45+00	2025-10-15 23:23:03.387+00
cmgs55c3e0039jl0rssr1ym5t	0	both	delivered	x 3612 🔔 Devant la porte	Pas de colis à ramasser 	2025-10-15 18:53:28.805+00	https://www.storage.tds-transports.fr/228d237c-290d-40c4-b699-c196b825907b.avif	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-15 15:23:47.45+00	2025-10-15 18:53:28.805+00
cmgz8kqcr007djl0rkefr1grr	11	pickup	delivered			2025-10-20 19:53:01.791+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-20 14:34:07.851+00	2025-10-20 19:53:01.791+00
cmgs4erp8002rjl0rwj1s6rhi	10	both	delivered			2025-10-15 18:54:56.88+00	\N	cmgs2y8ew001ljl0r5e0vsy6s	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-15 15:03:07.963+00	2025-10-15 18:54:56.88+00
cmgs55c3e003bjl0r92xpf4wc	13	dropoff	delivered			2025-10-16 00:05:43.667+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-15 15:23:47.45+00	2025-10-16 00:05:43.668+00
cmgz8kqcr007ijl0rrlvith55	12	both	delivered	Fermé les Mercredi		2025-10-20 20:20:12.488+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-20 14:34:07.851+00	2025-10-20 20:20:12.488+00
cmgs55c3e003djl0rrvdkvce3	15	dropoff	delivered			2025-10-16 00:13:15.595+00	\N	cmgs3y49l0021jl0rntnrpbpt	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-15 15:23:47.45+00	2025-10-16 00:13:15.595+00
cmgz8kqcr007kjl0rvpssw54y	13	both	delivered	Fermé les jeudi		2025-10-20 20:50:34.844+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-20 14:34:07.851+00	2025-10-20 20:50:34.844+00
cmgz8kqcr007jjl0rd6xif5y8	14	both	delivered	Fermé les Vendredi		2025-10-20 21:03:44.958+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-20 14:34:07.851+00	2025-10-20 21:03:44.958+00
cmgz8kqcr0076jl0rbnzet9uj	15	both	delivered			2025-10-20 21:39:41.413+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-20 14:34:07.851+00	2025-10-20 21:39:41.413+00
cmgz8kqcr007ljl0rqppvcsyc	18	pickup	delivered	Fermé les Mercredi		2025-10-20 22:02:25.659+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-20 14:34:07.851+00	2025-10-20 22:02:25.659+00
cmgz8kqcr007cjl0rt45lsbho	19	pickup	delivered			2025-10-20 22:23:23.21+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-20 14:34:07.851+00	2025-10-20 22:23:23.21+00
cmguwuv14005njl0rkl3mibdz	0	dropoff	delivered	x 3612 🔔 Devant la porte		2025-10-17 18:48:27.973+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-17 13:55:00.376+00	2025-10-17 18:48:27.973+00
cmh0nk7z9000cjl0ruyswp5pm	9	pickup	delivered	Boite au lettre du haut		2025-10-21 18:40:51.76+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-21 14:21:24.453+00	2025-10-21 18:40:51.76+00
cmguwuv14005ojl0rfrra93kv	1	both	delivered	\N		2025-10-17 18:48:30.208+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-17 13:55:00.376+00	2025-10-17 18:48:30.208+00
cmguwuv14005pjl0r7csyli9f	3	both	delivered	\N		2025-10-17 18:48:35.676+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-17 13:55:00.376+00	2025-10-17 18:48:35.676+00
cmh0nk7z9000ejl0r80wnau53	11	pickup	delivered			2025-10-21 19:22:33.61+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-21 14:21:24.453+00	2025-10-21 19:22:33.61+00
cmgux38ot0064jl0rbfjxy7ws	10	both	delivered	\N		2025-10-17 19:02:24.091+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-17 14:01:31.325+00	2025-10-17 19:02:24.091+00
cmgtk42rv005gjl0r3od8c1pl	1	dropoff	delivered			2025-10-16 16:33:55.181+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-10-16 15:10:29.131+00	2025-10-16 16:33:55.181+00
cmgtk42rv005fjl0ryu3l3x3f	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-16 16:48:06.368+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-16 15:10:29.131+00	2025-10-16 16:48:06.368+00
cmgux38ot0065jl0rphqje5zv	12	pickup	delivered	Fermé les Mercredi		2025-10-17 19:44:11.354+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-17 14:01:31.325+00	2025-10-17 19:44:11.354+00
cmgtk42rv005hjl0rf19rdt9c	12	both	delivered	Fermé les Mercredi		2025-10-16 20:05:24.143+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-16 15:10:29.131+00	2025-10-16 20:05:24.143+00
cmh0nk7z9000djl0rshoh3e4v	14	both	delivered	À l'étage dans le placard		2025-10-21 20:12:04.157+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-21 14:21:24.453+00	2025-10-21 20:12:04.157+00
cmgtk42rv005jjl0rz75zy4k7	13	both	delivered	Fermé les jeudi		2025-10-16 20:05:26.666+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-16 15:10:29.131+00	2025-10-16 20:05:26.666+00
cmguwuv14005qjl0r3tcyy0ne	8	dropoff	delivered	\N		2025-10-17 19:58:04.587+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-10-17 13:55:00.376+00	2025-10-17 19:58:04.587+00
cmgtk42rv005ijl0rbd2wex1m	14	dropoff	delivered	Fermé les Vendredi		2025-10-16 20:19:33.509+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-16 15:10:29.131+00	2025-10-16 20:19:33.509+00
cmgtk42rv005kjl0rhc5zrler	18	both	delivered	Fermé les Mercredi		2025-10-16 21:13:03.236+00	\N	cmgth4gzh003fjl0ru47bcukx	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-16 15:10:29.131+00	2025-10-16 21:13:03.236+00
cmguwuv14005rjl0rv949x9p2	9	pickup	delivered	Boite au lettre du haut		2025-10-17 19:58:07.271+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-17 13:55:00.376+00	2025-10-17 19:58:07.271+00
cmguwuv14005sjl0rbsmz5pg9	10	pickup	delivered	2306 placard étage		2025-10-17 19:58:09.931+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-17 13:55:00.376+00	2025-10-17 19:58:09.931+00
cmguwuv14005tjl0rtxgp2dyh	11	pickup	delivered	\N		2025-10-17 19:58:15.971+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-17 13:55:00.376+00	2025-10-17 19:58:15.971+00
cmguwuv14005ujl0r2ozqxcal	12	both	delivered	Fermé mercredi & jeudi		2025-10-17 19:58:20.41+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-17 13:55:00.376+00	2025-10-17 19:58:20.41+00
cmgux38ot005zjl0rgwzoa1zl	0	pickup	delivered	\N		2025-10-17 16:35:28.96+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-17 14:01:31.325+00	2025-10-17 16:35:28.96+00
cmgux38ot0066jl0rey62uaxr	13	both	delivered	Fermé les jeudi		2025-10-17 20:12:31.316+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-17 14:01:31.325+00	2025-10-17 20:12:31.316+00
cmgux38ot0060jl0rf1cdkumw	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-17 17:01:37.452+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-17 14:01:31.325+00	2025-10-17 17:01:37.452+00
cmgux38ot0061jl0rv7myl9x4	5	both	delivered	\N		2025-10-17 17:20:10.457+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-17 14:01:31.325+00	2025-10-17 17:20:10.457+00
cmgux38ot0067jl0rxlkup842	14	both	delivered	Fermé les Vendredi		2025-10-17 20:24:54.548+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-17 14:01:31.325+00	2025-10-17 20:24:54.548+00
cmgux38ot0062jl0rnq12k05z	7	pickup	delivered	\N		2025-10-17 17:53:16.722+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-17 14:01:31.325+00	2025-10-17 17:53:16.722+00
cmgux38ot0063jl0r0smbpf5a	8	dropoff	delivered	\N		2025-10-17 18:19:54.307+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-17 14:01:31.325+00	2025-10-17 18:19:54.307+00
cmguwuv14005vjl0ru7cjxiuw	13	both	delivered	\N		2025-10-17 20:53:03.962+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-17 13:55:00.376+00	2025-10-17 20:53:03.962+00
cmguwuv14005wjl0rt3kl4t4c	14	dropoff	delivered	À l'étage dans le placard	Pas de boite	2025-10-17 20:53:15.12+00	\N	cmguwuv13005ljl0rl5rcc4lo	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-17 13:55:00.376+00	2025-10-17 20:53:15.12+00
cmgux38ot0068jl0rtmg2ibhn	15	both	delivered	\N		2025-10-17 20:59:48.927+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-17 14:01:31.325+00	2025-10-17 20:59:48.927+00
cmgux38ot0069jl0rh4ays5zy	18	pickup	delivered	Fermé les Mercredi		2025-10-17 21:22:41.825+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-17 14:01:31.325+00	2025-10-17 21:22:41.825+00
cmgux38ot006ajl0r2e79jkzj	19	dropoff	delivered	\N		2025-10-17 21:42:08.031+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-17 14:01:31.325+00	2025-10-17 21:42:08.031+00
cmgux38ot006bjl0rsw1eu2tr	20	pickup	delivered	\N		2025-10-17 21:54:09.412+00	\N	cmgux38ot005xjl0rjn1ch8mn	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-10-17 14:01:31.325+00	2025-10-17 21:54:09.412+00
cmgz8cg5s006ejl0ri1bh92ex	1	both	delivered	\N		2025-10-20 16:18:27.167+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-20 14:27:41.391+00	2025-10-20 16:18:27.167+00
cmgz8cg5s006fjl0ris1w75za	3	both	delivered	\N		2025-10-20 16:55:56.704+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-20 14:27:41.391+00	2025-10-20 16:55:56.704+00
cmgz8kqcr007hjl0rzefjvrj3	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-20 17:25:23.174+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-20 14:34:07.851+00	2025-10-20 17:25:23.174+00
cmgz8cg5s006gjl0r672imyq8	7	pickup	delivered	3ème étage CODE: 2606		2025-10-20 18:26:12.073+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-20 14:27:41.391+00	2025-10-20 18:26:12.073+00
cmgz8cg5s006hjl0r5lgf6em6	8	pickup	delivered	\N		2025-10-20 18:36:27.55+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-10-20 14:27:41.391+00	2025-10-20 18:36:27.55+00
cmgz8cg5s006ijl0roau09xwl	9	pickup	delivered	Boite au lettre du haut		2025-10-20 18:38:40.317+00	\N	cmgz8cg5r006cjl0ruwimgl4x	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-20 14:27:41.391+00	2025-10-20 18:38:40.317+00
cmgz8kqcr007bjl0riynk0n3x	20	pickup	delivered			2025-10-20 22:34:36.807+00	\N	cmgz8hh6h006ojl0rwbj6rx0d	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-10-20 14:34:07.851+00	2025-10-20 22:34:36.807+00
cmh0qpq2q001kjl0rdtomf95s	8	both	delivered			2025-10-21 18:37:09.136+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-21 15:49:40.034+00	2025-10-21 18:37:09.136+00
cmh0qpq2q001hjl0r0kdxfht4	11	pickup	delivered			2025-10-21 19:17:42.85+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-21 15:49:40.034+00	2025-10-21 19:17:42.85+00
cmh0qpq2q001mjl0raapwgzc8	12	dropoff	delivered	Fermé les Mercredi		2025-10-21 19:44:09.917+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-21 15:49:40.034+00	2025-10-21 19:44:09.917+00
cmh0qpq2q001njl0rg6u490j5	14	both	delivered	Fermé les Vendredi		2025-10-21 20:03:04.559+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-21 15:49:40.034+00	2025-10-21 20:03:04.559+00
cmhj8pxzr0075dj0rfs36lsom	13	pickup	delivered	Fermé les jeudi		2025-11-03 21:21:35.176+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-03 14:33:34.551+00	2025-11-03 21:21:35.176+00
cmh0qpq2q001djl0rvl883ygl	15	both	delivered			2025-10-21 21:08:42.113+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-21 15:49:40.034+00	2025-10-21 21:08:42.113+00
cmh0qpq2q001ojl0r6uq7k4gw	18	dropoff	delivered	Fermé les Mercredi		2025-10-21 21:08:44.492+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-21 15:49:40.034+00	2025-10-21 21:08:44.492+00
cmhj8pxzr0076dj0r8yftlbvw	18	pickup	delivered	Fermé les Mercredi		2025-11-03 22:07:29.666+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-03 14:33:34.551+00	2025-11-03 22:07:29.666+00
cmh0qpq2q001gjl0rwfau912s	19	dropoff	delivered			2025-10-21 21:20:13.593+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-21 15:49:40.034+00	2025-10-21 21:20:13.593+00
cmh4wl5ng003mgc0r32c7yca2	7	both	delivered			2025-10-24 17:31:00.793+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-24 13:45:09.339+00	2025-10-24 17:31:00.793+00
cmh4wl5ng003ngc0rhplyj0ry	8	both	delivered			2025-10-24 17:54:34.305+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-24 13:45:09.339+00	2025-10-24 17:54:34.305+00
cmh4wl5ng003ogc0r7blk1vep	12	dropoff	delivered	Fermé les Mercredi		2025-10-24 19:58:05.137+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-24 13:45:09.339+00	2025-10-24 19:58:05.137+00
cmh4wl5ng003pgc0r9ivhcgq8	14	both	delivered	Fermé les Vendredi	Pas de ramasse (ferme le vendredi)	2025-10-24 19:58:28.633+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-24 13:45:09.339+00	2025-10-24 19:58:28.633+00
cmhdho15q002idj0r44g7323s	2	dropoff	delivered			2025-10-30 17:12:36.324+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-30 13:57:24.829+00	2025-10-30 17:12:36.324+00
cmh4wl5ng003qgc0rw9l7lf69	18	dropoff	delivered	Fermé les Mercredi		2025-10-24 21:02:17.883+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-24 13:45:09.339+00	2025-10-24 21:02:17.883+00
cmhdho15q002kdj0rrc8vtwwh	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-30 17:12:39.499+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-30 13:57:24.829+00	2025-10-30 17:12:39.499+00
cmh21fsf8000xg90sjnevh0d4	7	dropoff	delivered	3ème étage CODE: 2606		2025-10-22 18:51:44.748+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-22 13:37:38.468+00	2025-10-22 18:51:44.748+00
cmhdho15q002jdj0rc19jrhn2	7	both	delivered			2025-10-30 17:12:59.018+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-30 13:57:24.829+00	2025-10-30 17:12:59.018+00
cmhdho15q002hdj0ra20vj02x	11	dropoff	delivered			2025-10-30 18:22:45.368+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-30 13:57:24.829+00	2025-10-30 18:22:45.368+00
cmh21fsf8000wg90sg1s836l7	9	dropoff	delivered	Boite au lettre du haut		2025-10-22 19:03:07.935+00	\N	cmh1srsf40003g90ssnkl7dsf	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-22 13:37:38.468+00	2025-10-22 19:03:07.935+00
cmh0nk7z9000fjl0rd369urwy	1	both	delivered			2025-10-21 16:28:01.214+00	\N	cmh0nk1ko0000jl0rlql4yl58	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-21 14:21:24.453+00	2025-10-21 16:28:01.214+00
cmh0sg64b001rjl0rr6ss61nf	3	pickup	planned	\N	\N	\N	\N	cmh0sg64b001pjl0rroasqpu4	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-21 16:38:13.499+00	2025-10-21 16:38:13.499+00
cmh0qpq2q001ijl0rk1wbl5vl	2	dropoff	delivered			2025-10-21 17:26:57.199+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-21 15:49:40.034+00	2025-10-21 17:26:57.199+00
cmh1zjo42000cg90sddd1oj5h	0	dropoff	delivered			2025-10-22 20:06:53.68+00	\N	cmh1rj09b0000g90s6tpxhddz	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-22 12:44:40.274+00	2025-10-22 20:06:53.68+00
cmh0qpq2q001ljl0ri4wsgs31	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-21 17:37:03.827+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-21 15:49:40.034+00	2025-10-21 17:37:03.827+00
cmhdho15q002ldj0rfl9on0qr	14	pickup	delivered	Fermé les Vendredi		2025-10-30 19:06:21.705+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-30 13:57:24.829+00	2025-10-30 19:06:21.705+00
cmh0qpq2q001fjl0r14lc4n3g	4	both	delivered			2025-10-21 17:46:34.188+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-21 15:49:40.034+00	2025-10-21 17:46:34.188+00
cmh0qpq2q001ejl0rcsnaznjq	5	pickup	delivered			2025-10-21 17:58:12.4+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-21 15:49:40.034+00	2025-10-21 17:58:12.4+00
cmh0qpq2q001jjl0rgj652jly	7	pickup	delivered			2025-10-21 18:16:10.621+00	\N	cmh0parb7000ljl0rsvib843d	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-21 15:49:40.034+00	2025-10-21 18:16:10.621+00
cmh985qbk000oim0rgkqtkttp	1	both	delivered		A vérifier s’il est en Vacance stp ?	2025-10-27 17:00:15.277+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-27 14:20:09.728+00	2025-10-27 17:00:15.277+00
cmh985qbk000lim0rjvc666ax	7	dropoff	delivered	3ème étage CODE: 2606		2025-10-27 18:22:50.29+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-27 14:20:09.728+00	2025-10-27 18:22:50.29+00
cmh985qbk000kim0r419begvs	9	dropoff	delivered	Boite au lettre du haut	A vérifier s’il ne sont pas en congés ?	2025-10-27 18:39:33.223+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-27 14:20:09.728+00	2025-10-27 18:39:33.223+00
cmh97l3i2000eim0r4h0e2ecx	7	dropoff	delivered			2025-10-27 18:44:58.931+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-27 14:04:07.033+00	2025-10-27 18:44:58.931+00
cmh985qbk000nim0r78pzyyof	11	dropoff	delivered			2025-10-27 19:09:56.447+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-27 14:20:09.728+00	2025-10-27 19:09:56.447+00
cmh97l3i2000fim0rnvqh7n50	8	both	delivered			2025-10-27 19:09:59.535+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-27 14:04:07.033+00	2025-10-27 19:09:59.535+00
cmh985qbk000mim0rdkyhwimx	14	both	delivered	À l'étage dans le placard		2025-10-27 19:50:10.347+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-27 14:20:09.728+00	2025-10-27 19:50:10.347+00
cmh97l3i2000gim0r7rovmmwf	12	both	delivered	Fermé les Mercredi		2025-10-27 20:55:33.149+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-27 14:04:07.033+00	2025-10-27 20:55:33.149+00
cmh97l3i2000him0rzs6wlx8g	14	both	delivered	Fermé les Vendredi		2025-10-27 21:15:37.983+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-27 14:04:07.033+00	2025-10-27 21:15:37.983+00
cmh97l3i2000iim0rxjwa8xil	18	dropoff	delivered	Fermé les Mercredi		2025-10-27 22:16:42.304+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-27 14:04:07.033+00	2025-10-27 22:16:42.304+00
cmh3iiqc3002kgc0r6hdg5xb9	7	both	delivered	3ème étage CODE: 2606		2025-10-23 18:25:49.363+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-23 14:23:35.378+00	2025-10-23 18:25:49.363+00
cmhj8pxzr0072dj0r488h8xgy	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-03 17:26:18.04+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-03 14:33:34.551+00	2025-11-03 17:26:18.04+00
cmh3k2mg0002zgc0rkjlio7kb	8	both	delivered			2025-10-23 18:31:06.425+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-23 15:07:03.072+00	2025-10-23 18:31:06.425+00
cmh3iiqc3002jgc0rt11hhqn9	9	dropoff	delivered	Boite au lettre du haut		2025-10-23 18:39:45.243+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-23 14:23:35.378+00	2025-10-23 18:39:45.243+00
cmh3iiqc3002rgc0rwd8wchtx	10	dropoff	delivered	2306 placard étage		2025-10-23 18:41:24.424+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-23 14:23:35.378+00	2025-10-23 18:41:24.424+00
cmh3iiqc3002mgc0r2j5a24pm	11	both	delivered			2025-10-23 19:08:11.552+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-23 14:23:35.378+00	2025-10-23 19:08:11.552+00
cmh3k2mg0002ygc0rsqcs5pda	11	dropoff	delivered			2025-10-23 19:09:12.823+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-23 15:07:03.072+00	2025-10-23 19:09:12.823+00
cmh3iiqc3002ngc0rax7sqh7z	1	both	delivered			2025-10-23 16:05:58.341+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-23 14:23:35.378+00	2025-10-23 16:05:58.342+00
cmh3iiqc3002sgc0ru88v7pw7	12	both	delivered	Fermé mercredi & jeudi		2025-10-23 19:22:47.15+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-23 14:23:35.378+00	2025-10-23 19:22:47.15+00
cmh3iiqc3002pgc0rvlt6e7m6	2	pickup	delivered			2025-10-23 16:26:58.893+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-23 14:23:35.378+00	2025-10-23 16:26:58.893+00
cmh3iiqc3002lgc0rzfzfo6tl	14	both	delivered	À l'étage dans le placard		2025-10-23 19:32:55.592+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-23 14:23:35.378+00	2025-10-23 19:32:55.592+00
cmh3iiqc3002qgc0rx8160ifp	3	both	delivered			2025-10-23 16:54:09.829+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-23 14:23:35.378+00	2025-10-23 16:54:09.829+00
cmh3k2mg00031gc0rd5k1mlcb	14	both	delivered	Fermé les Vendredi		2025-10-23 19:52:12.745+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-23 15:07:03.072+00	2025-10-23 19:52:12.745+00
cmh3iiqc3002ogc0recl68qzw	4	pickup	delivered			2025-10-23 17:33:56.115+00	\N	cmh360t7o0000gc0rbfpn0unt	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-23 14:23:35.378+00	2025-10-23 17:33:56.115+00
cmh3k2mg00030gc0r1wtkesln	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-23 17:35:05.638+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-23 15:07:03.072+00	2025-10-23 17:35:05.638+00
cmh3k2mg0002wgc0rshjoh7bd	4	pickup	delivered			2025-10-23 17:46:12.389+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-23 15:07:03.072+00	2025-10-23 17:46:12.389+00
cmh3k2mg0002ugc0rv24epnzs	15	both	delivered			2025-10-23 20:27:32.679+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-23 15:07:03.072+00	2025-10-23 20:27:32.679+00
cmh3k2mg0002vgc0rw50vns9s	5	both	delivered			2025-10-23 17:57:11.603+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-23 15:07:03.072+00	2025-10-23 17:57:11.603+00
cmh3k2mg00032gc0rfrjfr4bp	18	pickup	delivered	Fermé les Mercredi		2025-10-23 20:49:38.406+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-23 15:07:03.072+00	2025-10-23 20:49:38.406+00
cmh3k2mg0002xgc0riujy2ord	19	both	delivered			2025-10-23 21:07:30.172+00	\N	cmh38m3x50003gc0ru8xskh3c	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-23 15:07:03.072+00	2025-10-23 21:07:30.172+00
cmh4x7mbx003vgc0r66370yz4	1	both	delivered			2025-10-24 15:58:56.368+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-24 14:02:37.389+00	2025-10-24 15:58:56.368+00
cmh4wl5nf003jgc0rwj5ymngj	0	dropoff	delivered			2025-10-24 16:21:09.056+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-24 13:45:09.339+00	2025-10-24 16:21:09.056+00
cmh4x7mbx003ygc0rinpzka7a	2	dropoff	delivered			2025-10-24 16:22:11.749+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-10-24 14:02:37.389+00	2025-10-24 16:22:11.749+00
cmh4wl5nf003lgc0r6j7gdyo6	2	pickup	delivered			2025-10-24 16:38:47.281+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-24 13:45:09.339+00	2025-10-24 16:38:47.281+00
cmh4x7mbx003wgc0rcy80vbv9	4	pickup	delivered			2025-10-24 16:48:46.175+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-24 14:02:37.389+00	2025-10-24 16:48:46.175+00
cmh4wl5nf003kgc0rs0qdwpgn	4	dropoff	delivered			2025-10-24 16:58:00.58+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-24 13:45:09.339+00	2025-10-24 16:58:00.58+00
cmh4wl5nf003hgc0rts8ol4td	5	both	delivered			2025-10-24 17:11:16.792+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-24 13:45:09.339+00	2025-10-24 17:11:16.792+00
cmh4x7mbx0040gc0rsosy6m3f	5	dropoff	delivered	La porte de gauche		2025-10-24 17:34:23.385+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-24 14:02:37.389+00	2025-10-24 17:34:23.385+00
cmh4x7mbx003xgc0rmuheewl8	6	dropoff	delivered			2025-10-24 18:28:26.179+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-24 14:02:37.389+00	2025-10-24 18:28:26.179+00
cmh4wl5nf003igc0rjpokr5cy	10	both	delivered			2025-10-24 18:52:59.394+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-24 13:45:09.339+00	2025-10-24 18:52:59.394+00
cmh4x7mbx003tgc0rbu4vzqzy	7	dropoff	delivered	3ème étage CODE: 2606		2025-10-24 19:24:13.488+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-24 14:02:37.389+00	2025-10-24 19:24:13.49+00
cmh4x7mbx003sgc0ra467ljsl	9	dropoff	delivered	Boite au lettre du haut		2025-10-24 19:25:39.566+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-24 14:02:37.389+00	2025-10-24 19:25:39.574+00
cmh4x7mbx003ugc0rlqcdw76m	11	both	delivered			2025-10-24 20:06:52.068+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-24 14:02:37.389+00	2025-10-24 20:06:52.068+00
cmh4x7mbx0041gc0rbsc4s4vt	12	both	delivered	Fermé mercredi & jeudi		2025-10-24 20:21:06.502+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-24 14:02:37.389+00	2025-10-24 20:21:06.502+00
cmh4wl5nf003ggc0rw9swnf1b	15	both	delivered			2025-10-24 20:37:10.09+00	\N	cmh4nv3nu0033gc0rfqkxuv4m	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-24 13:45:09.339+00	2025-10-24 20:37:10.09+00
cmh4x7mbx003zgc0rb0bvfiiw	15	both	delivered			2025-10-24 22:23:46.231+00	\N	cmh4t2nhd0036gc0r09zei2e8	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-24 14:02:37.389+00	2025-10-24 22:23:46.231+00
cmh97l3i2000aim0rqgw31zx8	0	dropoff	delivered			2025-10-27 17:45:08.787+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-27 14:04:07.033+00	2025-10-27 17:45:08.787+00
cmh97l3i20009im0rl6rtyd3r	10	pickup	delivered			2025-10-27 20:07:35.021+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-27 14:04:07.033+00	2025-10-27 20:07:35.021+00
cmh97l3i20008im0r2zfg0a9r	15	both	delivered			2025-10-27 21:51:44.941+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-27 14:04:07.033+00	2025-10-27 21:51:44.941+00
cmhc1japn000wdj0rw7sqkj1s	5	dropoff	delivered			2025-10-29 18:00:25.3+00	\N	cmhc1japm000sdj0rgfk97tq3	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-29 13:38:03.899+00	2025-10-29 18:00:25.3+00
cmhc4aszv001ddj0r7o2dvb69	6	dropoff	delivered			2025-10-29 18:11:27.564+00	\N	cmhc0lg5u000odj0rgduqledl	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-29 14:55:26.539+00	2025-10-29 18:11:27.564+00
cmhj8pxzr006ydj0rvv9m1iju	4	dropoff	delivered			2025-11-03 17:35:21.687+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-03 14:33:34.551+00	2025-11-03 17:35:21.687+00
cmhc1japn000xdj0rvq27ipkg	11	dropoff	delivered			2025-10-29 19:23:26.563+00	\N	cmhc1japm000sdj0rgfk97tq3	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-29 13:38:03.899+00	2025-10-29 19:23:26.563+00
cmhc4aszv001adj0rkz4mli1a	9	both	delivered	Boite au lettre du haut		2025-10-29 19:23:36.396+00	\N	cmhc0lg5u000odj0rgduqledl	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-29 14:55:26.539+00	2025-10-29 19:23:36.396+00
cmh985qbk000rim0rmt732awf	5	dropoff	delivered	La porte de gauche		2025-10-27 17:55:05.514+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-27 14:20:09.728+00	2025-10-27 17:55:05.514+00
cmh97l3i2000dim0rbfcco712	2	dropoff	delivered			2025-10-27 18:03:41.936+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-10-27 14:04:07.033+00	2025-10-27 18:03:41.936+00
cmh97l3i2000bim0rxhld1033	4	dropoff	delivered			2025-10-27 18:21:40.401+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-27 14:04:07.033+00	2025-10-27 18:21:40.401+00
cmhc4aszv001bdj0r6thjyawk	11	dropoff	delivered			2025-10-29 19:50:35.087+00	\N	cmhc0lg5u000odj0rgduqledl	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-29 14:55:26.539+00	2025-10-29 19:50:35.087+00
cmh985qbk000sim0rjd69qu61	10	dropoff	delivered	2306 placard étage		2025-10-27 18:40:36.776+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-27 14:20:09.728+00	2025-10-27 18:40:36.776+00
cmh985qbk000tim0r2n7uu4ea	12	both	delivered	Fermé mercredi & jeudi		2025-10-27 19:27:50.294+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-27 14:20:09.728+00	2025-10-27 19:27:50.295+00
cmhc1japn000ydj0r221g44nl	14	both	delivered	Fermé les Vendredi		2025-10-29 20:04:58.453+00	\N	cmhc1japm000sdj0rgfk97tq3	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-29 13:38:03.899+00	2025-10-29 20:04:58.453+00
cmh985qbk000pim0r8a1fturf	13	dropoff	delivered			2025-10-27 19:29:02.631+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-27 14:20:09.728+00	2025-10-27 19:29:02.631+00
cmh985qbk000qim0rh2rb1bvz	15	both	delivered			2025-10-27 19:50:22.455+00	\N	cmh9008p10000im0rwpf8as0i	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-27 14:20:09.728+00	2025-10-27 19:50:22.455+00
cmhc4aszv001edj0r2afqazad	13	pickup	delivered			2025-10-29 20:20:51.819+00	\N	cmhc0lg5u000odj0rgduqledl	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-29 14:55:26.539+00	2025-10-29 20:20:51.819+00
cmh97l3i2000cim0rohbl06u5	11	dropoff	delivered			2025-10-27 20:28:48.239+00	\N	cmh96eo5q0003im0rrejuncs7	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-27 14:04:07.033+00	2025-10-27 20:28:48.239+00
cmhc1japn000zdj0rfn5nllnv	15	both	delivered			2025-10-29 20:40:28.655+00	\N	cmhc1japm000sdj0rgfk97tq3	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-29 13:38:03.899+00	2025-10-29 20:40:28.655+00
cmhw3vlal00fwdj0rwcewxqvf	12	dropoff	delivered	Fermé les Mercredi		2025-11-12 20:42:48.292+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-12 14:39:00.237+00	2025-11-12 20:42:48.292+00
cmhc1japn0010dj0r9udu54pp	18	dropoff	delivered	Fermé les Mercredi		2025-10-29 21:04:49.375+00	\N	cmhc1japm000sdj0rgfk97tq3	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-29 13:38:03.899+00	2025-10-29 21:04:49.375+00
cmhw3vlal00fydj0r913q6ea9	13	pickup	delivered	Fermé les jeudi		2025-11-12 21:13:09.656+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-12 14:39:00.237+00	2025-11-12 21:13:09.656+00
cmhw3vlal00fxdj0rox7yskmk	14	both	delivered	Fermé les Vendredi		2025-11-12 21:30:20.749+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-12 14:39:00.237+00	2025-11-12 21:30:20.75+00
cmhanug5g0005dj0rdjgdrrwp	0	dropoff	delivered			2025-10-28 17:19:48.264+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-28 14:27:03.364+00	2025-10-28 17:19:48.264+00
cmhar76ti000jdj0r2xg2661t	9	both	delivered	Boite au lettre du haut		2025-10-28 17:59:10.151+00	\N	cmha9d9o80000jj0r0fye3b7p	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-28 16:00:56.646+00	2025-10-28 17:59:10.151+00
cmhar76ti000ndj0r92z544pr	10	both	delivered	2306 placard étage		2025-10-28 17:59:12.185+00	\N	cmha9d9o80000jj0r0fye3b7p	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-28 16:00:56.646+00	2025-10-28 17:59:12.185+00
cmhar76ti000kdj0r8bqkwzhy	11	dropoff	delivered			2025-10-28 17:59:14.421+00	\N	cmha9d9o80000jj0r0fye3b7p	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-28 16:00:56.646+00	2025-10-28 17:59:14.422+00
cmhanug5g0008dj0rfv0ah721	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-28 18:09:11.901+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-28 14:27:03.364+00	2025-10-28 18:09:11.901+00
cmhanug5g0004dj0rkcesobqh	5	pickup	delivered			2025-10-28 18:20:53.069+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-28 14:27:03.364+00	2025-10-28 18:20:53.069+00
cmhanug5g0007dj0rr2rn39bn	11	dropoff	delivered			2025-10-28 18:20:55.509+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-10-28 14:27:03.364+00	2025-10-28 18:20:55.509+00
cmhar76ti000ldj0rp5x4stpb	13	both	delivered			2025-10-28 18:41:54.064+00	\N	cmha9d9o80000jj0r0fye3b7p	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-28 16:00:56.646+00	2025-10-28 18:41:54.064+00
cmhar76ti000mdj0rz17599bc	15	pickup	delivered			2025-10-28 19:05:57.047+00	\N	cmha9d9o80000jj0r0fye3b7p	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-28 16:00:56.646+00	2025-10-28 19:05:57.047+00
cmhanug5g0009dj0r7o4rx2um	12	pickup	delivered	Fermé les Mercredi		2025-10-28 19:59:37.512+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-28 14:27:03.364+00	2025-10-28 19:59:37.512+00
cmhanug5g000adj0ry0t30md1	14	both	delivered	Fermé les Vendredi		2025-10-28 20:19:30.391+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-28 14:27:03.364+00	2025-10-28 20:19:30.391+00
cmhanug5g0003dj0r6df5ausr	15	both	delivered			2025-10-28 20:53:57.925+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-28 14:27:03.364+00	2025-10-28 20:53:57.925+00
cmhanug5g000bdj0r3jxkxra0	18	pickup	delivered	Fermé les Mercredi		2025-10-28 21:15:20.867+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-28 14:27:03.364+00	2025-10-28 21:15:20.867+00
cmhanug5g0006dj0rvoqanp8l	19	dropoff	delivered			2025-10-28 21:32:44.754+00	\N	cmhab9xxe0004jj0r1q1mdmnh	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-28 14:27:03.364+00	2025-10-28 21:32:44.754+00
cmhc4aszv001cdj0rocevl4l3	4	dropoff	delivered			2025-10-29 16:29:47.991+00	\N	cmhc0lg5u000odj0rgduqledl	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-29 14:55:26.539+00	2025-10-29 16:29:47.991+00
cmhc4aszv001fdj0rg5rrmmru	5	pickup	delivered	La porte de gauche		2025-10-29 17:17:08.462+00	\N	cmhc0lg5u000odj0rgduqledl	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-29 14:55:26.539+00	2025-10-29 17:17:08.462+00
cmhc1japn000udj0rb38zddo8	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-29 17:32:32.091+00	\N	cmhc1japm000sdj0rgfk97tq3	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-29 13:38:03.899+00	2025-10-29 17:32:32.091+00
cmhc1japn000vdj0rfdoovur5	4	dropoff	delivered			2025-10-29 17:48:22.634+00	\N	cmhc1japm000sdj0rgfk97tq3	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-10-29 13:38:03.899+00	2025-10-29 17:48:22.634+00
cmhj8pxzr006wdj0r6htui9s8	5	dropoff	delivered			2025-11-03 18:04:58.252+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-03 14:33:34.551+00	2025-11-03 18:04:58.252+00
cmhc4aszv001gdj0r2opktlhk	10	dropoff	delivered	2306 placard étage		2025-10-29 19:28:44.938+00	\N	cmhc0lg5u000odj0rgduqledl	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-29 14:55:26.539+00	2025-10-29 19:28:44.938+00
cmhj8pxzr0070dj0re365e9l7	7	pickup	delivered			2025-11-03 18:23:28.365+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-03 14:33:34.551+00	2025-11-03 18:23:28.365+00
cmhw3vlal00fzdj0rslx3u8ac	18	dropoff	delivered	Fermé les Mercredi		2025-11-12 22:28:10.148+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-12 14:39:00.237+00	2025-11-12 22:28:10.149+00
cmhj8pxzr0071dj0r0f43jhy1	8	pickup	delivered			2025-11-03 18:53:43.763+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-03 14:33:34.551+00	2025-11-03 18:53:43.763+00
cmhyx4bms00jldj0ry6hmjceq	18	pickup	delivered	Fermé les Mercredi		2025-11-14 20:51:22.638+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-14 13:53:08.835+00	2025-11-14 20:51:22.638+00
cmhj8pxzr006xdj0rubc2i82y	10	pickup	delivered			2025-11-03 19:57:16.363+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-03 14:33:34.551+00	2025-11-03 19:57:16.363+00
cmhj8pxzr0073dj0rmzitgqby	12	dropoff	delivered	Fermé les Mercredi		2025-11-03 20:48:11.489+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-03 14:33:34.551+00	2025-11-03 20:48:11.489+00
cmhj8pxzr0074dj0r61ngvu9b	14	both	delivered	Fermé les Vendredi		2025-11-03 21:21:38.597+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-03 14:33:34.551+00	2025-11-03 21:21:38.597+00
cmhj8pxzr006vdj0r4q2qwk9v	15	both	delivered			2025-11-03 22:07:26.231+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-03 14:33:34.551+00	2025-11-03 22:07:26.231+00
cmhj8pxzr006zdj0r2a8ajd2r	19	both	delivered			2025-11-03 22:50:59.865+00	\N	cmhivrvby004jdj0r7dr1lph0	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-03 14:33:34.551+00	2025-11-03 22:50:59.865+00
cmi3b5y0g00lcdj0rqqu5g2ub	0	pickup	delivered			2025-11-17 16:45:18.286+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-11-17 15:37:23.824+00	2025-11-17 16:45:18.286+00
cmi3b5y0g00lddj0rrdjah8iu	4	both	delivered			2025-11-17 17:18:35.689+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-17 15:37:23.824+00	2025-11-17 17:18:35.69+00
cmi3b5y0g00lgdj0rgd7g782a	8	both	delivered			2025-11-17 18:21:38.455+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-17 15:37:23.824+00	2025-11-17 18:21:38.455+00
cmi3b5y0g00lfdj0r02l79w7b	11	dropoff	delivered			2025-11-17 20:42:10.907+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-17 15:37:23.824+00	2025-11-17 20:42:10.907+00
cmhdm3o0b003ddj0rvgpf15e2	15	both	planned		\N	\N	\N	cmhd4bzn3001kdj0ra4fl24zp	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-30 16:01:32.746+00	2025-10-30 16:01:32.746+00
cmi3b5y0g00lhdj0rn9jxaf81	12	dropoff	delivered	Fermé les Mercredi		2025-11-17 20:42:14.245+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-17 15:37:23.824+00	2025-11-17 20:42:14.245+00
cmhdm3o0b003bdj0riobicqeb	4	dropoff	delivered			2025-10-30 17:01:30.954+00	\N	cmhd4bzn3001kdj0ra4fl24zp	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-10-30 16:01:32.746+00	2025-10-30 17:01:30.954+00
cmi3b5y0g00ledj0raiyq7u7i	19	both	delivered			2025-11-17 21:32:59.052+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-17 15:37:23.824+00	2025-11-17 21:32:59.052+00
cmhdho15q002fdj0rogsfbe1g	5	dropoff	delivered			2025-10-30 17:12:43.988+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-10-30 13:57:24.829+00	2025-10-30 17:12:43.988+00
cmhdm3o0b0038dj0rpd1iscaa	7	dropoff	delivered	3ème étage CODE: 2606		2025-10-30 18:09:47.545+00	\N	cmhd4bzn3001kdj0ra4fl24zp	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-30 16:01:32.746+00	2025-10-30 18:09:47.545+00
cmhdm3o0b0037dj0ry529rfas	9	dropoff	delivered	Boite au lettre du haut		2025-10-30 18:09:50.689+00	\N	cmhd4bzn3001kdj0ra4fl24zp	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-10-30 16:01:32.746+00	2025-10-30 18:09:50.689+00
cmhdm3o0b003adj0rn8xccjhf	11	both	delivered			2025-10-30 18:22:53.299+00	\N	cmhd4bzn3001kdj0ra4fl24zp	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-30 16:01:32.746+00	2025-10-30 18:22:53.299+00
cmhdm3o0b003edj0rqp1rzztu	12	both	delivered	Fermé mercredi & jeudi		2025-10-30 18:40:24.297+00	\N	cmhd4bzn3001kdj0ra4fl24zp	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-30 16:01:32.746+00	2025-10-30 18:40:24.297+00
cmhdm3o0b003cdj0rirql15qf	13	both	delivered			2025-10-30 19:08:07.259+00	\N	cmhd4bzn3001kdj0ra4fl24zp	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-30 16:01:32.746+00	2025-10-30 19:08:07.259+00
cmhdm3o0b0039dj0rax40i1ue	14	both	en_route	À l'étage dans le placard	\N	\N	\N	cmhd4bzn3001kdj0ra4fl24zp	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-30 16:01:32.746+00	2025-10-30 19:08:07.307+00
cmhdho15q002edj0rf2y3zm4x	15	both	delivered			2025-10-30 19:40:46.232+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-30 13:57:24.829+00	2025-10-30 19:40:46.232+00
cmhdho15q002mdj0rfeli1del	18	both	delivered	Fermé les Mercredi		2025-10-30 20:03:38.445+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-30 13:57:24.829+00	2025-10-30 20:03:38.445+00
cmhdho15q002gdj0roup7hlz6	19	pickup	delivered			2025-10-30 20:23:56.235+00	\N	cmhd3oifd001hdj0r0a64wdqo	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-10-30 13:57:24.829+00	2025-10-30 20:23:56.235+00
cmhewydm6003kdj0r3bvpo7eh	0	dropoff	delivered			2025-10-31 16:49:26.063+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-10-31 13:53:07.95+00	2025-10-31 16:49:26.063+00
cmhewydm6003ldj0rbo95ybjz	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-10-31 17:20:31.674+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-10-31 13:53:07.95+00	2025-10-31 17:20:31.674+00
cmhewydm6003mdj0rczvuxghh	7	dropoff	delivered			2025-10-31 17:42:40.34+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-10-31 13:53:07.95+00	2025-10-31 17:42:40.34+00
cmhewydm6003ndj0rmg9gnpxh	8	both	delivered		Ramasse noté mais boîte scellé. Non récupérer 	2025-10-31 18:13:10.163+00	https://www.storage.tds-transports.fr/22e64a12-f522-48e8-93f9-e0d554b94f89.avif	cmhewydm5003idj0r56nvat9x	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-10-31 13:53:07.95+00	2025-10-31 18:13:10.163+00
cmhewydm6003odj0r33l5q25j	10	both	delivered			2025-10-31 19:09:01.28+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-10-31 13:53:07.95+00	2025-10-31 19:09:01.28+00
cmhewydm6003pdj0rwgkvqzsk	12	dropoff	delivered	Fermé les Mercredi		2025-10-31 19:51:22.429+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-10-31 13:53:07.95+00	2025-10-31 19:51:22.429+00
cmhewydm6003qdj0rwzd27bj8	13	both	delivered	Fermé les jeudi		2025-10-31 20:23:50.938+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-10-31 13:53:07.95+00	2025-10-31 20:23:50.938+00
cmhewydm6003rdj0rfi0muoyn	14	dropoff	delivered	Fermé les Vendredi		2025-10-31 20:35:33.999+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-10-31 13:53:07.95+00	2025-10-31 20:35:33.999+00
cmhewydm6003sdj0rq238apr8	15	both	delivered			2025-10-31 21:08:47.143+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-10-31 13:53:07.95+00	2025-10-31 21:08:47.143+00
cmhewydm6003tdj0r76f18oq7	18	dropoff	delivered	Fermé les Mercredi		2025-10-31 21:30:30.234+00	\N	cmhewydm5003idj0r56nvat9x	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-10-31 13:53:07.95+00	2025-10-31 21:30:30.234+00
cmk2rb1kg005ogr0rtqrkvb00	2	dropoff	delivered			2026-01-06 16:37:24.349+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2026-01-06 15:40:54.064+00	2026-01-06 16:37:24.349+00
cmhyxkxhy00jpdj0r2g19elau	1	both	delivered			2025-11-14 17:43:06.366+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-14 14:06:03.67+00	2025-11-14 17:43:06.366+00
cmhyxkxhy00jqdj0rcx7tmikx	3	both	delivered			2025-11-14 17:43:10.159+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-14 14:06:03.67+00	2025-11-14 17:43:10.159+00
cmhyxkxhy00jrdj0r7fx7mq4z	4	dropoff	delivered			2025-11-14 17:43:13.752+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-14 14:06:03.67+00	2025-11-14 17:43:13.752+00
cmhyxkxhy00jsdj0rl5wgvlgy	6	dropoff	delivered			2025-11-14 18:59:13.037+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-14 14:06:03.67+00	2025-11-14 18:59:13.037+00
cmhexju48004cdj0rn7o4uzmm	0	both	delivered	x 3612 🔔 Devant la porte		2025-10-31 15:56:41.775+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-10-31 14:09:49.112+00	2025-10-31 15:56:41.775+00
cmhyxkxhy00jtdj0ry7boipc9	9	dropoff	delivered	Boite au lettre du haut		2025-11-14 20:02:09.07+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-14 14:06:03.67+00	2025-11-14 20:02:09.07+00
cmhexju48004adj0r738bix0s	1	both	delivered			2025-10-31 15:56:45.539+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-10-31 14:09:49.112+00	2025-10-31 15:56:45.539+00
cmhexju48004edj0rxsnukluk	3	both	delivered			2025-10-31 16:21:55.846+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-10-31 14:09:49.112+00	2025-10-31 16:21:55.846+00
cmhyxkxhy00judj0rnb7xbstb	11	dropoff	delivered			2025-11-14 20:28:25.312+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-14 14:06:03.67+00	2025-11-14 20:28:25.312+00
cmhexju48004gdj0rcvzkaj98	5	dropoff	delivered	La porte de gauche		2025-10-31 17:33:36.859+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-10-31 14:09:49.112+00	2025-10-31 17:33:36.859+00
cmhexju48004bdj0rvibj1nxq	6	dropoff	delivered			2025-10-31 18:31:06.942+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-10-31 14:09:49.112+00	2025-10-31 18:31:06.942+00
cmhexju480047dj0rqpefz41o	7	dropoff	delivered	3ème étage CODE: 2606		2025-10-31 19:24:46.326+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-10-31 14:09:49.112+00	2025-10-31 19:24:46.326+00
cmhexju48004hdj0r3zq3x1gz	10	dropoff	delivered	2306 placard étage		2025-10-31 19:40:37.731+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-10-31 14:09:49.112+00	2025-10-31 19:40:37.731+00
cmhoz5kyi00dfdj0rru3zz8q5	0	dropoff	delivered			2025-11-07 17:29:52.718+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-07 14:52:25.049+00	2025-11-07 17:29:52.718+00
cmhexju480049dj0r55obj5n1	11	both	delivered			2025-10-31 20:22:39.82+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-10-31 14:09:49.112+00	2025-10-31 20:22:39.82+00
cmhexju48004idj0ri5c6j91c	12	both	delivered	Fermé mercredi & jeudi		2025-10-31 20:22:42.114+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-10-31 14:09:49.112+00	2025-10-31 20:22:42.114+00
cmhexju48004ddj0r9e8y08wc	13	dropoff	delivered			2025-10-31 20:31:03.223+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-10-31 14:09:49.112+00	2025-10-31 20:31:03.223+00
cmhoz5kyi00dddj0r7uh5edpg	2	dropoff	delivered			2025-11-07 19:06:41.3+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-07 14:52:25.049+00	2025-11-07 19:06:41.3+00
cmhexju480048dj0rk98g8uiy	14	pickup	delivered	À l'étage dans le placard	PAS DE BOITE !!!	2025-10-31 20:32:40.132+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-10-31 14:09:49.112+00	2025-10-31 20:32:40.132+00
cmhexju48004fdj0rw9zj375r	15	both	delivered			2025-10-31 21:17:05.048+00	\N	cmhemvcgk003fdj0rsbqm8l3s	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-10-31 14:09:49.112+00	2025-10-31 21:17:05.048+00
cmhoz5kyi00dedj0r3p0cafdb	8	both	delivered			2025-11-07 20:00:46.494+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-07 14:52:25.049+00	2025-11-07 20:00:46.494+00
cmhkq72tt009mdj0rh5gme9l4	0	pickup	delivered	x 3612 🔔 Devant la porte		2025-11-04 17:27:00.796+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-04 15:30:33.617+00	2025-11-04 17:27:00.796+00
cmhkpknkw0097dj0r36bmcr0r	2	pickup	delivered			2025-11-04 17:47:51.987+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-11-04 15:13:07.424+00	2025-11-04 17:47:51.987+00
cmhkq72tt009kdj0r3wc4ttqo	1	both	delivered			2025-11-04 17:58:32.437+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-04 15:30:33.617+00	2025-11-04 17:58:32.437+00
cmhkpknkw009adj0rdeies3fc	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-04 18:05:12.182+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-04 15:13:07.424+00	2025-11-04 18:05:12.182+00
cmhkpknkw0098dj0rzge4zwaj	7	dropoff	delivered			2025-11-04 18:41:44.406+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-04 15:13:07.424+00	2025-11-04 18:41:44.406+00
cmhoz5kyi00dbdj0r1ukndp39	1	dropoff	delivered	Boite au lettre du haut		2025-11-07 18:38:57.898+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-07 14:52:25.049+00	2025-11-07 18:38:57.898+00
cmhkpknkw0099dj0rbpcztgkc	8	both	delivered			2025-11-04 19:12:58.696+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-04 15:13:07.424+00	2025-11-04 19:12:58.696+00
cmhkq72tt009ldj0rf1grtsjn	4	pickup	delivered			2025-11-04 19:29:27.027+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-04 15:30:33.617+00	2025-11-04 19:29:27.027+00
cmhkpknkw0096dj0r1lc5ckvi	11	dropoff	delivered			2025-11-04 20:36:05.225+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-04 15:13:07.424+00	2025-11-04 20:36:05.225+00
cmhoz5kyi00dcdj0r6b20xro0	4	both	delivered	À l'étage dans le placard		2025-11-07 19:35:15.797+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-07 14:52:25.049+00	2025-11-07 19:35:15.797+00
cmhkq72tt009hdj0rwdjnrchx	7	dropoff	delivered	3ème étage CODE: 2606		2025-11-04 20:46:17.918+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-11-04 15:30:33.617+00	2025-11-04 20:46:17.918+00
cmhkpknkw009bdj0rhollgtjz	12	pickup	delivered	Fermé les Mercredi		2025-11-04 21:04:05.97+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-04 15:13:07.424+00	2025-11-04 21:04:05.97+00
cmhkq72tt009gdj0ri4vobf6q	9	both	delivered	Boite au lettre du haut		2025-11-04 21:06:27.523+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-04 15:30:33.617+00	2025-11-04 21:06:27.523+00
cmhkq72tt009jdj0r9g2uxap6	11	dropoff	delivered			2025-11-04 21:34:26.519+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-04 15:30:33.617+00	2025-11-04 21:34:26.519+00
cmhkpknkw009ddj0rlr168hv5	13	pickup	delivered	Fermé les jeudi		2025-11-04 21:36:01.31+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-04 15:13:07.424+00	2025-11-04 21:36:01.31+00
cmhkq72tt009idj0riser9lk0	14	pickup	delivered	À l'étage dans le placard	Pas de boite !	2025-11-04 21:55:42.589+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-04 15:30:33.617+00	2025-11-04 21:55:42.589+00
cmhkpknkw009cdj0r8crfk59t	14	both	delivered	Fermé les Vendredi		2025-11-04 21:55:49.102+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-04 15:13:07.424+00	2025-11-04 21:55:49.102+00
cmhkpknkw009edj0rycwz12sy	18	pickup	delivered	Fermé les Mercredi		2025-11-04 22:56:45.936+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-04 15:13:07.424+00	2025-11-04 22:56:45.936+00
cmhj8deoc0060dj0rw8obu43c	0	pickup	delivered	x 3612 🔔 Devant la porte		2025-11-03 17:10:21.219+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-03 14:23:49.644+00	2025-11-03 17:10:21.219+00
cmhj8deoc005xdj0rv8f5e9l0	1	pickup	failed		Pas de boite déjà récupéré !	2025-11-03 17:44:46.05+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-03 14:23:49.644+00	2025-11-03 17:44:46.05+00
cmhyxkxhz00jwdj0rad0plwpn	13	pickup	delivered			2025-11-14 21:06:08.48+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-14 14:06:03.67+00	2025-11-14 21:06:08.48+00
cmhyxkxhz00jxdj0rxroqx2qg	14	both	delivered	À l'étage dans le placard		2025-11-14 21:07:35.213+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-14 14:06:03.67+00	2025-11-14 21:07:35.213+00
cmhyxkxhz00jydj0r7d31yxcr	15	both	delivered			2025-11-14 21:09:54.506+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-14 14:06:03.67+00	2025-11-14 21:09:54.506+00
cmhj8deoc0063dj0rwjsngbgq	3	both	delivered			2025-11-03 18:33:38.636+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-03 14:23:49.644+00	2025-11-03 18:33:38.636+00
cmhj8deoc005ydj0rju6j3drp	4	pickup	delivered			2025-11-03 19:10:53.222+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-03 14:23:49.644+00	2025-11-03 19:10:53.222+00
cmhj8deoc005zdj0r7b6h9ior	6	dropoff	delivered		+ Collecte	2025-11-03 20:33:16.543+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-03 14:23:49.644+00	2025-11-03 20:33:16.543+00
cmhj8deoc005udj0ripdg5xz0	7	dropoff	delivered	3ème étage CODE: 2606		2025-11-03 21:19:17.927+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-11-03 14:23:49.644+00	2025-11-03 21:19:17.927+00
cmhj8deoc0062dj0rwyjwtzxp	8	dropoff	delivered			2025-11-03 21:43:25.704+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-03 14:23:49.644+00	2025-11-03 21:43:25.704+00
cmhnjyb9800bpdj0rwexlgazb	0	dropoff	delivered			2025-11-06 16:23:38.977+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-11-06 14:59:05.468+00	2025-11-06 16:23:38.977+00
cmhw4jvvn00gddj0ropbxssj6	9	both	planned		\N	\N	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-12 14:57:53.698+00	2025-11-12 16:14:58.772+00
cmhnjyb9800bvdj0r4gtkvgtd	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-06 17:24:40.526+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-06 14:59:05.468+00	2025-11-06 17:24:40.526+00
cmhw4jvvn00gedj0r8te01jty	7	both	en_route	x 3612 🔔 Devant la porte	\N	\N	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-12 14:57:53.698+00	2025-11-12 19:09:36.444+00
cmhnjyb9800bqdj0r9g0ppg4v	4	pickup	delivered			2025-11-06 17:37:44.707+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-06 14:59:05.468+00	2025-11-06 17:37:44.707+00
cmhnjyb9800btdj0rlrawaeu4	7	dropoff	delivered			2025-11-06 18:09:37.912+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-06 14:59:05.468+00	2025-11-06 18:09:37.912+00
cmhj8deoc005tdj0r54qovng8	9	dropoff	delivered	Boite au lettre du haut		2025-11-03 21:43:30.308+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-03 14:23:49.644+00	2025-11-03 21:43:30.308+00
cmhnjyb9800budj0rvfsdl4v3	8	both	delivered			2025-11-06 18:36:46.043+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-06 14:59:05.468+00	2025-11-06 18:36:46.043+00
cmhj8deoc0065dj0r3lza9uq1	10	dropoff	delivered	2306 placard étage		2025-11-03 21:43:33.372+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-03 14:23:49.644+00	2025-11-03 21:43:33.372+00
cmhj8deoc005wdj0ry07p4oai	11	dropoff	delivered			2025-11-03 22:04:49.856+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-03 14:23:49.644+00	2025-11-03 22:04:49.856+00
cmhnjyb9800bodj0rwbjcbgxu	10	both	delivered			2025-11-06 18:36:51.367+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-06 14:59:05.468+00	2025-11-06 18:36:51.367+00
cmhj8deoc0066dj0rbugv417r	12	both	delivered	Fermé mercredi & jeudi		2025-11-03 22:26:59.447+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-03 14:23:49.644+00	2025-11-03 22:26:59.447+00
cmhj8deoc0061dj0rf9yv7j9z	13	both	delivered			2025-11-03 22:27:06.242+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-03 14:23:49.644+00	2025-11-03 22:27:06.242+00
cmhj8deoc005vdj0r5qnb620e	14	both	delivered	À l'étage dans le placard		2025-11-03 22:44:29.822+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-03 14:23:49.644+00	2025-11-03 22:44:29.822+00
cmhnpac9j00ccdj0rhukdjoxb	1	both	delivered			2025-11-06 19:35:05.422+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-06 17:28:24.727+00	2025-11-06 19:35:05.422+00
cmhj8deoc0064dj0rxumkewr1	15	both	delivered			2025-11-03 22:44:32.62+00	\N	cmhixkakh004tdj0rha13vrrl	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-03 14:23:49.644+00	2025-11-03 22:44:32.62+00
cmhnjyb9800bsdj0rjvea6eu6	11	dropoff	delivered			2025-11-06 19:58:20.444+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-06 14:59:05.468+00	2025-11-06 19:58:20.444+00
cmhnjyb9800bwdj0rkv5meeqr	12	both	delivered	Fermé les Mercredi		2025-11-06 20:29:20.15+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-06 14:59:05.468+00	2025-11-06 20:29:20.15+00
cmhnpac9j00cddj0ral44hsys	4	dropoff	delivered			2025-11-06 20:37:55.859+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-06 17:28:24.727+00	2025-11-06 20:37:55.859+00
cmhnjyb9800bydj0rfbs8hjsx	13	both	delivered	Fermé les jeudi		2025-11-06 20:59:13.823+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-06 14:59:05.468+00	2025-11-06 20:59:13.823+00
cmhnjyb9800bxdj0r4uzaikpw	14	both	delivered	Fermé les Vendredi		2025-11-06 21:11:26.808+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-06 14:59:05.468+00	2025-11-06 21:11:26.808+00
cmhnjyb9800bzdj0r668juad5	18	both	delivered	Fermé les Mercredi		2025-11-06 21:49:32.112+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-06 14:59:05.468+00	2025-11-06 21:49:32.112+00
cmhnjyb9800brdj0r9s1lok6v	19	both	delivered			2025-11-06 21:49:34.894+00	\N	cmhn5dgz900amdj0r2kh3uhm4	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-06 14:59:05.468+00	2025-11-06 21:49:34.894+00
cmhnpac9j00cadj0rgvaw09cx	9	pickup	delivered	Boite au lettre du haut		2025-11-06 21:55:59.856+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-06 17:28:24.727+00	2025-11-06 21:55:59.856+00
cmhnpac9j00cbdj0rpvng17hy	11	pickup	delivered			2025-11-06 22:02:13.735+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-06 17:28:24.727+00	2025-11-06 22:02:13.735+00
cmhkpknkw0094dj0rbj6t2z4q	4	pickup	delivered			2025-11-04 18:15:34.551+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-04 15:13:07.424+00	2025-11-04 18:15:34.551+00
cmhkpknkw0093dj0rklkzn4in	10	pickup	delivered			2025-11-04 20:15:19.902+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-04 15:13:07.424+00	2025-11-04 20:15:19.902+00
cmhkpknkw0092dj0rir9lujk3	15	both	delivered			2025-11-04 22:33:27.282+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-04 15:13:07.424+00	2025-11-04 22:33:27.282+00
cmhkpknkw0095dj0ryzyu500e	19	both	delivered			2025-11-04 23:16:49.73+00	\N	cmhkc68fm007ddj0ro1rhs0n2	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-04 15:13:07.424+00	2025-11-04 23:16:49.73+00
cmhm3moep009xdj0rx7klwcnn	15	both	delivered			2025-11-05 21:53:30.713+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-05 14:34:22.609+00	2025-11-05 21:53:30.713+00
cmk2rb1kg005rgr0r5rk3h5zt	3	pickup	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-06 16:55:23.176+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-06 15:40:54.064+00	2026-01-06 16:55:23.176+00
cmhm3moep00a6dj0r1zkodxmx	18	dropoff	delivered	Fermé les Mercredi		2025-11-05 22:14:43.869+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-05 14:34:22.609+00	2025-11-05 22:14:43.869+00
cmhyx4bms00jidj0rcx1fiub7	1	dropoff	delivered			2025-11-14 16:24:37.811+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-11-14 13:53:08.835+00	2025-11-14 16:24:37.811+00
cmhm3moep00a0dj0r0gqq7jpi	19	both	delivered			2025-11-05 22:59:37.697+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-05 14:34:22.609+00	2025-11-05 22:59:37.697+00
cmhyx4bmr00jfdj0ridk6f693	2	pickup	delivered			2025-11-14 16:57:24.879+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-11-14 13:53:08.835+00	2025-11-14 16:57:24.88+00
cmhkq72tu009odj0rh28lijph	3	both	delivered			2025-11-04 18:50:24.579+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-04 15:30:33.617+00	2025-11-04 18:50:24.579+00
cmhkq72tu009qdj0rxuamr4qy	5	dropoff	delivered	La porte de gauche		2025-11-04 20:17:47.479+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-11-04 15:30:33.617+00	2025-11-04 20:17:47.479+00
cmhyx4bms00jhdj0r9ec9prqw	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-14 16:57:28.725+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-14 13:53:08.835+00	2025-11-14 16:57:28.725+00
cmhkq72tu009rdj0rqefeiu3j	10	dropoff	delivered	2306 placard étage		2025-11-04 21:06:29.648+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-04 15:30:33.617+00	2025-11-04 21:06:29.648+00
cmhkq72tu009sdj0rylnsop2r	12	pickup	delivered	Fermé mercredi & jeudi		2025-11-04 21:49:14.253+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-04 15:30:33.617+00	2025-11-04 21:49:14.253+00
cmhyxkxhy00jodj0riin1aooq	0	both	delivered	x 3612 🔔 Devant la porte	Pas de boite	2025-11-14 17:43:03.97+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-14 14:06:03.67+00	2025-11-14 17:43:03.97+00
cmhkq72tt009ndj0ruztdkajh	13	both	delivered			2025-11-04 21:55:21.092+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-04 15:30:33.617+00	2025-11-04 21:55:21.092+00
cmhkq72tu009pdj0r508we696	15	pickup	delivered			2025-11-04 22:01:44.456+00	\N	cmhk9mzd50077dj0r0711rkgg	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-04 15:30:33.617+00	2025-11-04 22:01:44.456+00
cmhnpac9j00cedj0r4a07d8ni	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-06 19:08:21.682+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-06 17:28:24.727+00	2025-11-06 19:08:21.682+00
cmhnpac9j00cgdj0rln9qhs1d	3	both	delivered			2025-11-06 20:09:10.395+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-06 17:28:24.727+00	2025-11-06 20:09:10.395+00
cmhnpac9j00cidj0rznu66y17	10	dropoff	delivered	2306 placard étage		2025-11-06 22:02:11.355+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-06 17:28:24.727+00	2025-11-06 22:02:11.355+00
cmhnpac9j00cjdj0ru1fsjkpm	12	both	delivered	Fermé mercredi & jeudi		2025-11-06 22:42:58.059+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-06 17:28:24.727+00	2025-11-06 22:42:58.059+00
cmhnpac9j00cfdj0r6z7dyt6o	13	dropoff	delivered			2025-11-06 22:48:13.555+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-06 17:28:24.727+00	2025-11-06 22:48:13.555+00
cmhw4jvvn00gjdj0rkf725o1q	0	dropoff	delivered	La porte de gauche		2025-11-12 17:25:07.189+00	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-11-12 14:57:53.698+00	2025-11-12 17:25:07.189+00
cmhnpac9j00chdj0radeoxwzh	15	both	delivered			2025-11-06 22:58:45.475+00	\N	cmhn9qn8i00asdj0rx4yfeyzf	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-06 17:28:24.727+00	2025-11-06 22:58:45.475+00
cmhw4jvvn00ggdj0rtzk1f7ba	1	dropoff	delivered			2025-11-12 18:01:13.998+00	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-12 14:57:53.698+00	2025-11-12 18:01:13.998+00
cmhw4jvvn00ghdj0rfbs39u9g	8	both	planned		\N	\N	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-12 14:57:53.698+00	2025-11-12 16:14:58.772+00
cmhw4jvvn00gkdj0r3xac7jlt	2	dropoff	delivered	2306 placard étage		2025-11-12 18:08:30.164+00	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-12 14:57:53.698+00	2025-11-12 18:08:30.164+00
cmhm3moep00a3dj0royr8bzmq	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-05 16:48:10.412+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-05 14:34:22.609+00	2025-11-05 16:48:10.412+00
cmhm3moep009ydj0r1yl9g9xc	5	dropoff	delivered			2025-11-05 17:43:17.864+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-05 14:34:22.609+00	2025-11-05 17:43:17.864+00
cmhm3moep00a2dj0r6msrfakg	8	both	delivered			2025-11-05 19:40:33.278+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-05 14:34:22.609+00	2025-11-05 19:40:33.278+00
cmhm3moep009zdj0rfd7p821f	10	both	delivered			2025-11-05 19:40:37.232+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-05 14:34:22.609+00	2025-11-05 19:40:37.232+00
cmhm3moep00a1dj0ru2td7sfp	11	dropoff	delivered			2025-11-05 20:00:32.947+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-05 14:34:22.609+00	2025-11-05 20:00:32.947+00
cmhm4jw2n00ahdj0rc9zj4217	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-05 20:23:28.127+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-05 15:00:12.191+00	2025-11-05 20:23:28.127+00
cmhm3moep00a4dj0rh54ibwm5	12	dropoff	delivered	Fermé les Mercredi		2025-11-05 20:37:45.681+00	\N	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-05 14:34:22.609+00	2025-11-05 20:37:45.681+00
cmhm3moep00a5dj0r84xdn4es	13	both	failed	Fermé les jeudi	Pas de colis 	2025-11-05 21:06:09.888+00	https://www.storage.tds-transports.fr/e2ec4d93-82a9-4d37-8053-bc4d689d4fec.avif	cmhlt7a47009tdj0rbj4b37qf	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-05 14:34:22.609+00	2025-11-05 21:06:09.888+00
cmhm4jw2n00afdj0ri303d5oo	1	pickup	failed		Pas de boite !	2025-11-05 21:43:30.396+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-05 15:00:12.191+00	2025-11-05 21:43:30.396+00
cmhm4jw2n00akdj0rijxgg9vn	3	both	delivered			2025-11-05 21:43:33.963+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-05 15:00:12.191+00	2025-11-05 21:43:33.964+00
cmhm4jw2n00aldj0r0s26mp2o	5	dropoff	delivered	La porte de gauche		2025-11-05 21:43:37.469+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-11-05 15:00:12.191+00	2025-11-05 21:43:37.469+00
cmhm4jw2n00agdj0rn84tglw2	6	dropoff	delivered			2025-11-05 21:43:40.061+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-05 15:00:12.191+00	2025-11-05 21:43:40.061+00
cmhm4jw2n00ajdj0ruceqwt73	8	dropoff	delivered			2025-11-05 21:43:42.572+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-05 15:00:12.191+00	2025-11-05 21:43:42.572+00
cmhm4jw2n00addj0rjmpg9tco	9	dropoff	delivered	Boite au lettre du haut		2025-11-05 21:43:44.738+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-05 15:00:12.191+00	2025-11-05 21:43:44.738+00
cmhm4jw2n00aedj0rlndprgah	11	dropoff	delivered			2025-11-05 21:43:47.175+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-05 15:00:12.191+00	2025-11-05 21:43:47.175+00
cmhm4jw2n00aidj0ry2g6zupg	13	both	delivered			2025-11-05 21:43:51.55+00	\N	cmhm3yvvk00a7dj0r2teiumiu	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-05 15:00:12.191+00	2025-11-05 21:43:51.55+00
cmhyx4bmr00jgdj0rb5ni48zi	8	both	delivered			2025-11-14 17:47:43.052+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-14 13:53:08.835+00	2025-11-14 17:47:43.052+00
cmhyx4bmr00jddj0rm5khm5w6	9	dropoff	delivered			2025-11-14 18:04:53.736+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2025-11-14 13:53:08.835+00	2025-11-14 18:04:53.736+00
cmhyx4bmr00jcdj0rd0enzkof	10	both	delivered			2025-11-14 19:38:02.969+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-14 13:53:08.835+00	2025-11-14 19:38:02.969+00
cmhw4jvvn00gidj0rqe5phg16	6	both	delivered			2025-11-12 19:09:36.387+00	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-12 14:57:53.698+00	2025-11-12 19:09:36.387+00
cmhw3vlal00fpdj0r5vg5d3i7	10	both	delivered			2025-11-12 19:45:54.846+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-12 14:39:00.237+00	2025-11-12 19:45:54.846+00
cmhyx4bms00jjdj0rk7hrrael	12	dropoff	delivered	Fermé les Mercredi		2025-11-14 19:38:05.7+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-14 13:53:08.835+00	2025-11-14 19:38:05.7+00
cmhw3vlal00fsdj0rumo6ei0c	11	dropoff	delivered			2025-11-12 20:13:34.222+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-12 14:39:00.237+00	2025-11-12 20:13:34.222+00
cmhw3vlal00fodj0rl8clmtep	15	both	delivered			2025-11-12 22:28:07.418+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-12 14:39:00.237+00	2025-11-12 22:28:07.418+00
cmhw3vlal00fqdj0rgwg88zr4	4	dropoff	delivered			2025-11-12 17:45:12.776+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-12 14:39:00.237+00	2025-11-12 17:45:12.776+00
cmhw3vlal00ftdj0rdlel08qs	7	dropoff	delivered			2025-11-12 18:14:12.462+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-12 14:39:00.237+00	2025-11-12 18:14:12.462+00
cmhw4jvvm00gcdj0rg43xxn4f	3	both	delivered			2025-11-12 18:41:01.269+00	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-12 14:57:53.698+00	2025-11-12 18:41:01.269+00
cmhw3vlal00frdj0rr7kuzm8z	19	both	delivered			2025-11-12 23:27:03.103+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-12 14:39:00.237+00	2025-11-12 23:27:03.103+00
cmi3b5y0g00lbdj0r09ljftu5	10	both	delivered			2025-11-17 19:24:31.045+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-17 15:37:23.824+00	2025-11-17 19:24:31.045+00
cmhoz5kyi00dhdj0rxlw5j8yx	7	both	delivered			2025-11-07 20:00:42.836+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-07 14:52:25.049+00	2025-11-07 20:00:42.836+00
cmi3b5y0g00ljdj0ropdmeiro	13	both	delivered	Fermé les jeudi		2025-11-17 20:42:17.733+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-17 15:37:23.824+00	2025-11-17 20:42:17.733+00
cmhozoamk00dsdj0r1z9iv5e7	13	both	delivered	Fermé les jeudi		2025-11-07 20:22:53.814+00	\N	cmhon0nfo00cndj0rskph88a8	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-07 15:06:58.124+00	2025-11-07 20:22:53.814+00
cmi3b5y0g00lidj0r7mhr4wo7	14	both	delivered	Fermé les Vendredi		2025-11-17 20:55:02.152+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-17 15:37:23.824+00	2025-11-17 20:55:02.152+00
cmhw3vlal00fudj0rck5qvit0	8	both	delivered			2025-11-12 18:45:07.632+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-12 14:39:00.237+00	2025-11-12 18:45:07.632+00
cmhozoamk00drdj0r8j6ks5fn	14	both	delivered	Fermé les Vendredi		2025-11-07 20:22:56.546+00	\N	cmhon0nfo00cndj0rskph88a8	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-07 15:06:58.124+00	2025-11-07 20:22:56.546+00
cmhw4jvvn00gfdj0ru713smio	4	both	delivered			2025-11-12 19:09:25.204+00	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-12 14:57:53.698+00	2025-11-12 19:09:25.204+00
cmi3b5y0g00lkdj0rjpy2rtc4	18	dropoff	delivered	Fermé les Mercredi		2025-11-17 21:13:38.027+00	\N	cmi2wx3s700k5dj0rhh8pmp29	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-17 15:37:23.824+00	2025-11-17 21:13:38.027+00
cmhw4jvvm00gbdj0rvz4u0yrx	5	both	delivered	À l'étage dans le placard		2025-11-12 19:09:33.015+00	\N	cmhw1mgyk00fadj0re3vvbzef	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-12 14:57:53.698+00	2025-11-12 19:09:33.015+00
cmhozoamk00dldj0rn55vok4p	15	both	delivered			2025-11-07 20:57:57.037+00	\N	cmhon0nfo00cndj0rskph88a8	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-07 15:06:58.124+00	2025-11-07 20:57:57.037+00
cmi3f57gd00lxdj0r6zda5rpr	12	both	delivered	Fermé mercredi & jeudi		2025-11-17 22:34:52.629+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-17 17:28:47.869+00	2025-11-17 22:34:52.629+00
cmhozoamk00dtdj0rqnqdjant	18	both	delivered	Fermé les Mercredi		2025-11-07 21:19:33.036+00	\N	cmhon0nfo00cndj0rskph88a8	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-07 15:06:58.124+00	2025-11-07 21:19:33.036+00
cmhozoamk00dqdj0re6kv1f22	3	pickup	failed	753B Fermé Lundi aprèm et Vendredi	Pas de colis 	2025-11-07 16:49:12.359+00	https://www.storage.tds-transports.fr/121d94a7-0046-428f-ad74-aeb927a868f7.avif	cmhon0nfo00cndj0rskph88a8	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-07 15:06:58.124+00	2025-11-07 16:49:12.36+00
cmhozoamk00dodj0rhjm1spl2	7	dropoff	delivered			2025-11-07 17:22:09.932+00	\N	cmhon0nfo00cndj0rskph88a8	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-07 15:06:58.124+00	2025-11-07 17:22:09.932+00
cmhozoamk00dpdj0rjlr4wdox	8	both	delivered			2025-11-07 17:56:01.529+00	\N	cmhon0nfo00cndj0rskph88a8	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-07 15:06:58.124+00	2025-11-07 17:56:01.529+00
cmhozoamk00dmdj0rl08oz9w3	10	both	delivered			2025-11-07 18:59:28.966+00	\N	cmhon0nfo00cndj0rskph88a8	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-07 15:06:58.124+00	2025-11-07 18:59:28.966+00
cmhoz5kyi00djdj0rr3ihlx9n	3	both	delivered	Fermé mercredi & jeudi		2025-11-07 19:21:11.332+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-07 14:52:25.049+00	2025-11-07 19:21:11.332+00
cmhoz5kyi00didj0rqzvrf67f	5	both	delivered			2025-11-07 19:48:44.924+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-07 14:52:25.049+00	2025-11-07 19:48:44.924+00
cmi4p9wnr00m3dj0rzjfz4u7x	0	dropoff	delivered			2025-11-18 16:51:01.425+00	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-11-18 15:00:09.495+00	2025-11-18 16:51:01.425+00
cmhoz5kyi00dgdj0rj4qd6z52	6	pickup	delivered	x 3612 🔔 Devant la porte		2025-11-07 20:00:40.234+00	\N	cmhohy0fg00ckdj0rh8l8f1oi	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-07 14:52:25.049+00	2025-11-07 20:00:40.234+00
cmhozoamk00dndj0rz0l68qp5	19	both	delivered			2025-11-07 21:40:39.495+00	\N	cmhon0nfo00cndj0rskph88a8	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-07 15:06:58.124+00	2025-11-07 21:40:39.495+00
cmi4p9wnr00m4dj0rdqkkvd7v	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-18 17:21:08.544+00	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-18 15:00:09.495+00	2025-11-18 17:21:08.544+00
cmi4p9wns00m5dj0r5sgt90ed	4	dropoff	delivered			2025-11-18 17:32:41.584+00	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-18 15:00:09.495+00	2025-11-18 17:32:41.584+00
cmi4p9wns00m6dj0ral9angho	8	pickup	delivered			2025-11-18 18:31:20.993+00	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-18 15:00:09.495+00	2025-11-18 18:31:20.993+00
cmi4p9wns00m7dj0rknpci072	10	both	delivered			2025-11-18 19:28:37.517+00	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-18 15:00:09.495+00	2025-11-18 19:28:37.517+00
cmi4p9wns00m9dj0rvm2ci8lw	14	both	delivered	Fermé les Vendredi		2025-11-18 20:49:22.899+00	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-18 15:00:09.495+00	2025-11-18 20:49:22.899+00
cmht9px8900f0dj0rsghefd5s	4	dropoff	delivered			2025-11-10 17:12:32.088+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-10 14:59:14.937+00	2025-11-10 17:12:32.088+00
cmk2rb1kg005lgr0rswikam99	5	pickup	delivered			2026-01-06 17:17:12.084+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-06 15:40:54.064+00	2026-01-06 17:17:12.084+00
cmht8wpjo00etdj0rzw3qzthv	3	both	delivered			2025-11-10 17:13:29.826+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-10 14:36:31.956+00	2025-11-10 17:13:29.826+00
cmhyx4bms00jkdj0rf6br4rkp	14	both	delivered	Fermé les Vendredi		2025-11-14 19:56:56.384+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-14 13:53:08.835+00	2025-11-14 19:56:56.384+00
cmht8wpjo00eqdj0rwy3dez3a	4	both	delivered			2025-11-10 17:43:07.356+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-10 14:36:31.956+00	2025-11-10 17:43:07.356+00
cmj7cgw5301d1gr0r1kgk1jyx	3	both	delivered			2025-12-15 18:14:03.484+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-15 16:04:41.27+00	2025-12-15 18:14:03.484+00
cmi67n1oe00osdj0rn6ubpx91	5	dropoff	delivered			2025-11-19 18:24:40.89+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-19 16:22:01.79+00	2025-11-19 18:24:40.89+00
cmj7cgw5301d3gr0rj3jc5rkc	10	dropoff	delivered	2306 placard étage		2025-12-15 20:43:23.751+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-15 16:04:41.27+00	2025-12-15 20:43:23.751+00
cmht9px8900f5dj0r3t4anq6x	8	both	delivered			2025-11-10 18:01:36.845+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-10 14:59:14.937+00	2025-11-10 18:01:36.845+00
cmj7cgw5301d0gr0r0wtrodyp	13	pickup	delivered			2025-12-15 21:11:15.195+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-15 16:04:41.27+00	2025-12-15 21:11:15.195+00
cmj7cgw5301d2gr0rrjt7jpeg	15	both	delivered			2025-12-15 21:55:45.512+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-15 16:04:41.27+00	2025-12-15 21:55:45.512+00
cmht8wpjo00endj0r6syunt6y	7	pickup	delivered	3ème étage CODE: 2606		2025-11-10 18:45:16.425+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-11-10 14:36:31.956+00	2025-11-10 18:45:16.425+00
cmj32905d01a3gr0rn7br4r7t	16	both	delivered			2025-12-12 23:44:57.6+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-12 16:07:32.353+00	2025-12-12 23:44:57.6+00
cmht8wpjo00emdj0rs6cggt6a	9	dropoff	delivered	Boite au lettre du haut		2025-11-10 18:59:06.653+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-10 14:36:31.956+00	2025-11-10 18:59:06.653+00
cmht8wpjo00erdj0rimd7rdtp	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-10 16:44:39.749+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-10 14:36:31.956+00	2025-11-10 16:44:39.749+00
cmiesjqz600avgr0rqxl6z8c8	4	pickup	delivered			2025-11-25 18:08:06.453+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-25 16:29:29.298+00	2025-11-25 18:08:06.453+00
cmht8wpjo00epdj0rpsa3k68d	1	both	delivered			2025-11-10 16:44:55.329+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-10 14:36:31.956+00	2025-11-10 16:44:55.329+00
cmht9px8900f4dj0rdavsbpsq	2	dropoff	delivered			2025-11-10 16:50:18.776+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-11-10 14:59:14.937+00	2025-11-10 16:50:18.776+00
cmht9px8900ezdj0rx1570uem	10	both	delivered			2025-11-10 19:00:40.376+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-10 14:59:14.937+00	2025-11-10 19:00:40.376+00
cmht9px8900f6dj0rwnwlgqp1	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-10 17:02:04.755+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-10 14:59:14.937+00	2025-11-10 17:02:04.755+00
cmiesjqz600atgr0rgol7z5ug	5	dropoff	delivered		Inversion entre livraison et collecte	2025-11-25 18:27:42.376+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-25 16:29:29.298+00	2025-11-25 18:27:42.376+00
cmht8wpjo00evdj0r5anea76p	10	dropoff	delivered	2306 placard étage		2025-11-10 19:09:05.764+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-10 14:36:31.956+00	2025-11-10 19:09:05.764+00
cmiesjqz600azgr0rnlcfxjff	7	dropoff	delivered			2025-11-25 18:49:49.785+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-25 16:29:29.298+00	2025-11-25 18:49:49.785+00
cmht9px8900f3dj0riby4yzop	11	dropoff	delivered			2025-11-10 19:20:54.001+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-10 14:59:14.937+00	2025-11-10 19:20:54.001+00
cmht8wpjo00eodj0r7m1ub2x1	11	both	delivered		Pas de boite a récupérer 	2025-11-10 19:37:49.699+00	https://www.storage.tds-transports.fr/dddd76f3-a902-49d7-aa93-16ae8def62d7.avif	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-10 14:36:31.956+00	2025-11-10 19:37:49.699+00
cmiesjqz600augr0rjt1zvx9x	10	both	delivered			2025-11-25 20:24:50.423+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-25 16:29:29.298+00	2025-11-25 20:24:50.423+00
cmht8wpjo00ewdj0r7h22uj7g	12	pickup	delivered	Fermé mercredi & jeudi		2025-11-10 20:07:30.908+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-10 14:36:31.956+00	2025-11-10 20:07:30.909+00
cmht8wpjo00esdj0rirrim16f	13	pickup	delivered			2025-11-10 20:07:38.172+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-10 14:36:31.956+00	2025-11-10 20:07:38.172+00
cmiesjqz600aygr0r19c849vc	11	dropoff	delivered			2025-11-25 20:36:52.729+00	\N	cmieelrjt008ngr0rrhenvaod	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-11-25 16:29:29.298+00	2025-11-25 20:36:52.729+00
cmht9px8900f8dj0rwkx05un5	13	pickup	delivered	Fermé les jeudi		2025-11-10 20:14:34.657+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-10 14:59:14.937+00	2025-11-10 20:14:34.657+00
cmht9px8900f7dj0rwznur7bv	14	both	delivered	Fermé les Vendredi		2025-11-10 20:26:00.59+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-10 14:59:14.937+00	2025-11-10 20:26:00.59+00
cmiesjqz600axgr0rju0ztf0d	12	dropoff	delivered			2025-11-25 20:59:19.127+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-25 16:29:29.298+00	2025-11-25 20:59:19.127+00
cmht8wpjo00eudj0rtdy7hszk	15	both	delivered			2025-11-10 20:29:29.011+00	\N	cmhsvlz7700dudj0r699s2gg6	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-10 14:36:31.956+00	2025-11-10 20:29:29.012+00
cmht9px8900eydj0rke60t1gs	15	both	delivered			2025-11-10 20:59:16.342+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-10 14:59:14.937+00	2025-11-10 20:59:16.342+00
cmht9px8900f9dj0rl9xsx0ue	18	dropoff	delivered	Fermé les Mercredi		2025-11-10 21:21:09.131+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-10 14:59:14.937+00	2025-11-10 21:21:09.132+00
cmiesjqz600asgr0r6zf6rnvr	16	pickup	delivered			2025-11-25 22:28:56.859+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-25 16:29:29.298+00	2025-11-25 22:28:56.859+00
cmht9px8900f2dj0rj2hze4nd	19	both	delivered			2025-11-10 21:41:26.149+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-10 14:59:14.937+00	2025-11-10 21:41:26.149+00
cmht9px8900f1dj0rbs560bsm	20	dropoff	delivered			2025-11-10 21:53:58.541+00	\N	cmhsy900u00dzdj0r5z611ms8	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-11-10 14:59:14.937+00	2025-11-10 21:53:58.541+00
cmiesjqz600awgr0rudo97ebe	20	both	delivered			2025-11-25 22:29:07.617+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-25 16:29:29.298+00	2025-11-25 22:29:07.617+00
cmhw3vlal00fvdj0rpicl58nx	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-12 17:33:45.2+00	\N	cmhw2fxg200fddj0r23nos47a	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-12 14:39:00.237+00	2025-11-12 17:33:45.2+00
cmhxkvvuf00ikdj0rmif1q12w	8	both	delivered			2025-11-13 18:43:57.786+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-13 15:22:53.559+00	2025-11-13 18:43:57.786+00
cmk2rb1kg005qgr0r3tg2iibm	8	both	delivered			2026-01-06 18:14:50.492+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-06 15:40:54.064+00	2026-01-06 18:14:50.492+00
cmhxrpwyi00iudj0ry0qao2r5	0	both	delivered			2025-11-13 19:39:05.798+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-13 18:34:12.378+00	2025-11-13 19:39:05.798+00
cmi67n1oe00otdj0rjwgnn6p6	10	both	delivered			2025-11-19 20:12:34.457+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-19 16:22:01.79+00	2025-11-19 20:12:34.457+00
cmi67n1oe00ordj0r81ovu0rj	15	both	delivered			2025-11-19 23:17:34.801+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-19 16:22:01.79+00	2025-11-19 23:17:34.801+00
cmhxrpwyi00izdj0r0w6x5cx2	1	both	delivered			2025-11-13 19:39:07.691+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-13 18:34:12.378+00	2025-11-13 19:39:07.691+00
cmhxrpwyi00ivdj0rjyfq9yz3	2	both	delivered			2025-11-13 19:39:09.808+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-13 18:34:12.378+00	2025-11-13 19:39:09.808+00
cmhxkvvuf00ildj0rsbsqu7jx	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-13 17:27:36.505+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-13 15:22:53.559+00	2025-11-13 17:27:36.506+00
cmhxkvvuf00igdj0rihr68lsv	5	both	delivered			2025-11-13 18:28:43.973+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-13 15:22:53.559+00	2025-11-13 18:28:43.973+00
cmhxrpwyi00iwdj0rn37csem6	3	both	delivered	x 3612 🔔 Devant la porte		2025-11-13 19:39:20.415+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-13 18:34:12.378+00	2025-11-13 19:39:20.415+00
cmhxkvvuf00ihdj0r8i9we4fy	10	both	delivered			2025-11-13 19:41:30.011+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-13 15:22:53.559+00	2025-11-13 19:41:30.011+00
cmhxrpwyi00j0dj0rnibujxd6	4	both	delivered			2025-11-13 19:50:25.639+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-13 18:34:12.378+00	2025-11-13 19:50:25.639+00
cmhxrpwyi00ixdj0rklqvhzr3	5	pickup	delivered			2025-11-13 19:57:30.317+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-13 18:34:12.378+00	2025-11-13 19:57:30.317+00
cmhxkvvuf00ijdj0rcsm96jqz	11	pickup	delivered			2025-11-13 20:05:05.914+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-13 15:22:53.559+00	2025-11-13 20:05:05.914+00
cmhxrpwyi00j2dj0rfddvpqj1	6	both	delivered	Fermé mercredi & jeudi		2025-11-13 20:05:51.917+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-13 18:34:12.378+00	2025-11-13 20:05:51.917+00
cmhxkvvuf00imdj0rfwvktk0p	12	both	delivered	Fermé les Mercredi		2025-11-13 20:32:14.381+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-13 15:22:53.559+00	2025-11-13 20:32:14.381+00
cmhxrpwyi00itdj0rxpx44d7l	7	both	delivered			2025-11-13 20:36:37.779+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-13 18:34:12.378+00	2025-11-13 20:36:37.779+00
cmhxrpwyi00j1dj0rvjziwr9a	8	pickup	delivered	2306 placard étage		2025-11-13 20:49:29.972+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-13 18:34:12.378+00	2025-11-13 20:49:29.972+00
cmhxrpwyi00irdj0ratno9o42	9	both	delivered	Boite au lettre du haut		2025-11-13 20:49:35.272+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-13 18:34:12.378+00	2025-11-13 20:49:35.272+00
cmhxrpwyi00iydj0rzgt8aao9	10	pickup	delivered			2025-11-13 20:49:45.604+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-13 18:34:12.378+00	2025-11-13 20:49:45.604+00
cmhxkvvuf00iodj0rjuxadcse	13	both	delivered	Fermé les jeudi		2025-11-13 21:02:26.538+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-13 15:22:53.559+00	2025-11-13 21:02:26.538+00
cmhxkvvuf00indj0raap66y3j	14	both	delivered	Fermé les Vendredi		2025-11-13 21:16:02.563+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-13 15:22:53.559+00	2025-11-13 21:16:02.563+00
cmhxkvvuf00ifdj0rfbzchph0	15	both	delivered			2025-11-13 21:52:27.541+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-13 15:22:53.559+00	2025-11-13 21:52:27.541+00
cmhxkvvuf00ipdj0ru79ir2du	18	dropoff	delivered	Fermé les Mercredi		2025-11-13 22:14:30.461+00	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-13 15:22:53.559+00	2025-11-13 22:14:30.461+00
cmhxkvvuf00iidj0r84z13h9w	19	both	en_route		\N	\N	\N	cmhx5yg9l00gldj0r114wp2uh	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-13 15:22:53.559+00	2025-11-13 22:14:30.531+00
cmhxrpwyi00isdj0rzy1m866s	11	dropoff	delivered	3ème étage CODE: 2606		2025-11-14 16:02:51.904+00	\N	cmhx8gt2o00grdj0rs94a2zya	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-11-13 18:34:12.378+00	2025-11-14 16:02:51.904+00
cmhyx4bmr00jbdj0rb5zca0r0	15	both	delivered			2025-11-14 20:31:23.608+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-14 13:53:08.835+00	2025-11-14 20:31:23.608+00
cmhyxkxhy00jvdj0rb250p93w	12	both	delivered	Fermé mercredi & jeudi		2025-11-14 21:04:41.529+00	\N	cmhyxkxhy00jmdj0rx181cbq9	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-14 14:06:03.67+00	2025-11-14 21:04:41.529+00
cmhyx4bmr00jedj0rgce9vdxi	19	dropoff	delivered			2025-11-14 21:11:32.36+00	\N	cmhypl9hd00j3dj0riyi7ufc3	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-14 13:53:08.835+00	2025-11-14 21:11:32.36+00
cmi3f57gd00lrdj0r264fcezn	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-17 17:31:26.405+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-17 17:28:47.869+00	2025-11-17 17:31:26.405+00
cmi3f57gd00lodj0rdx483ti7	1	both	delivered			2025-11-17 17:54:10.702+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-17 17:28:47.869+00	2025-11-17 17:54:10.702+00
cmi3f57gd00lsdj0rglf0zn40	2	pickup	delivered			2025-11-17 18:28:51.607+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-11-17 17:28:47.869+00	2025-11-17 18:28:51.608+00
cmi3f57gd00ludj0rgo2hgdlu	3	both	delivered			2025-11-17 18:48:00.394+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-17 17:28:47.869+00	2025-11-17 18:48:00.394+00
cmi3f57gd00lpdj0ru85hcedv	4	pickup	delivered			2025-11-17 19:15:33.196+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-17 17:28:47.869+00	2025-11-17 19:15:33.196+00
cmi3f57gd00lqdj0rzrjuepdu	6	pickup	delivered			2025-11-17 20:41:02.716+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-17 17:28:47.869+00	2025-11-17 20:41:02.716+00
cmi3f57gd00lmdj0r2wzcz51w	9	pickup	delivered	Boite au lettre du haut		2025-11-17 22:05:01.129+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-17 17:28:47.869+00	2025-11-17 22:05:01.129+00
cmi3f57gd00lwdj0rpcua7voj	10	dropoff	delivered	2306 placard étage		2025-11-17 22:05:04.459+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-17 17:28:47.869+00	2025-11-17 22:05:04.459+00
cmi3f57gd00lndj0rm8vph2hy	11	pickup	delivered			2025-11-17 22:10:55.453+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-17 17:28:47.869+00	2025-11-17 22:10:55.453+00
cmi3f57gd00ltdj0rpk96ldia	13	both	delivered			2025-11-17 22:34:54.324+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-17 17:28:47.869+00	2025-11-17 22:34:54.324+00
cmi3f57gd00lvdj0rq13dzq4z	15	both	delivered			2025-11-17 22:57:38.217+00	\N	cmi2triel00jzdj0rtervhwnv	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-17 17:28:47.869+00	2025-11-17 22:57:38.217+00
cmj7cgw5301czgr0r0gv6t3dd	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-15 17:34:29.694+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-15 16:04:41.27+00	2025-12-15 17:34:29.694+00
cmihlnxh400e3gr0rfp982eis	11	pickup	delivered			2025-11-27 19:38:00.08+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-11-27 15:40:05.56+00	2025-11-27 19:38:00.08+00
cmihlnxh400e2gr0ryvgj1zpn	12	dropoff	delivered		Plus collecte	2025-11-27 20:05:37.35+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-27 15:40:05.56+00	2025-11-27 20:05:37.35+00
cmihlnxh400e1gr0rryod94sh	20	dropoff	delivered			2025-11-27 22:37:17.86+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-27 15:40:05.56+00	2025-11-27 22:37:17.86+00
cmi67njw700pcdj0rselx4yjc	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-19 17:26:41.48+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-19 16:22:25.399+00	2025-11-19 17:26:41.48+00
cmi4s5qlb00mvdj0rf1aakft3	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-18 18:33:37.619+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-18 16:20:53.855+00	2025-11-18 18:33:37.619+00
cmi4s5qlb00msdj0r4j47ubq4	1	both	delivered			2025-11-18 18:38:13.718+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-18 16:20:53.855+00	2025-11-18 18:38:13.718+00
cmi67njw700padj0rfl21pon7	1	both	delivered			2025-11-19 17:27:22.486+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-19 16:22:25.399+00	2025-11-19 17:27:22.486+00
cmi4s5qlb00mxdj0r6nvind7p	3	both	delivered			2025-11-18 19:13:26.588+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-18 16:20:53.855+00	2025-11-18 19:13:26.588+00
cmi67njw700pddj0rc0k9wdq1	2	dropoff	delivered			2025-11-19 17:34:26.644+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-11-19 16:22:25.399+00	2025-11-19 17:34:26.644+00
cmi4s5qlb00mtdj0r80eh4f0n	4	dropoff	delivered			2025-11-18 19:42:46.503+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-18 16:20:53.855+00	2025-11-18 19:42:46.503+00
cmi4p9wns00m8dj0r35rca8ix	13	both	delivered	Fermé les jeudi		2025-11-18 20:49:20.627+00	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-18 15:00:09.495+00	2025-11-18 20:49:20.627+00
cmi67n1oe00p1dj0raed0qpmz	1	pickup	delivered			2025-11-19 17:36:26.94+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-11-19 16:22:01.79+00	2025-11-19 17:36:26.94+00
cmi4s5qlb00mudj0rs82a6dqd	6	dropoff	delivered			2025-11-18 20:54:56.424+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-18 16:20:53.855+00	2025-11-18 20:54:56.424+00
cmi4p9wns00madj0r3h478dc9	15	both	delivered			2025-11-18 21:25:08.53+00	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-18 15:00:09.495+00	2025-11-18 21:25:08.53+00
cmi4p9wns00mbdj0rwzupvnpa	19	both	en_route		\N	\N	\N	cmi4p9wnr00m1dj0r38w3xx51	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-18 15:00:09.495+00	2025-11-18 21:25:08.618+00
cmi4s5qlb00mpdj0rx4t56jie	9	both	delivered	Boite au lettre du haut		2025-11-18 21:54:48.752+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-18 16:20:53.855+00	2025-11-18 21:54:48.752+00
cmi67n1oe00oxdj0r52gnqpiv	2	dropoff	delivered			2025-11-19 17:46:12.79+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-11-19 16:22:01.79+00	2025-11-19 17:46:12.79+00
cmi4s5qlb00mrdj0rc8zmdwa3	11	both	delivered			2025-11-18 22:25:20.431+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-18 16:20:53.855+00	2025-11-18 22:25:20.432+00
cmi4s5qlb00mzdj0r4748714m	12	both	delivered	Fermé mercredi & jeudi		2025-11-18 22:41:35.231+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-18 16:20:53.855+00	2025-11-18 22:41:35.231+00
cmi67n1oe00p0dj0rk4hhttyq	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-19 18:00:06.578+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-19 16:22:01.79+00	2025-11-19 18:00:06.578+00
cmi4s5qlb00mwdj0r43snpu41	13	both	delivered			2025-11-18 22:41:52.415+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-18 16:20:53.855+00	2025-11-18 22:41:52.415+00
cmi4s5qlb00mqdj0r1lww7jnf	14	pickup	delivered	À l'étage dans le placard		2025-11-18 22:48:27.937+00	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-18 16:20:53.855+00	2025-11-18 22:48:27.937+00
cmi4s5qlb00mydj0rxamtxnfy	15	both	en_route		\N	\N	\N	cmi4bslg000lydj0rgmxye3fk	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-18 16:20:53.855+00	2025-11-18 22:48:28.039+00
cmi67n1oe00oudj0req562sdy	4	dropoff	delivered			2025-11-19 18:10:07.616+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-19 16:22:01.79+00	2025-11-19 18:10:07.616+00
cmi67njw700pgdj0r25jt2jq7	3	both	delivered			2025-11-19 18:23:02.549+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-19 16:22:25.399+00	2025-11-19 18:23:02.549+00
cmi67n1oe00oydj0ro6ycali0	7	dropoff	delivered			2025-11-19 18:44:34.119+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-19 16:22:01.79+00	2025-11-19 18:44:34.119+00
cmi67n1oe00ozdj0rba1plwt6	8	both	delivered			2025-11-19 19:22:06.145+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-19 16:22:01.79+00	2025-11-19 19:22:06.145+00
cmi67n1oe00owdj0r7htp8x0r	11	both	delivered			2025-11-19 20:32:10.251+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-19 16:22:01.79+00	2025-11-19 20:32:10.251+00
cmi67njw700pbdj0riwds08ar	6	dropoff	delivered			2025-11-19 20:37:11.807+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-19 16:22:25.399+00	2025-11-19 20:37:11.807+00
cmi67n1oe00p2dj0r8g6sq9e7	12	dropoff	delivered	Fermé les Mercredi		2025-11-19 21:00:26.704+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-19 16:22:01.79+00	2025-11-19 21:00:26.704+00
cmi67njw600p8dj0r26s2con6	7	dropoff	delivered	3ème étage CODE: 2606		2025-11-19 21:41:13.911+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-11-19 16:22:25.399+00	2025-11-19 21:41:13.911+00
cmi67njw700pfdj0rsn4n81m1	8	dropoff	delivered			2025-11-19 21:59:43.178+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-19 16:22:25.399+00	2025-11-19 21:59:43.178+00
cmi67njw600p7dj0rx53317p0	9	dropoff	delivered	Boite au lettre du haut		2025-11-19 21:59:45.306+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-19 16:22:25.399+00	2025-11-19 21:59:45.306+00
cmi67n1oe00p4dj0rvvbkgqch	13	pickup	delivered	Fermé les jeudi		2025-11-19 22:00:54.2+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-19 16:22:01.79+00	2025-11-19 22:00:54.2+00
cmi67n1oe00p3dj0r1ykge4e1	14	both	delivered	Fermé les Vendredi		2025-11-19 22:01:03.407+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-19 16:22:01.79+00	2025-11-19 22:01:03.407+00
cmi67njw600p9dj0rkynixali	11	dropoff	delivered			2025-11-19 22:37:25.947+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-19 16:22:25.399+00	2025-11-19 22:37:25.947+00
cmi67njw700pedj0rde7s1ffd	13	both	delivered			2025-11-19 22:50:03.573+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-19 16:22:25.399+00	2025-11-19 22:50:03.573+00
cmi67n1oe00p5dj0rnrlxkxza	18	dropoff	delivered	Fermé les Mercredi		2025-11-19 23:17:38.17+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-19 16:22:01.79+00	2025-11-19 23:17:38.17+00
cmi67n1oe00ovdj0rq69m58oz	19	both	delivered			2025-11-19 23:17:40.328+00	\N	cmi5sbzi200n0dj0rhja3cwgy	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-19 16:22:01.79+00	2025-11-19 23:17:40.328+00
cmj7cgw5301cygr0rsicdfnju	1	both	delivered			2025-12-15 17:34:38.227+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-15 16:04:41.27+00	2025-12-15 17:34:38.227+00
cmihlnxh400e5gr0rs9ukecl0	3	pickup	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-27 17:48:06.472+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-27 15:40:05.56+00	2025-11-27 17:48:06.472+00
cmihlnxh400e4gr0rqyjp7qh0	8	both	delivered			2025-11-27 18:31:53.224+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-27 15:40:05.56+00	2025-11-27 18:31:53.224+00
cmihlnxh400e7gr0r7fmxeox9	14	both	delivered	Fermé les jeudi		2025-11-27 21:06:39.152+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-27 15:40:05.56+00	2025-11-27 21:06:39.152+00
cmi67njw700pidj0rq0xp48xv	5	dropoff	delivered	La porte de gauche		2025-11-19 19:34:01.945+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-11-19 16:22:25.399+00	2025-11-19 19:34:01.945+00
cmi67njw700pjdj0rxwcfnmza	10	dropoff	delivered	2306 placard étage		2025-11-19 21:59:47.005+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-19 16:22:25.399+00	2025-11-19 21:59:47.005+00
cmihlnxh400e6gr0rtnwwk99t	15	pickup	delivered	Fermé les Vendredi		2025-11-27 21:23:43.081+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-27 15:40:05.56+00	2025-11-27 21:23:43.081+00
cmi67njw700phdj0r5xelh8fk	15	both	delivered			2025-11-19 23:17:16.7+00	\N	cmi65m3pt00nxdj0rs4eu2o3a	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-19 16:22:25.399+00	2025-11-19 23:17:16.7+00
cmihlnxh400e8gr0rflsx2okl	19	both	delivered	Fermé les Mercredi		2025-11-27 22:36:55.573+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-27 15:40:05.56+00	2025-11-27 22:36:55.573+00
cmit0haol00ubgr0rtqgxylfv	7	both	delivered			2025-12-05 19:02:42.843+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-05 15:20:18.261+00	2025-12-05 19:02:42.843+00
cmit0haol00ucgr0r46emujtb	8	both	delivered			2025-12-05 20:45:03.452+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-05 15:20:18.261+00	2025-12-05 20:45:03.452+00
cmit0haol00ufgr0rh702i5nl	15	both	delivered	Fermé les Vendredi		2025-12-05 22:13:32.518+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-05 15:20:18.261+00	2025-12-05 22:13:32.518+00
cmi7m0s4k00qudj0rwg7i8suf	0	pickup	delivered	x 3612 🔔 Devant la porte		2025-11-20 16:59:40.055+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-20 15:52:23.395+00	2025-11-20 16:59:40.055+00
cmi7m0s4k00qsdj0r3f6pfn0c	1	both	delivered			2025-11-20 17:00:06.6+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-20 15:52:23.395+00	2025-11-20 17:00:06.6+00
cmi7m0s4k00qvdj0rsf183a22	2	pickup	delivered			2025-11-20 17:21:55.678+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-11-20 15:52:23.395+00	2025-11-20 17:21:55.678+00
cmi7mfyt500r7dj0r8trluhlp	3	pickup	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-20 17:39:14.412+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-20 16:04:11.896+00	2025-11-20 17:39:14.412+00
cmi7m0s4k00qwdj0roclaiqvg	3	both	delivered			2025-11-20 17:43:56.306+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-20 15:52:23.395+00	2025-11-20 17:43:56.307+00
cmi7mfyt500r2dj0rimbl7n4s	4	pickup	delivered			2025-11-20 17:53:04.255+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-20 16:04:11.896+00	2025-11-20 17:53:04.255+00
cmi7mfyt500r0dj0ry1hrdwq3	5	pickup	delivered			2025-11-20 18:19:46.283+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-20 16:04:11.896+00	2025-11-20 18:19:46.283+00
cmi7mfyt500r5dj0r4m9bju5d	7	both	delivered			2025-11-20 18:38:35.83+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-20 16:04:11.896+00	2025-11-20 18:38:35.83+00
cmi7mfyt500r6dj0rd340mchc	8	both	delivered			2025-11-20 18:58:53.036+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-20 16:04:11.896+00	2025-11-20 18:58:53.037+00
cmi7mfyt500r1dj0rv80sb9a7	10	both	delivered			2025-11-20 19:58:19.699+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-20 16:04:11.896+00	2025-11-20 19:58:19.699+00
cmi7mfyt500r4dj0rljkutsig	11	both	delivered			2025-11-20 20:17:52.622+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-20 16:04:11.896+00	2025-11-20 20:17:52.622+00
cmi7m0s4k00qtdj0rmau0kyg7	6	dropoff	delivered			2025-11-20 20:40:53.926+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-20 15:52:23.395+00	2025-11-20 20:40:53.926+00
cmi7m0s4k00qpdj0razoy41ib	7	dropoff	delivered	3ème étage CODE: 2606		2025-11-20 20:55:26.261+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-11-20 15:52:23.395+00	2025-11-20 20:55:26.261+00
cmi7mfyt500r9dj0r0fcnhvrt	13	both	delivered	Fermé les jeudi		2025-11-20 21:08:56.606+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-20 16:04:11.896+00	2025-11-20 21:08:56.606+00
cmi7m0s4k00qrdj0rynr65yba	11	dropoff	delivered			2025-11-20 21:16:33.139+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-20 15:52:23.395+00	2025-11-20 21:16:33.139+00
cmi7mfyt500r8dj0rqcmerb6r	14	pickup	delivered	Fermé les Vendredi		2025-11-20 21:22:29.64+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-20 16:04:11.896+00	2025-11-20 21:22:29.64+00
cmi7m0s4k00qydj0rswgt15pc	12	both	delivered	Fermé mercredi & jeudi		2025-11-20 21:33:52.642+00	https://www.storage.tds-transports.fr/f57006f4-c888-4f7b-bad6-78b0d0358753.avif	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-20 15:52:23.395+00	2025-11-20 21:33:52.642+00
cmi7m0s4k00qqdj0reorq8ka5	14	both	delivered	À l'étage dans le placard		2025-11-20 21:48:04.626+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-20 15:52:23.395+00	2025-11-20 21:48:04.626+00
cmi7m0s4k00qxdj0rvb4o4m5o	15	both	delivered			2025-11-20 22:04:25.925+00	\N	cmi7imjq500pzdj0roya4jk8o	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-20 15:52:23.395+00	2025-11-20 22:04:25.925+00
cmi7mfyt500radj0r1mi6dk7y	18	both	delivered	Fermé les Mercredi		2025-11-20 22:05:21.308+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-20 16:04:11.896+00	2025-11-20 22:05:21.308+00
cmi7mfyt500r3dj0rh0wkaqbo	19	both	delivered			2025-11-20 22:57:01.465+00	\N	cmi76p72000pkdj0rpadkyd97	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-20 16:04:11.896+00	2025-11-20 22:57:01.465+00
cmi90nox60011dj0r3ds1d2pr	1	both	delivered			2025-11-21 18:55:27.875+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-21 15:29:53.13+00	2025-11-21 18:55:27.875+00
cmi90nox60012dj0r9aronoru	4	both	delivered			2025-11-21 20:05:28.77+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-21 15:29:53.13+00	2025-11-21 20:05:28.77+00
cmi90nox6000ydj0rahmp62ox	9	dropoff	delivered	Boite au lettre du haut		2025-11-21 22:58:08.313+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-21 15:29:53.13+00	2025-11-21 22:58:08.313+00
cmi90nox60010dj0r1y28uvyp	11	dropoff	delivered			2025-11-21 23:21:59.004+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-21 15:29:53.13+00	2025-11-21 23:21:59.004+00
cmi90nox6000zdj0rs9lxo67p	14	both	delivered	À l'étage dans le placard		2025-11-21 23:43:59.116+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-21 15:29:53.13+00	2025-11-21 23:43:59.116+00
cmj7cgw5201cvgr0rvwo5c5i0	7	pickup	delivered	3ème étage CODE: 2606		2025-12-15 19:44:45.708+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-12-15 16:04:41.27+00	2025-12-15 19:44:45.708+00
cminaezs300hvgr0rdvk75els	16	both	planned		\N	\N	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-01 15:11:49.923+00	2025-12-01 15:11:49.923+00
cminaezs300hygr0rb7tyulxp	20	both	planned		\N	\N	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-01 15:11:49.923+00	2025-12-01 15:11:49.923+00
cminaezs300i0gr0rcokr8ogq	2	pickup	delivered			2025-12-01 17:38:48.108+00	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-01 15:11:49.923+00	2025-12-01 17:38:48.108+00
cminaezs300hwgr0rxq475m3j	5	dropoff	delivered			2025-12-01 18:14:21.723+00	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-12-01 15:11:49.923+00	2025-12-01 18:14:21.723+00
cminaezs300i1gr0r3kc2wgv1	7	pickup	delivered			2025-12-01 20:24:29.516+00	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-01 15:11:49.923+00	2025-12-01 20:24:29.516+00
cminaezs300i2gr0r3l6s3csf	8	both	delivered			2025-12-01 20:24:32.369+00	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-01 15:11:49.923+00	2025-12-01 20:24:32.369+00
cmi923lla001gdj0r2g0l9bnk	2	dropoff	delivered			2025-11-21 17:06:41.425+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-11-21 16:10:14.926+00	2025-11-21 17:06:41.425+00
cminaezs300hxgr0rohumnvls	10	pickup	delivered			2025-12-01 20:24:34.456+00	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-01 15:11:49.923+00	2025-12-01 20:24:34.456+00
cmi923lla001jdj0r3vp4agfu	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-21 17:25:32.808+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-21 16:10:14.926+00	2025-11-21 17:25:32.808+00
cmi923lla001ddj0r6mfrgbtu	5	both	delivered			2025-11-21 17:43:59.205+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-21 16:10:14.926+00	2025-11-21 17:43:59.205+00
cminaezs300hzgr0rvs5zw5vv	12	dropoff	delivered			2025-12-01 20:24:36.185+00	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-01 15:11:49.923+00	2025-12-01 20:24:36.185+00
cmi923lla001hdj0rm62askae	7	both	delivered			2025-11-21 18:03:48.866+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-21 16:10:14.926+00	2025-11-21 18:03:48.866+00
cmi90nox60014dj0rldsdltak	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-21 18:40:51.635+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-21 15:29:53.13+00	2025-11-21 18:40:51.635+00
cmid8o6vp007rgr0rm2pvwvrc	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-24 17:17:31.929+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-24 14:25:18.037+00	2025-11-24 17:17:31.929+00
cmi90nox60015dj0rte4zjkw9	2	dropoff	delivered			2025-11-21 19:15:38.893+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-11-21 15:29:53.13+00	2025-11-21 19:15:38.893+00
cmi923lla001idj0r942q12ln	8	both	delivered			2025-11-21 19:27:57.68+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-21 16:10:14.926+00	2025-11-21 19:27:57.68+00
cmid8o6vp007jgr0re28vj4h3	4	dropoff	delivered			2025-11-24 17:35:32.171+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-24 14:25:18.037+00	2025-11-24 17:35:32.171+00
cmi923lla001edj0r6gg8ak8t	10	both	delivered			2025-11-21 19:28:01.602+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-21 16:10:14.926+00	2025-11-21 19:28:01.602+00
cmi90nox60018dj0r4fas1wmv	3	both	delivered			2025-11-21 19:36:01.848+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-21 15:29:53.13+00	2025-11-21 19:36:01.848+00
cmid8o6vp007hgr0r2mr2z1k6	5	pickup	delivered			2025-11-24 17:53:26.161+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-24 14:25:18.037+00	2025-11-24 17:53:26.161+00
cmi923lla001ldj0rc7ubxqly	13	pickup	delivered	Fermé les jeudi		2025-11-21 20:38:11.789+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-21 16:10:14.926+00	2025-11-21 20:38:11.789+00
cmi90nox6001adj0rynzi0m7s	5	both	delivered	La porte de gauche		2025-11-21 20:49:35.683+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-11-21 15:29:53.13+00	2025-11-21 20:49:35.683+00
cmid8o6vp007pgr0re073qi7e	7	dropoff	delivered			2025-11-24 18:15:30.893+00	https://www.storage.tds-transports.fr/29435b72-a48a-4d36-ad20-6523a134e8d5.avif	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-24 14:25:18.037+00	2025-11-24 18:15:30.893+00
cmi923lla001kdj0rg8venqku	14	both	delivered	Fermé les Vendredi		2025-11-21 20:50:11.637+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-21 16:10:14.926+00	2025-11-21 20:50:11.637+00
cmi923lla001mdj0rso4a5k56	18	both	delivered	Fermé les Mercredi		2025-11-21 21:09:15.365+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-21 16:10:14.926+00	2025-11-21 21:09:15.365+00
cmid8o6vp007qgr0rxaz53dwb	8	both	delivered			2025-11-24 18:45:19.408+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-24 14:25:18.037+00	2025-11-24 18:45:19.409+00
cmi90nox60013dj0rf9ftc0os	6	pickup	delivered			2025-11-21 21:46:29.389+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-21 15:29:53.13+00	2025-11-21 21:46:29.389+00
cmi923lla001fdj0r86w5s2px	19	dropoff	delivered			2025-11-21 21:59:35.98+00	\N	cmi8k0fbi0000dj0rrgw3jvwn	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-21 16:10:14.926+00	2025-11-21 21:59:35.98+00
cmi90nox60017dj0rgk9z6xai	8	pickup	delivered			2025-11-21 22:48:13.316+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-21 15:29:53.13+00	2025-11-21 22:48:13.316+00
cmid8o6vp007igr0r9vjh4ur0	10	both	delivered			2025-11-24 19:04:14.046+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-24 14:25:18.037+00	2025-11-24 19:04:14.046+00
cmi90nox6001bdj0ruchkt633	10	dropoff	delivered	2306 placard étage		2025-11-21 22:58:11.399+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-21 15:29:53.13+00	2025-11-21 22:58:11.399+00
cmi90nox60016dj0rfwhdee4w	13	pickup	delivered			2025-11-21 23:43:28.043+00	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-21 15:29:53.13+00	2025-11-21 23:43:28.043+00
cmi90nox60019dj0r2efw0etp	15	both	en_route		\N	\N	\N	cmi8qdq2k0006dj0r1pgmfn6t	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-21 15:29:53.13+00	2025-11-21 23:43:59.153+00
cmid8o6vp007ogr0rnjm7d6zl	11	dropoff	delivered			2025-11-24 19:57:56.347+00	\N	cmicw5zeo0064gr0rnksycwyo	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-11-24 14:25:18.037+00	2025-11-24 19:57:56.347+00
cmid8o6vp007mgr0r8dphhhpp	12	dropoff	delivered			2025-11-24 20:20:51.19+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-11-24 14:25:18.037+00	2025-11-24 20:20:51.19+00
cmid8o6vp007sgr0rcyq5jfab	15	both	delivered	Fermé les Vendredi		2025-11-24 21:45:46.745+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-24 14:25:18.037+00	2025-11-24 21:45:46.745+00
cmid8o6vp007ggr0r3t7rbmq8	16	pickup	delivered			2025-11-24 22:29:06.422+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-24 14:25:18.037+00	2025-11-24 22:29:06.422+00
cmid8o6vp007lgr0rqleio618	20	both	delivered			2025-11-24 22:29:27.758+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-24 14:25:18.037+00	2025-11-24 22:29:27.758+00
cmid8o6vp007kgr0r7k9qafvo	21	dropoff	delivered			2025-11-24 22:29:31.26+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-11-24 14:25:18.037+00	2025-11-24 22:29:31.26+00
cmig4p79100crgr0rwpyaeidt	1	dropoff	delivered	Fermé les Mercredi		2025-11-26 17:21:56.415+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-26 14:57:25.237+00	2025-11-26 17:21:56.415+00
cmid8o6vp007tgr0r2aew17u1	14	both	delivered	Fermé les jeudi	Pas de collecte	2025-11-24 21:25:16.995+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-24 14:25:18.037+00	2025-11-24 21:25:16.995+00
cmj7cgw5201cugr0rbciiy971	9	both	delivered	Boite au lettre du haut		2025-12-15 20:43:20.972+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-15 16:04:41.27+00	2025-12-15 20:43:20.972+00
cminaezs300i5gr0rn6goi4tk	15	both	planned	Fermé les Vendredi	\N	\N	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-01 15:11:49.923+00	2025-12-01 15:11:49.923+00
cminaezs300i6gr0rje66huh5	14	both	planned	Fermé les jeudi	\N	\N	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-01 15:11:49.923+00	2025-12-01 15:11:49.923+00
cminaezs300i7gr0r4lnz716w	19	both	planned	Fermé les Mercredi	\N	\N	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-01 15:11:49.923+00	2025-12-01 15:11:49.923+00
cmig4upov00cxgr0rwzcpupsx	4	dropoff	delivered			2025-11-26 18:29:37.694+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-26 15:01:42.415+00	2025-11-26 18:29:37.694+00
cminaezs300i3gr0ry4exaoe9	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-01 17:57:55.316+00	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-01 15:11:49.923+00	2025-12-01 17:57:55.316+00
cmiesjqz600b1gr0r0zp91zmh	1	dropoff	delivered			2025-11-25 17:27:50.801+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-11-25 16:29:29.298+00	2025-11-25 17:27:50.801+00
cminaezs300i4gr0rqxithumr	13	both	en_route	Fermé les Mercredi	\N	\N	\N	cmimugqs500gxgr0rpr1haed8	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-01 15:11:49.923+00	2025-12-01 20:24:36.214+00
cmiesjqz600b0gr0ri0ulc47o	8	both	delivered			2025-11-25 19:22:02.433+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-25 16:29:29.298+00	2025-11-25 19:22:02.433+00
cmiesjqz600b3gr0rqsoxqkjc	14	both	delivered	Fermé les jeudi	Pas de collecte	2025-11-25 22:08:28.926+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-25 16:29:29.298+00	2025-11-25 22:08:28.926+00
cmiesjqz600b2gr0rhkpu0nok	15	both	delivered	Fermé les Vendredi		2025-11-25 22:27:59.756+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-25 16:29:29.298+00	2025-11-25 22:27:59.756+00
cmig4p79100cqgr0rpqs3qfzi	3	both	delivered	Fermé les Vendredi		2025-11-26 18:45:03.24+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-26 14:57:25.237+00	2025-11-26 18:45:03.24+00
cmiesjqz600b4gr0rok11tgfs	19	dropoff	delivered	Fermé les Mercredi		2025-11-25 22:29:02.538+00	\N	cmieelrjt008ngr0rrhenvaod	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-11-25 16:29:29.298+00	2025-11-25 22:29:02.538+00
cmkr2csjf003oh90qefi3cc1k	3	dropoff	delivered	La porte de gauche		2026-01-23 19:08:39.152+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-23 15:56:39.675+00	2026-01-23 19:08:39.152+00
cmig4p79100cmgr0rp2abknhp	4	dropoff	delivered			2025-11-26 20:03:38.84+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-11-26 14:57:25.237+00	2025-11-26 20:03:38.841+00
cmig4p79100cogr0riuuuw2sc	6	both	delivered			2025-11-26 21:12:43.35+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-26 14:57:25.237+00	2025-11-26 21:12:43.35+00
cmjbhxh7a01ldgr0rpzknkk8f	4	dropoff	delivered	La porte de gauche		2025-12-18 20:52:25.931+00	\N	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-12-18 13:48:37.846+00	2025-12-18 20:52:25.931+00
cmig4p79100cngr0r83j5j182	7	both	delivered			2025-11-26 21:38:15.676+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-26 14:57:25.237+00	2025-11-26 21:38:15.676+00
cmig4p79100cpgr0re2bu1bj9	10	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-26 22:24:22.783+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-26 14:57:25.237+00	2025-11-26 22:24:22.783+00
cmig4upov00cygr0r513ozszh	6	both	delivered			2025-11-27 01:01:35.948+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-26 15:01:42.415+00	2025-11-27 01:01:35.948+00
cmig4upov00cugr0rutvqeonr	14	both	delivered	À l'étage dans le placard		2025-11-27 02:47:29.34+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-26 15:01:42.415+00	2025-11-27 02:47:29.34+00
cmjr4flpt01v6gr0rzl706a78	9	pickup	delivered			2025-12-29 14:17:54.991+00	\N	cmjr37ano01ukgr0rtwo61dpd	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2025-12-29 12:15:07.697+00	2025-12-29 14:17:54.991+00
cmjr4flpt01v5gr0r1bxwg4kn	10	both	delivered			2025-12-29 15:02:42.182+00	\N	cmjr37ano01ukgr0rtwo61dpd	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-29 12:15:07.697+00	2025-12-29 15:02:42.182+00
cmjbhxh7a01legr0ri26g6yjm	2	dropoff	delivered	2306 placard étage		2025-12-18 20:14:35.273+00	https://www.storage.tds-transports.fr/3e321133-3f4c-44b0-9943-c44573d27e91.avif	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-18 13:48:37.846+00	2025-12-18 20:14:35.273+00
cmklebu23010lgr0ranhwz8m6	5	dropoff	delivered	3ème étage CODE: 2606		2026-01-19 22:25:02.588+00	https://www.storage.tds-transports.fr/aa38c002-bad2-4b4e-8928-3a9375bba491.avif	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-19 16:45:13.323+00	2026-01-19 22:25:02.588+00
cmjr4flpt01v7gr0r9gw309dl	12	dropoff	delivered			2025-12-29 15:25:24.307+00	\N	cmjr37ano01ukgr0rtwo61dpd	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-29 12:15:07.697+00	2025-12-29 15:25:24.307+00
cmjr4flpt01v8gr0r38gku4by	14	pickup	delivered	Fermé les jeudi		2025-12-29 16:44:02.833+00	\N	cmjr37ano01ukgr0rtwo61dpd	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-29 12:15:07.697+00	2025-12-29 16:44:02.833+00
cmig4upov00cwgr0rpo6nh7b9	1	both	delivered			2025-11-26 17:16:57.894+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-26 15:01:42.415+00	2025-11-26 17:16:57.894+00
cmig4upov00ctgr0r0opbwdj8	9	dropoff	delivered	Boite au lettre du haut		2025-11-27 01:56:47.027+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-26 15:01:42.415+00	2025-11-27 01:56:47.027+00
cmig4upov00cvgr0rmoa2yfjs	11	pickup	delivered			2025-11-27 01:56:52.2+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-26 15:01:42.415+00	2025-11-27 01:56:52.2+00
cmios0ucf00l6gr0r4av9hjgq	5	pickup	delivered			2025-12-02 17:52:28.415+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-12-02 16:12:28.959+00	2025-12-02 17:52:28.415+00
cmios0ucf00l5gr0ri81xe7a1	16	both	delivered			2025-12-02 22:53:10.462+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-02 16:12:28.959+00	2025-12-02 22:53:10.462+00
cmjd4dgin01oygr0rw00rqcu6	1	both	delivered			2025-12-19 17:42:30.666+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-19 17:04:41.183+00	2025-12-19 17:42:30.666+00
cmjd4dgin01ovgr0r7q2riod6	9	dropoff	delivered	Boite au lettre du haut		2025-12-19 23:23:14.727+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-19 17:04:41.183+00	2025-12-19 23:23:14.727+00
cmjd4dgin01oxgr0rz969dd0p	11	both	delivered			2025-12-19 23:49:02.245+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-19 17:04:41.183+00	2025-12-19 23:49:02.245+00
cmjd4dgin01owgr0r8w8wwys1	14	both	delivered	À l'étage dans le placard		2025-12-20 00:13:14.231+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-19 17:04:41.183+00	2025-12-20 00:13:14.231+00
cmj7cgw5301cxgr0rcb85rwen	11	dropoff	delivered			2025-12-15 20:43:26.26+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-15 16:04:41.27+00	2025-12-15 20:43:26.26+00
cmiho0mdh00f0gr0r5qirj9uu	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-27 17:00:10.126+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-27 16:45:56.933+00	2025-11-27 17:00:10.126+00
cminazkec00iggr0r3j7075gx	3	both	delivered			2025-12-01 18:30:02.831+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-01 15:27:49.764+00	2025-12-01 18:30:02.831+00
cmid8o6vp007ngr0riov36pm7	2	pickup	delivered			2025-11-24 16:55:35.72+00	\N	cmicw5zeo0064gr0rnksycwyo	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-11-24 14:25:18.037+00	2025-11-24 16:55:35.72+00
cmiho0mdh00ezgr0rn2267up0	1	both	delivered			2025-11-27 17:13:40.79+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-27 16:45:56.933+00	2025-11-27 17:13:40.79+00
cmiho0mdh00f3gr0r9i5iy85s	3	both	delivered			2025-11-27 17:48:45.728+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-27 16:45:56.933+00	2025-11-27 17:48:45.728+00
cminazkec00icgr0r5ystb5lo	6	both	delivered			2025-12-01 20:12:01.477+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-01 15:27:49.764+00	2025-12-01 20:12:01.477+00
cmiho0mdh00ewgr0r1vtoeniy	7	dropoff	delivered	3ème étage CODE: 2606	+ Collecte	2025-11-28 00:20:01.679+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-11-27 16:45:56.933+00	2025-11-28 00:20:01.679+00
cmiho0mdh00f2gr0rphuwu41h	8	dropoff	delivered			2025-11-28 00:24:49.883+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-27 16:45:56.933+00	2025-11-28 00:24:49.883+00
cminazkec00ifgr0rob77rde7	8	dropoff	delivered			2025-12-01 21:12:14.115+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-01 15:27:49.764+00	2025-12-01 21:12:14.115+00
cmiho0mdh00evgr0r1pbzqmzz	9	pickup	delivered	Boite au lettre du haut		2025-11-28 00:27:59.715+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-27 16:45:56.933+00	2025-11-28 00:27:59.715+00
cmiho0mdh00eygr0rsjl510ro	11	dropoff	delivered			2025-11-28 00:28:04.252+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-27 16:45:56.933+00	2025-11-28 00:28:04.252+00
cminazkec00iigr0rfup0oaoe	10	dropoff	delivered	2306 placard étage		2025-12-01 21:25:42.493+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-01 15:27:49.764+00	2025-12-01 21:25:42.493+00
cmiho0mdh00f1gr0r4xkapcz8	13	both	delivered			2025-11-28 01:04:47.869+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-27 16:45:56.933+00	2025-11-28 01:04:47.869+00
cmiho0mdh00exgr0r0ikalya7	14	both	delivered	À l'étage dans le placard	Pas de collecte	2025-11-28 01:04:59.705+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-27 16:45:56.933+00	2025-11-28 01:04:59.705+00
cminazkec00ibgr0ristlr07i	11	dropoff	delivered			2025-12-01 22:16:56.617+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-01 15:27:49.764+00	2025-12-01 22:16:56.617+00
cmiho0mdh00f4gr0rccuyubvj	15	both	delivered			2025-11-28 03:56:26.29+00	\N	cmigzkcdu00d4gr0r8kce8ay8	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-27 16:45:56.933+00	2025-11-28 03:56:26.29+00
cminazkec00iegr0rcu1835l2	13	both	delivered			2025-12-01 22:17:10.456+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-01 15:27:49.764+00	2025-12-01 22:17:10.456+00
cminazkec00iagr0r8o0co0er	14	both	delivered	À l'étage dans le placard		2025-12-01 22:28:55.488+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-01 15:27:49.764+00	2025-12-01 22:28:55.488+00
cminazkec00ihgr0rkmo2bc2s	15	pickup	delivered			2025-12-01 22:28:59.372+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-01 15:27:49.764+00	2025-12-01 22:28:59.372+00
cmic4hp7w003hgr0r77fxp8gw	16	pickup	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003igr0rrwfxiozw	24	dropoff	planned	CODE: 1945	\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwv002bz0l65kx21hd9	cmfxz4zwv002az0l6wm6zh6wh	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003jgr0rg5nhz4fz	18	pickup	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwv001zz0l65qqq9usa	cmfxz4zwv001yz0l6sidgj4lq	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003kgr0rqn0lqyq4	10	pickup	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003lgr0rkyr60oud	0	pickup	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003mgr0rxd4l9qcq	4	pickup	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003ngr0rcqy3tz3v	9	pickup	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003ogr0r6pwu5edh	2	both	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003pgr0rl1zc65ol	11	pickup	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003qgr0rob56b0y4	6	both	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu001dz0l6jrju1qt7	cmfxz4zwu001cz0l631u4zru7	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003rgr0r3pq6frc9	3	both	planned	753B Fermé Lundi aprèm et Vendredi	\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4hp7w003sgr0rt7or58ju	1	both	planned		\N	\N	\N	cmibrlsa00000f00recsfqhyt	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2025-11-23 19:40:30.572+00	2025-11-23 19:40:30.572+00
cmic4l1ra005ogr0r2k24z06m	9	both	planned	Boite au lettre du haut	\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005pgr0r0agnxswy	11	pickup	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005qgr0rklmjcz8p	1	pickup	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005rgr0rdh8wiplf	4	dropoff	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005sgr0roetttdg7	6	pickup	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005tgr0ryou42ray	0	both	planned	x 3612 🔔 Devant la porte	\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005ugr0ra11mxt92	2	dropoff	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005vgr0rckgxr0y2	13	dropoff	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005wgr0rbdvejod7	8	pickup	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005xgr0rge7xaeov	3	both	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmiizfkzd00fsgr0rmk86i6mw	9	both	delivered			2025-11-28 22:28:59.123+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-28 14:53:16.921+00	2025-11-28 22:28:59.123+00
cmihlnxh400e0gr0r4gasrpja	10	both	delivered			2025-11-27 19:26:35.602+00	\N	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-27 15:40:05.56+00	2025-11-27 19:26:35.602+00
cmihlnxh400dzgr0rzpuwp5cb	16	both	delivered		Pas de collecte	2025-11-27 22:04:27.632+00	https://www.storage.tds-transports.fr/42d7dce7-0e84-4c28-9275-b3f3c6db3e2c.avif	cmihb6h5x00d7gr0rvsbp8eqi	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-27 15:40:05.56+00	2025-11-27 22:04:27.632+00
cmixa9h1q00vdgr0r4lndp3si	2	dropoff	delivered			2025-12-08 17:08:52.65+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-08 15:05:14.126+00	2025-12-08 17:08:52.65+00
cmiizfkzd00fugr0rexmx60el	10	pickup	delivered			2025-11-28 22:41:22.689+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-28 14:53:16.921+00	2025-11-28 22:41:22.689+00
cmj7cgw5301d4gr0rfgtppti2	12	both	delivered	Fermé mercredi & jeudi		2025-12-15 20:50:15.809+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-15 16:04:41.27+00	2025-12-15 20:50:15.809+00
cmiizfkze00fzgr0r9eum8hmz	11	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-11-28 22:52:25.832+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-11-28 14:53:16.921+00	2025-11-28 22:52:25.832+00
cmixa9h1q00v9gr0rhc5vcyf6	5	dropoff	delivered			2025-12-08 17:52:26.262+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-12-08 15:05:14.126+00	2025-12-08 17:52:26.262+00
cminazkec00ijgr0r5zhm98wc	12	both	delivered	Fermé mercredi & jeudi		2025-12-01 22:17:07.752+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-01 15:27:49.764+00	2025-12-01 22:17:07.752+00
cmixa9h1q00vegr0r0kt0478v	8	both	delivered			2025-12-08 19:36:01.499+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-08 15:05:14.126+00	2025-12-08 19:36:01.499+00
cmixa9h1q00vagr0rza6oesxf	10	both	delivered			2025-12-08 19:36:05.001+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-08 15:05:14.126+00	2025-12-08 19:36:05.001+00
cmidc7ueh008dgr0rpjb6jjoz	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-24 21:54:03.511+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-24 16:04:33.833+00	2025-11-24 21:54:03.511+00
cmidc7ueh008bgr0rnibxqes3	1	both	delivered			2025-11-24 21:54:05.617+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-24 16:04:33.833+00	2025-11-24 21:54:05.617+00
cmidc7ueh008fgr0r5mdty3p4	3	both	delivered			2025-11-24 21:54:07.788+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-24 16:04:33.833+00	2025-11-24 21:54:07.788+00
cmixa9h1q00vcgr0r3405f7bd	20	both	delivered			2025-12-09 15:33:22.933+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-08 15:05:14.126+00	2025-12-09 15:33:22.933+00
cmidc7ueh008hgr0rhovuij1p	5	dropoff	delivered	La porte de gauche		2025-11-25 01:10:35.74+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-11-24 16:04:33.833+00	2025-11-25 01:10:35.74+00
cmit0haol00uggr0rysnws6zm	14	both	delivered	Fermé les jeudi		2025-12-05 22:13:29.828+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-05 15:20:18.261+00	2025-12-05 22:13:29.828+00
cmidc7ueh008cgr0rsrgeft26	6	dropoff	delivered			2025-11-25 02:04:34.192+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-24 16:04:33.833+00	2025-11-25 02:04:34.192+00
cmidc7ueh0088gr0r5uyfwotc	9	dropoff	delivered	Boite au lettre du haut		2025-11-25 03:11:25.469+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-24 16:04:33.833+00	2025-11-25 03:11:25.469+00
cmit0haol00uhgr0rf5cuum7q	19	both	delivered	Fermé les Mercredi		2025-12-05 23:12:56.595+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-05 15:20:18.261+00	2025-12-05 23:12:56.595+00
cmidc7ueh008igr0rqum5rsjj	10	dropoff	delivered	2306 placard étage		2025-11-25 03:11:28.826+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-24 16:04:33.833+00	2025-11-25 03:11:28.826+00
cmidc7ueh008agr0re17rzebx	11	dropoff	delivered			2025-11-25 03:11:32.105+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-24 16:04:33.833+00	2025-11-25 03:11:32.105+00
cmidc7ueh008jgr0rsd9q4cg1	12	pickup	delivered	Fermé mercredi & jeudi		2025-11-25 03:11:36.994+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-24 16:04:33.833+00	2025-11-25 03:11:36.994+00
cmidc7ueh008egr0r8z38sk3p	13	both	delivered			2025-11-25 03:11:40.317+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-24 16:04:33.833+00	2025-11-25 03:11:40.317+00
cmidc7ueh0089gr0ruhen73a5	14	both	delivered	À l'étage dans le placard		2025-11-25 03:11:43.307+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-24 16:04:33.833+00	2025-11-25 03:11:43.307+00
cmixa9h1q00vbgr0r06d8rpte	21	dropoff	delivered			2025-12-09 15:33:24.993+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-12-08 15:05:14.126+00	2025-12-09 15:33:24.994+00
cmidc7ueh008ggr0rqr63glsz	15	pickup	delivered			2025-11-25 03:11:47.34+00	\N	cmicugzsr0061gr0r62hcgtka	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-24 16:04:33.833+00	2025-11-25 03:11:47.34+00
cmiyuf4te0114gr0rhutcxzqx	6	dropoff	delivered		+ Collecte	2025-12-09 20:38:52.575+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-09 17:17:16.706+00	2025-12-09 20:38:52.575+00
cmiyuf4te0111gr0r3vwv02co	9	both	delivered	Boite au lettre du haut		2025-12-09 21:40:40.36+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-09 17:17:16.706+00	2025-12-09 21:40:40.36+00
cmiyuf4te0112gr0rnkx3ylqc	11	both	delivered			2025-12-09 22:29:34.374+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-09 17:17:16.706+00	2025-12-09 22:29:34.374+00
cmiizfkze00g0gr0rw5slfc6z	5	dropoff	delivered	Fermé les Mercredi		2025-11-28 19:39:14.845+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-11-28 14:53:16.921+00	2025-11-28 19:39:14.845+00
cmiizfkzd00fvgr0r5nssby9b	0	dropoff	delivered			2025-11-28 16:48:37.808+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-11-28 14:53:16.921+00	2025-11-28 16:48:37.808+00
cmiizfkze00fwgr0rzdxvkczo	1	both	delivered			2025-11-28 17:07:45.343+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-28 14:53:16.921+00	2025-11-28 17:07:45.343+00
cmiizfkzd00ftgr0rp8d8mgt7	6	both	delivered			2025-11-28 20:23:36.13+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-28 14:53:16.921+00	2025-11-28 20:23:36.13+00
cmiizfkzd00frgr0rpw5qvvui	2	both	delivered			2025-11-28 18:03:12.524+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-28 14:53:16.921+00	2025-11-28 18:03:12.524+00
cmiizfkze00fygr0r21w8q0wm	7	both	delivered			2025-11-28 21:44:30.485+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-11-28 14:53:16.921+00	2025-11-28 21:44:30.485+00
cmiizfkze00g2gr0r2suv511l	3	both	delivered	Fermé les jeudi		2025-11-28 18:59:18.38+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-11-28 14:53:16.921+00	2025-11-28 18:59:18.38+00
cmiizfkze00g1gr0rcbeq4y92	4	both	delivered	Fermé les Vendredi		2025-11-28 19:15:35.644+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-11-28 14:53:16.921+00	2025-11-28 19:15:35.644+00
cmiizfkze00fxgr0re8n0b19d	8	dropoff	delivered			2025-11-28 21:44:49.676+00	\N	cmiilp5t000f5gr0rtuc9h863	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-11-28 14:53:16.921+00	2025-11-28 21:44:49.676+00
cmic4l1ra005ygr0r5ecw4h76	15	pickup	planned		\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra005zgr0rssqt8jyf	5	both	planned	La porte de gauche	\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cmic4l1ra0060gr0r0wwknydd	10	both	planned	2306 placard étage	\N	\N	\N	cmibrnj7c0007f00ruoxciowt	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-23 19:43:06.79+00	2025-11-23 19:43:06.79+00
cminazkec00idgr0rgujllgyg	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-01 17:49:06.745+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-01 15:27:49.764+00	2025-12-01 17:49:06.745+00
cmj7cgw5201cwgr0r1iv1upv0	14	both	delivered	À l'étage dans le placard		2025-12-15 21:11:52.701+00	\N	cmj6xbo4001aygr0rtr8157a3	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-15 16:04:41.27+00	2025-12-15 21:11:52.701+00
cminazkeb00i9gr0r8mx6ns5e	9	dropoff	delivered	Boite au lettre du haut		2025-12-01 21:25:39.424+00	\N	cmimwe7wk00h0gr0rsu47z600	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-01 15:27:49.764+00	2025-12-01 21:25:39.424+00
cmig4p79100cggr0rkzqborel	2	both	delivered			2025-11-26 18:01:54.84+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-11-26 14:57:25.237+00	2025-11-26 18:01:54.84+00
cmig4p79100cigr0re7l56xyj	5	both	delivered		Pas de collecte 	2025-11-26 20:08:19.007+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-11-26 14:57:25.237+00	2025-11-26 20:08:19.007+00
cmig4p79100chgr0r47ee1bmj	8	dropoff	delivered			2025-11-26 22:00:19.201+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-11-26 14:57:25.237+00	2025-11-26 22:00:19.201+00
cmiesji6h00amgr0r69efe53s	0	pickup	delivered	x 3612 🔔 Devant la porte	Pas de boîte !	2025-11-25 22:22:31.962+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-25 16:29:17.897+00	2025-11-25 22:22:31.962+00
cmiesji6h00akgr0rlgtrdkef	1	both	delivered			2025-11-25 22:22:34.499+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-25 16:29:17.897+00	2025-11-25 22:22:34.499+00
cmiesji6h00aogr0rfxjdc64n	3	both	delivered			2025-11-25 22:22:36.285+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-25 16:29:17.897+00	2025-11-25 22:22:36.285+00
cmiesji6h00algr0r6wekd39u	4	dropoff	delivered			2025-11-25 22:22:37.97+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-25 16:29:17.897+00	2025-11-25 22:22:37.97+00
cmig4p79100ckgr0r7u6xnf8a	9	both	delivered			2025-11-26 22:14:30.517+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-11-26 14:57:25.237+00	2025-11-26 22:14:30.517+00
cmiesji6h00ahgr0ry61lhbzu	7	pickup	delivered	3ème étage CODE: 2606		2025-11-26 01:11:04.974+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-11-25 16:29:17.897+00	2025-11-26 01:11:04.974+00
cmiesji6h00ajgr0rk4vjhomv	11	dropoff	delivered			2025-11-26 01:44:11.22+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-25 16:29:17.897+00	2025-11-26 01:44:11.22+00
cmig4p79100cjgr0r0rxmcbfv	11	dropoff	delivered			2025-11-26 22:48:40.378+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-11-26 14:57:25.237+00	2025-11-26 22:48:40.378+00
cmiesji6h00aqgr0rmoptejux	12	pickup	delivered	Fermé mercredi & jeudi		2025-11-26 01:53:13.789+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-25 16:29:17.897+00	2025-11-26 01:53:13.789+00
cmiesji6h00angr0ryzsa6j5y	13	pickup	delivered			2025-11-26 01:59:17.099+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-25 16:29:17.897+00	2025-11-26 01:59:17.099+00
cmiesji6h00aigr0rpalngseo	14	both	delivered	À l'étage dans le placard		2025-11-26 02:15:02.676+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-25 16:29:17.897+00	2025-11-26 02:15:02.676+00
cmiesji6h00apgr0rlk2brkdv	15	both	delivered			2025-11-26 02:15:04.611+00	\N	cmie9gao8008kgr0r2rxqgrlm	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-25 16:29:17.897+00	2025-11-26 02:15:04.611+00
cmj8r2csb01flgr0rskmrll5y	2	dropoff	delivered			2025-12-16 17:01:13.617+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-16 15:41:03.419+00	2025-12-16 17:01:13.617+00
cmj8r2csb01fngr0re28zrbgd	7	dropoff	delivered			2025-12-16 18:05:14.778+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-16 15:41:03.419+00	2025-12-16 18:05:14.778+00
cmj8r2csb01fogr0rvvrwj6tb	8	both	delivered			2025-12-16 19:36:18.787+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-16 15:41:03.419+00	2025-12-16 19:36:18.787+00
cmig4p79100clgr0rql3qd6d5	0	both	delivered			2025-11-26 16:58:23.501+00	\N	cmifqukfd00b5gr0rj6hcutyc	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-11-26 14:57:25.237+00	2025-11-26 16:58:23.501+00
cmj8r2csb01fhgr0r7qwaag18	10	both	delivered			2025-12-16 19:36:21.435+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-16 15:41:03.419+00	2025-12-16 19:36:21.435+00
cmj8r2csb01fmgr0r56mslui6	11	dropoff	delivered			2025-12-16 19:36:23.162+00	\N	cmj8bo34z01degr0r9n5aktqx	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-12-16 15:41:03.419+00	2025-12-16 19:36:23.162+00
cmj8r2csb01fkgr0r39sge9jm	20	both	delivered			2025-12-16 22:35:44.127+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-16 15:41:03.419+00	2025-12-16 22:35:44.127+00
cmj32905d01a8gr0r1aiz210x	2	dropoff	delivered			2025-12-12 17:51:24.765+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-12 16:07:32.353+00	2025-12-12 17:51:24.765+00
cmj8r2csb01fjgr0rbvexm4ww	21	pickup	delivered			2025-12-16 22:38:35.668+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-12-16 15:41:03.419+00	2025-12-16 22:38:35.668+00
cmj32905d01acgr0rcprp8nwd	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-12 18:03:08.043+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-12 16:07:32.353+00	2025-12-12 18:03:08.043+00
cmj32905d01aagr0rtmghmj5q	7	dropoff	delivered			2025-12-12 18:52:20.63+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-12 16:07:32.353+00	2025-12-12 18:52:20.63+00
cmj32905d01abgr0rrys2mwvg	8	both	delivered			2025-12-12 18:52:22.966+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-12 16:07:32.353+00	2025-12-12 18:52:22.966+00
cmj32905d01a4gr0r65g62emi	10	both	delivered			2025-12-12 20:25:18.932+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-12 16:07:32.353+00	2025-12-12 20:25:18.932+00
cmj32905d01a9gr0rakxb1iw2	11	pickup	delivered			2025-12-12 20:25:22.213+00	\N	cmj2l37mw0182gr0rwtrw4him	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-12-12 16:07:32.353+00	2025-12-12 20:25:22.213+00
cmj32905d01a7gr0ri4utah8p	12	dropoff	delivered			2025-12-12 20:25:25.691+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-12 16:07:32.353+00	2025-12-12 20:25:25.691+00
cmj32905d01adgr0r941y5om7	13	dropoff	delivered	Fermé les Mercredi		2025-12-12 20:47:44.831+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-12 16:07:32.353+00	2025-12-12 20:47:44.831+00
cmj32905d01aegr0r9virr18t	15	both	delivered	Fermé les Vendredi		2025-12-12 21:31:08.224+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-12 16:07:32.353+00	2025-12-12 21:31:08.224+00
cmj32905d01a6gr0rskhvt9tw	20	dropoff	delivered			2025-12-12 23:45:02.04+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-12 16:07:32.353+00	2025-12-12 23:45:02.04+00
cmj32905d01a5gr0roz6mpmrx	21	dropoff	delivered			2025-12-12 23:45:03.729+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-12-12 16:07:32.353+00	2025-12-12 23:45:03.729+00
cmij2b9ua00gpgr0rnsllzzym	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-28 23:02:18.757+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-28 16:13:54.706+00	2025-11-28 23:02:18.757+00
cmij2b9ua00gmgr0rud7uoc4g	1	both	delivered			2025-11-29 00:05:43.149+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-11-28 16:13:54.706+00	2025-11-29 00:05:43.149+00
cmij2b9ua00gsgr0r9okih99x	3	both	delivered			2025-11-29 00:32:36.901+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-28 16:13:54.706+00	2025-11-29 00:32:36.901+00
cmig4upov00czgr0rupksr8ym	0	both	delivered	x 3612 🔔 Devant la porte		2025-11-26 16:39:08.713+00	https://www.storage.tds-transports.fr/d027c9f3-7bcc-49bc-b62f-47afc1d3d226.avif	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-11-26 15:01:42.415+00	2025-11-26 16:39:08.713+00
cmig4upov00d1gr0rkk7zw57j	3	both	delivered			2025-11-26 17:55:55.056+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-11-26 15:01:42.415+00	2025-11-26 17:55:55.056+00
cmij2b9ua00gngr0r8ofmd6o4	4	dropoff	delivered			2025-11-29 01:04:55.232+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-11-28 16:13:54.706+00	2025-11-29 01:04:55.232+00
cmig4upov00d3gr0reghjssr5	10	dropoff	delivered	2306 placard étage		2025-11-27 01:56:50.072+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-26 15:01:42.415+00	2025-11-27 01:56:50.072+00
cmig4upov00d0gr0rk3r930a4	13	pickup	delivered			2025-11-27 02:47:26.681+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-26 15:01:42.415+00	2025-11-27 02:47:26.681+00
cmij2b9ua00gugr0rm3iznxys	5	dropoff	delivered	La porte de gauche		2025-11-29 01:36:19.842+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-11-28 16:13:54.706+00	2025-11-29 01:36:19.842+00
cmig4upov00d2gr0ravsrkw06	15	both	delivered			2025-11-27 02:47:32.22+00	\N	cmifwzg5700bfgr0r579zi3p4	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-26 15:01:42.415+00	2025-11-27 02:47:32.22+00
cmij2b9ua00gogr0rc72j0qp9	6	dropoff	delivered			2025-11-29 02:27:50.328+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-11-28 16:13:54.706+00	2025-11-29 02:27:50.328+00
cmk2xcic90060gr0r8p08tat7	1	both	delivered			2026-01-06 19:53:45.798+00	\N	cmk2d2oh6004agr0ry04b70g5	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-06 18:30:00.153+00	2026-01-06 19:53:45.798+00
cmk2xcic90061gr0re2x5ml02	6	pickup	delivered		Pas de boite	2026-01-06 22:18:07.077+00	https://www.storage.tds-transports.fr/b3fc9309-b04f-4d3d-90c5-cb4f89bfa314.avif	cmk2d2oh6004agr0ry04b70g5	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-06 18:30:00.153+00	2026-01-06 22:18:07.077+00
cmk47hy57008kgr0r81itrxwa	16	both	delivered			2026-01-07 21:49:51.78+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-07 16:01:56.251+00	2026-01-07 21:49:51.78+00
cmirluhe800r0gr0rhftud12k	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-04 19:32:46.391+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-04 15:42:53.072+00	2025-12-04 19:32:46.391+00
cmij2b9ua00grgr0rz1if8w4m	8	both	delivered			2025-11-29 03:49:12.181+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-11-28 16:13:54.706+00	2025-11-29 03:49:12.181+00
cmirluhe800qwgr0rvkc6mrhq	4	pickup	delivered			2025-12-04 19:32:48.984+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-04 15:42:53.072+00	2025-12-04 19:32:48.984+00
cmij2b9ua00gjgr0r4hvsxgb6	9	dropoff	delivered	Boite au lettre du haut		2025-11-29 03:49:15.437+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-11-28 16:13:54.706+00	2025-11-29 03:49:15.437+00
cmij2b9ua00gvgr0rb1isjhve	10	dropoff	delivered	2306 placard étage		2025-11-29 03:49:20.993+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-11-28 16:13:54.706+00	2025-11-29 03:49:20.993+00
cmirluhe800qzgr0r0e1i1c60	8	both	delivered			2025-12-04 19:32:51.892+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-04 15:42:53.072+00	2025-12-04 19:32:51.892+00
cmij2b9ua00glgr0rb3ntjk27	11	both	delivered			2025-11-29 03:49:25.631+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-11-28 16:13:54.706+00	2025-11-29 03:49:25.631+00
cmij2b9ua00gwgr0rldtcor6t	12	both	delivered	Fermé mercredi & jeudi		2025-11-29 04:00:06.884+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-11-28 16:13:54.706+00	2025-11-29 04:00:06.884+00
cmirluhe800qvgr0rz4owcpw9	10	both	delivered			2025-12-04 20:19:40.837+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-04 15:42:53.072+00	2025-12-04 20:19:40.837+00
cmij2b9ua00gqgr0ru70t5spq	13	pickup	delivered			2025-11-29 04:28:52.889+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-11-28 16:13:54.706+00	2025-11-29 04:28:52.889+00
cmij2b9ua00gkgr0rigqwatg8	14	both	delivered	À l'étage dans le placard		2025-11-29 04:28:57.551+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-11-28 16:13:54.706+00	2025-11-29 04:28:57.551+00
cmirluhe800qygr0rd9bggofl	12	both	delivered			2025-12-04 20:19:43.392+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-04 15:42:53.072+00	2025-12-04 20:19:43.392+00
cmij2b9ua00gtgr0r52al27vl	15	both	delivered			2025-11-29 04:29:00.088+00	\N	cmiitd69w00fbgr0r995o2ou9	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-11-28 16:13:54.706+00	2025-11-29 04:29:00.088+00
cmirluhe800r1gr0rvl3ojwlh	13	both	delivered	Fermé les Mercredi		2025-12-04 22:50:41.594+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-04 15:42:53.072+00	2025-12-04 22:50:41.594+00
cmirluhe800r2gr0rquln0u3p	15	pickup	delivered	Fermé les Vendredi		2025-12-04 22:50:43.464+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-04 15:42:53.072+00	2025-12-04 22:50:43.464+00
cmirluhe800qugr0rc89m7pv3	16	both	delivered			2025-12-04 22:50:45.328+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-04 15:42:53.072+00	2025-12-04 22:50:45.328+00
cmirluhe800r3gr0rrj7j1sfs	19	both	delivered	Fermé les Mercredi		2025-12-04 22:50:47.414+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-04 15:42:53.072+00	2025-12-04 22:50:47.414+00
cmirluhe800qxgr0rnx8lzqlz	20	both	delivered			2025-12-04 22:50:48.931+00	\N	cmir6008c00oigr0rxquzrbtu	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-04 15:42:53.072+00	2025-12-04 22:50:48.931+00
cmiyuf4te0115gr0rpoitdfoq	0	pickup	delivered	x 3612 🔔 Devant la porte		2025-12-09 17:37:49.846+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-09 17:17:16.706+00	2025-12-09 17:37:49.847+00
cmiyuf4te0118gr0rf9gl5tts	3	both	delivered			2025-12-09 18:59:38.35+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-09 17:17:16.706+00	2025-12-09 18:59:38.35+00
cmiyuf4te0117gr0ru5p37zr6	8	pickup	delivered			2025-12-09 21:40:34.514+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-09 17:17:16.706+00	2025-12-09 21:40:34.514+00
cmiyuf4tf011agr0rdi3pyuwa	10	dropoff	delivered	2306 placard étage		2025-12-09 22:29:31.733+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-09 17:17:16.706+00	2025-12-09 22:29:31.733+00
cmiyuf4tf011bgr0r4rhm7n0u	12	pickup	failed	Fermé mercredi & jeudi	Pas de collecte	2025-12-09 22:30:16.964+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-09 17:17:16.706+00	2025-12-09 22:30:16.964+00
cmiyuf4te0116gr0rzcg12mu0	13	both	delivered			2025-12-09 22:31:04.578+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-09 17:17:16.706+00	2025-12-09 22:31:04.578+00
cmiyuf4te0119gr0rlz6wbdld	15	both	delivered			2025-12-09 22:59:03.583+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-09 17:17:16.706+00	2025-12-09 22:59:03.583+00
cmk2rb1kg005mgr0repml2h07	10	both	delivered			2026-01-06 19:14:28.128+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-06 15:40:54.064+00	2026-01-06 19:14:28.128+00
cmjr4flpt01v4gr0rm3r3j3gc	16	pickup	delivered			2025-12-29 17:36:16.469+00	\N	cmjr37ano01ukgr0rtwo61dpd	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-29 12:15:07.697+00	2025-12-29 17:36:16.47+00
cmkr2csjf003ih90qsyio8zh2	6	both	delivered			2026-01-23 20:24:16.773+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-23 15:56:39.675+00	2026-01-23 20:24:16.773+00
cmjrdl4pc01vfgr0r9xfcu1vu	12	pickup	failed	Fermé mercredi & jeudi	Pas de collecte	2025-12-29 17:52:15.334+00	\N	cmjr3hfa901uvgr0r0wpcb9gp	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-29 16:31:22.117+00	2025-12-29 17:52:15.334+00
cmkr2csjf003lh90qromf2jb7	8	pickup	delivered			2026-01-23 20:44:58.633+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-23 15:56:39.675+00	2026-01-23 20:44:58.633+00
cmirp6adx00r8gr0rdys08qrd	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-04 19:36:41.422+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-04 17:16:02.709+00	2025-12-04 19:36:41.422+00
cmirp6adx00r7gr0rtfh848w9	1	both	delivered			2025-12-04 19:36:45.046+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-04 17:16:02.709+00	2025-12-04 19:36:45.046+00
cmirp6adx00ragr0r7ddal52q	3	both	delivered			2025-12-04 19:36:56.106+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-04 17:16:02.709+00	2025-12-04 19:36:56.106+00
cmirp6adx00rcgr0rdvqixet8	5	dropoff	delivered	La porte de gauche		2025-12-04 20:21:46.471+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-12-04 17:16:02.709+00	2025-12-04 20:21:46.471+00
cmirp6adx00r9gr0rdrs4j47a	8	dropoff	delivered			2025-12-04 20:53:15.773+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-04 17:16:02.709+00	2025-12-04 20:53:15.773+00
cmj8r2csb01fqgr0rp8v99t0i	13	pickup	delivered	Fermé les Mercredi		2025-12-16 21:29:24.684+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-16 15:41:03.419+00	2025-12-16 21:29:24.684+00
cmirp6adx00r6gr0r0b2u7u96	11	dropoff	delivered			2025-12-04 20:53:20.001+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-04 17:16:02.709+00	2025-12-04 20:53:20.001+00
cmirp6adx00rdgr0rn1hlxmkh	12	pickup	failed	Fermé mercredi & jeudi	Fermé les jeudis	2025-12-04 20:54:08.686+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-04 17:16:02.709+00	2025-12-04 20:54:08.686+00
cmj8r2csb01fsgr0roeizqrcr	14	both	delivered	Fermé les jeudi		2025-12-16 21:29:27.496+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-16 15:41:03.419+00	2025-12-16 21:29:27.496+00
cmios0ucf00lbgr0rigkyc1eo	2	pickup	delivered			2025-12-02 16:58:16.419+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-02 16:12:28.959+00	2025-12-02 16:58:16.419+00
cmirp6adx00r5gr0r77tclhkx	14	both	delivered	À l'étage dans le placard		2025-12-04 21:28:01.769+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-04 17:16:02.709+00	2025-12-04 21:28:01.769+00
cmios0yho00lpgr0rrrkgsfz1	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-02 17:19:10.695+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-02 16:12:34.332+00	2025-12-02 17:19:10.695+00
cmios0ucf00ldgr0r179do5aj	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-02 17:20:08.535+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-02 16:12:28.959+00	2025-12-02 17:20:08.535+00
cmirp6adx00rbgr0r3uheozyn	15	pickup	delivered			2025-12-04 21:55:46.647+00	\N	cmir7ums400p0gr0r3q2n7ur7	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-04 17:16:02.709+00	2025-12-04 21:55:46.647+00
cmios0ucf00l8gr0rl9eeokcy	4	dropoff	delivered			2025-12-02 17:33:05.101+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-02 16:12:28.959+00	2025-12-02 17:33:05.101+00
cmios0yho00lmgr0rvktx5fxy	1	both	delivered			2025-12-02 17:47:34.05+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-02 16:12:34.332+00	2025-12-02 17:47:34.05+00
cmj8r2csb01frgr0rjrcht6bs	15	both	delivered	Fermé les Vendredi		2025-12-16 21:56:45.302+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-16 15:41:03.419+00	2025-12-16 21:56:45.302+00
cmios0yho00lrgr0rjls0izwq	3	both	delivered			2025-12-02 18:25:24.14+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-02 16:12:34.332+00	2025-12-02 18:25:24.14+00
cmios0ucf00lcgr0rgpzvqa95	8	both	delivered			2025-12-02 18:33:09.698+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-02 16:12:28.959+00	2025-12-02 18:33:09.698+00
cmios0yho00lngr0rmn2f6cn1	4	both	delivered			2025-12-02 19:01:55.058+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-12-02 16:12:34.332+00	2025-12-02 19:01:55.058+00
cmios0ucf00l7gr0rmccvjn0w	10	both	delivered			2025-12-02 19:31:40.393+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-02 16:12:28.959+00	2025-12-02 19:31:40.393+00
cmios0ucf00lagr0rakyl0v27	12	dropoff	delivered			2025-12-02 19:52:52.907+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-02 16:12:28.959+00	2025-12-02 19:52:52.907+00
cmios0yho00logr0rjom8avto	6	both	delivered			2025-12-02 20:34:22.136+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-02 16:12:34.332+00	2025-12-02 20:34:22.136+00
cmios0yho00ljgr0r9q35f8wi	7	dropoff	delivered	3ème étage CODE: 2606		2025-12-02 21:25:42.387+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-12-02 16:12:34.332+00	2025-12-02 21:25:42.387+00
cmios0yho00llgr0risct70jy	11	both	delivered			2025-12-02 21:46:44.341+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-02 16:12:34.332+00	2025-12-02 21:46:44.341+00
cmios0yho00ltgr0rq8nhbp1e	12	pickup	delivered	Fermé mercredi & jeudi		2025-12-02 22:01:18.631+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-02 16:12:34.332+00	2025-12-02 22:01:18.631+00
cmios0yho00lqgr0rjrgxx7wn	13	pickup	delivered			2025-12-02 22:01:49.459+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-02 16:12:34.332+00	2025-12-02 22:01:49.459+00
cmios0yho00lkgr0rbil3jo4z	14	pickup	delivered	À l'étage dans le placard		2025-12-02 22:22:49.151+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-02 16:12:34.332+00	2025-12-02 22:22:49.151+00
cmios0yho00lsgr0rffmnzy98	15	both	delivered			2025-12-02 22:22:52.363+00	\N	cmiocj3xp00ikgr0rkzs27tzq	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-02 16:12:34.332+00	2025-12-02 22:22:52.363+00
cmios0ucf00legr0ri6bjotx9	13	pickup	delivered	Fermé les Mercredi		2025-12-02 22:53:03.955+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-02 16:12:28.959+00	2025-12-02 22:53:03.955+00
cmios0ucf00lggr0rh0fao4uh	14	both	delivered	Fermé les jeudi		2025-12-02 22:53:06.768+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-02 16:12:28.959+00	2025-12-02 22:53:06.768+00
cmios0ucf00lfgr0ram3hlzqf	15	both	delivered	Fermé les Vendredi		2025-12-02 22:53:08.684+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-02 16:12:28.959+00	2025-12-02 22:53:08.684+00
cmios0ucf00lhgr0rjq23n2pc	19	both	delivered	Fermé les Mercredi		2025-12-02 22:53:12.524+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-02 16:12:28.959+00	2025-12-02 22:53:12.524+00
cmios0ucf00l9gr0rpap9zkfx	20	both	delivered			2025-12-02 22:53:14.233+00	\N	cmiof29ye00itgr0ro4mnbi3h	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-02 16:12:28.959+00	2025-12-02 22:53:14.233+00
cmk2rb1kg005pgr0rrgr48w3v	11	pickup	delivered			2026-01-06 19:14:31.104+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-06 15:40:54.064+00	2026-01-06 19:14:31.104+00
cmiq5xb9k00nxgr0rzv3eylaf	1	both	delivered			2025-12-03 17:50:31.167+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-03 15:29:25.064+00	2025-12-03 17:50:31.167+00
cmiq61x7s00o9gr0rvbeg5u08	4	pickup	delivered			2025-12-03 18:04:11.75+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-03 15:33:00.136+00	2025-12-03 18:04:11.75+00
cmiq61x7s00o6gr0rloludpq7	5	dropoff	delivered			2025-12-03 18:16:21.25+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-12-03 15:33:00.136+00	2025-12-03 18:16:21.25+00
cmiq5xb9k00o2gr0rqm9dxyxy	3	both	delivered			2025-12-03 18:36:05.267+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-03 15:29:25.064+00	2025-12-03 18:36:05.267+00
cmiq5xb9k00nygr0rrs7j102c	4	dropoff	delivered			2025-12-03 19:35:19.705+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2025-12-03 15:29:25.064+00	2025-12-03 19:35:19.705+00
cmjim6soy01thgr0rse65951w	3	pickup	delivered			2025-12-23 20:15:48.254+00	\N	cmji9ykrt01r8gr0rdlxsatpd	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-23 13:22:14.338+00	2025-12-23 20:15:48.255+00
cmiq61x7s00o7gr0rmbqice4p	10	both	delivered			2025-12-03 20:01:08.137+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-03 15:33:00.136+00	2025-12-03 20:01:08.137+00
cmjim6soy01tfgr0r3j0kgjqz	9	dropoff	delivered	Boite au lettre du haut		2025-12-23 20:16:22.534+00	\N	cmji9ykrt01r8gr0rdlxsatpd	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-23 13:22:14.338+00	2025-12-23 20:16:22.534+00
cmiq5xb9k00nzgr0r9rsmhw8e	6	dropoff	delivered			2025-12-03 20:32:28.122+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-03 15:29:25.064+00	2025-12-03 20:32:28.122+00
cmiq61x7s00obgr0r7vylu6as	12	dropoff	delivered			2025-12-03 20:48:42.202+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-03 15:33:00.136+00	2025-12-03 20:48:42.202+00
cmjbhxh7a01l9gr0rocu7fy40	0	dropoff	delivered			2025-12-18 19:02:28.556+00	\N	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-18 13:48:37.846+00	2025-12-18 19:02:28.556+00
cmiq5xb9k00o1gr0rco693thq	8	dropoff	delivered			2025-12-03 21:31:16.259+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-03 15:29:25.064+00	2025-12-03 21:31:16.259+00
cmixa9h1q00v8gr0rbjee7085	16	both	delivered			2025-12-09 15:33:20.449+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-08 15:05:14.126+00	2025-12-09 15:33:20.449+00
cmiq5xb9k00nugr0rmff7leel	9	dropoff	delivered	Boite au lettre du haut		2025-12-03 21:36:23.481+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-03 15:29:25.064+00	2025-12-03 21:36:23.481+00
cmjim6soy01tggr0rrqammdv6	11	dropoff	delivered			2025-12-23 20:46:23.49+00	\N	cmji9ykrt01r8gr0rdlxsatpd	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-23 13:22:14.338+00	2025-12-23 20:46:23.49+00
cmiq61x7s00o5gr0rwdjs7dx1	16	both	delivered			2025-12-03 21:43:44.053+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-03 15:33:00.136+00	2025-12-03 21:43:44.053+00
cmiq5xb9k00nwgr0rkkv0wwo9	11	dropoff	delivered			2025-12-03 21:59:33.471+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-03 15:29:25.064+00	2025-12-03 21:59:33.471+00
cmiq61x7s00oagr0rvczky8q5	20	both	en_route		\N	\N	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-03 15:33:00.136+00	2025-12-03 22:09:02.614+00
cmiq5xb9k00o0gr0r0sk5z1oy	13	pickup	delivered			2025-12-03 22:19:33.752+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-03 15:29:25.064+00	2025-12-03 22:19:33.752+00
cmjim6soy01tigr0r52zxc4fx	12	pickup	failed	Fermé mercredi & jeudi	Pas de collecte	2025-12-23 20:46:36.131+00	\N	cmji9ykrt01r8gr0rdlxsatpd	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-23 13:22:14.338+00	2025-12-23 20:46:36.131+00
cmiq5xb9k00nvgr0r4ut3jv07	14	both	delivered	À l'étage dans le placard		2025-12-03 22:27:51.644+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-03 15:29:25.064+00	2025-12-03 22:27:51.644+00
cmiq5xb9k00o3gr0rp6c1h98c	15	both	delivered			2025-12-03 22:28:11.187+00	\N	cmipuyh4a00m2gr0rwwernp8k	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-03 15:29:25.064+00	2025-12-03 22:28:11.187+00
cmjrdl4pc01vegr0rn7jxqfny	11	dropoff	delivered			2025-12-29 17:51:41.734+00	\N	cmjr3hfa901uvgr0r0wpcb9gp	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-29 16:31:22.117+00	2025-12-29 17:51:41.734+00
cmjrdl4pc01vdgr0r5flddvqp	14	pickup	delivered	À l'étage dans le placard		2025-12-29 18:52:34.787+00	\N	cmjr3hfa901uvgr0r0wpcb9gp	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-29 16:31:22.117+00	2025-12-29 18:52:34.788+00
cmiq61x7s00o8gr0ronj6ucsw	0	dropoff	delivered		Colis déposé en boîte au lettre ( SAS FERME )	2025-12-03 17:19:28.076+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-12-03 15:33:00.136+00	2025-12-03 17:19:28.076+00
cmit13wqu00ungr0r13k6wwjg	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-05 18:12:34.233+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-05 15:37:53.286+00	2025-12-05 18:12:34.233+00
cmit0haol00udgr0r66ajm3k5	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-05 18:15:45.261+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-05 15:20:18.261+00	2025-12-05 18:15:45.261+00
cmit13wqu00ulgr0rj6hk262n	1	both	delivered			2025-12-05 18:32:56.653+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-05 15:37:53.286+00	2025-12-05 18:32:56.653+00
cmit13wqu00uogr0rhw843ikb	2	pickup	delivered			2025-12-05 19:59:04.389+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-12-05 15:37:53.286+00	2025-12-05 19:59:04.389+00
cmit13wqu00uqgr0raufiuvff	3	both	delivered			2025-12-05 19:59:06.387+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-05 15:37:53.286+00	2025-12-05 19:59:06.387+00
cmit13wqu00umgr0r1opy4xz5	6	dropoff	delivered			2025-12-05 21:30:59.569+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-05 15:37:53.286+00	2025-12-05 21:30:59.569+00
cmit0haol00uegr0r0hg6fh8a	13	dropoff	delivered	Fermé les Mercredi		2025-12-05 22:13:27.391+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-05 15:20:18.261+00	2025-12-05 22:13:27.391+00
cmit13wqu00upgr0r2djk29xj	8	pickup	delivered			2025-12-05 22:31:19.808+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-05 15:37:53.286+00	2025-12-05 22:31:19.808+00
cmit13wqu00ujgr0r1xbqxsdo	9	dropoff	delivered	Boite au lettre du haut		2025-12-05 22:31:26.211+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-05 15:37:53.286+00	2025-12-05 22:31:26.211+00
cmit13wqu00usgr0r3glid1mk	10	dropoff	delivered	2306 placard étage	+ Collecte	2025-12-05 22:41:24.644+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-05 15:37:53.286+00	2025-12-05 22:41:24.644+00
cmit13wqu00ukgr0rebiwo8wx	11	dropoff	delivered		3 colis dans la boîte aux lettres	2025-12-05 23:03:19.02+00	https://www.storage.tds-transports.fr/8b54777b-3f85-4825-a144-3d3b70cb36d8.avif	cmiskw0gb00regr0rzgjxztof	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-05 15:37:53.286+00	2025-12-05 23:03:19.02+00
cmit13wqv00utgr0ro19l6e9s	12	both	delivered	Fermé mercredi & jeudi		2025-12-05 23:14:14.025+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-05 15:37:53.286+00	2025-12-05 23:14:14.025+00
cmit13wqu00urgr0roqqv0n8y	15	both	delivered			2025-12-05 23:25:49.787+00	\N	cmiskw0gb00regr0rzgjxztof	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-05 15:37:53.286+00	2025-12-05 23:25:49.787+00
cmk2rb1kg005tgr0rtscnocej	14	both	delivered	Fermé les jeudi		2026-01-06 20:27:49.963+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-06 15:40:54.064+00	2026-01-06 20:27:49.963+00
cmiq61x7s00oegr0r051zxt2y	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-03 17:51:55.963+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-03 15:33:00.136+00	2025-12-03 17:51:55.963+00
cmiq61x7s00ocgr0rl9rswab0	7	dropoff	delivered			2025-12-03 18:34:46.837+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-03 15:33:00.136+00	2025-12-03 18:34:46.837+00
cmjbhxh7a01l6gr0r1lye21do	5	both	delivered	À l'étage dans le placard		2025-12-18 21:24:09.531+00	https://www.storage.tds-transports.fr/a2b7f7a8-0931-4eef-826d-96f7b6fb8c0a.avif	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-18 13:48:37.846+00	2025-12-18 21:24:09.531+00
cmiq61x7s00odgr0rfea7swxr	8	both	delivered			2025-12-03 20:01:05.707+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-03 15:33:00.136+00	2025-12-03 20:01:05.707+00
cmiq61x7s00ofgr0r0aju2o8r	13	dropoff	delivered	Fermé les Mercredi		2025-12-03 20:48:45.134+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-03 15:33:00.136+00	2025-12-03 20:48:45.134+00
cmiq61x7s00oggr0r3qrzh99c	15	both	delivered	Fermé les Vendredi		2025-12-03 21:08:06.16+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-03 15:33:00.136+00	2025-12-03 21:08:06.16+00
cmiq61x7s00ohgr0r5izvhdh0	19	dropoff	delivered	Fermé les Mercredi		2025-12-03 22:09:02.532+00	\N	cmipus7zt00lugr0r7c0emmc1	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-03 15:33:00.136+00	2025-12-03 22:09:02.532+00
cmiyuf4te0113gr0r4fj0bm8w	1	both	delivered			2025-12-09 18:07:40.335+00	\N	cmiybqd5w00w3gr0r1sq2gfnp	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-09 17:17:16.706+00	2025-12-09 18:07:40.335+00
cmjbhxh7a01l5gr0rj14z5fm1	1	dropoff	delivered	Boite au lettre du haut		2025-12-18 20:08:56.307+00	https://www.storage.tds-transports.fr/83992e6d-ab20-4195-ab4c-36c6676552c4.avif	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-18 13:48:37.846+00	2025-12-18 20:08:56.307+00
cmjbhxh7a01lcgr0rnm75yipp	6	both	delivered			2025-12-18 21:33:10.175+00	\N	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-18 13:48:37.846+00	2025-12-18 21:33:10.175+00
cmj30hvcg019ggr0ru1ekqnm1	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-12 18:52:34.536+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-12 15:18:26.8+00	2025-12-12 18:52:34.536+00
cmj30hvcg019egr0r3mq4idch	1	both	delivered			2025-12-12 19:19:33.265+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-12 15:18:26.8+00	2025-12-12 19:19:33.265+00
cmjbhxh7a01l7gr0rfdlkub05	3	dropoff	delivered		Livrer en main propre	2025-12-18 20:15:16.26+00	\N	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-18 13:48:37.846+00	2025-12-18 20:15:16.26+00
cmj30hvcg019igr0roplusuzh	3	both	delivered			2025-12-12 20:31:13.337+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-12 15:18:26.8+00	2025-12-12 20:31:13.337+00
cmj30hvcg019kgr0r1v5xlbyl	5	dropoff	delivered	La porte de gauche		2025-12-12 21:05:22.83+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-12-12 15:18:26.8+00	2025-12-12 21:05:22.83+00
cmit0haol00u9gr0rtkz1porn	2	both	delivered			2025-12-05 18:02:28.34+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-05 15:20:18.261+00	2025-12-05 18:02:28.34+00
cmj30hvcg019fgr0rjj9w7bek	6	dropoff	delivered			2025-12-12 21:51:07.493+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-12 15:18:26.8+00	2025-12-12 21:51:07.493+00
cmit0haol00u6gr0re51ejxm9	4	dropoff	delivered			2025-12-05 18:24:48.427+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-05 15:20:18.261+00	2025-12-05 18:24:48.427+00
cmjbhxh7a01lagr0r0eve54ea	7	both	delivered	x 3612 🔔 Devant la porte		2025-12-18 22:03:29.768+00	https://www.storage.tds-transports.fr/e005574c-720f-47c4-ba58-e76d4c4de1cf.avif	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-18 13:48:37.846+00	2025-12-18 22:03:29.768+00
cmit0haol00u5gr0rblpeysyv	10	both	delivered			2025-12-05 20:45:05.574+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-05 15:20:18.261+00	2025-12-05 20:45:05.574+00
cmj30hvcg019bgr0r2mjo15xe	9	dropoff	delivered	Boite au lettre du haut		2025-12-12 23:53:44.604+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-12 15:18:26.8+00	2025-12-12 23:53:44.604+00
cmit0haol00uagr0rai7bbd7b	11	dropoff	delivered			2025-12-05 20:45:08.094+00	\N	cmisnnrzx00smgr0rki30riax	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-12-05 15:20:18.261+00	2025-12-05 20:45:08.094+00
cmit0haol00u4gr0rm132xekk	16	both	delivered			2025-12-05 23:12:52.688+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-05 15:20:18.261+00	2025-12-05 23:12:52.688+00
cmj30hvch019lgr0r4b9yc4pl	10	dropoff	delivered	2306 placard étage		2025-12-12 23:53:51.369+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-12 15:18:26.8+00	2025-12-12 23:53:51.369+00
cmit0haol00u8gr0rq42kc5lj	20	both	delivered			2025-12-05 23:34:58.169+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-05 15:20:18.261+00	2025-12-05 23:34:58.17+00
cmjbhxh7a01l8gr0rq3slrq9j	8	both	delivered			2025-12-19 00:00:48.038+00	\N	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-18 13:48:37.846+00	2025-12-19 00:00:48.038+00
cmit0haol00u7gr0rod382m15	21	dropoff	delivered			2025-12-05 23:47:43.368+00	\N	cmisnnrzx00smgr0rki30riax	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-12-05 15:20:18.261+00	2025-12-05 23:47:43.368+00
cmj30hvcg019dgr0r05rqpsyt	11	dropoff	delivered			2025-12-12 23:53:54.895+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-12 15:18:26.8+00	2025-12-12 23:53:54.895+00
cmj30hvcg019hgr0rsiwckjdh	13	pickup	delivered			2025-12-13 00:18:07.57+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-12 15:18:26.8+00	2025-12-13 00:18:07.57+00
cmjbhxh7a01lbgr0r5l9ylbdd	9	both	delivered		Pas de collecte	2025-12-19 00:01:03.772+00	\N	cmjbc89wq01jxgr0rme0b1vn7	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-18 13:48:37.846+00	2025-12-19 00:01:03.772+00
cmj30hvcg019cgr0risya11vj	14	both	delivered	À l'étage dans le placard		2025-12-13 00:33:25.676+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-12 15:18:26.8+00	2025-12-13 00:33:25.676+00
cmj30hvcg019jgr0r5jch93ea	15	both	delivered			2025-12-13 00:33:48.452+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-12 15:18:26.8+00	2025-12-13 00:33:48.452+00
cmjd4dgin01p1gr0rr6q4qrot	3	both	delivered			2025-12-19 18:09:05.792+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-19 17:04:41.183+00	2025-12-19 18:09:05.792+00
cmjd4dgin01ozgr0rcstjw6m0	6	dropoff	delivered			2025-12-19 22:06:25.062+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-19 17:04:41.183+00	2025-12-19 22:06:25.062+00
cmjd4dgin01p0gr0r3cljsjbt	8	pickup	delivered			2025-12-19 23:19:17.757+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-19 17:04:41.183+00	2025-12-19 23:19:17.757+00
cmjd4dgin01p3gr0r8a0i33dz	12	both	delivered	Fermé mercredi & jeudi		2025-12-20 00:04:44.189+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-19 17:04:41.183+00	2025-12-20 00:04:44.189+00
cmjd4dgin01p2gr0r6efj9qne	15	pickup	delivered			2025-12-20 00:49:39.534+00	\N	cmjbc7at401jigr0rw12k19ee	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-19 17:04:41.183+00	2025-12-20 00:49:39.534+00
cmj1lws67017cgr0rasbz6dv8	1	both	delivered			2025-12-11 19:05:28.366+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-11 15:42:22.111+00	2025-12-11 19:05:28.366+00
cmixb3xp200vngr0r93vyclgu	0	pickup	delivered	x 3612 🔔 Devant la porte	Pas de boite	2025-12-08 17:13:01.692+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-08 15:28:55.382+00	2025-12-08 17:13:01.692+00
cmixb3xp200vmgr0rxuw2g015	1	both	delivered			2025-12-08 17:13:14.658+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-08 15:28:55.382+00	2025-12-08 17:13:14.658+00
cmj1lws67017ggr0rjj4t5ocj	3	both	delivered			2025-12-11 19:45:09.554+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-11 15:42:22.111+00	2025-12-11 19:45:09.554+00
cmixa9h1q00vfgr0r3gyhzreo	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-08 17:33:39.103+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-08 15:05:14.126+00	2025-12-08 17:33:39.104+00
cmixb3xp200vogr0rh25x9pg1	2	dropoff	delivered			2025-12-08 17:34:36.836+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2025-12-08 15:28:55.382+00	2025-12-08 17:34:36.836+00
cmixb3xp200vrgr0rkgstge43	3	both	delivered			2025-12-08 17:56:13.532+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-08 15:28:55.382+00	2025-12-08 17:56:13.532+00
cmj1n8vih017lgr0r9wdc93cr	10	both	delivered			2025-12-11 21:14:34.947+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-11 16:19:45.929+00	2025-12-11 21:14:34.947+00
cmj1lws67017fgr0ry54qleby	8	dropoff	delivered			2025-12-11 21:21:38.849+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-11 15:42:22.111+00	2025-12-11 21:21:38.849+00
cmixb3xp200vjgr0rxrn68dyc	7	dropoff	delivered	3ème étage CODE: 2606		2025-12-08 19:46:17.55+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-12-08 15:28:55.382+00	2025-12-08 19:46:17.55+00
cmixb3xp200vqgr0r0n4r4yae	8	dropoff	delivered			2025-12-08 20:01:07.752+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-08 15:28:55.382+00	2025-12-08 20:01:07.752+00
cmixb3xp200vlgr0rv99jj11b	11	dropoff	delivered			2025-12-08 20:01:12.008+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-08 15:28:55.382+00	2025-12-08 20:01:12.008+00
cmj1lws67017bgr0ritb5ul9n	11	dropoff	delivered		+ Collecte	2025-12-11 21:54:06.262+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-11 15:42:22.111+00	2025-12-11 21:54:06.262+00
cmixb3xp200vtgr0ry9zb9mxh	12	both	delivered	Fermé mercredi & jeudi		2025-12-08 20:01:15.006+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-08 15:28:55.382+00	2025-12-08 20:01:15.006+00
cmixb3xp200vpgr0r9dk6nxf6	13	both	delivered			2025-12-08 20:01:18.917+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-08 15:28:55.382+00	2025-12-08 20:01:18.917+00
cmj1lws67017igr0ryd31hbiv	12	both	delivered	Fermé mercredi & jeudi		2025-12-11 22:10:00.377+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-11 15:42:22.111+00	2025-12-11 22:10:00.377+00
cmixb3xp200vkgr0rollhd7s9	14	both	delivered	À l'étage dans le placard		2025-12-08 20:01:21.495+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-08 15:28:55.382+00	2025-12-08 20:01:21.495+00
cmixb3xp200vsgr0r18vacxsr	15	both	delivered			2025-12-08 20:01:24.094+00	\N	cmix8rpfi00uugr0rpbz68k5w	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-08 15:28:55.382+00	2025-12-08 20:01:24.094+00
cmixa9h1q00vhgr0raxn523xg	14	both	delivered	Fermé les jeudi		2025-12-08 21:05:02.883+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-08 15:05:14.126+00	2025-12-08 21:05:02.883+00
cmj1lws67017egr0rvanysrs2	13	pickup	delivered			2025-12-11 22:24:39.961+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-11 15:42:22.111+00	2025-12-11 22:24:39.961+00
cmixa9h1q00vggr0rfwa7q5hm	15	both	delivered	Fermé les Vendredi		2025-12-08 21:05:06.321+00	\N	cmixa05bo00uxgr0rzsaez8tv	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-08 15:05:14.126+00	2025-12-08 21:05:06.321+00
cmj1lws67017agr0rhi59h91z	14	dropoff	delivered	À l'étage dans le placard		2025-12-11 22:25:13.858+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-11 15:42:22.111+00	2025-12-11 22:25:13.858+00
cmj1lws67017hgr0r4jz4wxfo	15	both	delivered			2025-12-11 22:31:24.772+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-11 15:42:22.111+00	2025-12-11 22:31:24.772+00
cmj1n8vih017kgr0rg819g28k	16	both	delivered			2025-12-11 22:57:35.541+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-11 16:19:45.929+00	2025-12-11 22:57:35.541+00
cmiyspcwk00zlgr0rfqrgtgq4	0	dropoff	delivered			2025-12-09 16:56:13.04+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-12-09 16:29:14.516+00	2025-12-09 16:56:13.04+00
cmiyspcwk00zpgr0rrketsoe9	2	both	delivered			2025-12-09 17:17:22.785+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-09 16:29:14.516+00	2025-12-09 17:17:22.785+00
cmiyspcwk00zsgr0rn7z3nw0v	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-09 17:38:55.918+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-09 16:29:14.516+00	2025-12-09 17:38:55.918+00
cmiyspcwk00zmgr0rhv12n8bf	4	pickup	delivered			2025-12-09 17:50:00.598+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-09 16:29:14.516+00	2025-12-09 17:50:00.598+00
cmiyspcwk00zjgr0ron3djtvv	5	dropoff	delivered			2025-12-09 18:08:35.188+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-12-09 16:29:14.516+00	2025-12-09 18:08:35.188+00
cmiyspcwk00zqgr0rli5uy7nw	7	both	delivered			2025-12-09 18:38:59.177+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-09 16:29:14.516+00	2025-12-09 18:38:59.177+00
cmiyspcwk00zrgr0rdzy393t9	8	both	delivered			2025-12-09 19:03:02.561+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-09 16:29:14.516+00	2025-12-09 19:03:02.561+00
cmiyspcwk00zkgr0r2k3mn2z8	10	both	delivered			2025-12-09 20:01:29.4+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-09 16:29:14.516+00	2025-12-09 20:01:29.4+00
cmiyspcwk00zogr0r22vsycco	12	dropoff	delivered			2025-12-09 20:22:36.538+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-09 16:29:14.516+00	2025-12-09 20:22:36.538+00
cmiyspcwk00ztgr0r7zzdj6p5	13	dropoff	delivered	Fermé les Mercredi		2025-12-09 20:50:29.395+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-09 16:29:14.516+00	2025-12-09 20:50:29.395+00
cmiyspcwk00zvgr0r22a8ssqc	14	pickup	delivered	Fermé les jeudi		2025-12-09 21:28:05.898+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-09 16:29:14.516+00	2025-12-09 21:28:05.898+00
cmiyspcwk00zugr0roewdxcn6	15	both	delivered	Fermé les Vendredi		2025-12-09 21:47:06.265+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-09 16:29:14.516+00	2025-12-09 21:47:06.265+00
cmiyspcwk00zigr0rex372ilm	16	both	delivered			2025-12-09 23:42:12.52+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-09 16:29:14.516+00	2025-12-09 23:42:12.52+00
cmiyspcwk00zwgr0radclx66q	19	pickup	delivered	Fermé les Mercredi		2025-12-09 23:42:14.619+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-09 16:29:14.516+00	2025-12-09 23:42:14.619+00
cmiyspcwk00zngr0rswg8xcmm	20	both	delivered			2025-12-09 23:42:17.114+00	\N	cmiybp5eh00vugr0ri6xopbff	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-09 16:29:14.516+00	2025-12-09 23:42:17.114+00
cmj06t9880130gr0rfb2s3dl8	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-10 17:16:40.544+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-10 15:51:57.176+00	2025-12-10 17:16:40.544+00
cmj06t988012ygr0r5wlkomgl	1	both	delivered			2025-12-10 17:37:27.678+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-10 15:51:57.176+00	2025-12-10 17:37:27.678+00
cmj06t9880132gr0r3heurqts	3	both	delivered			2025-12-10 18:15:33.657+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-10 15:51:57.176+00	2025-12-10 18:15:33.657+00
cmj06t988012zgr0rbkwdylqh	6	dropoff	delivered			2025-12-10 19:58:00.687+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-10 15:51:57.176+00	2025-12-10 19:58:00.688+00
cmj06t987012vgr0rt3teu03q	9	both	delivered	Boite au lettre du haut		2025-12-10 20:58:30.951+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-10 15:51:57.176+00	2025-12-10 20:58:30.951+00
cmk2xcic9005vgr0r7awkpvap	3	pickup	delivered	Boite au lettre du haut		2026-01-06 21:32:17.872+00	\N	cmk2d2oh6004agr0ry04b70g5	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-06 18:30:00.153+00	2026-01-06 21:32:17.873+00
cmj06t9880134gr0rupyvpn0q	10	dropoff	delivered	2306 placard étage	+ Collecte	2025-12-10 21:05:26.965+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-10 15:51:57.176+00	2025-12-10 21:05:26.965+00
cmj06t987012xgr0rsfcd2mub	11	dropoff	delivered		+ Collecte 	2025-12-10 21:29:10.65+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-10 15:51:57.176+00	2025-12-10 21:29:10.65+00
cmk2xcic9005xgr0ruq0uxqi8	4	dropoff	delivered			2026-01-06 21:54:15.044+00	\N	cmk2d2oh6004agr0ry04b70g5	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-06 18:30:00.153+00	2026-01-06 21:54:15.044+00
cmj06t9880131gr0rv03on1xk	13	pickup	delivered			2025-12-10 21:50:26.458+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-10 15:51:57.176+00	2025-12-10 21:50:26.458+00
cmj06t987012wgr0rhv7fzt59	14	both	delivered	À l'étage dans le placard		2025-12-10 22:33:46.959+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-10 15:51:57.176+00	2025-12-10 22:33:46.959+00
cmj8r2csb01fpgr0rct14gj20	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-16 17:25:49.348+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-16 15:41:03.419+00	2025-12-16 17:25:49.348+00
cmj06t9880133gr0rwii6xypl	15	both	delivered			2025-12-10 22:34:03.179+00	\N	cmizqrzf9011cgr0r091vzsvr	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-10 15:51:57.176+00	2025-12-10 22:34:03.179+00
cmk2xcic90062gr0rfnhh39xx	5	pickup	delivered	Fermé mercredi & jeudi	Pas de boite	2026-01-06 21:54:50.91+00	\N	cmk2d2oh6004agr0ry04b70g5	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-06 18:30:00.153+00	2026-01-06 21:54:50.91+00
cmjsnt9an01vugr0r2380jukr	9	dropoff	delivered	Boite au lettre du haut		2025-12-30 17:07:39.572+00	https://www.storage.tds-transports.fr/84f0beec-be53-4d00-a94a-7aacae61e91d.avif	cmjslrwey01vogr0raubff1en	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-30 14:05:23.662+00	2025-12-30 17:07:39.572+00
cmjsnt9an01vvgr0rlxsq0m26	11	dropoff	delivered			2025-12-30 17:35:56.052+00	\N	cmjslrwey01vogr0raubff1en	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-30 14:05:23.662+00	2025-12-30 17:35:56.052+00
cmjsnt9an01vwgr0r8jazcjsg	12	pickup	delivered	Fermé mercredi & jeudi	Pas de collecte	2025-12-30 18:34:00.837+00	\N	cmjslrwey01vogr0raubff1en	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-30 14:05:23.662+00	2025-12-30 18:34:00.837+00
cmj8r2csb01figr0rl191tv8e	4	dropoff	delivered			2025-12-16 17:38:31.325+00	\N	cmj8bo34z01degr0r9n5aktqx	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-16 15:41:03.419+00	2025-12-16 17:38:31.325+00
cmj8uyv2s01g7gr0r2mguz3wk	1	both	delivered			2025-12-16 18:44:42.4+00	\N	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-16 17:30:18.964+00	2025-12-16 18:44:42.4+00
cmj8uyv2s01g9gr0rroc1dp5e	3	both	delivered			2025-12-16 18:44:45.557+00	\N	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-16 17:30:18.964+00	2025-12-16 18:44:45.557+00
cmj8uyv2s01g4gr0rozt9ad9u	9	both	delivered	Boite au lettre du haut	Collecte posé dans la boite au lettre du bas .	2025-12-16 20:24:49.532+00	https://www.storage.tds-transports.fr/b88a9506-abe0-45fb-837f-d90a38ad4871.avif	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-16 17:30:18.964+00	2025-12-16 20:24:49.533+00
cmj8uyv2s01gbgr0roz6is1si	10	dropoff	delivered	2306 placard étage		2025-12-16 20:58:17.158+00	\N	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-16 17:30:18.964+00	2025-12-16 20:58:17.158+00
cmj1n8vih017pgr0r9q5g6d4m	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-11 18:02:53.251+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-11 16:19:45.929+00	2025-12-11 18:02:53.251+00
cmj8uyv2s01g6gr0rmwovt9uy	11	dropoff	delivered			2025-12-16 20:58:30.031+00	\N	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-16 17:30:18.964+00	2025-12-16 20:58:30.031+00
cmj1n8vih017ngr0rr92dt4d5	7	both	delivered			2025-12-11 18:24:33.729+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-11 16:19:45.929+00	2025-12-11 18:24:33.729+00
cmj1n8vih017ogr0rvsj5uk9f	8	both	delivered			2025-12-11 18:55:20.665+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-11 16:19:45.929+00	2025-12-11 18:55:20.665+00
cmj8uyv2s01gcgr0rjlq5ofpd	12	pickup	delivered	Fermé mercredi & jeudi		2025-12-16 22:31:58.674+00	\N	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-16 17:30:18.964+00	2025-12-16 22:31:58.674+00
cmj1n8vih017qgr0r4cyrrpe5	13	both	delivered	Fermé les Mercredi		2025-12-11 21:14:37.378+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-11 16:19:45.929+00	2025-12-11 21:14:37.378+00
cmj1n8vih017sgr0rr6r0dl7q	14	dropoff	delivered	Fermé les jeudi		2025-12-11 21:14:39.849+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-11 16:19:45.929+00	2025-12-11 21:14:39.849+00
cmj8uyv2s01g8gr0rkmrg1uoe	13	both	delivered			2025-12-16 22:32:01.992+00	\N	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2025-12-16 17:30:18.964+00	2025-12-16 22:32:01.992+00
cmj1n8vih017rgr0rft8m07nc	15	pickup	delivered	Fermé les Vendredi		2025-12-11 21:29:04.28+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-11 16:19:45.929+00	2025-12-11 21:29:04.28+00
cmj1n8vih017tgr0rxngy8fz2	19	both	delivered	Fermé les Mercredi		2025-12-11 22:57:40.437+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-11 16:19:45.929+00	2025-12-11 22:57:40.437+00
cmj8uyv2s01g5gr0rlwgozcrx	14	both	delivered	À l'étage dans le placard		2025-12-16 22:32:05.038+00	\N	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-16 17:30:18.964+00	2025-12-16 22:32:05.038+00
cmj1n8vih017mgr0rjhfxekgl	20	both	delivered			2025-12-11 22:57:42.44+00	\N	cmj16fh7d014dgr0rcnqd3oxy	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-11 16:19:45.929+00	2025-12-11 22:57:42.44+00
cmj8uyv2s01gagr0rlpvo2gzq	15	both	delivered			2025-12-16 22:32:07.433+00	\N	cmj8bkb3m01d5gr0rknqf6duh	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-16 17:30:18.964+00	2025-12-16 22:32:07.433+00
cmj32905d01afgr0r01rlmzm2	14	both	delivered	Fermé les jeudi		2025-12-12 21:31:01.327+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-12 16:07:32.353+00	2025-12-12 21:31:01.328+00
cmj32905d01aggr0ria5mpcdo	19	both	delivered	Fermé les Mercredi		2025-12-12 23:44:59.827+00	\N	cmj2l37mw0182gr0rwtrw4him	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-12 16:07:32.353+00	2025-12-12 23:44:59.827+00
cmj30hvch019mgr0r7m0ajnf3	12	both	delivered	Fermé mercredi & jeudi		2025-12-13 00:18:05.047+00	\N	cmj2jkkj9017ugr0rmbs0h6ao	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-12 15:18:26.8+00	2025-12-13 00:18:05.047+00
cmj09qlmf0144gr0r5869yl8i	2	pickup	delivered			2025-12-10 18:13:50.35+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-10 17:13:52.118+00	2025-12-10 18:13:50.35+00
cmj09qlmf0148gr0r7md6vze9	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-10 18:27:34.072+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-10 17:13:52.118+00	2025-12-10 18:27:34.072+00
cmk2xcic9005zgr0rtq32b3nn	7	pickup	delivered	x 3612 🔔 Devant la porte		2026-01-06 22:27:50.565+00	\N	cmk2d2oh6004agr0ry04b70g5	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-06 18:30:00.153+00	2026-01-06 22:27:50.565+00
cmj09qlmf0141gr0rotzj4dvb	4	both	delivered			2025-12-10 18:36:55.383+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-10 17:13:52.118+00	2025-12-10 18:36:55.383+00
cmj09qlmf0146gr0r34w9ked2	7	both	delivered			2025-12-10 18:58:05.317+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-10 17:13:52.118+00	2025-12-10 18:58:05.317+00
cmj09qlmf0147gr0rfn4bawmx	8	both	delivered			2025-12-10 19:21:24.465+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-10 17:13:52.118+00	2025-12-10 19:21:24.465+00
cmkr45bpt003th90q64pz22q1	5	dropoff	delivered			2026-01-23 17:30:27.103+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-23 16:46:50.513+00	2026-01-23 17:30:27.103+00
cmj09qlmf0140gr0rc7rof0mq	10	both	delivered			2025-12-10 22:24:07.724+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-10 17:13:52.118+00	2025-12-10 22:24:07.724+00
cmj09qlmf0145gr0re5v0p87l	11	both	delivered			2025-12-10 22:24:12.137+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-12-10 17:13:52.118+00	2025-12-10 22:24:12.137+00
cmkr45bpt003uh90qkupb06jb	11	both	delivered			2026-01-23 19:38:24.714+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-23 16:46:50.513+00	2026-01-23 19:38:24.714+00
cmj09qlmf0143gr0rbklyvcij	12	both	delivered			2025-12-10 22:24:14.101+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-10 17:13:52.118+00	2025-12-10 22:24:14.101+00
cmj09qlmf0149gr0r49ev80zj	13	dropoff	delivered	Fermé les Mercredi		2025-12-10 22:24:15.815+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-10 17:13:52.118+00	2025-12-10 22:24:15.815+00
cmjinsf1201tugr0rpyjkee5h	5	both	delivered			2025-12-23 16:12:29.163+00	\N	cmjif84mr01regr0ru28hcgon	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-12-23 14:07:02.678+00	2025-12-23 16:12:29.163+00
cmj09qlmf014bgr0rglo9ylz6	14	pickup	failed	Fermé les jeudi	Pas de colis en boîte au lettre ( ferme le jeudi ) 	2025-12-10 22:26:09.881+00	https://www.storage.tds-transports.fr/a42ed9e3-7728-44a1-ad93-183e2f6fb40c.avif	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-10 17:13:52.118+00	2025-12-10 22:26:09.881+00
cmj09qlmf014agr0rj9yyhr7z	15	both	delivered	Fermé les Vendredi		2025-12-10 22:43:05.749+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-10 17:13:52.118+00	2025-12-10 22:43:05.749+00
cmjinsf1201tvgr0rgn8kt69j	10	pickup	delivered			2025-12-23 17:59:59.655+00	\N	cmjif84mr01regr0ru28hcgon	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-23 14:07:02.678+00	2025-12-23 17:59:59.655+00
cmjblpxr401m2gr0rm8qovmy1	4	pickup	delivered			2025-12-18 19:06:02.123+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-18 15:34:44.512+00	2025-12-18 19:06:02.123+00
cmjblpxr401m5gr0r5q7295fl	7	both	delivered			2025-12-18 19:53:09.427+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-18 15:34:44.512+00	2025-12-18 19:53:09.427+00
cmjinsf1201txgr0rj0vid03h	12	dropoff	delivered			2025-12-23 18:23:29.643+00	\N	cmjif84mr01regr0ru28hcgon	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-23 14:07:02.678+00	2025-12-23 18:23:29.643+00
cmjblpxr401m6gr0r0pxejin3	8	both	delivered			2025-12-18 19:53:11.458+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-18 15:34:44.512+00	2025-12-18 19:53:11.458+00
cmjblpxr401m1gr0rxyndow7e	10	both	delivered			2025-12-18 20:49:16.31+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-18 15:34:44.512+00	2025-12-18 20:49:16.31+00
cmjinsf1301tygr0rxm7o78jh	13	both	delivered	Fermé les Mercredi		2025-12-23 18:54:40.242+00	\N	cmjif84mr01regr0ru28hcgon	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-23 14:07:02.678+00	2025-12-23 18:54:40.242+00
cmjblpxr401m4gr0rsj3zxccb	12	dropoff	delivered			2025-12-18 21:11:04.776+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-18 15:34:44.512+00	2025-12-18 21:11:04.776+00
cmjblpxr401m7gr0r5940d9uf	13	dropoff	delivered	Fermé les Mercredi		2025-12-18 21:38:56.452+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-18 15:34:44.512+00	2025-12-18 21:38:56.452+00
cmjinsf1301u0gr0rwtfwbpuz	14	pickup	delivered	Fermé les jeudi		2025-12-23 19:34:53.351+00	\N	cmjif84mr01regr0ru28hcgon	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-23 14:07:02.678+00	2025-12-23 19:34:53.351+00
cmjblpxr401m9gr0r16cxstjd	14	both	delivered	Fermé les jeudi		2025-12-18 22:10:17.418+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-18 15:34:44.512+00	2025-12-18 22:10:17.418+00
cmj09qlmf013zgr0relpk68t0	16	both	delivered			2025-12-10 23:43:10.054+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-10 17:13:52.118+00	2025-12-10 23:43:10.055+00
cmjblpxr401m8gr0rz1e580dc	15	pickup	delivered	Fermé les Vendredi		2025-12-18 22:26:24.15+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-18 15:34:44.512+00	2025-12-18 22:26:24.15+00
cmj09qlmf014cgr0r3zq0t0v9	19	dropoff	delivered	Fermé les Mercredi		2025-12-10 23:43:21.088+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-10 17:13:52.118+00	2025-12-10 23:43:21.088+00
cmjinsf1301tzgr0riz86e75g	15	both	delivered	Fermé les Vendredi		2025-12-23 19:50:07.774+00	\N	cmjif84mr01regr0ru28hcgon	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-23 14:07:02.678+00	2025-12-23 19:50:07.774+00
cmj09qlmf0142gr0rx6lkjn82	20	dropoff	delivered			2025-12-11 00:10:15.356+00	\N	cmizqvbe0011jgr0r6u8nd7iv	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-10 17:13:52.118+00	2025-12-11 00:10:15.356+00
cmjblpxr301m0gr0r7f4zeh34	16	both	delivered			2025-12-18 23:04:17.633+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-18 15:34:44.512+00	2025-12-18 23:04:17.633+00
cmj1lws67017dgr0r09bf4y97	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-11 18:40:39.05+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-11 15:42:22.111+00	2025-12-11 18:40:39.05+00
cmj1lws670179gr0rhmcd1a7s	9	dropoff	delivered	Boite au lettre du haut		2025-12-11 21:23:49.332+00	\N	cmj186uog014tgr0rl57u5t4o	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-11 15:42:22.111+00	2025-12-11 21:23:49.332+00
cmjblpxr401m3gr0rbbh2pe4s	20	both	delivered			2025-12-19 01:45:28.26+00	\N	cmjb9bhgd01j2gr0rdxffr3i6	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-18 15:34:44.512+00	2025-12-19 01:45:28.26+00
cmjinsf1201ttgr0rpf9xpn9f	16	dropoff	delivered			2025-12-23 20:27:08.854+00	\N	cmjif84mr01regr0ru28hcgon	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-23 14:07:02.678+00	2025-12-23 20:27:08.854+00
cmjinsf1201twgr0r7jjpf768	20	dropoff	delivered			2025-12-23 21:08:02.504+00	\N	cmjif84mr01regr0ru28hcgon	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-23 14:07:02.678+00	2025-12-23 21:08:02.504+00
cmjtxnuc8000bgr0r9hn5dlho	2	pickup	planned		\N	\N	\N	cmjtxnoxu0007gr0rdmc2emcr	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-31 11:28:53.336+00	2025-12-31 11:28:53.336+00
cmju03506000jgr0r2cahe1yz	0	pickup	delivered	x 3612 🔔 Devant la porte		2025-12-31 15:32:10.896+00	\N	cmjtq23qo0000gr0rlyrityqs	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-31 12:36:46.23+00	2025-12-31 15:32:10.897+00
cmju03506000igr0r9q4u0l12	11	pickup	delivered			2025-12-31 15:32:16.977+00	\N	cmjtq23qo0000gr0rlyrityqs	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-31 12:36:46.23+00	2025-12-31 15:32:16.977+00
cmj79dwut01c8gr0r0v6qhdj2	0	dropoff	delivered			2025-12-15 17:32:29.096+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-12-15 14:38:23.381+00	2025-12-15 17:32:29.096+00
cmk2xcic9005ygr0rochbkocb	0	both	delivered			2026-01-06 19:24:05.137+00	\N	cmk2d2oh6004agr0ry04b70g5	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-06 18:30:00.153+00	2026-01-06 19:24:05.137+00
cmj79dwut01cbgr0r9sy28ina	2	dropoff	delivered			2025-12-15 17:46:29.32+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2025-12-15 14:38:23.381+00	2025-12-15 17:46:29.32+00
cmjju9up901u3gr0ryold6vhv	11	dropoff	delivered		+ Collecte	2025-12-24 14:14:44.327+00	\N	cmjju9up901u1gr0r5226isq3	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-24 09:56:20.013+00	2025-12-24 14:14:44.327+00
cmj79dwut01cdgr0rrgnooymh	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2025-12-15 17:57:32.486+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-15 14:38:23.381+00	2025-12-15 17:57:32.486+00
cmkh177f000vtgr0rb93uxv9p	16	both	delivered			2026-01-16 22:51:27.799+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-16 15:26:37.644+00	2026-01-16 22:51:27.799+00
cmj79dwut01c6gr0r1fc7v3eg	5	both	delivered			2025-12-15 18:16:10.79+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-12-15 14:38:23.381+00	2025-12-15 18:16:10.79+00
cmj79dwut01ccgr0r02sjjld5	8	both	delivered			2025-12-15 19:00:14.338+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-15 14:38:23.381+00	2025-12-15 19:00:14.338+00
cmk2rb1kg005sgr0r5jewzf8u	15	both	delivered	Fermé les Vendredi		2026-01-06 20:43:04.01+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-06 15:40:54.064+00	2026-01-06 20:43:04.01+00
cmj79dwut01c7gr0rrdww8qbz	10	both	delivered			2025-12-15 19:59:10.599+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-15 14:38:23.381+00	2025-12-15 19:59:10.599+00
cmkh177f000vygr0rxe64l2tc	20	pickup	delivered			2026-01-17 00:00:19.151+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-16 15:26:37.644+00	2026-01-17 00:00:19.151+00
cmj79dwut01cagr0ri703wf1u	12	dropoff	delivered			2025-12-15 20:21:53.352+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-15 14:38:23.381+00	2025-12-15 20:21:53.352+00
cmk2xcic9005wgr0rrfi61bba	2	both	delivered	3ème étage CODE: 2606		2026-01-06 21:16:02.86+00	https://www.storage.tds-transports.fr/369330ab-e874-45c1-b5ec-01e28e2868bb.avif	cmk2d2oh6004agr0ry04b70g5	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-06 18:30:00.153+00	2026-01-06 21:16:02.86+00
cmj79dwut01cegr0rawl3csog	13	both	delivered	Fermé les Mercredi		2025-12-15 22:19:24.416+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-15 14:38:23.381+00	2025-12-15 22:19:24.416+00
cmk2rb1kg005kgr0rsxu5tdnu	16	both	delivered			2026-01-06 22:45:42.948+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-06 15:40:54.064+00	2026-01-06 22:45:42.948+00
cmj79dwut01cggr0r2nkf93ap	14	both	delivered	Fermé les jeudi		2025-12-15 22:19:26.639+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-15 14:38:23.381+00	2025-12-15 22:19:26.639+00
cmk2rb1kg005ngr0rk17wxw4g	20	pickup	delivered			2026-01-06 22:45:48.171+00	\N	cmk2d1exv0041gr0rcpnzmxbr	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-06 15:40:54.064+00	2026-01-06 22:45:48.171+00
cmj79dwut01cfgr0r1ht16orq	15	both	delivered	Fermé les Vendredi		2025-12-15 22:19:29.261+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-15 14:38:23.381+00	2025-12-15 22:19:29.261+00
cmj79dwut01c5gr0rznr2a3ia	16	both	delivered			2025-12-15 22:19:32.611+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-15 14:38:23.381+00	2025-12-15 22:19:32.611+00
cmkh177f000vwgr0rdvg4il5p	21	dropoff	delivered			2026-01-17 00:00:21.825+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2026-01-16 15:26:37.644+00	2026-01-17 00:00:21.825+00
cmj79dwut01chgr0rpo3f8073	19	dropoff	delivered	Fermé les Mercredi		2025-12-15 22:42:42.307+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-15 14:38:23.381+00	2025-12-15 22:42:42.307+00
cmjmqw93101u9gr0r555hwoel	7	dropoff	delivered			2025-12-26 12:33:17.231+00	\N	cmjmqw93101u7gr0r8j1ijxro	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-26 10:45:05.149+00	2025-12-26 12:33:17.231+00
cmjmqw93101uagr0ra5zgh96d	10	both	delivered			2025-12-26 13:59:54.878+00	\N	cmjmqw93101u7gr0r8j1ijxro	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-26 10:45:05.149+00	2025-12-26 13:59:54.878+00
cmkr45bpu003yh90q9o9dlmhs	10	dropoff	delivered			2026-01-23 19:38:22.128+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-23 16:46:50.513+00	2026-01-23 19:38:22.128+00
cmjmqw93101ubgr0r3o3oq47l	14	dropoff	delivered	Fermé les jeudi		2025-12-26 15:20:11.647+00	\N	cmjmqw93101u7gr0r8j1ijxro	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-26 10:45:05.149+00	2025-12-26 15:20:11.647+00
cmjmqw93101ucgr0rhi6dwmft	16	dropoff	delivered			2025-12-26 16:14:13.947+00	\N	cmjmqw93101u7gr0r8j1ijxro	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-26 10:45:05.149+00	2025-12-26 16:14:13.947+00
cmkr45bpu003wh90qscs0d79w	12	dropoff	delivered			2026-01-23 19:58:14.67+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-23 16:46:50.513+00	2026-01-23 19:58:14.67+00
cmjmsgvwx01ujgr0rdt0kzrbq	0	dropoff	delivered	x 3612 🔔 Devant la porte	Devant la porte 	2025-12-26 18:48:44.243+00	\N	cmjmrfhdv01udgr0rr7r8ap9e	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-26 11:29:07.473+00	2025-12-26 18:48:44.243+00
cmjmsgvwx01uigr0rcoqwq4dm	1	dropoff	delivered			2025-12-26 18:48:48.732+00	\N	cmjmrfhdv01udgr0rr7r8ap9e	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-26 11:29:07.473+00	2025-12-26 18:48:48.732+00
cmj79dwut01c9gr0rlh3hdhwo	20	pickup	delivered			2025-12-15 23:28:37.771+00	\N	cmj6x9psy01ahgr0r71j3cpaw	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-15 14:38:23.381+00	2025-12-15 23:28:37.772+00
cmjsntxaa01w6gr0ru9vslvfd	12	dropoff	delivered			2025-12-30 15:32:38.496+00	\N	cmjskt4f701vggr0rpvtasbnj	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-30 14:05:54.754+00	2025-12-30 15:32:38.496+00
cmjsntxaa01w7gr0rwm6i2ozr	14	both	delivered	Fermé les jeudi		2025-12-30 16:32:42.955+00	\N	cmjskt4f701vggr0rpvtasbnj	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-30 14:05:54.754+00	2025-12-30 16:32:42.955+00
cmjsntxaa01w5gr0rn4eiyyxa	16	both	delivered			2025-12-30 17:37:35.616+00	\N	cmjskt4f701vggr0rpvtasbnj	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-30 14:05:54.754+00	2025-12-30 17:37:35.616+00
cmkh177f000w1gr0rs60k2bow	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-16 17:54:34.115+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-16 15:26:37.644+00	2026-01-16 17:54:34.115+00
cmkh177f000vugr0rch0n487k	5	pickup	delivered			2026-01-16 18:12:38.686+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-16 15:26:37.644+00	2026-01-16 18:12:38.686+00
cmkh177f000vzgr0rij8ey6fr	7	dropoff	delivered			2026-01-16 18:35:00.177+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-16 15:26:37.644+00	2026-01-16 18:35:00.177+00
cmkh177f000w0gr0rehe44frn	8	both	delivered			2026-01-16 19:06:05.676+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-16 15:26:37.644+00	2026-01-16 19:06:05.676+00
cmkh177f000vxgr0rh46pkwke	9	dropoff	delivered			2026-01-16 19:33:15.8+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2026-01-16 15:26:37.644+00	2026-01-16 19:33:15.8+00
cmkh177f000vvgr0rbndjszlt	10	both	delivered			2026-01-16 20:12:19.196+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-16 15:26:37.644+00	2026-01-16 20:12:19.196+00
cmkh177f000w2gr0r77rr9fek	13	both	delivered	Fermé les Mercredi		2026-01-16 21:01:05.104+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-16 15:26:37.644+00	2026-01-16 21:01:05.104+00
cmjjufdiq01u6gr0rt6re9o5m	10	both	delivered			2025-12-24 16:16:02.341+00	\N	cmjjufdiq01u4gr0rf2r26r8j	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-24 10:00:37.682+00	2025-12-24 16:16:02.341+00
cmjcy8ajm01nfgr0r1b92g91p	5	dropoff	delivered			2025-12-19 17:20:19.577+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2025-12-19 14:12:42.466+00	2025-12-19 17:20:19.577+00
cmjcy8ajm01nlgr0rz7gqv9ga	7	both	delivered			2025-12-19 17:54:09.343+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-19 14:12:42.466+00	2025-12-19 17:54:09.343+00
cmjcy8ajm01nmgr0rwr9ze9p4	8	both	delivered			2025-12-19 18:24:59.684+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-19 14:12:42.466+00	2025-12-19 18:24:59.684+00
cmjcy8ajm01nigr0r7vutq6vr	9	dropoff	delivered			2025-12-19 18:40:36.727+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2025-12-19 14:12:42.466+00	2025-12-19 18:40:36.727+00
cmjcy8ajm01nggr0revjcqp3o	10	both	delivered			2025-12-19 20:18:04.464+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-19 14:12:42.466+00	2025-12-19 20:18:04.464+00
cmjcy8ajm01nkgr0rzk2jbfav	12	dropoff	delivered			2025-12-19 20:18:07.292+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-19 14:12:42.466+00	2025-12-19 20:18:07.292+00
cmjcy8ajm01nngr0rimafxpfe	13	dropoff	delivered	Fermé les Mercredi		2025-12-19 20:18:11.545+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-19 14:12:42.466+00	2025-12-19 20:18:11.545+00
cmk47hy57008ngr0rrgfn4p4e	7	dropoff	delivered			2026-01-07 17:15:00.828+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-07 16:01:56.251+00	2026-01-07 17:15:00.828+00
cmjcy8ajm01nogr0ry5dg0ebq	15	both	delivered	Fermé les Vendredi		2025-12-19 22:35:23.324+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-19 14:12:42.466+00	2025-12-19 22:35:23.324+00
cmjcy8ajm01negr0rdd8m3cpn	16	pickup	delivered			2025-12-19 22:35:25.237+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-19 14:12:42.466+00	2025-12-19 22:35:25.237+00
cmk47hy57008ogr0rnmtbuwhp	8	both	delivered			2026-01-07 17:45:48.553+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-07 16:01:56.251+00	2026-01-07 17:45:48.553+00
cmjcy8ajm01njgr0rtfrfmxgs	20	dropoff	delivered			2025-12-19 22:35:26.911+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-19 14:12:42.466+00	2025-12-19 22:35:26.911+00
cmja7sv1901irgr0r854z6c16	16	both	delivered			2025-12-17 22:41:43.747+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-17 16:17:20.157+00	2025-12-17 22:41:43.747+00
cmjcy8ajm01nhgr0rbojp6v4u	21	dropoff	delivered			2025-12-19 22:35:30.56+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-12-19 14:12:42.466+00	2025-12-19 22:35:30.56+00
cmk47hy57008qgr0rhx2la7cn	13	dropoff	delivered	Fermé les Mercredi		2026-01-07 20:13:36.971+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-07 16:01:56.251+00	2026-01-07 20:13:36.971+00
cmk47hy57008rgr0rx4p4dl5r	15	both	delivered	Fermé les Vendredi		2026-01-07 20:36:48.984+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-07 16:01:56.251+00	2026-01-07 20:36:48.984+00
cmk47hy57008mgr0rrx32au20	20	pickup	delivered			2026-01-07 23:09:01.248+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-07 16:01:56.251+00	2026-01-07 23:09:01.248+00
cmja7ssd901ijgr0r11mzr4fl	1	both	delivered			2025-12-17 17:39:26.17+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-17 16:17:16.701+00	2025-12-17 17:39:26.17+00
cmja7ssd901ingr0r7tk0honw	2	both	delivered			2025-12-17 18:15:11.259+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-17 16:17:16.701+00	2025-12-17 18:15:11.259+00
cmja7sv1901ixgr0rz47vte3v	8	both	delivered			2025-12-17 19:25:07.538+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-17 16:17:20.157+00	2025-12-17 19:25:07.538+00
cmja7sv1901isgr0rnbst71qf	10	both	delivered			2025-12-17 19:25:10.055+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-17 16:17:20.157+00	2025-12-17 19:25:10.055+00
cmja7sv1901iwgr0r7za0b5hb	11	dropoff	delivered			2025-12-17 19:25:12.001+00	\N	cmja655zb01h1gr0rgbtm3o07	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2025-12-17 16:17:20.157+00	2025-12-17 19:25:12.001+00
cmja7sv1901izgr0r0ax8mtjc	15	both	delivered	Fermé les Vendredi		2025-12-17 20:56:23.46+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-17 16:17:20.157+00	2025-12-17 20:56:23.46+00
cmja7ssd901imgr0rfmizilli	4	dropoff	delivered			2025-12-17 21:03:32.643+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2025-12-17 16:17:16.701+00	2025-12-17 21:03:32.644+00
cmja7sv1901j1gr0rhh6dbq6i	19	dropoff	delivered	Fermé les Mercredi		2025-12-17 22:41:46.045+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2025-12-17 16:17:20.157+00	2025-12-17 22:41:46.045+00
cmja7sv1901itgr0raypljkid	0	dropoff	delivered			2025-12-17 16:48:00.03+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-12-17 16:17:20.157+00	2025-12-17 16:48:00.03+00
cmja7ssd901ilgr0rqtcst4ji	0	both	delivered	x 3612 🔔 Devant la porte		2025-12-17 17:06:40.946+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2025-12-17 16:17:16.701+00	2025-12-17 17:06:40.946+00
cmja7sv1901iygr0ri91dkx0w	3	pickup	failed	753B Fermé Lundi aprèm et Vendredi	Le docteur a appelé pour dire qu’il n’y avais pas de ramasse 	2025-12-17 17:31:16.149+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2025-12-17 16:17:20.157+00	2025-12-17 17:31:16.149+00
cmja7sv1901ivgr0rs64148iv	12	both	delivered			2025-12-17 19:46:50.03+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-17 16:17:20.157+00	2025-12-17 19:46:50.03+00
cmja7ssd901ikgr0rinngw6n2	3	dropoff	delivered			2025-12-17 20:16:54.743+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2025-12-17 16:17:16.701+00	2025-12-17 20:16:54.743+00
cmja7sv1901j0gr0r7rinxvht	14	pickup	delivered	Fermé les jeudi		2025-12-17 20:40:49.781+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-17 16:17:20.157+00	2025-12-17 20:40:49.781+00
cmja7ssd901ifgr0r8v7u9m3b	5	dropoff	delivered	Boite au lettre du haut		2025-12-17 21:03:55.939+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-17 16:17:16.701+00	2025-12-17 21:03:55.939+00
cmja7ssd901iggr0rpiih2c0k	6	dropoff	delivered	3ème étage CODE: 2606		2025-12-17 21:21:40.693+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2025-12-17 16:17:16.701+00	2025-12-17 21:21:40.693+00
cmja7ssd901ipgr0rqnnetdmv	7	dropoff	delivered	La porte de gauche		2025-12-17 22:07:09.573+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2025-12-17 16:17:16.701+00	2025-12-17 22:07:09.573+00
cmja7ssd901iigr0ro021egsu	8	both	delivered			2025-12-17 22:07:15.928+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-17 16:17:16.701+00	2025-12-17 22:07:15.928+00
cmja7ssd901ihgr0rx543zkc8	9	both	delivered	À l'étage dans le placard		2025-12-17 22:35:24.061+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-17 16:17:16.701+00	2025-12-17 22:35:24.061+00
cmja7ssd901iogr0r3bol6lad	10	both	delivered			2025-12-17 22:35:28.301+00	\N	cmj9uh3uo01gegr0ripjmhxga	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2025-12-17 16:17:16.701+00	2025-12-17 22:35:28.301+00
cmja7sv1901iugr0r2e7ofadt	20	dropoff	delivered			2025-12-17 22:41:48.732+00	\N	cmja655zb01h1gr0rgbtm3o07	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-17 16:17:20.157+00	2025-12-17 22:41:48.732+00
cmkmt1iwu017bgr0r33c1pb9b	15	pickup	delivered	Fermé les Mercredi		2026-01-21 00:24:41.577+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-20 16:24:52.733+00	2026-01-21 00:24:41.577+00
cmjcy8ajm01npgr0rylt96cxf	14	both	delivered	Fermé les jeudi		2025-12-19 20:57:43.732+00	\N	cmjcrukbt01mqgr0rtha1l1lc	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-19 14:12:42.466+00	2025-12-19 20:57:43.732+00
cmkmt1iwt0171gr0r0afhscz5	16	both	delivered			2026-01-21 01:00:43.85+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-20 16:24:52.733+00	2026-01-21 01:00:43.85+00
cmkr45bpu0040h90q13irkkzu	8	both	delivered			2026-01-23 18:34:14.111+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-23 16:46:50.513+00	2026-01-23 18:34:14.112+00
cmkr45bpu0042h90qbevadumx	13	dropoff	delivered	Fermé les Mercredi		2026-01-23 20:25:29.491+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-23 16:46:50.513+00	2026-01-23 20:25:29.491+00
cmklebu24010sgr0rhjjnzk1z	1	both	delivered			2026-01-19 18:24:23.05+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-19 16:45:13.323+00	2026-01-19 18:24:23.05+00
cmjwutry2002wgr0rvrg78hiw	19	dropoff	delivered	Fermé les Mercredi		2026-01-02 20:30:28.902+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-02 12:32:49.85+00	2026-01-02 20:30:28.902+00
cmjwutry2002vgr0rtj8hgtvi	14	both	delivered	Fermé les jeudi		2026-01-02 19:11:03.863+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-02 12:32:49.85+00	2026-01-02 19:11:03.863+00
cmjwutry2002ugr0rnu6btpxn	15	dropoff	delivered	Fermé les Vendredi		2026-01-02 19:27:57.758+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-02 12:32:49.85+00	2026-01-02 19:27:57.758+00
cmjwtx99d0022gr0rtar3ewrh	13	both	delivered			2026-01-02 20:18:18.399+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-02 12:07:32.641+00	2026-01-02 20:18:18.399+00
cmk17c45m003dgr0r2if88gow	3	dropoff	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-05 16:06:28.833+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-05 13:34:05.578+00	2026-01-05 16:06:28.833+00
cmk17c45m0039gr0rkewka9hj	5	dropoff	delivered			2026-01-05 16:30:28.139+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-05 13:34:05.578+00	2026-01-05 16:30:28.139+00
cmk17c45m003bgr0rr5dbvn1s	7	dropoff	delivered			2026-01-05 17:01:46.721+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-05 13:34:05.578+00	2026-01-05 17:01:46.721+00
cmjh8dr0501q7gr0rct70fkmo	0	dropoff	delivered			2025-12-22 16:55:45.653+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2025-12-22 14:07:57.941+00	2025-12-22 16:55:45.654+00
cmk18yxg2003xgr0rkazuzs4l	0	pickup	delivered	x 3612 🔔 Devant la porte		2026-01-05 17:22:28.424+00	\N	cmk0w36kk002xgr0rrgbxgco1	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-05 14:19:49.586+00	2026-01-05 17:22:28.424+00
cmjh8dr0501q8gr0rkvwlma0i	4	dropoff	delivered			2025-12-22 17:26:26.356+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2025-12-22 14:07:57.941+00	2025-12-22 17:26:26.356+00
cmjh8dr0501qcgr0ro0d96ngo	7	both	delivered			2025-12-22 17:52:10.038+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2025-12-22 14:07:57.941+00	2025-12-22 17:52:10.038+00
cmk17c45m003cgr0re0fbucds	8	both	delivered			2026-01-05 17:50:52.984+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-05 13:34:05.578+00	2026-01-05 17:50:52.984+00
cmjh8dr0501qdgr0r7gkzhgvh	8	pickup	delivered			2025-12-22 18:22:41.541+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2025-12-22 14:07:57.941+00	2025-12-22 18:22:41.541+00
cmjh8dr0501q6gr0rz8bws8mp	10	both	delivered			2025-12-22 19:27:53.257+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2025-12-22 14:07:57.941+00	2025-12-22 19:27:53.257+00
cmk17c45m003agr0rg490cozl	10	pickup	delivered			2026-01-05 18:55:04.697+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-05 13:34:05.578+00	2026-01-05 18:55:04.697+00
cmjh8dr0501qbgr0rs1i38sxr	12	both	delivered			2025-12-22 19:51:54.35+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2025-12-22 14:07:57.941+00	2025-12-22 19:51:54.35+00
cmjh8dr0501qegr0r6jyl9xc4	13	both	delivered	Fermé les Mercredi		2025-12-22 20:20:50.822+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2025-12-22 14:07:57.941+00	2025-12-22 20:20:50.822+00
cmk17c45m003egr0rq5p8me2z	13	pickup	delivered	Fermé les Mercredi		2026-01-05 19:42:57.715+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-05 13:34:05.578+00	2026-01-05 19:42:57.715+00
cmjh8dr0501qggr0rndzo53ym	14	both	delivered	Fermé les jeudi		2025-12-22 21:17:26.746+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2025-12-22 14:07:57.941+00	2025-12-22 21:17:26.746+00
cmjh8dr0501qfgr0r5ewtmk9b	15	both	delivered	Fermé les Vendredi		2025-12-22 21:17:29.705+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2025-12-22 14:07:57.941+00	2025-12-22 21:17:29.705+00
cmk17c45m003ggr0r95bv4e44	14	dropoff	delivered	Fermé les jeudi		2026-01-05 20:14:52.836+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-05 13:34:05.578+00	2026-01-05 20:14:52.836+00
cmjh8dr0501q4gr0rx5euxp7l	16	both	delivered			2025-12-22 22:58:24.237+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2025-12-22 14:07:57.941+00	2025-12-22 22:58:24.237+00
cmjh8dr0501q5gr0r98uvhkbm	18	dropoff	delivered			2025-12-22 22:58:26.914+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwv001zz0l65qqq9usa	cmfxz4zwv001yz0l6sidgj4lq	2025-12-22 14:07:57.941+00	2025-12-22 22:58:26.914+00
cmk18yxg2003zgr0rh57r7ccj	3	dropoff	delivered		+ Collecte	2026-01-05 20:30:32.151+00	\N	cmk0w36kk002xgr0rrgbxgco1	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-05 14:19:49.586+00	2026-01-05 20:30:32.151+00
cmjh8dr0501qagr0rwtbmb854	20	both	delivered			2025-12-22 22:58:28.744+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2025-12-22 14:07:57.941+00	2025-12-22 22:58:28.744+00
cmjh8dr0501q9gr0rk38zsm3y	21	dropoff	delivered			2025-12-22 22:58:30.628+00	\N	cmjguxyb601p4gr0r7631du3f	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2025-12-22 14:07:57.941+00	2025-12-22 22:58:30.629+00
cmk17c45m003fgr0r3kpfvdx0	15	pickup	delivered	Fermé les Vendredi		2026-01-05 20:31:53.536+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-05 13:34:05.578+00	2026-01-05 20:31:53.536+00
cmk18yxg1003vgr0rl64ymzs0	7	dropoff	delivered	3ème étage CODE: 2606		2026-01-05 21:41:49.562+00	https://www.storage.tds-transports.fr/4e2ffc28-5d59-4017-b6ed-a489b5edba01.avif	cmk0w36kk002xgr0rrgbxgco1	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-05 14:19:49.586+00	2026-01-05 21:41:49.562+00
cmk18yxg2003wgr0rallbshn1	11	pickup	delivered			2026-01-05 22:03:43.126+00	\N	cmk0w36kk002xgr0rrgbxgco1	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-05 14:19:49.586+00	2026-01-05 22:03:43.126+00
cmk18yxg20040gr0rnzf4lcil	12	pickup	delivered	Fermé mercredi & jeudi		2026-01-05 22:21:38.881+00	\N	cmk0w36kk002xgr0rrgbxgco1	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-05 14:19:49.586+00	2026-01-05 22:21:38.881+00
cmk18yxg2003ygr0ry96wgasm	13	both	delivered			2026-01-05 22:29:25.434+00	\N	cmk0w36kk002xgr0rrgbxgco1	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-05 14:19:49.586+00	2026-01-05 22:29:25.434+00
cmk17c45m0038gr0r3lt92pt3	16	both	delivered			2026-01-05 22:54:48.988+00	\N	cmk16u5j40034gr0r0u5fs8ih	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-05 13:34:05.578+00	2026-01-05 22:54:48.988+00
cmkr45bpu0043h90qwmh9klog	18	both	delivered	Fermé les Mercredi		2026-01-23 21:22:28.466+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-23 16:46:50.513+00	2026-01-23 21:22:28.466+00
cmkvby1e0002nh90r3urftc1c	4	pickup	delivered			2026-01-26 17:46:09.223+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2026-01-26 15:36:12.168+00	2026-01-26 17:46:09.223+00
cmjh9hwdr01r4gr0r4j5tsq7t	1	both	delivered			2025-12-22 17:09:11.258+00	\N	cmjh970pm01qhgr0rewmh0mtp	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2025-12-22 14:39:11.151+00	2025-12-22 17:09:11.258+00
cmjh9hwdr01r5gr0rhi7h9wjy	3	both	delivered			2025-12-22 17:42:33.438+00	\N	cmjh970pm01qhgr0rewmh0mtp	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2025-12-22 14:39:11.151+00	2025-12-22 17:42:33.438+00
cmjh9hwdr01r1gr0rdloktmkc	9	dropoff	delivered	Boite au lettre du haut		2025-12-22 21:20:55.87+00	\N	cmjh970pm01qhgr0rewmh0mtp	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2025-12-22 14:39:11.151+00	2025-12-22 21:20:55.87+00
cmjh9hwdr01r6gr0rejvu50cu	10	dropoff	delivered	2306 placard étage		2025-12-22 21:51:21.288+00	\N	cmjh970pm01qhgr0rewmh0mtp	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2025-12-22 14:39:11.151+00	2025-12-22 21:51:21.288+00
cmjh9hwdr01r3gr0rd2a05mgv	11	dropoff	delivered		+ Collecte	2025-12-22 21:52:06.692+00	\N	cmjh970pm01qhgr0rewmh0mtp	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2025-12-22 14:39:11.151+00	2025-12-22 21:52:06.692+00
cmk47ffd5008fgr0r6th1iil5	0	both	delivered	x 3612 🔔 Devant la porte		2026-01-07 17:02:10.003+00	\N	cmk3q6baj0063gr0ry2rlufv1	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-07 15:59:58.601+00	2026-01-07 17:02:10.003+00
cmjh9hwdr01r7gr0rb2vmwqig	12	both	delivered	Fermé mercredi & jeudi		2025-12-22 22:13:20.451+00	\N	cmjh970pm01qhgr0rewmh0mtp	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2025-12-22 14:39:11.151+00	2025-12-22 22:13:20.451+00
cmjh9hwdr01r2gr0r9nbwc7ep	14	both	delivered	À l'étage dans le placard		2025-12-22 22:13:26.229+00	\N	cmjh970pm01qhgr0rewmh0mtp	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2025-12-22 14:39:11.151+00	2025-12-22 22:13:26.229+00
cmk47ffd5008dgr0r5c16qdfe	1	both	delivered			2026-01-07 17:27:01.031+00	\N	cmk3q6baj0063gr0ry2rlufv1	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-07 15:59:58.601+00	2026-01-07 17:27:01.031+00
cmk47ffd5008egr0ro6qi8m71	4	dropoff	delivered			2026-01-07 18:30:21.48+00	\N	cmk3q6baj0063gr0ry2rlufv1	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2026-01-07 15:59:58.601+00	2026-01-07 18:30:21.48+00
cmk47ffd5008bgr0rp73xy0tp	9	both	delivered	Boite au lettre du haut		2026-01-07 21:46:32.831+00	\N	cmk3q6baj0063gr0ry2rlufv1	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-07 15:59:58.601+00	2026-01-07 21:46:32.831+00
cmk47ffd5008cgr0rimr4mmy2	11	pickup	delivered			2026-01-07 22:34:22.19+00	\N	cmk3q6baj0063gr0ry2rlufv1	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-07 15:59:58.601+00	2026-01-07 22:34:22.19+00
cmk47ffd5008ggr0rd79jam27	13	pickup	delivered			2026-01-07 22:58:00.4+00	\N	cmk3q6baj0063gr0ry2rlufv1	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-07 15:59:58.601+00	2026-01-07 22:58:00.4+00
cmjwutry2002pgr0r62y75cf6	2	both	delivered			2026-01-02 15:28:54.905+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2026-01-02 12:32:49.85+00	2026-01-02 15:28:54.905+00
cmjwtx99d001ygr0r6wi6rt3d	2	dropoff	delivered	Devant le porte parapluie		2026-01-02 15:35:14.331+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt0009z0l6ja0s4dxo	cmfxz4zwt0008z0l62f3uvk3y	2026-01-02 12:07:32.641+00	2026-01-02 15:35:14.331+00
cmjwutry2002rgr0r776ven8l	8	dropoff	delivered			2026-01-02 16:36:34.341+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-02 12:32:49.85+00	2026-01-02 16:36:34.341+00
cmjwutry2002lgr0r7r1gdtjr	0	dropoff	delivered			2026-01-02 15:04:33.919+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-02 12:32:49.85+00	2026-01-02 15:04:33.919+00
cmjwtx99d001xgr0rb1etbw1n	0	both	delivered	x 3612 🔔 Devant la porte		2026-01-02 15:14:58.793+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-02 12:07:32.641+00	2026-01-02 15:14:58.793+00
cmjwtx99d001ugr0ruga6r5is	1	both	delivered			2026-01-02 15:15:04.185+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-02 12:07:32.641+00	2026-01-02 15:15:04.185+00
cmjwutry2002sgr0rkq3prkj0	1	dropoff	delivered			2026-01-02 15:21:34.802+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2026-01-02 12:32:49.85+00	2026-01-02 15:21:34.802+00
cmjwutry2002mgr0r0lxqbfab	4	dropoff	delivered			2026-01-02 15:45:03.317+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2026-01-02 12:32:49.85+00	2026-01-02 15:45:03.317+00
cmjwtx99d001zgr0rqgg4wyx7	12	dropoff	delivered			2026-01-02 20:09:38.051+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-02 12:07:32.641+00	2026-01-02 20:09:38.051+00
cmjwtx99d0021gr0rm11woaeo	3	both	delivered			2026-01-02 16:14:38.099+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-02 12:07:32.641+00	2026-01-02 16:14:38.099+00
cmjwtx99d001vgr0rmme1h5gt	4	dropoff	delivered			2026-01-02 16:21:20.384+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2026-01-02 12:07:32.641+00	2026-01-02 16:21:20.385+00
cmjwutry2002qgr0r9rs215zb	11	dropoff	delivered			2026-01-02 17:38:34.059+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-02 12:32:49.85+00	2026-01-02 17:38:34.059+00
cmjwtx99d001wgr0rpxxbdx99	5	dropoff	delivered			2026-01-02 17:44:23.127+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-02 12:07:32.641+00	2026-01-02 17:44:23.127+00
cmjwutry2002tgr0r1ec1lry5	13	dropoff	delivered	Fermé les Mercredi		2026-01-02 18:28:38.86+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-02 12:32:49.85+00	2026-01-02 18:28:38.86+00
cmjwtx99d0020gr0ru75e6tfj	6	dropoff	delivered			2026-01-02 18:44:04.856+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2026-01-02 12:07:32.641+00	2026-01-02 18:44:04.856+00
cmjwtx99d001rgr0rlckxdn5n	7	dropoff	delivered	Boite au lettre du haut		2026-01-02 18:48:05.09+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-02 12:07:32.641+00	2026-01-02 18:48:05.09+00
cmjwtx99d0024gr0rprq100hf	8	dropoff	delivered	2306 placard étage		2026-01-02 18:56:22.594+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-02 12:07:32.641+00	2026-01-02 18:56:22.594+00
cmjwtx99d001sgr0r8w5v9408	9	dropoff	delivered	3ème étage CODE: 2606		2026-01-02 19:10:30.922+00	https://www.storage.tds-transports.fr/7c6d6a83-1c52-4c57-98e7-c9f5c3b72efe.avif	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-02 12:07:32.641+00	2026-01-02 19:10:30.922+00
cmjwtx99d0023gr0rrmbgbraw	10	dropoff	delivered	La porte de gauche		2026-01-02 19:32:47.652+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-02 12:07:32.641+00	2026-01-02 19:32:47.652+00
cmjwtx99d001tgr0ridabgpwu	11	both	delivered			2026-01-02 19:49:25.225+00	\N	cmjwnbc1l000kgr0rbducazkw	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-02 12:07:32.641+00	2026-01-02 19:49:25.225+00
cmjwutry2002kgr0rodq676aj	16	dropoff	delivered			2026-01-02 20:05:08.628+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-02 12:32:49.85+00	2026-01-02 20:05:08.628+00
cmjwutry2002ogr0rytass63k	20	dropoff	delivered			2026-01-02 20:52:24.177+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-02 12:32:49.85+00	2026-01-02 20:52:24.177+00
cmjwutry2002ngr0r9hu1mxc1	21	dropoff	delivered			2026-01-02 21:06:53.92+00	\N	cmjtzzyiq000cgr0r7mjjg6xr	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2026-01-02 12:32:49.85+00	2026-01-02 21:06:53.92+00
cmkr45bpu003xh90qvg9h6o4w	2	pickup	delivered			2026-01-23 16:58:12.263+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2026-01-23 16:46:50.513+00	2026-01-23 16:58:12.263+00
cmkr45bpu0041h90qa6j4gr3a	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-23 16:58:14.842+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-23 16:46:50.513+00	2026-01-23 16:58:14.842+00
cmkl9je1f00yqgr0rgwb2vy2z	5	dropoff	delivered			2026-01-19 17:29:09.832+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-19 14:31:07.731+00	2026-01-19 17:29:09.832+00
cmkr2csjf003kh90q9epojls0	0	both	delivered	x 3612 🔔 Devant la porte		2026-01-23 17:10:20.366+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-23 15:56:39.675+00	2026-01-23 17:10:20.366+00
cmkr2csjf003mh90qindi4wg7	2	both	delivered			2026-01-23 17:46:01.439+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-23 15:56:39.675+00	2026-01-23 17:46:01.439+00
cmkr45bpu003zh90q0mt9h0wp	7	both	delivered			2026-01-23 18:03:25.343+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-23 16:46:50.513+00	2026-01-23 18:03:25.343+00
cmkr2csjf003gh90q65khetdx	4	dropoff	delivered	Boite au lettre du haut		2026-01-23 19:54:06.556+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-23 15:56:39.675+00	2026-01-23 19:54:06.556+00
cmkr2csjf003ph90qrhrtphhs	5	both	delivered	2306 placard étage		2026-01-23 19:54:14.568+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-23 15:56:39.675+00	2026-01-23 19:54:14.568+00
cmk47hy57008pgr0r1khhno9g	3	both	delivered	753B Fermé Lundi aprèm et Vendredi	Pas de ramasse en boîte au lettre, pas de réponse à la porte 	2026-01-07 16:47:44.28+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-07 16:01:56.251+00	2026-01-07 16:47:44.28+00
cmkr2csjf003qh90qr8070g4r	7	both	delivered	Fermé mercredi & jeudi		2026-01-23 20:36:29.553+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-23 15:56:39.675+00	2026-01-23 20:36:29.554+00
cmk47ffd5008hgr0rhwa4cow6	3	both	delivered			2026-01-07 17:59:48.452+00	\N	cmk3q6baj0063gr0ry2rlufv1	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-07 15:59:58.601+00	2026-01-07 17:59:48.452+00
cmk47hy57008lgr0r3gdh2gu1	10	both	delivered			2026-01-07 18:47:32.601+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-07 16:01:56.251+00	2026-01-07 18:47:32.601+00
cmk47hy57008sgr0rb1ibvdt9	14	pickup	failed	Fermé les jeudi	Pas de colis en boîte 	2026-01-07 20:14:22.71+00	https://www.storage.tds-transports.fr/71006f10-b89d-4231-9661-eea79382617d.avif	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-07 16:01:56.251+00	2026-01-07 20:14:22.71+00
cmklebu24010vgr0ryo5h4c5g	4	dropoff	delivered	2306 placard étage		2026-01-19 22:14:41.396+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-19 16:45:13.323+00	2026-01-19 22:14:41.396+00
cmkl9je1f00z0gr0r7glrikqy	13	both	delivered	Fermé les Mercredi		2026-01-19 21:06:18.891+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-19 14:31:07.731+00	2026-01-19 21:06:18.891+00
cmklebu23010rgr0rkkr0bqkd	2	dropoff	delivered			2026-01-19 22:14:32.964+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2026-01-19 16:45:13.323+00	2026-01-19 22:14:32.964+00
cmk47ffd5008igr0rvmpb4so2	15	pickup	delivered			2026-01-07 23:03:11.791+00	\N	cmk3q6baj0063gr0ry2rlufv1	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-07 15:59:58.601+00	2026-01-07 23:03:11.792+00
cmk47hy57008tgr0r8h5cfejk	19	dropoff	delivered	Fermé les Mercredi		2026-01-07 23:08:53.556+00	\N	cmk41rplm006jgr0rfwcj9bl4	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-07 16:01:56.251+00	2026-01-07 23:08:53.556+00
cmklebu24010ugr0r7q1csn62	6	pickup	delivered	La porte de gauche		2026-01-19 22:50:29.824+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-19 16:45:13.323+00	2026-01-19 22:50:29.824+00
cmklebu23010ogr0rxmgf73l4	0	both	delivered			2026-01-19 18:17:15.551+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-19 16:45:13.323+00	2026-01-19 18:17:15.551+00
cmklebu23010kgr0rigsbqx6i	3	dropoff	delivered	Boite au lettre du haut		2026-01-19 22:14:37.529+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-19 16:45:13.323+00	2026-01-19 22:14:37.529+00
cmklebu23010ngr0rl2co1nii	7	dropoff	delivered			2026-01-19 23:10:11.954+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-19 16:45:13.323+00	2026-01-19 23:10:11.954+00
cmk5l726q00bogr0rdgauisrt	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-08 16:55:22.225+00	\N	cmk5c3fi3008ugr0rdn3e8o0x	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-08 15:13:09.074+00	2026-01-08 16:55:22.225+00
cmk5l726q00blgr0ru7uc1h6g	5	pickup	delivered			2026-01-08 17:17:50.409+00	\N	cmk5c3fi3008ugr0rdn3e8o0x	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-08 15:13:09.074+00	2026-01-08 17:17:50.409+00
cmk5l726q00bngr0r5dhjjhtp	8	both	delivered			2026-01-08 18:06:25.198+00	\N	cmk5c3fi3008ugr0rdn3e8o0x	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-08 15:13:09.074+00	2026-01-08 18:06:25.198+00
cmk5qrtns00c2gr0rre1dcqhg	0	pickup	delivered			2026-01-08 18:10:57.15+00	\N	cmk5ip0sa009ngr0ro91xmoba	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-08 17:49:15.88+00	2026-01-08 18:10:57.15+00
cmk5l726q00bmgr0r70rvf1ln	10	pickup	delivered			2026-01-08 19:15:57.51+00	\N	cmk5c3fi3008ugr0rdn3e8o0x	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-08 15:13:09.074+00	2026-01-08 19:15:57.51+00
cmk5qrtns00c3gr0rquluv0ul	1	dropoff	delivered			2026-01-08 19:27:40.365+00	\N	cmk5ip0sa009ngr0ro91xmoba	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-08 17:49:15.88+00	2026-01-08 19:27:40.365+00
cmk5l726q00bqgr0rhgrba66t	14	both	delivered	Fermé les jeudi		2026-01-08 20:43:46.265+00	\N	cmk5c3fi3008ugr0rdn3e8o0x	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-08 15:13:09.074+00	2026-01-08 20:43:46.265+00
cmk5l726q00bpgr0r5soxx1ev	15	pickup	delivered	Fermé les Vendredi		2026-01-08 21:06:30.641+00	\N	cmk5c3fi3008ugr0rdn3e8o0x	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-08 15:13:09.074+00	2026-01-08 21:06:30.641+00
cmk5qrtns00c0gr0ry1xq441x	2	both	delivered	Boite au lettre du haut		2026-01-08 21:42:43.144+00	\N	cmk5ip0sa009ngr0ro91xmoba	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-08 17:49:15.88+00	2026-01-08 21:42:43.144+00
cmk5qrtns00c7gr0r29awxqs8	3	pickup	delivered	2306 placard étage		2026-01-08 21:46:11.856+00	\N	cmk5ip0sa009ngr0ro91xmoba	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-08 17:49:15.88+00	2026-01-08 21:46:11.856+00
cmk5qrtns00c1gr0r8hp9xc5s	4	pickup	delivered			2026-01-08 22:19:31.771+00	\N	cmk5ip0sa009ngr0ro91xmoba	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-08 17:49:15.88+00	2026-01-08 22:19:31.772+00
cmk5qrtns00c5gr0rjjlwha2g	5	dropoff	delivered			2026-01-08 22:42:20.146+00	\N	cmk5ip0sa009ngr0ro91xmoba	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-08 17:49:15.88+00	2026-01-08 22:42:20.146+00
cmk5qrtns00c6gr0ravi0mi34	6	pickup	delivered		Pas de boite	2026-01-08 23:00:08.948+00	\N	cmk5ip0sa009ngr0ro91xmoba	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-08 17:49:15.88+00	2026-01-08 23:00:08.948+00
cmk5qrtns00c4gr0r1syhd88f	7	both	delivered	x 3612 🔔 Devant la porte		2026-01-08 23:00:17.122+00	\N	cmk5ip0sa009ngr0ro91xmoba	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-08 17:49:15.88+00	2026-01-08 23:00:17.122+00
cmk6ygiau00d0gr0rqfqo6efl	14	both	delivered	Fermé les jeudi		2026-01-09 21:41:28.955+00	\N	cmk6xs55100cigr0rqb6lku4c	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-09 14:12:11.046+00	2026-01-09 21:41:28.955+00
cmk6ygiau00czgr0rhixcbrx4	15	both	delivered	Fermé les Vendredi		2026-01-09 22:09:40.373+00	\N	cmk6xs55100cigr0rqb6lku4c	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-09 14:12:11.046+00	2026-01-09 22:09:40.373+00
cmkr45bpt003vh90qjf8jcfca	4	dropoff	delivered			2026-01-23 17:09:26.463+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2026-01-23 16:46:50.513+00	2026-01-23 17:09:26.463+00
cmk6ygiau00csgr0r1a1001gk	16	both	delivered			2026-01-10 00:27:06.581+00	\N	cmk6xs55100cigr0rqb6lku4c	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-09 14:12:11.046+00	2026-01-10 00:27:06.581+00
cmk6ytbpc00dngr0rfqfkmx9e	4	both	delivered	Fermé mercredi & jeudi		2026-01-10 01:33:04.229+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-09 14:22:09.024+00	2026-01-10 01:33:04.229+00
cmk6ytbpc00djgr0re402hjod	5	pickup	delivered			2026-01-10 01:33:08.482+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-09 14:22:09.024+00	2026-01-10 01:33:08.482+00
cmkppyfrx0017h90q6idcctp5	1	both	delivered			2026-01-22 19:52:11.957+00	\N	cmkp9m8yb002hgr0rzte4hmju	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-22 17:21:48.381+00	2026-01-22 19:52:11.957+00
cmk6ytbpc00dfgr0r9tjbsgc2	6	both	delivered	À l'étage dans le placard		2026-01-10 01:33:13.046+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-09 14:22:09.024+00	2026-01-10 01:33:13.046+00
cmkr2csjf003jh90qk95sd30t	1	both	delivered			2026-01-23 17:10:36.27+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-23 15:56:39.675+00	2026-01-23 17:10:36.27+00
cmkppyfrx0019h90quzndueum	5	both	delivered	2306 placard étage		2026-01-23 00:25:50.462+00	\N	cmkp9m8yb002hgr0rzte4hmju	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-22 17:21:48.381+00	2026-01-23 00:25:50.463+00
cmk6ytbpc00digr0ra60zueup	7	both	delivered	x 3612 🔔 Devant la porte		2026-01-10 01:33:33.13+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-09 14:22:09.024+00	2026-01-10 01:33:33.13+00
cmk6ytbpc00dhgr0rnhf3a1ms	8	both	delivered			2026-01-10 01:33:35.726+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-09 14:22:09.024+00	2026-01-10 01:33:35.726+00
cmk6ytbpc00dkgr0rgopw8t37	9	both	delivered			2026-01-10 01:33:38.191+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-09 14:22:09.024+00	2026-01-10 01:33:38.191+00
cmkr2csjf003hh90qw24uof5k	9	both	delivered	À l'étage dans le placard		2026-01-23 20:48:16.909+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-23 15:56:39.675+00	2026-01-23 20:48:16.909+00
cmkmt1iwt016vgr0rokt7rmum	14	both	delivered			2026-01-20 23:53:31.731+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-20 16:24:52.733+00	2026-01-20 23:53:31.731+00
cmk6ytbpc00dlgr0r2c5v42xv	10	pickup	delivered			2026-01-10 01:33:43.176+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-09 14:22:09.024+00	2026-01-10 01:33:43.176+00
cmkr45bpt003sh90qv8ftq9w6	16	both	delivered			2026-01-23 20:55:26.986+00	\N	cmkqnfvmt001ah90q7wgvjg4r	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-23 16:46:50.513+00	2026-01-23 20:55:26.986+00
cmkvby1e0002sh90roomsdrov	1	dropoff	delivered			2026-01-26 17:14:33.317+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2026-01-26 15:36:12.168+00	2026-01-26 17:14:33.318+00
cmkvby1e0002rh90rdd3o91zn	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-26 17:33:33.679+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-26 15:36:12.168+00	2026-01-26 17:33:33.679+00
cmkppyfrx0018h90q1p82ixdp	7	both	delivered			2026-01-23 01:14:31.467+00	\N	cmkp9m8yb002hgr0rzte4hmju	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-22 17:21:48.381+00	2026-01-23 01:14:31.467+00
cmkvby1e0002qh90ry6xlngdy	8	both	delivered			2026-01-26 18:44:48.866+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-26 15:36:12.168+00	2026-01-26 18:44:48.866+00
cmkppyfrx0016h90qrn2kq6o9	8	pickup	delivered	x 3612 🔔 Devant la porte		2026-01-23 01:27:48.418+00	\N	cmkp9m8yb002hgr0rzte4hmju	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-22 17:21:48.381+00	2026-01-23 01:27:48.418+00
cmkvby1e0002ph90rx75sr7hv	10	both	delivered			2026-01-26 19:45:58.18+00	\N	cmkuwsxl30000h90r00c40gsk	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-26 15:36:12.168+00	2026-01-26 19:45:58.18+00
cmkvby1e0002th90rg1d48cuq	13	both	delivered	Fermé les Mercredi		2026-01-26 20:30:56.401+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-26 15:36:12.168+00	2026-01-26 20:30:56.401+00
cmk6ygiau00cxgr0rklq3fhgz	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-09 17:02:18.312+00	\N	cmk6xs55100cigr0rqb6lku4c	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-09 14:12:11.046+00	2026-01-09 17:02:18.312+00
cmkvby1e0002uh90rapo14hr9	15	pickup	delivered	Fermé les Vendredi		2026-01-26 21:19:58.177+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-26 15:36:12.168+00	2026-01-26 21:19:58.177+00
cmk6ygiau00cvgr0r0vwokz0y	7	dropoff	delivered			2026-01-09 17:02:24.549+00	\N	cmk6xs55100cigr0rqb6lku4c	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-09 14:12:11.046+00	2026-01-09 17:02:24.549+00
cmkvby1e0002oh90rntj1s3s4	19	both	delivered			2026-01-26 22:38:33.688+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-26 15:36:12.168+00	2026-01-26 22:38:33.688+00
cmk6ytbpc00ddgr0rsqcu3gen	2	pickup	delivered	Boite au lettre du haut		2026-01-09 18:57:07.203+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-09 14:22:09.024+00	2026-01-09 18:57:07.203+00
cmk6ytbpc00dmgr0rge98sxvf	3	dropoff	delivered	2306 placard étage		2026-01-09 18:57:10.285+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-09 14:22:09.024+00	2026-01-09 18:57:10.285+00
cmk6ygiau00ctgr0rjkec0mp9	10	both	delivered			2026-01-09 19:03:25.342+00	\N	cmk6xs55100cigr0rqb6lku4c	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-09 14:12:11.046+00	2026-01-09 19:03:25.342+00
cmk6ytbpc00dggr0rlv9hml1f	0	dropoff	delivered			2026-01-09 17:35:52.165+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-09 14:22:09.024+00	2026-01-09 17:35:52.165+00
cmk6ygiau00cugr0rauik6m1o	11	pickup	delivered			2026-01-09 19:03:27.847+00	\N	cmk6xs55100cigr0rqb6lku4c	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-09 14:12:11.046+00	2026-01-09 19:03:27.847+00
cmk6ygiau00cygr0r4j1muai4	13	dropoff	delivered	Fermé les Mercredi		2026-01-09 20:12:07.741+00	\N	cmk6xs55100cigr0rqb6lku4c	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-09 14:12:11.046+00	2026-01-09 20:12:07.742+00
cmk6ygiau00cwgr0rq6bau0ly	8	both	delivered			2026-01-09 17:37:15.778+00	\N	cmk6xs55100cigr0rqb6lku4c	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-09 14:12:11.046+00	2026-01-09 17:37:15.778+00
cmk6ytbpc00degr0rh5hbtzng	1	dropoff	delivered	3ème étage CODE: 2606		2026-01-09 17:52:20.281+00	\N	cmk6ubdvh00c8gr0r7t8oxjub	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-09 14:22:09.024+00	2026-01-09 17:52:20.281+00
cmkh177f000w4gr0ri9h4atne	14	both	delivered	Fermé les jeudi		2026-01-16 22:51:22.408+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-16 15:26:37.644+00	2026-01-16 22:51:22.408+00
cmkh177f000w3gr0r188k683v	15	both	delivered	Fermé les Vendredi		2026-01-16 22:51:25.728+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-16 15:26:37.644+00	2026-01-16 22:51:25.728+00
cmkr2csjf003nh90qdi05zrn4	10	both	delivered			2026-01-23 21:48:38.966+00	\N	cmkqr8pf4001ih90qihkju1wc	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-23 15:56:39.675+00	2026-01-23 21:48:38.966+00
cmkh177f000w5gr0rmkvh44hj	19	both	delivered	Fermé les Mercredi		2026-01-16 22:54:45.527+00	\N	cmkgm7rte00rugr0rq4ip9gum	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-16 15:26:37.644+00	2026-01-16 22:54:45.527+00
cmkvby1e0002vh90r4cmos1s7	14	both	delivered	Fermé les jeudi		2026-01-26 21:05:39.75+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-26 15:36:12.168+00	2026-01-26 21:05:39.75+00
cmkvby1e0002wh90r1q06naf6	18	both	delivered	Fermé les Mercredi		2026-01-26 22:18:08.17+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-26 15:36:12.168+00	2026-01-26 22:18:08.17+00
cmklebu24010wgr0r5rzhgkbx	8	pickup	delivered	Fermé mercredi & jeudi		2026-01-19 23:42:21.359+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-19 16:45:13.323+00	2026-01-19 23:42:21.359+00
cmklebu23010qgr0r5nqorynr	9	pickup	delivered			2026-01-19 23:42:24.089+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-19 16:45:13.323+00	2026-01-19 23:42:24.089+00
cmklebu23010mgr0re92f6ikh	10	pickup	delivered	À l'étage dans le placard		2026-01-19 23:42:29.344+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-19 16:45:13.323+00	2026-01-19 23:42:29.344+00
cmklebu24010tgr0rvou58aom	11	both	delivered			2026-01-19 23:42:34.738+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-19 16:45:13.323+00	2026-01-19 23:42:34.738+00
cmkmt1iwt0170gr0ry1pjvn74	1	both	delivered			2026-01-20 17:53:55.431+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2026-01-20 16:24:52.733+00	2026-01-20 17:53:55.431+00
cmklebu23010pgr0rh7hz94e1	12	pickup	delivered	x 3612 🔔 Devant la porte	Pas de boite	2026-01-19 23:51:50.124+00	\N	cmkkzo2n000wqgr0rcy4agnxq	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-19 16:45:13.323+00	2026-01-19 23:51:50.124+00
cmky9gx9l00a7h90r4hlplzqy	1	both	delivered			2026-01-28 18:40:24.223+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-28 16:50:12.969+00	2026-01-28 18:40:24.223+00
cmky9gx9l00a6h90ry7bsdzy4	4	dropoff	delivered			2026-01-28 20:54:31.427+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2026-01-28 16:50:12.969+00	2026-01-28 20:54:31.427+00
cmkmt1iwt016wgr0rda4gqz5f	2	dropoff	delivered			2026-01-20 18:10:56.335+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-20 16:24:52.733+00	2026-01-20 18:10:56.335+00
cmkmt1iwu0177gr0reec2nekt	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-20 18:28:57.828+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-20 16:24:52.733+00	2026-01-20 18:28:57.828+00
cmkmt1iwu0174gr0rh008hx0e	9	both	delivered			2026-01-20 21:18:35.491+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-20 16:24:52.733+00	2026-01-20 21:18:35.491+00
cmkh19tjn00wegr0ridvsy0ic	8	both	delivered			2026-01-16 22:48:59.245+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-16 15:28:39.635+00	2026-01-16 22:48:59.245+00
cmkmt1iwt016ygr0rydkipvi4	10	both	delivered			2026-01-20 21:25:33.863+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-20 16:24:52.733+00	2026-01-20 21:25:33.863+00
cmkmt1iwu0172gr0rxrj8u5ta	11	dropoff	delivered		+ Collecte	2026-01-20 21:46:11.925+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-20 16:24:52.733+00	2026-01-20 21:46:11.925+00
cmkmt1iwu0173gr0rcrcfa7aa	4	dropoff	delivered			2026-01-20 18:47:51.148+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2026-01-20 16:24:52.733+00	2026-01-20 18:47:51.148+00
cmkmt1iwu0178gr0r2eos1yjn	5	both	delivered			2026-01-20 19:15:08.644+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2026-01-20 16:24:52.733+00	2026-01-20 19:15:08.644+00
cmkppyfrx0012h90qx7aw4xmw	3	dropoff	delivered			2026-01-22 23:01:51.349+00	https://www.storage.tds-transports.fr/e1d73ac5-cf78-4656-a7bb-6ef42c20b2f6.avif	cmkp9m8yb002hgr0rzte4hmju	cmj8fy13701e6gr0rzan7pd7n	cmj8fy13701e5gr0reelcb512	2026-01-22 17:21:48.381+00	2026-01-22 23:01:51.349+00
cmkmt1iwu0175gr0r2dmhnzxa	6	dropoff	delivered			2026-01-20 19:28:49.578+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-20 16:24:52.733+00	2026-01-20 19:28:49.578+00
cmkmt1iwt016zgr0rfmwz3j7h	7	dropoff	delivered			2026-01-20 19:42:11.229+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-20 16:24:52.733+00	2026-01-20 19:42:11.229+00
cmkmt1iwu017agr0rhrob0uhv	12	pickup	delivered	Fermé les jeudi		2026-01-20 22:50:42.049+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-20 16:24:52.733+00	2026-01-20 22:50:42.049+00
cmkmt1iwt016xgr0r01dwzwud	0	dropoff	delivered		Livré au Cabinet	2026-01-20 17:15:00.505+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmkmapsx70117gr0rv8bwx2n8	cmkmapsx60116gr0rbvqa8zx2	2026-01-20 16:24:52.733+00	2026-01-20 17:15:00.505+00
cmkmt1iwu0176gr0rz0qx5zuq	8	both	delivered			2026-01-20 20:12:37.983+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-20 16:24:52.733+00	2026-01-20 20:12:37.983+00
cmkmt1iwu0179gr0rc6x4f13l	13	both	delivered	Fermé les Vendredi		2026-01-20 23:08:55.573+00	\N	cmkmbuj1f0118gr0rr4s29a34	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-20 16:24:52.733+00	2026-01-20 23:08:55.573+00
cmkppyfrx0011h90qgvhpujqv	4	dropoff	delivered	Boite au lettre du haut		2026-01-23 00:19:31.989+00	\N	cmkp9m8yb002hgr0rzte4hmju	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-22 17:21:48.381+00	2026-01-23 00:19:31.989+00
cmkppyfrx0013h90qyd2ykeeh	6	pickup	delivered			2026-01-23 00:48:16.987+00	\N	cmkp9m8yb002hgr0rzte4hmju	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-22 17:21:48.381+00	2026-01-23 00:48:16.987+00
cmkppyfrx0014h90qu47eue2b	0	both	delivered			2026-01-22 19:17:36.234+00	\N	cmkp9m8yb002hgr0rzte4hmju	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-22 17:21:48.381+00	2026-01-22 19:17:36.234+00
cmkppyfrx0015h90qg4zd8ijg	2	both	delivered			2026-01-22 21:30:51.708+00	\N	cmkp9m8yb002hgr0rzte4hmju	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-22 17:21:48.381+00	2026-01-22 21:30:51.708+00
cmkl9je1f00yugr0r43lkteoa	9	dropoff	delivered			2026-01-19 19:56:19.648+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2026-01-19 14:31:07.731+00	2026-01-19 19:56:19.648+00
cmkl9je1f00yrgr0rd8jffuvn	10	both	delivered			2026-01-19 19:56:21.845+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-19 14:31:07.731+00	2026-01-19 19:56:21.845+00
cmkl9je1f00ypgr0rr5ifd7mq	16	both	delivered			2026-01-19 23:08:02.088+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-19 14:31:07.731+00	2026-01-19 23:08:02.088+00
cmkl9je1f00ytgr0rudgfe2n2	21	dropoff	delivered			2026-01-19 23:08:07.54+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2026-01-19 14:31:07.731+00	2026-01-19 23:08:07.54+00
cmkfmh4me00r6gr0rs2ndzvzn	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-15 17:34:59.334+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-15 15:46:40.166+00	2026-01-15 17:34:59.334+00
cmkfmh4me00r3gr0rlhm5of2m	4	pickup	delivered			2026-01-15 17:48:18.169+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2026-01-15 15:46:40.166+00	2026-01-15 17:48:18.169+00
cmkfmh4me00r0gr0rh7y5ahrx	5	both	delivered			2026-01-15 18:03:43.412+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-15 15:46:40.166+00	2026-01-15 18:03:43.412+00
cmkfmh4me00r5gr0rfmk7ki3d	8	both	delivered			2026-01-15 19:48:16.98+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-15 15:46:40.166+00	2026-01-15 19:48:16.98+00
cmkfmh4me00r1gr0rc5pgznxw	10	both	delivered			2026-01-15 19:48:19.961+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-15 15:46:40.166+00	2026-01-15 19:48:19.961+00
cmkfmh4me00r4gr0rp1p92ix0	11	dropoff	delivered			2026-01-15 19:48:21.83+00	\N	cmkf5wb7000oagr0rn09vs99s	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-15 15:46:40.166+00	2026-01-15 19:48:21.83+00
cmkbc0p8b00i7gr0rba3w78de	0	both	delivered			2026-01-12 16:56:25.77+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-12 15:42:52.859+00	2026-01-12 16:56:25.77+00
cmkfmh4me00r7gr0r8ym7xi5b	13	dropoff	delivered	Fermé les Mercredi		2026-01-15 20:34:04.896+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-15 15:46:40.166+00	2026-01-15 20:34:04.896+00
cmkfmh4me00r8gr0r43rmpmvu	15	both	delivered	Fermé les Vendredi		2026-01-15 20:55:21.856+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-15 15:46:40.166+00	2026-01-15 20:55:21.856+00
cmkfmh4me00qzgr0r18viszwe	16	both	delivered			2026-01-15 21:34:48.233+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-15 15:46:40.166+00	2026-01-15 21:34:48.233+00
cmkfmh4me00r9gr0rmrop2u2s	19	both	delivered	Fermé les Mercredi		2026-01-15 21:58:02.714+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-15 15:46:40.166+00	2026-01-15 21:58:02.715+00
cmkbc0p8b00ibgr0r4tqe6jyf	2	pickup	delivered			2026-01-12 17:17:00.776+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2026-01-12 15:42:52.859+00	2026-01-12 17:17:00.776+00
cmkbc0p8b00iegr0rec7kwneh	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-12 17:32:58.865+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-12 15:42:52.859+00	2026-01-12 17:32:58.865+00
cmkbctocu00ingr0rrq3nkocs	0	both	delivered			2026-01-12 17:46:28.757+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-12 16:05:24.75+00	2026-01-12 17:46:28.757+00
cmkbc0p8b00i5gr0rrgrrk7za	5	both	delivered			2026-01-12 17:54:48.177+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-12 15:42:52.859+00	2026-01-12 17:54:48.177+00
cmkbctocu00iqgr0rs8cqjp8j	1	both	delivered			2026-01-12 18:25:56.244+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-12 16:05:24.75+00	2026-01-12 18:25:56.244+00
cmkbc0p8b00idgr0r34v5tl22	8	both	delivered			2026-01-12 19:43:10.45+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-12 15:42:52.859+00	2026-01-12 19:43:10.45+00
cmkbc0p8b00i6gr0r4rhkkkmh	10	both	delivered			2026-01-12 19:43:13.098+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-12 15:42:52.859+00	2026-01-12 19:43:13.098+00
cmkbc0p8b00icgr0r1e6ztf62	11	dropoff	delivered			2026-01-12 19:43:15.053+00	\N	cmkawib3500dogr0rj3dxrlp9	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-12 15:42:52.859+00	2026-01-12 19:43:15.053+00
cmkbctocu00iogr0rousorse7	2	dropoff	delivered		+ Collecte	2026-01-12 20:02:12.149+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-12 16:05:24.75+00	2026-01-12 20:02:12.149+00
cmkbc0p8b00iagr0r8zu13prb	12	dropoff	delivered			2026-01-12 20:05:07.888+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-12 15:42:52.859+00	2026-01-12 20:05:07.888+00
cmkbc0p8b00ifgr0rvnb9dg88	13	pickup	delivered	Fermé les Mercredi		2026-01-12 20:35:07.092+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-12 15:42:52.859+00	2026-01-12 20:35:07.093+00
cmkbctocu00ikgr0rxqpkwcyc	3	pickup	delivered	Boite au lettre du haut		2026-01-12 21:03:46.287+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-12 16:05:24.75+00	2026-01-12 21:03:46.287+00
cmkbc0p8b00ihgr0rm3jfietc	14	both	delivered	Fermé les jeudi		2026-01-12 21:26:19.999+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-12 15:42:52.859+00	2026-01-12 21:26:19.999+00
cmkbc0p8b00iggr0rqibyv91c	15	both	delivered	Fermé les Vendredi		2026-01-12 21:26:22.244+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-12 15:42:52.859+00	2026-01-12 21:26:22.244+00
cmkbctocu00isgr0re4oo3ny3	4	dropoff	delivered	La porte de gauche		2026-01-12 21:37:16.437+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-12 16:05:24.75+00	2026-01-12 21:37:16.437+00
cmkbctocu00imgr0rvp2aw601	5	dropoff	delivered			2026-01-12 21:56:13.591+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-12 16:05:24.75+00	2026-01-12 21:56:13.591+00
cmkbc0p8b00i4gr0rhq5a9cyh	16	both	delivered			2026-01-12 22:08:31.298+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-12 15:42:52.859+00	2026-01-12 22:08:31.298+00
cmkbctocu00itgr0rtybz7ajv	6	pickup	delivered	Fermé mercredi & jeudi		2026-01-12 22:12:21.267+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-12 16:05:24.75+00	2026-01-12 22:12:21.267+00
cmkbctocu00ipgr0r6uzlrdhm	7	pickup	delivered			2026-01-12 22:19:02.516+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-12 16:05:24.75+00	2026-01-12 22:19:02.516+00
cmkbctocu00ilgr0rtz3mfx2t	8	pickup	delivered	À l'étage dans le placard		2026-01-12 22:37:28.355+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-12 16:05:24.75+00	2026-01-12 22:37:28.355+00
cmkbctocu00irgr0rlqt36bsk	9	both	delivered			2026-01-12 22:57:22.925+00	\N	cmkawir0x00dxgr0rcxp7zz7r	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-12 16:05:24.75+00	2026-01-12 22:57:22.925+00
cmkbc0p8b00iigr0rx1fivngn	19	pickup	delivered	Fermé les Mercredi		2026-01-13 15:00:35.933+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-12 15:42:52.859+00	2026-01-13 15:00:35.933+00
cmkbc0p8b00i9gr0rryqj16nu	20	both	delivered			2026-01-13 15:00:38.566+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-12 15:42:52.859+00	2026-01-13 15:00:38.566+00
cmkbc0p8b00i8gr0rmhx5av3r	21	dropoff	delivered			2026-01-13 15:00:40.67+00	\N	cmkawib3500dogr0rj3dxrlp9	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2026-01-12 15:42:52.859+00	2026-01-13 15:00:40.67+00
cmkl9je1f00yygr0r6ag4vh5j	8	both	delivered			2026-01-19 18:17:19.713+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-19 14:31:07.731+00	2026-01-19 18:17:19.713+00
cmkl9je1f00yxgr0rvqkmbibb	11	both	delivered			2026-01-19 19:56:24.319+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-19 14:31:07.731+00	2026-01-19 19:56:24.319+00
cmkl9je1f00ywgr0rdzbmezs4	12	dropoff	delivered			2026-01-19 19:56:26.789+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-19 14:31:07.731+00	2026-01-19 19:56:26.789+00
cmkl9je1f00z2gr0r0dnu216j	14	both	delivered	Fermé les jeudi		2026-01-19 21:06:21.032+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-19 14:31:07.731+00	2026-01-19 21:06:21.032+00
cmkl9je1f00z1gr0rucsru5c7	15	both	delivered	Fermé les Vendredi		2026-01-19 21:06:23.29+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-19 14:31:07.731+00	2026-01-19 21:06:23.29+00
cmkl9je1f00z3gr0rtwq788fc	19	dropoff	delivered	Fermé les Mercredi		2026-01-19 23:08:04.25+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-19 14:31:07.731+00	2026-01-19 23:08:04.25+00
cmkl9je1f00yvgr0rdoso5j9d	20	dropoff	delivered			2026-01-19 23:08:05.936+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-19 14:31:07.731+00	2026-01-19 23:08:05.936+00
cmkcrqi1m00kggr0rm7lzr6om	0	dropoff	delivered			2026-01-13 16:29:13.824+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-13 15:50:37.018+00	2026-01-13 16:29:13.824+00
cmkcrqi1m00kmgr0rsa5gzcbw	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-13 17:11:51.278+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-13 15:50:37.018+00	2026-01-13 17:11:51.278+00
cmkcrqi1m00kegr0rlxqjtrcf	5	dropoff	delivered			2026-01-13 17:32:02.788+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-13 15:50:37.018+00	2026-01-13 17:32:02.789+00
cmkh19tjn00wcgr0rhkgv1o54	3	both	delivered			2026-01-16 20:40:02.224+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2026-01-16 15:28:39.635+00	2026-01-16 20:40:02.224+00
cmkcrqi1m00kkgr0ree52hfp1	7	dropoff	delivered			2026-01-13 17:57:14.479+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-13 15:50:37.018+00	2026-01-13 17:57:14.479+00
cmkcrqi1m00klgr0ryve0rs3n	8	both	delivered			2026-01-13 18:29:35.466+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-13 15:50:37.018+00	2026-01-13 18:29:35.466+00
cmkcvp0ox00kvgr0rnsdbuk2w	0	pickup	delivered	x 3612 🔔 Devant la porte		2026-01-13 19:03:45.643+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-13 17:41:26.337+00	2026-01-13 19:03:45.643+00
cmkh19tjn00wggr0rpttlnjc0	6	both	delivered	Fermé mercredi & jeudi		2026-01-16 21:55:41.95+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-16 15:28:39.635+00	2026-01-16 21:55:41.95+00
cmkcvp0ox00ktgr0rfohji8fl	1	both	delivered			2026-01-13 19:03:48.199+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-13 17:41:26.337+00	2026-01-13 19:03:48.199+00
cmkcvp0ox00kxgr0rvivs6xs3	3	both	delivered			2026-01-13 19:05:53.841+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-13 17:41:26.337+00	2026-01-13 19:05:53.841+00
cmkcvp0ox00kugr0rmcrs91ku	4	dropoff	delivered			2026-01-13 19:35:34.638+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2026-01-13 17:41:26.337+00	2026-01-13 19:35:34.638+00
cmkcrqi1m00kfgr0rslobxrrd	10	both	delivered			2026-01-13 19:35:44.042+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-13 15:50:37.018+00	2026-01-13 19:35:44.042+00
cmkh19tjn00w9gr0rherjqc0p	0	both	delivered			2026-01-16 17:59:54.916+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-16 15:28:39.635+00	2026-01-16 17:59:54.916+00
cmkcrqi1m00kjgr0rhnysjfrv	11	pickup	delivered			2026-01-13 19:35:51.328+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-13 15:50:37.018+00	2026-01-13 19:35:51.328+00
cmkcrqi1m00kigr0rru9zuzxy	12	dropoff	delivered			2026-01-13 19:57:06.263+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-13 15:50:37.018+00	2026-01-13 19:57:06.263+00
cmkh19tjn00wdgr0r5mx88ai4	1	both	delivered			2026-01-16 17:59:57.848+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-16 15:28:39.635+00	2026-01-16 17:59:57.848+00
cmkcvp0ox00kqgr0rxw71q7u5	7	pickup	delivered	3ème étage CODE: 2606		2026-01-13 20:39:13.845+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-13 17:41:26.337+00	2026-01-13 20:39:13.845+00
cmkcvp0ox00ksgr0rc6nap0ld	11	dropoff	delivered		+ Collecte	2026-01-13 20:59:20.922+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-13 17:41:26.337+00	2026-01-13 20:59:20.922+00
cmkh19tjn00wagr0r5cjoemww	2	both	delivered			2026-01-16 19:42:08.064+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-16 15:28:39.635+00	2026-01-16 19:42:08.064+00
cmkcvp0ox00kzgr0ra367uekh	12	pickup	delivered	Fermé mercredi & jeudi		2026-01-13 21:14:54.999+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-13 17:41:26.337+00	2026-01-13 21:14:54.999+00
cmkcvp0ox00kwgr0re7ido5hm	13	pickup	delivered			2026-01-13 21:21:40.987+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-13 17:41:26.337+00	2026-01-13 21:21:40.987+00
cmkh19tjn00wfgr0rjk20qew0	4	both	delivered	La porte de gauche		2026-01-16 21:16:20.188+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-16 15:28:39.635+00	2026-01-16 21:16:20.188+00
cmkcvp0ox00krgr0r2vh9uxib	14	pickup	delivered	À l'étage dans le placard	Pas de boite	2026-01-13 21:27:55.761+00	https://www.storage.tds-transports.fr/54013280-9560-42fc-a88b-eaec1841d9e8.avif	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-13 17:41:26.337+00	2026-01-13 21:27:55.761+00
cmkcvp0ox00kygr0rs4glgpm6	15	both	delivered			2026-01-13 21:57:59.458+00	\N	cmkcdkeld00iugr0rn927pqrs	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-13 17:41:26.337+00	2026-01-13 21:57:59.458+00
cmkcrqi1m00kogr0r4zmyqilw	14	both	delivered	Fermé les jeudi		2026-01-13 22:43:45.333+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-13 15:50:37.018+00	2026-01-13 22:43:45.333+00
cmkh19tjn00w8gr0r1tcsgvx8	5	dropoff	delivered			2026-01-16 21:39:50.463+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-16 15:28:39.635+00	2026-01-16 21:39:50.463+00
cmkcrqi1m00kngr0rvusirkcz	15	both	delivered	Fermé les Vendredi		2026-01-13 22:43:48.254+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-13 15:50:37.018+00	2026-01-13 22:43:48.254+00
cmkcrqi1m00kdgr0r2h304iyh	16	both	delivered			2026-01-13 22:43:50.846+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-13 15:50:37.018+00	2026-01-13 22:43:50.846+00
cmkh19tjn00w7gr0r2kutoccm	7	pickup	delivered	À l'étage dans le placard	Pas de boite	2026-01-16 22:05:11.857+00	https://www.storage.tds-transports.fr/e190d11c-db5e-4a4f-b562-d7c01fccba30.avif	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-16 15:28:39.635+00	2026-01-16 22:05:11.857+00
cmkcrqi1m00khgr0rtal5w60i	20	both	delivered			2026-01-13 22:43:53.159+00	\N	cmkce0g1h00jbgr0rkdzbprp6	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-13 15:50:37.018+00	2026-01-13 22:43:53.159+00
cmkh19tjn00wbgr0rypnuyad7	9	both	delivered	x 3612 🔔 Devant la porte		2026-01-16 22:49:38.953+00	\N	cmkgo7o1100s3gr0rrxxus2dk	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-16 15:28:39.635+00	2026-01-16 22:49:38.953+00
cmkfmh4me00r2gr0r0hcnr2il	0	both	delivered			2026-01-15 16:44:50.588+00	\N	cmkf5wb7000oagr0rn09vs99s	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-15 15:46:40.166+00	2026-01-15 16:44:50.588+00
cmky9gx9l00a0h90rhtjnhwbd	9	dropoff	delivered	À l'étage dans le placard		2026-01-28 22:10:54.9+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-28 16:50:12.969+00	2026-01-28 22:10:54.9+00
cmky9gx9l00a2h90renapcd2e	0	both	delivered			2026-01-28 18:40:22.523+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-28 16:50:12.969+00	2026-01-28 18:40:22.523+00
cmky9gx9l00a3h90rhl82rt5f	2	dropoff	delivered			2026-01-28 19:12:29.827+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2026-01-28 16:50:12.969+00	2026-01-28 19:12:29.827+00
cmkl9je1f00ysgr0rzdwgg0cz	0	both	delivered			2026-01-19 16:35:37.576+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-19 14:31:07.731+00	2026-01-19 16:35:37.576+00
cmkvby1e0002mh90r5iaamben	0	pickup	delivered			2026-01-26 16:58:51.281+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-26 15:36:12.168+00	2026-01-26 16:58:51.281+00
cmky9gx9l00a9h90rsflik1zc	3	dropoff	delivered	La porte de gauche		2026-01-28 20:14:21.445+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-28 16:50:12.969+00	2026-01-28 20:14:21.445+00
cmkvby1e0002kh90rqmqpwdqo	5	both	delivered			2026-01-26 18:01:34.183+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-26 15:36:12.168+00	2026-01-26 18:01:34.183+00
cmkvby1e0002lh90r58hwm23k	11	both	delivered			2026-01-26 19:45:59.917+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-26 15:36:12.168+00	2026-01-26 19:45:59.917+00
cmkvby1e0002jh90rl4h41yo2	16	both	delivered			2026-01-26 21:55:56.49+00	\N	cmkuwsxl30000h90r00c40gsk	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-26 15:36:12.168+00	2026-01-26 21:55:56.49+00
cmky9gx9l009zh90rzbg9ffnd	5	both	delivered	Boite au lettre du haut		2026-01-28 20:54:37.674+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-28 16:50:12.969+00	2026-01-28 20:54:37.674+00
cmkl9je1f00yzgr0rk7w6d0sz	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-19 17:03:59.081+00	\N	cmkkx4y5e00whgr0r70jh5znv	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-19 14:31:07.731+00	2026-01-19 17:03:59.081+00
cmky9gx9l00aah90rr9u1zqe7	6	dropoff	delivered	2306 placard étage		2026-01-28 21:15:11.53+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-28 16:50:12.969+00	2026-01-28 21:15:11.53+00
cmky9gx9l00a1h90rdkighwqd	7	dropoff	delivered			2026-01-28 21:39:36.091+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-28 16:50:12.969+00	2026-01-28 21:39:36.091+00
cmky9gx9l00a5h90r576j94d5	8	pickup	delivered			2026-01-28 22:01:05.483+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-28 16:50:12.969+00	2026-01-28 22:01:05.483+00
cmkfogq3000rpgr0r36vc8kmh	0	both	delivered			2026-01-15 19:14:45.998+00	\N	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-15 16:42:20.556+00	2026-01-15 19:14:45.999+00
cmky9gx9l00a8h90rvh58o2ts	10	both	delivered			2026-01-28 22:21:22.459+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-28 16:50:12.969+00	2026-01-28 22:21:22.459+00
cmky9gx9l00a4h90rahlp0i5x	11	both	delivered	x 3612 🔔 Devant la porte		2026-01-28 22:30:13.623+00	\N	cmkxumrww0086h90rb8rbdxv6	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-28 16:50:12.969+00	2026-01-28 22:30:13.623+00
cmkfogq3000rsgr0rbr01pgcj	1	both	delivered			2026-01-15 19:41:56.931+00	\N	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-15 16:42:20.556+00	2026-01-15 19:41:56.931+00
cmkfogq3000rlgr0rsw6ltof6	2	dropoff	delivered	Boite au lettre du haut		2026-01-15 23:25:12.443+00	\N	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-15 16:42:20.556+00	2026-01-15 23:25:12.443+00
cmkfogq3000rmgr0r3lhf6fji	3	both	delivered	3ème étage CODE: 2606		2026-01-15 23:39:59.654+00	https://www.storage.tds-transports.fr/ef820dcc-07a3-4529-8206-39a65e536939.avif	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-15 16:42:20.556+00	2026-01-15 23:39:59.654+00
cmkfogq3000rogr0rnc00g4l2	4	dropoff	delivered			2026-01-15 23:55:02.736+00	\N	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-15 16:42:20.556+00	2026-01-15 23:55:02.736+00
cml1075ff006bh90qbwdb6tfx	19	both	planned		\N	\N	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-30 14:53:58.971+00	2026-01-30 14:53:58.971+00
cmkfogq3000rrgr0rxz4jna94	5	pickup	delivered			2026-01-16 00:14:53.103+00	\N	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-15 16:42:20.556+00	2026-01-16 00:14:53.103+00
cml1075ff006eh90qfue05xvl	3	pickup	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-30 17:01:46.983+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-30 14:53:58.971+00	2026-01-30 17:01:46.983+00
cmkfogq3000rngr0rwdjhl8tc	6	pickup	delivered	À l'étage dans le placard	Pas de boîte	2026-01-16 00:17:28.069+00	https://www.storage.tds-transports.fr/191c5e1f-6da9-4327-a88b-8db79828be69.avif	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-15 16:42:20.556+00	2026-01-16 00:17:28.069+00
cmkfogq3000rtgr0r4n1p0vmh	7	both	delivered			2026-01-16 00:28:50.356+00	\N	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-15 16:42:20.556+00	2026-01-16 00:28:50.356+00
cml1075ff0069h90qvz813vku	5	dropoff	delivered			2026-01-30 17:25:51.285+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-30 14:53:58.971+00	2026-01-30 17:25:51.285+00
cmkfogq3000rqgr0ro0x2jf37	8	both	delivered	x 3612 🔔 Devant la porte		2026-01-16 00:37:51.129+00	\N	cmkf5xl1c00oigr0rw6rm4od3	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-15 16:42:20.556+00	2026-01-16 00:37:51.129+00
cml1075ff006ch90qqkk2yuht	7	dropoff	delivered			2026-01-30 17:54:35.667+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-30 14:53:58.971+00	2026-01-30 17:54:35.667+00
cml1075ff006dh90q77l3q8lm	8	both	delivered			2026-01-30 18:32:37.496+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-30 14:53:58.971+00	2026-01-30 18:32:37.496+00
cml1075ff006ah90qfr8x0ynw	11	both	delivered			2026-01-30 19:32:18.187+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-30 14:53:58.971+00	2026-01-30 19:32:18.187+00
cml1075ff006fh90q1eoejy52	13	dropoff	delivered	Fermé les Mercredi		2026-01-30 20:56:19.228+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-30 14:53:58.971+00	2026-01-30 20:56:19.228+00
cml1075ff006gh90q1w631rv8	15	both	delivered	Fermé les Vendredi		2026-01-30 21:17:32.665+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-30 14:53:58.971+00	2026-01-30 21:17:32.666+00
cml1075ff0068h90qmnloefhx	16	both	delivered			2026-01-30 22:11:57.393+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-30 14:53:58.971+00	2026-01-30 22:11:57.393+00
cmke3d24g00nggr0reyck1a31	1	pickup	delivered			2026-01-14 16:30:28.525+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2026-01-14 14:03:51.424+00	2026-01-14 16:30:28.525+00
cmke3d24g00ndgr0r3d1u7x5t	2	dropoff	delivered			2026-01-14 16:39:06.777+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2026-01-14 14:03:51.424+00	2026-01-14 16:39:06.777+00
cmke3d24g00nfgr0rwkhnvz2p	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-14 17:03:51.619+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-14 14:03:51.424+00	2026-01-14 17:03:51.619+00
cmke3d24g00n9gr0rwv6n0cpe	5	dropoff	delivered			2026-01-14 17:23:47.868+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-14 14:03:51.424+00	2026-01-14 17:23:47.868+00
cmke3lbxz00o4gr0rsd86zn1d	0	both	delivered	x 3612 🔔 Devant la porte		2026-01-14 17:44:48.845+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-14 14:10:17.399+00	2026-01-14 17:44:48.845+00
cmke3lbxz00o2gr0r5zzq5q8p	1	both	delivered			2026-01-14 17:44:54.581+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-14 14:10:17.399+00	2026-01-14 17:44:54.581+00
cmke3lbxz00o7gr0ruiikstfl	3	pickup	delivered			2026-01-14 17:44:57.741+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-14 14:10:17.399+00	2026-01-14 17:44:57.741+00
cmke3d24g00negr0r73q1jvj7	8	both	delivered			2026-01-14 18:40:35.099+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-14 14:03:51.424+00	2026-01-14 18:40:35.099+00
cmke3lbxz00o3gr0rfowxzr6a	6	dropoff	delivered		+ Collecte	2026-01-14 19:26:46.348+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-14 14:10:17.399+00	2026-01-14 19:26:46.349+00
cmke3d24g00nagr0rth1cz39r	10	both	delivered			2026-01-14 20:07:08.139+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-14 14:03:51.424+00	2026-01-14 20:07:08.139+00
cmke3d24g00ncgr0rwmp1km0o	12	dropoff	delivered			2026-01-14 20:07:10.555+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-14 14:03:51.424+00	2026-01-14 20:07:10.555+00
cmke3d24g00nhgr0ryt4kbmal	13	pickup	delivered	Fermé les Mercredi		2026-01-14 20:07:12.372+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-14 14:03:51.424+00	2026-01-14 20:07:12.372+00
cmke3d24g00njgr0r8tivotnc	14	pickup	delivered	Fermé les jeudi		2026-01-14 21:35:06.89+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-14 14:03:51.424+00	2026-01-14 21:35:06.89+00
cmke3d24g00nigr0re3wl5lez	15	both	delivered	Fermé les Vendredi		2026-01-14 21:35:09.574+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-14 14:03:51.424+00	2026-01-14 21:35:09.574+00
cmke3d24g00n8gr0reylguuo2	16	both	delivered			2026-01-14 21:35:11.632+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-14 14:03:51.424+00	2026-01-14 21:35:11.632+00
cmke3lbxz00nzgr0rtyxcrwtk	7	dropoff	delivered	3ème étage CODE: 2606		2026-01-14 22:06:08.502+00	https://www.storage.tds-transports.fr/a3ecfaa1-87ed-4369-8017-8f82ca564e84.avif	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-14 14:10:17.399+00	2026-01-14 22:06:08.502+00
cmke3lbxz00o6gr0rq8vwg1j1	8	dropoff	delivered			2026-01-14 22:21:11.604+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2026-01-14 14:10:17.399+00	2026-01-14 22:21:11.604+00
cmke3lbxz00nygr0rjvbtpxgt	9	dropoff	delivered	Boite au lettre du haut		2026-01-14 22:21:43.225+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-14 14:10:17.399+00	2026-01-14 22:21:43.225+00
cmke3lbxz00o9gr0ri8819zll	10	dropoff	delivered	2306 placard étage		2026-01-14 22:30:05.568+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-14 14:10:17.399+00	2026-01-14 22:30:05.568+00
cmke3d24g00nbgr0ri8sytsz5	20	dropoff	delivered			2026-01-14 22:36:49.502+00	\N	cmkdv1fp700lhgr0rsxhsrqrb	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-14 14:03:51.424+00	2026-01-14 22:36:49.502+00
cmke3lbxz00o1gr0rok7axdr3	11	dropoff	delivered			2026-01-14 22:55:12.761+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-14 14:10:17.399+00	2026-01-14 22:55:12.761+00
cmke3lbxz00o5gr0r26tm0n7o	13	pickup	delivered			2026-01-14 23:12:53.249+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-14 14:10:17.399+00	2026-01-14 23:12:53.249+00
cmke3lbxz00o0gr0r87co9f81	14	both	delivered	À l'étage dans le placard		2026-01-14 23:18:36.667+00	https://www.storage.tds-transports.fr/b542b671-94b1-4706-a3fb-3516a79f4a11.avif	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-14 14:10:17.399+00	2026-01-14 23:18:36.667+00
cmke3lbxz00o8gr0rw0pt11y4	15	both	delivered			2026-01-14 23:28:39.138+00	\N	cmkduj7ae00l0gr0rhykttdca	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-14 14:10:17.399+00	2026-01-14 23:28:39.139+00
cmkvcy0y1003jh90rdoiur2yo	0	both	delivered			2026-01-26 17:22:09.409+00	\N	cmkux08xd0009h90ru4ekqry4	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-26 16:04:11.209+00	2026-01-26 17:22:09.409+00
cmkvcy0y1003mh90rc7mabb8t	1	both	delivered			2026-01-26 17:22:11.062+00	\N	cmkux08xd0009h90ru4ekqry4	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-26 16:04:11.209+00	2026-01-26 17:22:11.062+00
cmkvcy0y1003kh90r8skizzkq	2	both	delivered			2026-01-26 19:02:28.07+00	\N	cmkux08xd0009h90ru4ekqry4	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-26 16:04:11.209+00	2026-01-26 19:02:28.07+00
cmkvcy0y1003hh90r3sclanxs	3	dropoff	delivered	Boite au lettre du haut		2026-01-26 20:09:06.031+00	\N	cmkux08xd0009h90ru4ekqry4	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-26 16:04:11.209+00	2026-01-26 20:09:06.031+00
cmkvcy0y1003ih90ry5p5q61d	4	both	delivered			2026-01-26 20:36:00.593+00	\N	cmkux08xd0009h90ru4ekqry4	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-26 16:04:11.209+00	2026-01-26 20:36:00.593+00
cmkvcy0y1003oh90r12hf0yyk	5	both	delivered	Fermé mercredi & jeudi		2026-01-26 20:50:45.861+00	\N	cmkux08xd0009h90ru4ekqry4	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-26 16:04:11.209+00	2026-01-26 20:50:45.861+00
cmkvcy0y1003nh90rmx5x7g1n	6	both	delivered			2026-01-26 22:16:31.605+00	\N	cmkux08xd0009h90ru4ekqry4	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-26 16:04:11.209+00	2026-01-26 22:16:31.605+00
cmkvcy0y1003lh90rgkj3ak5e	7	both	delivered	x 3612 🔔 Devant la porte		2026-01-26 22:16:34.827+00	\N	cmkux08xd0009h90ru4ekqry4	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-26 16:04:11.209+00	2026-01-26 22:16:34.827+00
cmko5n9d70020gr0r9ylh3t3g	1	pickup	delivered			2026-01-21 16:55:51.647+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2026-01-21 15:05:28.363+00	2026-01-21 16:55:51.648+00
cmko5n9d7001zgr0r5hwmhls0	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-21 17:36:08.965+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-21 15:05:28.363+00	2026-01-21 17:36:08.965+00
cmko5n9d7001sgr0relski2y4	4	dropoff	delivered			2026-01-21 17:49:43.095+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2026-01-21 15:05:28.363+00	2026-01-21 17:49:43.095+00
cmkzqailj0054h90q248nsf15	4	both	delivered	Boite au lettre du haut		2026-01-30 00:43:39.915+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-29 17:28:53.67+00	2026-01-30 00:43:39.915+00
cmko5n9d7001qgr0rasbag4nf	5	dropoff	delivered			2026-01-21 18:02:14.818+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-21 15:05:28.363+00	2026-01-21 18:02:14.818+00
cmko5n9d7001xgr0rhp7ku2h4	7	dropoff	delivered			2026-01-21 18:21:34.639+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-21 15:05:28.363+00	2026-01-21 18:21:34.639+00
cmko5n9d7001ygr0rbkzkfmpd	8	both	delivered			2026-01-21 18:44:23.301+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-21 15:05:28.363+00	2026-01-21 18:44:23.301+00
cmko5n9d7001tgr0rtx8rx40b	9	dropoff	delivered			2026-01-21 19:09:23.095+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001jz0l6qz399lde	cmfxz4zwu001iz0l6b70uwclc	2026-01-21 15:05:28.363+00	2026-01-21 19:09:23.095+00
cmko5n9d7001wgr0rue8wgrrq	10	dropoff	delivered			2026-01-21 19:55:17.215+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmiaos1hs0001ky0rmvj0x5q1	cmiaos1hq0000ky0rdqb761bd	2026-01-21 15:05:28.363+00	2026-01-21 19:55:17.215+00
cmko5n9d7001rgr0rx34nemxk	11	both	delivered			2026-01-21 19:55:18.958+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-21 15:05:28.363+00	2026-01-21 19:55:18.958+00
cmkzqailj0055h90qsmo6v9i4	6	dropoff	delivered	3ème étage CODE: 2606		2026-01-30 00:59:21.217+00	https://www.storage.tds-transports.fr/2689d28e-edf2-4777-86ca-af360d8447dd.avif	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-29 17:28:53.67+00	2026-01-30 00:59:21.217+00
cmko5n9d7001vgr0rhl9tco6l	12	dropoff	delivered			2026-01-21 20:09:15.817+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-21 15:05:28.363+00	2026-01-21 20:09:15.817+00
cmko5n9d70021gr0rnk7ab9r9	13	dropoff	delivered	Fermé les Mercredi		2026-01-21 20:37:37.145+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-21 15:05:28.363+00	2026-01-21 20:37:37.145+00
cmko5n9d70023gr0rxcnim28r	14	pickup	delivered	Fermé les jeudi		2026-01-21 21:14:28.56+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-21 15:05:28.363+00	2026-01-21 21:14:28.56+00
cmkzqailj0057h90qow9pz7bw	10	both	delivered	À l'étage dans le placard		2026-01-30 01:49:30.73+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-29 17:28:53.67+00	2026-01-30 01:49:30.73+00
cmko5n9d70022gr0rrk7hyldq	15	both	delivered	Fermé les Vendredi		2026-01-21 21:29:16.359+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-21 15:05:28.363+00	2026-01-21 21:29:16.359+00
cmko5n9d7001pgr0rnekxrs1h	16	both	delivered			2026-01-21 22:09:51.382+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-21 15:05:28.363+00	2026-01-21 22:09:51.382+00
cmko5n9d70024gr0rb90jy9hr	18	dropoff	delivered	Fermé les Mercredi		2026-01-21 22:32:16.572+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-21 15:05:28.363+00	2026-01-21 22:32:16.572+00
cmko5n9d7001ugr0rpi0bnlv7	19	dropoff	delivered			2026-01-21 23:00:46.799+00	\N	cmko3ax5d000fgr0rezbvuzpz	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-21 15:05:28.363+00	2026-01-21 23:00:46.799+00
cmkzqailj0056h90qvtgxrioo	3	pickup	delivered			2026-01-29 23:23:40.153+00	https://www.storage.tds-transports.fr/c9fd3b6c-b8c8-44a5-8f0e-1e50cf959341.avif	cmkz7wvoi0014h90qizjcxhp6	cmj8fy13701e6gr0rzan7pd7n	cmj8fy13701e5gr0reelcb512	2026-01-29 17:28:53.67+00	2026-01-29 23:23:40.153+00
cmko5oyoo002bgr0rswxcmwrr	0	both	delivered	x 3612 🔔 Devant la porte		2026-01-21 17:19:04.319+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-21 15:06:47.832+00	2026-01-21 17:19:04.319+00
cmko5oyoo0028gr0rwyr4sonm	1	both	delivered			2026-01-21 17:19:08.964+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-21 15:06:47.832+00	2026-01-21 17:19:08.964+00
cmko5oyoo002dgr0r9c9pijxz	3	both	delivered			2026-01-21 18:05:12.752+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-21 15:06:47.832+00	2026-01-21 18:05:12.752+00
cmko5oyoo0029gr0r1qoi58fi	4	dropoff	delivered			2026-01-21 18:36:56.667+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2026-01-21 15:06:47.832+00	2026-01-21 18:36:56.667+00
cmko5oyoo002agr0rjytoqjn5	5	dropoff	delivered			2026-01-21 19:51:27.129+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-21 15:06:47.832+00	2026-01-21 19:51:27.129+00
cmko5oyoo002ggr0rhpy0php2	9	dropoff	delivered	2306 placard étage		2026-01-21 20:57:58.329+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-21 15:06:47.832+00	2026-01-21 20:57:58.329+00
cmko5oyoo002fgr0rco7fzvk6	11	dropoff	delivered	La porte de gauche		2026-01-21 21:31:21.871+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-21 15:06:47.832+00	2026-01-21 21:31:21.871+00
cmko5oyoo0027gr0rp4ki7o1s	12	dropoff	delivered			2026-01-21 21:50:29.722+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-21 15:06:47.832+00	2026-01-21 21:50:29.723+00
cmko5oyoo002cgr0rcyn7f31f	14	pickup	delivered			2026-01-21 22:12:42.81+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-21 15:06:47.832+00	2026-01-21 22:12:42.81+00
cmko5oyoo0026gr0rsyyp7e3g	15	pickup	delivered	À l'étage dans le placard	Pas de boite	2026-01-21 22:16:28.573+00	https://www.storage.tds-transports.fr/a3b22b52-3e6d-4c7f-bd05-6264e8c58b2e.avif	cmknqhkf90000gr0rq3249ivb	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-21 15:06:47.832+00	2026-01-21 22:16:28.573+00
cmko5oyoo002egr0rzs3bbzne	16	pickup	delivered			2026-01-21 22:44:05.079+00	\N	cmknqhkf90000gr0rq3249ivb	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-21 15:06:47.832+00	2026-01-21 22:44:05.08+00
cmkpksz0r003tgr0rgilu4hji	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-22 17:28:11.235+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-22 14:57:35.306+00	2026-01-22 17:28:11.235+00
cmkpksz0r003ogr0rgaczfw6b	5	dropoff	delivered			2026-01-22 17:45:44.008+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-22 14:57:35.306+00	2026-01-22 17:45:44.008+00
cmkpksz0r003sgr0rqf9d26ms	8	both	delivered			2026-01-22 18:24:00.392+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-22 14:57:35.306+00	2026-01-22 18:24:00.392+00
cmkpksz0r003pgr0rkprkycd3	11	both	delivered			2026-01-22 19:22:59.979+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-22 14:57:35.306+00	2026-01-22 19:22:59.98+00
cmkpksz0r003vgr0re8tk5iju	14	both	delivered	Fermé les jeudi		2026-01-22 20:33:34.197+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-22 14:57:35.306+00	2026-01-22 20:33:34.197+00
cmkpksz0r003ugr0r4k1sbwcg	15	both	delivered	Fermé les Vendredi		2026-01-22 21:03:52.826+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-22 14:57:35.306+00	2026-01-22 21:03:52.826+00
cmkpksz0q003ngr0r3dz6xqbt	16	both	delivered			2026-01-22 21:51:39.956+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-22 14:57:35.306+00	2026-01-22 21:51:39.956+00
cmkpksz0r003wgr0rs9dettpj	18	both	delivered	Fermé les Mercredi		2026-01-22 21:51:42.549+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-22 14:57:35.306+00	2026-01-22 21:51:42.549+00
cmkpksz0r003rgr0r45lgi9jk	19	both	delivered			2026-01-22 22:11:42.613+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-22 14:57:35.306+00	2026-01-22 22:11:42.613+00
cmkpksz0r003qgr0rgr3skoxk	20	dropoff	delivered			2026-01-22 22:45:58.441+00	\N	cmkp9nrly002ugr0rr7nevk92	cmfxz4zwv0025z0l6p6fal4j9	cmfxz4zwv0024z0l6xpkgmdf9	2026-01-22 14:57:35.306+00	2026-01-22 22:45:58.441+00
cmkmr9t98016lgr0rbjaaeljs	7	both	delivered			2026-01-21 00:06:23.781+00	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-20 15:35:20.156+00	2026-01-21 00:06:23.781+00
cmkmr9t98016mgr0r7r3dudjl	1	both	delivered			2026-01-20 16:49:42.949+00	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-20 15:35:20.156+00	2026-01-20 16:49:42.949+00
cmkmr9t98016qgr0rxdg2zx6q	2	both	delivered			2026-01-20 18:21:21.542+00	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-20 15:35:20.156+00	2026-01-20 18:21:21.542+00
cmkzqailj0059h90q1ioc9r55	0	both	delivered			2026-01-29 19:15:40.303+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-29 17:28:53.67+00	2026-01-29 19:15:40.303+00
cmkzqailj005dh90qg9qf9eie	1	both	delivered			2026-01-29 20:11:29.872+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-29 17:28:53.67+00	2026-01-29 20:11:29.872+00
cmkzqailj005ah90q48rayyl3	2	dropoff	delivered		+ Collecte	2026-01-29 22:12:22.864+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-29 17:28:53.67+00	2026-01-29 22:12:22.864+00
cmkzqailj005fh90q9im7weon	5	pickup	delivered	2306 placard étage		2026-01-30 00:47:10.123+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-29 17:28:53.67+00	2026-01-30 00:47:10.123+00
cmkzqailj0058h90qzzvobdfn	7	dropoff	delivered			2026-01-30 01:14:22.761+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-29 17:28:53.67+00	2026-01-30 01:14:22.761+00
cmkmr9t98016pgr0rce69a159	9	pickup	planned		\N	\N	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-20 15:35:20.156+00	2026-01-20 15:52:47.91+00
cmkmr9t98016kgr0rsp5waqv7	10	pickup	planned	À l'étage dans le placard	\N	\N	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-20 15:35:20.156+00	2026-01-20 15:52:47.91+00
cmkmr9t98016rgr0r2sl44n5n	11	both	planned		\N	\N	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-20 15:35:20.156+00	2026-01-20 15:52:47.91+00
cmkmr9t98016ogr0r0a9a6tb5	0	both	delivered	x 3612 🔔 Devant la porte		2026-01-20 16:19:42.768+00	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-20 15:35:20.156+00	2026-01-20 16:19:42.768+00
cmkmr9t98016ngr0rhpby0ekv	3	dropoff	delivered			2026-01-20 20:06:41.842+00	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-20 15:35:20.156+00	2026-01-20 20:06:41.842+00
cmkmr9t98016jgr0r0pmssdwv	4	both	delivered			2026-01-20 21:43:28.729+00	https://www.storage.tds-transports.fr/49bf043b-b2b8-4899-bead-14deb65cab05.avif	cmkmag8ua010xgr0rnorw43s0	cmj8fy13701e6gr0rzan7pd7n	cmj8fy13701e5gr0reelcb512	2026-01-20 15:35:20.156+00	2026-01-20 21:43:28.729+00
cmkmr9t98016igr0rnomzelb1	5	both	delivered	Boite au lettre du haut		2026-01-20 23:02:20.239+00	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-20 15:35:20.156+00	2026-01-20 23:02:20.239+00
cmkzqailj005gh90qptw90m0m	8	both	delivered	Fermé mercredi & jeudi		2026-01-30 01:49:24.178+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-29 17:28:53.67+00	2026-01-30 01:49:24.178+00
cmkmr9t98016sgr0ric00n9sj	6	dropoff	delivered	La porte de gauche		2026-01-20 23:44:31.825+00	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-20 15:35:20.156+00	2026-01-20 23:44:31.825+00
cmkzqailj005ch90q6bivw93c	9	both	delivered			2026-01-30 01:49:27.768+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwu000vz0l6ejbrh7fe	cmfxz4zwu000uz0l6unuyenon	2026-01-29 17:28:53.67+00	2026-01-30 01:49:27.768+00
cmkzqailj005eh90qa9q6f69e	11	both	delivered			2026-01-30 01:49:33.12+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-29 17:28:53.67+00	2026-01-30 01:49:33.12+00
cmkzqailj005bh90q1ysqyd45	12	both	delivered	x 3612 🔔 Devant la porte		2026-01-30 02:18:27.843+00	\N	cmkz7wvoi0014h90qizjcxhp6	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-29 17:28:53.67+00	2026-01-30 02:18:27.844+00
cmkmr9t98016tgr0rwhtu5ci1	8	pickup	en_route	Fermé mercredi & jeudi	\N	\N	\N	cmkmag8ua010xgr0rnorw43s0	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-20 15:35:20.156+00	2026-01-21 00:06:23.831+00
cmkzldg63004oh90qm3n21u0u	18	dropoff	delivered	Fermé les Mercredi		2026-01-29 23:23:21.439+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-29 15:11:12.411+00	2026-01-29 23:23:21.439+00
cml1075ff006hh90qs69mkj91	14	both	delivered	Fermé les jeudi		2026-01-30 20:56:21.989+00	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-30 14:53:58.971+00	2026-01-30 20:56:21.989+00
cml18h1bo0073h90qd7v0l01c	0	both	delivered	x 3612 🔔 Devant la porte		2026-01-30 21:48:03.299+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-30 18:45:37.139+00	2026-01-30 21:48:03.299+00
cml18h1bn0070h90qy6v0l9iv	1	both	delivered			2026-01-30 21:48:05.029+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-30 18:45:37.139+00	2026-01-30 21:48:05.029+00
cml18h1bo0074h90qvomezrv2	3	both	delivered			2026-01-30 21:48:12.117+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-30 18:45:37.139+00	2026-01-30 21:48:12.117+00
cml18h1bn0071h90qv3rknwq2	4	dropoff	delivered			2026-01-30 21:48:16.444+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2026-01-30 18:45:37.139+00	2026-01-30 21:48:16.444+00
cml18h1bn0072h90q725s1snb	5	dropoff	delivered			2026-01-30 21:48:19.898+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwt000hz0l6khrgmt7o	cmfxz4zwt000gz0l6c4hu1zfe	2026-01-30 18:45:37.139+00	2026-01-30 21:48:19.898+00
cml18h1bn006wh90qjeh7l6hg	8	dropoff	delivered	Boite au lettre du haut		2026-01-30 22:09:13.649+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-30 18:45:37.139+00	2026-01-30 22:09:13.649+00
cml1075ff006ih90q4u4dkfrw	18	pickup	en_route	Fermé les Mercredi	\N	\N	\N	cml0qbq11005ph90qvcnk0o5e	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-30 14:53:58.971+00	2026-01-30 22:11:57.454+00
cml18h1bn006xh90qaiwze1vw	10	pickup	delivered	3ème étage CODE: 2606		2026-01-30 22:26:44.016+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwt000jz0l6uk09y3b6	cmfxz4zwt000iz0l6shrzls03	2026-01-30 18:45:37.139+00	2026-01-30 22:26:44.016+00
cml18h1bo0076h90qogfojnae	11	dropoff	delivered	La porte de gauche		2026-01-30 23:29:23.63+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwt000fz0l6iax5t11k	cmfxz4zwt000ez0l6haauf9ol	2026-01-30 18:45:37.139+00	2026-01-30 23:29:23.63+00
cml18h1bn006zh90qh7njs0yu	12	both	delivered			2026-01-30 23:29:25.234+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-30 18:45:37.139+00	2026-01-30 23:29:25.234+00
cml18h1bo0077h90qo5g0dn7y	13	both	delivered	Fermé mercredi & jeudi		2026-01-30 23:29:26.911+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-30 18:45:37.139+00	2026-01-30 23:29:26.911+00
cml18h1bn006yh90qffmz1zxx	15	pickup	delivered	À l'étage dans le placard	Pas de boite	2026-01-30 23:29:38.884+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-30 18:45:37.139+00	2026-01-30 23:29:38.884+00
cml18h1bo0075h90qp1v7c1yf	16	both	delivered			2026-01-30 23:40:54.937+00	\N	cml0qavtr005hh90q547cl0jn	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-30 18:45:37.139+00	2026-01-30 23:40:54.937+00
cmkzldg63004hh90q12fptq7c	2	pickup	delivered			2026-01-29 16:44:08.951+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2026-01-29 15:11:12.411+00	2026-01-29 16:44:08.951+00
cmkzldg63004ch90qzstpz8wo	5	pickup	delivered			2026-01-29 17:30:59.467+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-29 15:11:12.411+00	2026-01-29 17:30:59.467+00
cmkzldg63004ih90qw4tpzzip	7	dropoff	delivered			2026-01-29 17:57:01.16+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-29 15:11:12.411+00	2026-01-29 17:57:01.16+00
cmkzldg63004jh90qgtt4pa2d	8	both	delivered			2026-01-29 18:20:59.318+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-29 15:11:12.411+00	2026-01-29 18:20:59.319+00
cmkzldg63004eh90q9bp8k9a4	11	both	delivered			2026-01-29 19:16:49.358+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-29 15:11:12.411+00	2026-01-29 19:16:49.358+00
cmkzldg63004gh90q2bpgegyi	12	dropoff	delivered			2026-01-29 19:47:02.899+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-29 15:11:12.411+00	2026-01-29 19:47:02.899+00
cmkzldg63004bh90qfdwqjoqd	16	both	delivered			2026-01-29 23:23:17.348+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-29 15:11:12.411+00	2026-01-29 23:23:17.348+00
cmkzldg63004dh90quu6a1zkc	17	dropoff	delivered			2026-01-29 23:23:19.5+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwv001zz0l65qqq9usa	cmfxz4zwv001yz0l6sidgj4lq	2026-01-29 15:11:12.411+00	2026-01-29 23:23:19.5+00
cmkzldg63004fh90qefx2brn8	19	both	delivered			2026-01-29 23:23:26.336+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-29 15:11:12.411+00	2026-01-29 23:23:26.336+00
cmkwskvkz007ph90rksws0wz9	1	dropoff	delivered			2026-01-27 17:36:10.822+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2026-01-27 16:09:37.763+00	2026-01-27 17:36:10.822+00
cmkwskvkz007jh90rnx5tlv19	0	both	delivered			2026-01-27 17:09:49.544+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-27 16:09:37.763+00	2026-01-27 17:09:49.544+00
cmkwskzfv0080h90rx8fn1fm0	0	both	delivered	x 3612 🔔 Devant la porte		2026-01-27 17:31:35.501+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwt0005z0l6377zbls6	cmfxz4zwt0004z0l6zqng8yuq	2026-01-27 16:09:42.763+00	2026-01-27 17:31:35.501+00
cmkwskvkz007oh90r2hrlqn6a	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-27 17:59:51.103+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-27 16:09:37.763+00	2026-01-27 17:59:51.103+00
cmkwskzfv007yh90rinj2rycx	1	both	delivered			2026-01-27 18:02:01.163+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwt0007z0l6tsu4632a	cmfxz4zwt0006z0l6yr9euw2m	2026-01-27 16:09:42.763+00	2026-01-27 18:02:01.163+00
cmkwskvkz007hh90rpqqifyt7	5	both	delivered			2026-01-27 18:15:16.75+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001bz0l6v7xbgn16	cmfxz4zwu001az0l6zkwsszng	2026-01-27 16:09:37.763+00	2026-01-27 18:15:16.75+00
cmkwskvkz007mh90rujvm4nza	7	both	delivered			2026-01-27 18:36:22.199+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-27 16:09:37.763+00	2026-01-27 18:36:22.199+00
cmkwskvkz007nh90r3nczk0j7	8	both	delivered			2026-01-27 19:03:19.626+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-27 16:09:37.763+00	2026-01-27 19:03:19.626+00
cmkwskzfv0082h90r4hdhnbi7	2	both	delivered			2026-01-27 19:16:05.091+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwt000bz0l61lev0d5m	cmfxz4zwt000az0l6a8g0jvfx	2026-01-27 16:09:42.763+00	2026-01-27 19:16:05.091+00
cmkwskzfv007zh90ruhzqaeo6	3	dropoff	delivered		+ Collecte	2026-01-27 19:55:15.159+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwt000dz0l6t3nwdm9u	cmfxz4zwt000cz0l63jopkl86	2026-01-27 16:09:42.763+00	2026-01-27 19:55:15.159+00
cmkwskvkz007ih90r427tzo7g	11	both	delivered			2026-01-27 20:02:07.718+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-27 16:09:37.763+00	2026-01-27 20:02:07.718+00
cmkwskvkz007lh90rl4v2tq42	12	dropoff	delivered			2026-01-27 20:23:39.252+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-27 16:09:37.763+00	2026-01-27 20:23:39.252+00
cmkwskvkz007qh90rzgpj5pmd	13	both	delivered	Fermé les Mercredi		2026-01-27 20:52:24.034+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-27 16:09:37.763+00	2026-01-27 20:52:24.034+00
cmkwskvkz007sh90rtcaxckkq	14	both	delivered	Fermé les jeudi		2026-01-27 21:24:59.241+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-27 16:09:37.763+00	2026-01-27 21:24:59.241+00
cmkwskvkz007rh90r30176g8t	15	both	delivered	Fermé les Vendredi		2026-01-27 21:40:26.976+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-27 16:09:37.763+00	2026-01-27 21:40:26.976+00
cmkwskzfv007vh90r58zle4qu	4	dropoff	delivered			2026-01-27 22:01:47.065+00	https://www.storage.tds-transports.fr/edc9594f-c5c3-4743-8b33-373da3e632fe.avif	cmkwbbk4b003xh90rjvbjs14g	cmj8fy13701e6gr0rzan7pd7n	cmj8fy13701e5gr0reelcb512	2026-01-27 16:09:42.763+00	2026-01-27 22:01:47.065+00
cmkwskvkz007gh90r11qtdny1	16	both	delivered			2026-01-27 22:17:32.903+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-27 16:09:37.763+00	2026-01-27 22:17:32.903+00
cmkwskzfv0081h90rx3u1zb8u	5	pickup	delivered			2026-01-27 23:30:34.959+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwt000lz0l6owoi6g7u	cmfxz4zwt000kz0l6o7lrq20g	2026-01-27 16:09:42.763+00	2026-01-27 23:30:34.959+00
cmkwskzfv007uh90rynhs2eiz	6	dropoff	delivered	Boite au lettre du haut		2026-01-27 23:30:36.852+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwu000nz0l6vptvuhz7	cmfxz4zwt000mz0l6pwecpw20	2026-01-27 16:09:42.763+00	2026-01-27 23:30:36.852+00
cmkwskzfv0084h90r704kxyh5	7	dropoff	delivered	2306 placard étage		2026-01-27 23:30:39.367+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwu000pz0l66llbzvxl	cmfxz4zwu000oz0l6aj2tgboj	2026-01-27 16:09:42.763+00	2026-01-27 23:30:39.367+00
cmkwskvkz007kh90rhaikz6w0	19	pickup	delivered			2026-01-27 23:37:09.56+00	\N	cmkwan8n6003ph90rgltflhui	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-27 16:09:37.763+00	2026-01-27 23:37:09.56+00
cmkwskzfv007xh90rvxmu9r7q	8	dropoff	delivered			2026-01-27 23:58:38.342+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwu000rz0l67swnwr7w	cmfxz4zwu000qz0l6k4qx5gcg	2026-01-27 16:09:42.763+00	2026-01-27 23:58:38.342+00
cmkwskzfv0085h90rxmrbl01d	9	pickup	delivered	Fermé mercredi & jeudi		2026-01-28 00:17:17.667+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwu000tz0l6za4gmxhm	cmfxz4zwu000sz0l6ciblpcl8	2026-01-27 16:09:42.763+00	2026-01-28 00:17:17.667+00
cmkwskzfv007wh90rig7cy2m5	10	pickup	delivered	À l'étage dans le placard		2026-01-28 00:24:13.433+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwu000xz0l6virvjlx8	cmfxz4zwu000wz0l62zksqdrp	2026-01-27 16:09:42.763+00	2026-01-28 00:24:13.433+00
cmkwskzfv0083h90rvg74yegi	11	pickup	delivered			2026-01-28 00:34:45.416+00	\N	cmkwbbk4b003xh90rjvbjs14g	cmfxz4zwu000zz0l6ke2so588	cmfxz4zwu000yz0l6ldp5p81b	2026-01-27 16:09:42.763+00	2026-01-28 00:34:45.416+00
cmky59791008xh90r0mmexvn9	0	dropoff	delivered			2026-01-28 16:41:12.624+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu0011z0l6mxi3uvv6	cmfxz4zwu0010z0l60d4hr8gn	2026-01-28 14:52:14.197+00	2026-01-28 16:41:12.624+00
cmky597910091h90rqlddu1nl	2	dropoff	delivered			2026-01-28 17:43:13.879+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu0015z0l6yk4ftah0	cmfxz4zwu0014z0l6m7wtycqr	2026-01-28 14:52:14.197+00	2026-01-28 17:43:13.879+00
cmky597910094h90rei8vu8ub	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-28 18:10:52.614+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-28 14:52:14.197+00	2026-01-28 18:10:52.614+00
cmky59791008yh90r2e5df7vq	4	dropoff	delivered			2026-01-28 18:10:54.655+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu0019z0l6zp0crwh8	cmfxz4zwu0018z0l6dronn9u9	2026-01-28 14:52:14.197+00	2026-01-28 18:10:54.655+00
cmky597910092h90r9wesqmy6	7	dropoff	delivered			2026-01-28 18:31:32.532+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu001fz0l6t4ipmm4j	cmfxz4zwu001ez0l6qvd3idqv	2026-01-28 14:52:14.197+00	2026-01-28 18:31:32.532+00
cmky597910093h90r9ztski75	8	both	delivered			2026-01-28 18:56:45.33+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu001hz0l6bs46doc7	cmfxz4zwu001gz0l6d9nsn8j4	2026-01-28 14:52:14.197+00	2026-01-28 18:56:45.33+00
cmky59791008wh90rfddimu20	11	both	delivered			2026-01-28 19:57:00.925+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu001lz0l660mpkd0r	cmfxz4zwu001kz0l6g65kmde2	2026-01-28 14:52:14.197+00	2026-01-28 19:57:00.925+00
cmky597910090h90r7ml01d7n	12	dropoff	delivered			2026-01-28 20:18:32.403+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu001nz0l6phnv13ya	cmfxz4zwu001mz0l6r4dmbx2m	2026-01-28 14:52:14.197+00	2026-01-28 20:18:32.403+00
cmky597910096h90r10w2c3n8	14	pickup	delivered	Fermé les jeudi		2026-01-28 21:20:17.496+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu001rz0l6zsw1krxj	cmfxz4zwu001qz0l6ey1vznej	2026-01-28 14:52:14.197+00	2026-01-28 21:20:17.496+00
cmky597910095h90ren9mgumf	15	both	delivered	Fermé les Vendredi		2026-01-28 21:42:46.153+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-28 14:52:14.197+00	2026-01-28 21:42:46.153+00
cmky59791008vh90rjeb9p7ha	16	both	delivered			2026-01-28 22:25:54.172+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwu001vz0l6smmcx7dy	cmfxz4zwu001uz0l65paxy9cb	2026-01-28 14:52:14.197+00	2026-01-28 22:25:54.172+00
cmky597910097h90rhyhnp78l	18	dropoff	delivered	Fermé les Mercredi		2026-01-28 22:57:32.111+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwv0021z0l6dlwf7doq	cmfxz4zwv0020z0l6xoe8ii70	2026-01-28 14:52:14.197+00	2026-01-28 22:57:32.111+00
cmky59791008zh90rg6gxysr2	19	dropoff	delivered			2026-01-28 23:41:45.011+00	\N	cmky59106008fh90rb0kjwky7	cmfxz4zwv0023z0l60za498k4	cmfxz4zwv0022z0l6kl4987n9	2026-01-28 14:52:14.197+00	2026-01-28 23:41:45.011+00
cmkzldg63004lh90qte0aci2a	1	pickup	delivered			2026-01-29 16:32:59.466+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu0013z0l6a38aqbd4	cmfxz4zwu0012z0l61iqy8ovm	2026-01-29 15:11:12.411+00	2026-01-29 16:32:59.466+00
cmkzldg63004kh90qf5zldjzj	3	both	delivered	753B Fermé Lundi aprèm et Vendredi		2026-01-29 17:12:03.623+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu0017z0l6ub68avv8	cmfxz4zwu0016z0l6b3qq7nz5	2026-01-29 15:11:12.411+00	2026-01-29 17:12:03.624+00
cmkzldg63004mh90qa2dvw07m	13	dropoff	delivered	Fermé les Mercredi		2026-01-29 20:09:12.5+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu001pz0l6qnbahf8g	cmfxz4zwu001oz0l6iz9xe6e9	2026-01-29 15:11:12.411+00	2026-01-29 20:09:12.5+00
cmkzldg63004nh90qg8wy7to5	15	pickup	delivered	Fermé les Vendredi		2026-01-29 23:23:14.705+00	\N	cmkz7rjj50000h90q219ycnlp	cmfxz4zwu001tz0l6lih8lryx	cmfxz4zwu001sz0l64myqptrd	2026-01-29 15:11:12.411+00	2026-01-29 23:23:14.705+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, external_id, first_name, last_name, role, "companyId", "vehicleId", created_at, updated_at) FROM stdin;
cmfxz52gt002ez0l6ekycmz55	oudjedi.chabane@tds-transports.fr	user_30gXqhZkQRhDD3zgMUBJ7NHqDdr	Oudjedi	Chabane	admin	cmfxz4zwr0000z0l67js09uij	cmfxz52gu002fz0l61kbsbg10	2025-09-24 12:42:31.998+00	2025-09-24 12:42:31.998+00
cmfxz52nl002hz0l6bk088s1e	bilel-du-73@hotmail.fr	user_32Ha67FyAPJUPH87KNYvcEbxfRS	Bilel	Mokrane	member	cmfxz4zwr0000z0l67js09uij	cmfxz52nl002iz0l6jl2a26hr	2025-09-24 12:42:31.998+00	2025-09-24 12:42:31.998+00
cmfxz52nf002gz0l63lkrygch	m.culoma@adeis.org	user_30gYSl8gOm0vjGML2nWKXbkIN4r	Maeva	Culoma	admin	cmfxz4zws0002z0l6x67s4cw9	\N	2025-09-24 12:42:31.998+00	2025-09-24 12:42:31.998+00
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vehicles (id, plate, model, company_id, created_at, updated_at) FROM stdin;
cmfxz52gu002fz0l61kbsbg10	HF-584-PB	2025 Explorer EV	cmfxz4zwr0000z0l67js09uij	2025-09-24 12:42:31.998+00	2025-09-24 12:42:31.998+00
cmfxz52nl002iz0l6jl2a26hr	HF-559-PB	2025 Explorer EV	cmfxz4zwr0000z0l67js09uij	2025-09-24 12:42:31.998+00	2025-09-24 12:42:31.998+00
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
-- Name: batch_items batch_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_items
    ADD CONSTRAINT batch_items_pkey PRIMARY KEY (id);


--
-- Name: batches batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT batches_pkey PRIMARY KEY (id);


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
-- Name: batch_items_batch_id_company_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX batch_items_batch_id_company_id_key ON public.batch_items USING btree (batch_id, company_id);


--
-- Name: batches_delivery_company_id_client_company_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX batches_delivery_company_id_client_company_id_idx ON public.batches USING btree (delivery_company_id, client_company_id);


--
-- Name: batches_delivery_company_id_client_company_id_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX batches_delivery_company_id_client_company_id_name_key ON public.batches USING btree (delivery_company_id, client_company_id, name);


--
-- Name: companies_type_parent_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX companies_type_parent_id_idx ON public.companies USING btree (type, parent_id);


--
-- Name: deliveries_date_delivery_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deliveries_date_delivery_status_idx ON public.deliveries USING btree (date, delivery_status);


--
-- Name: deliveries_driver_id_vehicle_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deliveries_driver_id_vehicle_id_idx ON public.deliveries USING btree (driver_id, vehicle_id);


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
-- Name: batch_items batch_items_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_items
    ADD CONSTRAINT batch_items_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.batches(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: batch_items batch_items_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_items
    ADD CONSTRAINT batch_items_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: batches batches_client_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT batches_client_company_id_fkey FOREIGN KEY (client_company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: batches batches_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT "batches_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: batches batches_delivery_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT batches_delivery_company_id_fkey FOREIGN KEY (delivery_company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: batches batches_driver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batches
    ADD CONSTRAINT batches_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: deliveries deliveries_client_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_client_company_id_fkey FOREIGN KEY (client_company_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: deliveries deliveries_delivery_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_delivery_batch_id_fkey FOREIGN KEY (delivery_batch_id) REFERENCES public.batches(id) ON UPDATE CASCADE ON DELETE CASCADE;


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

\unrestrict EU7hTEB4Ho2qhcEUmgUF0K9nxaLBVagD4IIn2B4yu5TYj1XZaVY3fYWHO99jmZy

