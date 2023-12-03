create database lab8;
create schema lab8;
create extension postgis;
create extension postgis_raster;

SELECT * FROM uk_250k;

SELECT * FROM parki_narodowe;
-- zad 6
CREATE TABLE lab8.uk_lake_district AS
SELECT ST_Clip(a.rast, b.geom, true)
FROM  lab8.uk_250k AS a, lab8.parki_narodowe AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.gid  = 1;

--zad7
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0, ST_AsGDALRaster(ST_Union(st_clip), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])) AS loid
FROM lab8.uk_lake_district;

SELECT lo_export(loid, 'D:\JetBrains\DataGrip2023.2.3\projekty\cw8\uk_lake_district.tiff') --> Save the file in a placewhere the user postgres have access. In windows a flash drive usualy worksfine.
FROM tmp_out;

DROP TABLE tmp_out;

--zad8-10
create table green as SELECT ST_Union(ST_SetBandNodataValue(rast, NULL), 'MAX') rast
                      FROM (SELECT rast FROM lab8.sentinel2_band3_1
                        UNION ALL
                         SELECT rast FROM lab8.sentinel2_band3_2);

create table nirr as SELECT ST_Union(ST_SetBandNodataValue(rast, NULL), 'MAX') rast
                      FROM (SELECT rast FROM lab8.sentinel2_band8_1
                        UNION ALL
                         SELECT rast FROM lab8.sentinel2_band8_2);


WITH r1 AS (
(SELECT ST_Union(ST_Clip(a.rast, ST_Transform(b.geom, 32630), true)) as rast
            FROM public.green AS a, lab8.parki_narodowe AS b
            WHERE ST_Intersects(a.rast, ST_Transform(b.geom, 32630)) AND b.gid=1))
,
r2 AS (
(SELECT ST_Union(ST_Clip(a.rast, ST_Transform(b.geom, 32630), true)) as rast
    FROM public.nirr AS a, lab8.parki_narodowe AS b
    WHERE ST_Intersects(a.rast, ST_Transform(b.geom, 32630)) AND b.gid=1))

SELECT ST_MapAlgebra(r1.rast, r2.rast, '([rast1.val]-[rast2.val])/([rast1.val]+[rast2.val])::float', '32BF') AS rast
INTO lake_district_ndvi FROM r1, r2;

CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
       ST_AsGDALRaster(ST_Union(rast), 'GTiff',  ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
        ) AS loid
FROM public.lake_district_ndwi;

SELECT lo_export(loid, 'D:\JetBrains\DataGrip2023.2.3\projekty\cw8\ndwi.tif')
FROM tmp_out;

DROP TABLE tmp_out;