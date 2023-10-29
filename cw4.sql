CREATE DATABASE lab4;
CREATE SCHEMA cw4;
CREATE EXTENSION postgis;

SELECT * FROM t2018_kar_buildings;
SELECT * FROM t2019_kar_buildings;
-- zad 1;
CREATE TABLE nowe_budynki AS
SELECT  b19.*  FROM t2018_kar_buildings AS b18, t2019_kar_buildings AS b19
WHERE ST_Equals(b18.geom,b19.geom) = FALSE AND b19.polygon_id = b18.polygon_id;

--zad 2;
SELECT * FROM t2018_kar_poi_table;
SELECT * FROM t2019_kar_poi_table;

CREATE TABLE nowe_budynki_POI AS
SELECT  p19.*  FROM t2018_kar_poi_table AS p18, t2019_kar_poi_table AS p19
WHERE ST_Equals(p18.geom,p19.geom) = FALSE AND p19.poi_id = p18.poi_id;

SELECT * FROM nowe_budynki_POI;

SELECT p.type ,count(DISTINCT p.poi_id) FROM nowe_budynki_POI AS p, nowe_budynki AS b
WHERE ST_DWithin(p.geom, b.geom,500) = TRUE
GROUP BY p.type;

--zad3
SELECT * FROM t2019_kar_streets;
SELECT st_srid(geom) from t2019_kar_streets;

CREATE TABLE streets_reprojected AS
    SELECT GID, LINK_ID, ST_NAME, REF_IN_ID, NREF_IN_ID, FUNC_CLASS, SPEED_CAT, FR_SPEED_L, TO_SPEED_L, DIR_TRAVEL,st_setsrid(s.geom,3068) AS geom FROM t2019_kar_streets s;

DROP TABLE streets_reprojected;
SELECT * FROM streets_reprojected;
SELECT st_srid(geom) from streets_reprojected;

--zad4
CREATE TABLE input_points (
	p_id INT PRIMARY KEY,
	geom GEOMETRY(POINT, 4326)
);

INSERT INTO input_points (p_id, geom)
VALUES
	(1, ST_GeomFromText('POINT(8.36093 49.03174)', 4326)),
	(2, ST_GeomFromText('POINT(8.39876 49.00644)', 4326));
SELECT * FROM input_points;
SELECT st_srid(geom) from input_points;
-- zad5
ALTER TABLE input_points
  ALTER COLUMN geom TYPE geometry(POINT, 3068)
    USING ST_SetSRID(geom,3068);

--zad6
SELECT * FROM t2019_kar_street_node;

ALTER TABLE t2019_kar_street_node
  ALTER COLUMN geom TYPE geometry(POINT, 3068)
    USING ST_SetSRID(geom,3068);

SELECT n.* FROM t2019_kar_street_node n
WHERE st_Dwithin((SELECT ST_MakeLine(i.geom) FROM input_points i),n.geom,200) AND n."intersect" = 'Y';

--zad 7
SELECT * FROM t2019_kar_land_use_a;

SELECT COUNT(DISTINCT(p.geom)) FROM t2019_kar_land_use_a l, t2019_kar_poi_table p
WHERE p.type = 'Sporting Goods Store' AND ST_DWithin(l.geom, p.geom, 300) AND l.type = 'Park (City/County)';

--zad 8
CREATE TABLE T2019_KAR_BRIDGES AS
	SELECT DISTINCT(ST_Intersection(r.geom, w.geom)) FROM t2019_kar_railways r,t2019_kar_water_lines w;

SELECT * FROM T2019_KAR_BRIDGES