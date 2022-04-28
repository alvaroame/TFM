--TABLES
SET default_tablespace = ts_licpub_data;
SET default_with_oids = false;

--Se crea tabla cpv
CREATE TABLE if not exists licpub.licitacion_es
(
    id_licitacion_es integer NOT NULL,
    id_cpv integer NULL,
    identificador character varying(150) NOT NULL,
    expediente character varying(50) NOT NULL,
    estatus character varying(5) NOT NULL,
    presupuesto NUMERIC(15, 3) NOT NULL,
    moneda character varying(5) NOT NULL,
    objeto character varying(2500) NOT NULL,
    titulo character varying(2500) NOT NULL,
    link character varying(150) NOT NULL,
    organo character varying(300) NOT NULL,
    cpvs character varying(1500) NULL,
    fecha_actualizacion timestamp with time zone NOT NULL,
    fecha_eliminacion timestamp with time zone NULL
)TABLESPACE ts_licpub_data;

ALTER TABLE licpub.licitacion_es OWNER TO licpub;

SET default_tablespace = ts_licpub_idx;

ALTER TABLE licpub.licitacion_es ADD CONSTRAINT licitacion_es_pkey PRIMARY KEY (id_licitacion_es)
	USING INDEX TABLESPACE ts_licpub_idx;

ALTER TABLE ONLY licpub.licitacion_es
    ADD CONSTRAINT licitacion_es_fk FOREIGN KEY (id_cpv)
    REFERENCES licpub.cpv(id_cpv) DEFERRABLE INITIALLY DEFERRED;