
-- *****************
-- ELEMENTS SURFACIQUES

DROP MATERIALIZED VIEW IF EXISTS cadastre.od_element_surfacique;
CREATE MATERIALIZED VIEW cadastre.od_element_surfacique AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY os.ogc_fid,os._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			os.wkb_geometry::geometry(Polygon,2056) as geometry,
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM fribourg.objets_divers__element_surfacique os
		LEFT OUTER JOIN fribourg.objets_divers__objet_divers od ON od._tid = os.element_surfacique_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (numero_objet_de) * FROM fribourg.objets_divers__numero_objet) num ON num.numero_objet_de = od._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON (posnumero_objet_de) * FROM fribourg.objets_divers__posnumero_objet) pos ON pos.posnumero_objet_de = num._tid
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY os.ogc_fid,os._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			os.wkb_geometry::geometry(Polygon,2056) as geometry,
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM valais.objets_divers__element_surfacique os
		LEFT OUTER JOIN valais.objets_divers__objet_divers od ON od._tid = os.element_surfacique_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (numero_objet_de) * FROM valais.objets_divers__numero_objet) num ON num.numero_objet_de = od._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON (posnumero_objet_de) * FROM valais.objets_divers__posnumero_objet) pos ON pos.posnumero_objet_de = num._tid
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY os.ogc_fid,os._tid ASC) AS cid,
			od.origine,
			od.qualite,
			od.genre,
			os.wkb_geometry::geometry(Polygon,2056) as geometry,
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM vaud.objets_divers__element_surfacique os
		LEFT OUTER JOIN vaud.objets_divers__objet_divers od ON od._tid = os.element_surfacique_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (numero_objet_de) * FROM vaud.objets_divers__numero_objet) num ON num.numero_objet_de = od._tid
		LEFT OUTER JOIN (SELECT DISTINCT ON (posnumero_objet_de) * FROM vaud.objets_divers__posnumero_objet) pos ON pos.posnumero_objet_de = num._tid
	)
	;
CREATE INDEX od_element_surfacique_geom_idx ON cadastre.od_element_surfacique USING gist (geometry);
