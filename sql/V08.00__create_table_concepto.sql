--TABLES
SET default_tablespace = ts_licpub_data;
SET default_with_oids = false;

--Se crea tabla concepto
CREATE TABLE if not exists licpub.concepto
(
    id_concepto integer NOT NULL,
    id_capitulo integer NOT NULL,
    descripcion character varying(500) NOT NULL
)TABLESPACE ts_licpub_data;

ALTER TABLE licpub.concepto OWNER TO licpub;

SET default_tablespace = ts_licpub_idx;

ALTER TABLE licpub.concepto ADD CONSTRAINT concepto_pkey PRIMARY KEY (id_concepto)
	USING INDEX TABLESPACE ts_licpub_idx;

ALTER TABLE ONLY licpub.concepto
    ADD CONSTRAINT concepto_fk FOREIGN KEY (id_capitulo)
    REFERENCES licpub.capitulo(id_capitulo) DEFERRABLE INITIALLY DEFERRED;

--Inserts
insert into concepto (id_concepto, id_capitulo, descripcion) values (2100, 2000, 'Materiales de administración, emisión de documentos y artículos oficiales');
insert into concepto (id_concepto, id_capitulo, descripcion) values (2200, 2000, 'Alimentos y utensilios');
insert into concepto (id_concepto, id_capitulo, descripcion) values (2300, 2000, 'Materias primas y materiales de producción y comercialización');
insert into concepto (id_concepto, id_capitulo, descripcion) values (2400, 2000, 'Materiales y artículos de construcción y de reparación');
insert into concepto (id_concepto, id_capitulo, descripcion) values (2500, 2000, 'Productos químicos, farmacéuticos y de laboratorio');
insert into concepto (id_concepto, id_capitulo, descripcion) values (2600, 2000, 'Combustibles, lubricantes y aditivos');
insert into concepto (id_concepto, id_capitulo, descripcion) values (2700, 2000, 'Vestuario, blancos, prendas de protección y artículos deportivos');
insert into concepto (id_concepto, id_capitulo, descripcion) values (2800, 2000, 'Materiales y suministros para seguridad');
insert into concepto (id_concepto, id_capitulo, descripcion) values (2900, 2000, 'Herramientas, refacciones y accesorios menores');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3100, 3000, 'Servicios básicos');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3200, 3000, 'Servicios de arrendamiento');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3300, 3000, 'Servicios profesionales, científicos, técnicos y otros servicios');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3400, 3000, 'Servicios financieros, bancarios y comerciales');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3500, 3000, 'Servicios de instalación, reparación, mantenimiento y conservación');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3600, 3000, 'Servicios de comunicación social y publicidad');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3700, 3000, 'Servicios de traslado y viáticos');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3800, 3000, 'Servicios oficiales');
insert into concepto (id_concepto, id_capitulo, descripcion) values (3900, 3000, 'Otros servicios generales');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5100, 5000, 'Mobiliario y equipo de administracion');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5200, 5000, 'Mobiliario y equipo educacional y recreativo');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5300, 5000, 'Equipo e instrumental medico y de laboratorio');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5400, 5000, 'Vehículos y equipo de transporte');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5500, 5000, 'Equipo de defensa y seguridad');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5600, 5000, 'Maquinaria, otros equipos y herramientas');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5700, 5000, 'Activos biológicos');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5800, 5000, 'Bienes inmuebles');
insert into concepto (id_concepto, id_capitulo, descripcion) values (5900, 5000, 'Activos intangibles');
insert into concepto (id_concepto, id_capitulo, descripcion) values (6100, 6000, 'Obra pública en bienes de dominio publico');
insert into concepto (id_concepto, id_capitulo, descripcion) values (6200, 6000, 'Obra pública en bienes propios');
insert into concepto (id_concepto, id_capitulo, descripcion) values (6300, 6000, 'Proyectos productivos y acciones de fomento');

