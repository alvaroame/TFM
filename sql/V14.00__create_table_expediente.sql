--TABLES
SET default_tablespace = ts_licpub_data;
SET default_with_oids = false;

--Se crea tabla expediente
CREATE TABLE if not exists licpub.expediente
(
    id_expediente integer NOT NULL, --codigo expediente
    id_cucop integer NULL,
    referencia character varying(500) NULL,
    numero_procedimiento character varying(500) NULL,
    titulo character varying(2500) NULL,
    descripcion character varying(2500) NULL,
    cucops character varying(4000) NULL,
    clave_unidad_compradora character varying(50) NULL,
    unidad_compradora character varying(300) NULL,
    uri character varying(150) NOT NULL,
    fecha_publicacion timestamp with time zone NOT NULL
)TABLESPACE ts_licpub_data;

ALTER TABLE licpub.expediente OWNER TO licpub;

SET default_tablespace = ts_licpub_idx;

ALTER TABLE licpub.expediente ADD CONSTRAINT expediente_pkey PRIMARY KEY (id_expediente)
	USING INDEX TABLESPACE ts_licpub_idx;

ALTER TABLE ONLY licpub.expediente
    ADD CONSTRAINT expediente_fk FOREIGN KEY (id_cucop)
    REFERENCES licpub.cucop(id_cucop) DEFERRABLE INITIALLY DEFERRED;