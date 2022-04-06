--TABLES
SET default_tablespace = ts_licpub_data;
SET default_with_oids = false;

--Se crea tabla divisiones
CREATE TABLE if not exists licpub.division
(
    id_division integer NOT NULL,
    descripcion character varying(500) NOT NULL
)TABLESPACE ts_licpub_data;

ALTER TABLE licpub.division OWNER TO licpub;

SET default_tablespace = ts_licpub_idx;

ALTER TABLE licpub.division ADD CONSTRAINT division_pkey PRIMARY KEY (id_division)
	USING INDEX TABLESPACE ts_licpub_idx;

--Inserts
insert into division (id_division, descripcion) values (3000000,'Productos de la agricultura, ganadería, pesca, silvicultura y productos afines');
insert into division (id_division, descripcion) values (9000000,'Derivados del petróleo, combustibles, electricidad y otras fuentes de energía');
insert into division (id_division, descripcion) values (14000000,'Productos de la minería, de metales de base y productos afines');
insert into division (id_division, descripcion) values (15000000,'Alimentos, bebidas, tabaco y productos afines');
insert into division (id_division, descripcion) values (16000000,'Maquinaria agrícola');
insert into division (id_division, descripcion) values (18000000,'Prendas de vestir, calzado, artículos de viaje y accesorios');
insert into division (id_division, descripcion) values (19000000,'Piel y textiles, materiales de plástico y caucho');
insert into division (id_division, descripcion) values (22000000,'Impresos y productos relacionados');
insert into division (id_division, descripcion) values (24000000,'Productos químicos');
insert into division (id_division, descripcion) values (30000000,'Máquinas, equipo y artículos de oficina y de informática, excepto mobiliario y paquetes de software');
insert into division (id_division, descripcion) values (31000000,'Máquinas, aparatos, equipo y productos consumibles eléctricos; iluminación');
insert into division (id_division, descripcion) values (32000000,'Equipos de radio, televisión, comunicaciones y telecomunicaciones y equipos conexos');
insert into division (id_division, descripcion) values (33000000,'Equipamiento y artículos médicos, farmacéuticos y de higiene personal');
insert into division (id_division, descripcion) values (34000000,'Equipos de transporte y productos auxiliares');
insert into division (id_division, descripcion) values (35000000,'Equipo de seguridad, extinción de incendios, policía y defensa');
insert into division (id_division, descripcion) values (37000000,'Instrumentos musicales, artículos deportivos, juegos, juguetes, artículos de artesanía, materiales artísticos y accesorios');
insert into division (id_division, descripcion) values (38000000,'Equipo de laboratorio, óptico y de precisión (excepto gafas)');
insert into division (id_division, descripcion) values (39000000,'Mobiliario (incluido el de oficina), complementos de mobiliario, aparatos electrodomésticos (excluida la iluminación) y productos de limpieza');
insert into division (id_division, descripcion) values (41000000,'Agua recogida y depurada');
insert into division (id_division, descripcion) values (42000000,'Maquinaria industrial');
insert into division (id_division, descripcion) values (43000000,'Maquinaria para la minería y la explotación de canteras y equipo de construcción');
insert into division (id_division, descripcion) values (44000000,'Estructuras y materiales de construcción; productos auxiliares para la construcción (excepto aparatos eléctricos)');
insert into division (id_division, descripcion) values (45000000,'Trabajos de construcción');
insert into division (id_division, descripcion) values (48000000,'Paquetes de software y sistemas de información');
insert into division (id_division, descripcion) values (50000000,'Servicios de reparación y mantenimiento');
insert into division (id_division, descripcion) values (51000000,'Servicios de instalación (excepto software)');
insert into division (id_division, descripcion) values (55000000,'Servicios comerciales al por menor de hostelería y restauración');
insert into division (id_division, descripcion) values (60000000,'Servicios de transporte (excluido el transporte de residuos)');
insert into division (id_division, descripcion) values (63000000,'Servicios de transporte complementarios y auxiliares; servicios de agencias de viajes');
insert into division (id_division, descripcion) values (64000000,'Servicios de correos y telecomunicaciones');
insert into division (id_division, descripcion) values (65000000,'Servicios públicos');
insert into division (id_division, descripcion) values (66000000,'Servicios financieros y de seguros');
insert into division (id_division, descripcion) values (70000000,'Servicios inmobiliarios');
insert into division (id_division, descripcion) values (71000000,'Servicios de arquitectura, construcción, ingeniería e inspección');
insert into division (id_division, descripcion) values (72000000,'Servicios TI: consultoría, desarrollo de software, Internet y apoyo');
insert into division (id_division, descripcion) values (73000000,'Servicios de investigación y desarrollo y servicios de consultoría conexos');
insert into division (id_division, descripcion) values (75000000,'Servicios de administración pública, defensa y servicios de seguridad social');
insert into division (id_division, descripcion) values (76000000,'Servicios relacionados con la industria del gas y del petróleo');
insert into division (id_division, descripcion) values (77000000,'Servicios agrícolas, forestales, hortícolas, acuícolas y apícolas');
insert into division (id_division, descripcion) values (79000000,'Servicios a empresas: legislación, mercadotecnia, asesoría, selección de personal, imprenta y seguridad');
insert into division (id_division, descripcion) values (80000000,'Servicios de enseñanza y formación');
insert into division (id_division, descripcion) values (85000000,'Servicios de salud y asistencia social');
insert into division (id_division, descripcion) values (90000000,'Servicios de alcantarillado, basura, limpieza y medio ambiente');
insert into division (id_division, descripcion) values (92000000,'Servicios de esparcimiento, culturales y deportivos');
insert into division (id_division, descripcion) values (98000000,'Otros servicios comunitarios, sociales o personales');
