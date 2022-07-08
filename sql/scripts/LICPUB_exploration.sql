select * from cucop where id_cucop = '3390';
select * from cpv where id_cpv = '45500000';
---------------------------LICITACIONES ES --------------------------------------
select count(*) from division;--45
select count(*) from grupo;--272
select count(*) from clase;--1004
select count(*) from categoria;--2385
select count(*) from codigo;--5756

select count(*) from cpv;--9462; es la suma de los niveles herarquicos mayores

select * from division di
left join grupo gpo on (gpo.id_division=di.id_division)
where gpo.id_division is null;--Todas las divisiones tienen al menos un grupo

select * from grupo gpo
left join clase cls on (gpo.id_grupo=cls.id_grupo)
where cls.id_grupo is null;--No todos los grupos tienen clases asignadas: 18

select * from clase cls
left join categoria ctg on (cls.id_clase=ctg.id_clase)
where ctg.id_clase is null;--No todas las clases tienen categorias asignadas: 317
--Hubo clases que se crearon ya que no existian en el catálogo oficial EU pero eran necesarios para agregar 
--las categorias: 2 (39250000,60110000)

select * from categoria ctg
left join codigo cod on (ctg.id_categoria=cod.id_categoria)
where cod.id_categoria is null;--No todas las categorias tienen codigos asignadas, niveles inferiores: 1398

select * from codigo where id_categoria is null;--Todos los codigos perteneces a una categoria
--Hubo categorias que se crearon ya que no existian en el catálogo oficial pero eran necesarios
--para agregar codigos de niveles inferiores: 6 (34511000, 35611000, 35612000, 35811000, 38527000, 42924000)

select count(*) from licitacion_es;--511,180 licitaciones de 2012 al 2022 (Abril)
select count(*) from licitacion_es where id_cpv is null and cpvs is null;--5800 licitaciones sin cpv
select count(*) from licitacion_es where id_cpv is not null;--387,395 licitaciones con un único cpv
select count(*) from licitacion_es where id_cpv is null and cpvs is not null;--117,985 licitaciones con varios cpvs

select distinct * from licitacion_es where id_cpv is null and cpvs is not null limit 10;

SELECT count(*) FROM LICITACION_ES LI
INNER JOIN CPV C ON (LI.ID_CPV =C.ID_CPV)
WHERE c.id_division IS NOT NULL; --Todas las licitaciones tienen una division asignada: 387,395

SELECT count(*) FROM LICITACION_ES LI
INNER JOIN CPV C ON (LI.ID_CPV =C.ID_CPV)
WHERE c.id_grupo IS NOT NULL and c.id_grupo='79600000'; --No todas las licitaciones tienen un grupo asignado: 344,532 

SELECT count(*) FROM LICITACION_ES LI
INNER JOIN CPV C ON (LI.ID_CPV =C.ID_CPV)
WHERE c.id_CLASE IS NOT NULL;-- No todas las licitaciones tienen una clase asignada: 282,452

SELECT count(*) FROM LICITACION_ES LI
INNER JOIN CPV C ON (LI.ID_CPV =C.ID_CPV)
WHERE c.id_categoria IS NOT NULL;-- No todas las licitaciones tienen una categoria asignada: 193,798

--Solo se están considerando aquellas licitaciones con solo un CPV
SELECT LI.ID_CPV, C.ID_DIVISION, C.ID_GRUPO, C.ID_CLASE, C.ID_CATEGORIA,  LI.OBJETO FROM LICITACION_ES LI
INNER JOIN CPV C ON (LI.ID_CPV =C.ID_CPV)
WHERE LI.OBJETO  IS NOT NULL; --export de licitaciones CPV



---------------------------LICITACIONES MX --------------------------------------
select count(*) from capitulo;--4
select count(*) from concepto;--30
select count(*) from partida_generica;--197
select count(*) from partida_especifica;--296
select count(*) from consecutivo;--14286

SELECT COUNT(*) FROM CUCOP;

select * from capitulo cap
left join concepto co on (cap.id_capitulo=co.id_capitulo)
where co.id_capitulo is null;--Todos los capitulos tienen asignados al menos un concepto

select * from concepto co
left join partida_generica pg on (co.id_concepto=pg.id_concepto)
where pg.id_concepto is null;--Todos los conceptos tienen asignado al menos una partida especifica

select * from partida_generica pg
left join partida_especifica pe on (pg.id_partida_generica=pe.id_partida_generica)
where pe.id_partida_generica is null;--No todas las partidas genericas tiene partidas especificas (11)

select * from partida_especifica pe 
left join consecutivo co on (pe.id_partida_especifica = co.id_partida_especifica)
where co.id_partida_especifica is null;--No todas las partidas especificas tienen cucops asignados (55)

---Los codigos cucops se dejan de utilizar en algunos años, el código no se sobreescribe pero ya no está vigente en el catalogo de cucops


SELECT * FROM LICITACION_MX LI LIMIT 10;

select * from licitacion_mx where id_cucop is null and cucops is null LIMIT 20;

select count(*) from licitacion_mx l
inner join expediente e on (l.id_licitacion_mx = e.id_expediente);--117966 SE COMPARTEN


select count(*) from licitacion_mx l
inner join expediente e on (l.id_licitacion_mx = e.id_expediente) where l.id_cucop is not null limit 10;--117 950

select count(*) from licitacion_mx; --300265 licitaciones de mexico
select count(*) from licitacion_mx where id_cucop is null and cucops is null; -- 206093 No hay expedientes sin cucops
select count(*) from licitacion_mx where id_cucop is not null;--80954 con un único cucop
select count(*) from licitacion_mx where id_cucop is null and cucops is NOT NULL;--13218


select count(*) from expediente; --654,109 licitaciones de mexico
select count(*) from expediente where id_cucop is null and cucops is null;--No hay expedientes sin cucops
select count(*) from expediente where id_cucop is not null;--626,168 con un único cucop
select count(*) from expediente where id_cucop is null;--27,941 con más de un cucop

select count(*) from expediente e
inner join cucop c on (e.id_cucop = c.id_cucop)
where c.id_capitulo is not null; --626168 Todas las licitaciones tienen capitulo

select count(*) from expediente e
inner join cucop c on (e.id_cucop = c.id_cucop)
where c.id_concepto is not null; --626168 ---Todas  las licitaciones tienen concepto

select count(*) from expediente e
inner join cucop c on (e.id_cucop = c.id_cucop)
where c.id_partida_generica is not null and c.id_partida_generica=2380; --626168 -- Todas las licitaciones tienen una partida generica

select count(*) from expediente e
inner join cucop c on (e.id_cucop = c.id_cucop)
where c.id_partida_especifica is not null; --0 --Pero ya no tienen una partida especifica, su nivel herarquico más especifico es hasta una partida generica

select count(*) from expediente e
inner join cucop c on (e.id_cucop = c.id_cucop)
where c.version = 2022; --622927 Tienen asignado una partida generica vigente

--exporrt aquellas licitaciones que tienen un solo cucop
select c.id_capitulo, c.id_concepto, c.id_partida_generica, e.descripcion
from expediente e
inner join cucop c on (e.id_cucop = c.id_cucop);

select * from concepto;