--TABLES
SET default_tablespace = ts_licpub_data;
SET default_with_oids = false;

--Se crea tabla licitacion_mx
CREATE TABLE if not exists licpub.licitacion_mx
(
    id_licitacion_mx integer NOT NULL, --codigo expediente
    id_cucop integer NULL,
    identificador character varying(24) NOT NULL,
    id_publicacion character varying(30) NOT NULL,
    ocid character varying(24) NOT NULL,
    titulo character varying(2500) NULL,
    descripcion character varying(2500) NULL,
    cucops character varying(4000) NULL,
    clave_dependencia character varying(50) NULL,
    dependencia character varying(300) NULL,
    clave_unidad_compradora character varying(50) NULL,
    unidad_compradora character varying(300) NULL,
    estatus character varying(25) NULL,
    uri character varying(150) NOT NULL,
    fecha timestamp with time zone NOT NULL,
    origen character varying(150) NOT NULL
)TABLESPACE ts_licpub_data;

ALTER TABLE licpub.licitacion_mx OWNER TO licpub;

SET default_tablespace = ts_licpub_idx;

ALTER TABLE licpub.licitacion_mx ADD CONSTRAINT licitacion_mx_pkey PRIMARY KEY (id_licitacion_mx)
	USING INDEX TABLESPACE ts_licpub_idx;

ALTER TABLE ONLY licpub.licitacion_mx
    ADD CONSTRAINT licitacion_mx_fk FOREIGN KEY (id_cucop)
    REFERENCES licpub.cucop(id_cucop) DEFERRABLE INITIALLY DEFERRED;