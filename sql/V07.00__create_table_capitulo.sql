--TABLES
SET default_tablespace = ts_licpub_data;
SET default_with_oids = false;

--Se crea tabla capitulo
CREATE TABLE if not exists licpub.capitulo
(
    id_capitulo integer NOT NULL,
    descripcion character varying(500) NOT NULL
)TABLESPACE ts_licpub_data;

ALTER TABLE licpub.capitulo OWNER TO licpub;

SET default_tablespace = ts_licpub_idx;

ALTER TABLE licpub.capitulo ADD CONSTRAINT capitulo_pkey PRIMARY KEY (id_capitulo)
	USING INDEX TABLESPACE ts_licpub_idx;

--Inserts
insert into capitulo (id_capitulo, descripcion) values (2000, 'Materiales y suministros');
insert into capitulo (id_capitulo, descripcion) values (3000, 'Servicios generales');
insert into capitulo (id_capitulo, descripcion) values (5000, 'Bienes muebles, e intangibles');
insert into capitulo (id_capitulo, descripcion) values (6000, 'Inversión Pública');