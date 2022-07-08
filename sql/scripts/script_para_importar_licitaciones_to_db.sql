

--PRIMER HACER ADMIN AL USER
ALTER USER licpub WITH SUPERUSER;

--CAMBIAR LA CODIFICACION DEL CLIENTE DE  SQL
SET client_encoding = 'UTF8';

COPY licpub.expediente(id_expediente, referencia, titulo, descripcion, clave_unidad_compradora, unidad_compradora, fecha_publicacion, cucops, uri, id_cucop )
FROM 'C:\temp\expedientes2018.csv'
DELIMITER ','
CSV HEADER encoding 'UTF8';

begin;
CREATE TEMP TABLE tmp_table (LIKE licpub.expediente INCLUDING DEFAULTS) ON COMMIT DROP;

COPY tmp_table(id_expediente,numero_procedimiento, referencia, titulo, descripcion, clave_unidad_compradora, unidad_compradora, fecha_publicacion, cucops, uri, id_cucop )
FROM 'C:\temp\expedientes2019.csv'
DELIMITER ','
CSV HEADER encoding 'UTF8';

INSERT INTO licpub.expediente
SELECT *
FROM tmp_table
ON CONFLICT DO NOTHING;
commit;

begin;
CREATE TEMP TABLE tmp_table (LIKE licpub.expediente INCLUDING DEFAULTS) ON COMMIT DROP;

COPY tmp_table(id_expediente,numero_procedimiento, referencia, titulo, descripcion, clave_unidad_compradora, unidad_compradora, fecha_publicacion, cucops, uri, id_cucop )
FROM 'C:\temp\expedientes2020.csv'
DELIMITER ','
CSV HEADER encoding 'UTF8';

INSERT INTO licpub.expediente
SELECT *
FROM tmp_table
ON CONFLICT DO NOTHING;
commit;

begin;
CREATE TEMP TABLE tmp_table (LIKE licpub.expediente INCLUDING DEFAULTS) ON COMMIT DROP;

COPY tmp_table(id_expediente,numero_procedimiento, referencia, titulo, descripcion, clave_unidad_compradora, unidad_compradora, fecha_publicacion, cucops, uri, id_cucop )
FROM 'C:\temp\expedientes2021.csv'
DELIMITER ','
CSV HEADER encoding 'UTF8';

INSERT INTO licpub.expediente
SELECT *
FROM tmp_table
ON CONFLICT DO NOTHING;
commit;

begin;
CREATE TEMP TABLE tmp_table (LIKE licpub.expediente INCLUDING DEFAULTS) ON COMMIT DROP;

COPY tmp_table(id_expediente,numero_procedimiento, referencia, titulo, descripcion, clave_unidad_compradora, unidad_compradora, fecha_publicacion, cucops, uri, id_cucop )
FROM 'C:\temp\expedientes2022.csv'
DELIMITER ','
CSV HEADER encoding 'UTF8';

INSERT INTO licpub.expediente
SELECT *
FROM tmp_table
ON CONFLICT DO NOTHING;
commit;
