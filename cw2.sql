CREATE DATABASE lab2;
CREATE SCHEMA  cw2;
CREATE EXTENSION postgis;

CREATE TABLE cw2.budynki(
id INT PRIMARY KEY NOT NULL,
geometria GEOMETRY,
nazwa VARCHAR(100)
);
CREATE TABLE cw2.drogi(
id INT PRIMARY KEY NOT NULL,
geometria GEOMETRY,
nazwa VARCHAR(100)
);
CREATE TABLE cw2.punkty_informacyjne(
id INT PRIMARY KEY NOT NULL,
geometria GEOMETRY,
nazwa VARCHAR(100)
);

--budynki
INSERT INTO cw2.budynki VALUES(1,ST_GeomFromText('POLYGON((8 1.5,10.5 1.5,10.5 4,8 4,8 1.5))'),'BuildingA');
INSERT INTO cw2.budynki VALUES(2,ST_GeomFromText('POLYGON((4 5,4 7,6 7,6 5,4 5))'),'BuildingB');
INSERT INTO cw2.budynki VALUES(3,ST_GeomFromText('POLYGON((3 6,5 6,5 8,3 8,3 6))'),'BuildingC');
INSERT INTO cw2.budynki VALUES(4,ST_GeomFromText('POLYGON((9 8,10 8,10 9,9 9,9 8))'),'BuildingD');
INSERT INTO cw2.budynki VALUES(5,ST_GeomFromText('POLYGON((1 1,2 1,2 2,1 2,1 1))'),'BuildingF');
--drogi
INSERT INTO cw2.drogi VALUES(1,ST_GeomFromText('LINESTRING(0 4.5,12 4.5)'),'RoadX');
INSERT INTO cw2.drogi VALUES(2,ST_GeomFromText('LINESTRING(7.5 0,7.5 10.5)'),'RoadY');
--pkt
INSERT INTO cw2.punkty_informacyjne VALUES(4,ST_GeomFromText('POINT(1 3.5)'),'G');
INSERT INTO cw2.punkty_informacyjne VALUES(5,ST_GeomFromText('POINT(5.5 1.5)'),'H');
INSERT INTO cw2.punkty_informacyjne VALUES(3,ST_GeomFromText('POINT(9.5 6)'),'I');
INSERT INTO cw2.punkty_informacyjne VALUES(2,ST_GeomFromText('POINT(6.5 6)'),'J');
INSERT INTO cw2.punkty_informacyjne VALUES(1,ST_GeomFromText('POINT(6 9.5)'),'K');

--6a)
SELECT SUM(ST_Length(geometria)) AS Dlugosc_drogi FROM cw2.drogi;

--6b)
SELECT ST_AsText(geometria) AS geometria , ST_Area(geometria)  AS  pole_powierzchni, ST_Perimeter(geometria) AS obwod
FROM cw2.budynki WHERE nazwa = 'BuildingA';

--6c)
SELECT nazwa, ST_Area(geometria) AS pole_powierzchni
FROM cw2.budynki
ORDER BY nazwa;

--6d)
SELECT nazwa, ST_Perimeter(geometria) AS obwod
FROM cw2.budynki
ORDER BY ST_Area(geometria) DESC LIMIT 2;

--6e)
SELECT ST_Distance ((SELECT geometria FROM cw2.budynki WHERE nazwa = 'BuildingC'),(SELECT geometria FROM cw2.punkty_informacyjne WHERE nazwa = 'G')) AS dystans;
--6f)
SELECT ST_Area((SELECT geometria FROM cw2.budynki WHERE nazwa = 'BuildingC')) - ST_Area(ST_Intersection((SELECT geometria FROM cw2.budynki WHERE nazwa = 'BuildingC'),(SELECT ST_Buffer((SELECT geometria FROM cw2.budynki WHERE nazwa = 'BuildingB'),0.5)))) AS pole;
--6g)
SELECT * FROM cw2.budynki WHERE ST_Y(ST_Centroid(geometria)) > (SELECT ST_Y(ST_Centroid(geometria)) FROM cw2.drogi WHERE nazwa = 'RoadX');
--6h)
SELECT ST_Area(st_symdifference((SELECT geometria FROM cw2.budynki WHERE nazwa='BuildingC'),ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')));