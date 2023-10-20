CREATE DATABASE lab3;
CREATE SCHEMA CW3;
create extension postgis;

select*from alaska;
select*from popp;

--4.
DROP TABLE tabelaB;
SELECT COUNT(p.f_codedesc) AS ILOSC_BUDYNKOW INTO tabelaB  FROM popp p, majrivers m
WHERE ST_DWithin(p.geom,m.geom,1000) AND f_codedesc='Building';
SELECT * FROM tabelaB;
--5.
SELECT * FROM airports;

SELECT name, geom, elev INTO airportsNEW FROM airports;
SELECT * FROM airportsNEW;
--wschod
SELECT name,ST_Y(geom) AS ycoor_e FROM airportsNEW
ORDER BY ycoor_e DESC LIMIT 1;
--zachod
SELECT name,ST_Y(geom) AS ycoor_w FROM airportsNEW
ORDER BY ycoor_w ASC LIMIT 1;
--dodanie
INSERT INTO airportsNEW VALUES ('airportB',(select st_centroid(ST_MakeLine((select geom from airportsNew where name = 'NIKOLSKI AS'),(select geom from airportsNew where name = 'NOATAK')))),80);
SELECT * FROM airportsNEW WHERE name='airportB';

--6.
SELECT ST_area(St_buffer(st_ShortestLine(a.geom, l.geom), 1000)) AS pole FROM airports a, lakes l
WHERE l.names='Iliamna Lake' and a.name='AMBLER';

--7.
SELECT vegdesc AS Typ_drzewa, Sum(ST_Area(t.geom)) AS Pole FROM trees t, swamp s, tundra tu
WHERE ST_Contains(tu.geom, t.geom) OR ST_Contains(s.geom, t.geom)
GROUP BY vegdesc;

SELECT st_srid(geom) FROM tundra