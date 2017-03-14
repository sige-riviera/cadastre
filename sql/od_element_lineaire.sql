
-- *****************
-- ELEMENTS LINEAIRES

DROP MATERIALIZED VIEW IF EXISTS cadastre.od_element_lineaire;
CREATE MATERIALIZED VIEW cadastre.od_element_lineaire AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY ol.ogc_fid,ol._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			ol.wkb_geometry::geometry(MultiLineString,2056) as geometry
		FROM fribourg.objets_divers__element_lineaire ol
		LEFT OUTER JOIN fribourg.objets_divers__objet_divers od ON od._tid = ol.element_lineaire_de
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY ol.ogc_fid,ol._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			ol.wkb_geometry::geometry(MultiLineString,2056) as geometry
		FROM valais.objets_divers__element_lineaire ol
		LEFT OUTER JOIN valais.objets_divers__objet_divers od ON od._tid = ol.element_lineaire_de
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY ol.ogc_fid,ol._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			ol.wkb_geometry::geometry(MultiLineString,2056) as geometry
		FROM vaud.objets_divers__element_lineaire ol
		LEFT OUTER JOIN vaud.objets_divers__objet_divers od ON od._tid = ol.element_lineaire_de
	)
	;
CREATE INDEX od_element_lineaire_geom_idx ON cadastre.od_element_lineaire USING gist (geometry);
