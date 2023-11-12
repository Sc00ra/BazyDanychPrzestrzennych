CREATE DATABASE lab6;
CREATE SCHEMA cw6;
CREATE EXTENSION postgis;

--dod danych
CREATE TABLE Obiekty(
    ID INT PRIMARY KEY,
    Name varchar(10),
    Geom geometry
);

INSERT INTO Obiekty(ID, Name, Geom)  VALUES(1,'Obiekt1', ST_GeomFromEWKT('SRID=0;COMPOUNDCURVE(LINESTRING(0 1, 1 1), CIRCULARSTRING(1 1,2 0, 3 1), CIRCULARSTRING(3 1, 4 2, 5 1),LINESTRING(5 1, 6 1))'));
INSERT INTO Obiekty(ID, Name, Geom)  VALUES(2,'Obiekt2', ST_GeomFromEWKT('SRID=0;CURVEPOLYGON(COMPOUNDCURVE(LINESTRING(10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2), CIRCULARSTRING(14 2, 12 0, 10 2), LINESTRING(10 2, 10 6)), CIRCULARSTRING(11 2, 13 2, 11 2))'));
INSERT INTO Obiekty(ID, Name, Geom)  VALUES(3,'Obiekt3', ST_GeomFromEWKT('SRID=0;POLYGON((7 15, 10 17, 12 13, 7 15))'));
INSERT INTO Obiekty(ID, Name, Geom)  VALUES(4,'Obiekt4', ST_GeomFromEWKT('SRID=0;COMPOUNDCURVE((20 20, 25 25), (25 25, 27 24),(27 24, 25 22),(25 22, 26 21), (26 21, 22 19),(22 19, 20.5 19.5))'));
INSERT INTO Obiekty(ID, Name, Geom)  VALUES(5,'Obiekt5', ST_GeomFromEWKT('SRID=0; MULTIPOINT((30 30 59),(38 32 234))'));
INSERT INTO Obiekty(ID, Name, Geom)  VALUES(6,'Obiekt6', ST_GeomFromEWKT('SRID=0; GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2),POINT(4 2))'));

SELECT ST_CurveToLine(geom) FROM Obiekty;

--1
SELECT ST_Area(ST_Buffer(ST_ShortestLine(j.geom, d.geom),5)) FROM Obiekty j, Obiekty d
WHERE j.Name = 'Obiekt3' AND d.Name = 'Obiekt4';

--2
SELECT ST_GeometryType(Geom) FROM Obiekty WHERE Name = 'Obiekt4';

UPDATE Obiekty
SET Geom  = 'COMPOUNDCURVE( (20 20, 25 25), (25 25, 27 24),(27 24, 25 22),(25 22, 26 21), (26 21, 22 19),(22 19, 20.5 19.5), (20.5 19.5, 20 20))'
WHERE Name = 'Obiekt4';

UPDATE Obiekty
SET Geom = ST_BuildArea((SELECT Geom FROM Obiekty WHERE Name = 'Obiekt4'))
WHERE Name = 'Obiekt4';
--3
INSERT INTO obiekty VALUES(7, 'Obiekt7', ST_Collect((SELECT geom FROM obiekty WHERE name = 'Obiekt3'), (SELECT geom FROM obiekty WHERE name = 'Obiekt4')));

--4
SELECT Sum(ST_Area(ST_Buffer(obiekty.geom, 5))) Pole FROM Obiekty
WHERE ST_HasArc(Geom)=FALSE;