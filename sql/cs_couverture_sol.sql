
-- *****************
-- COUVERTURE DU SOL

DROP MATERIALIZED VIEW IF EXISTS cadastre.cs_couverture_sol;
CREATE MATERIALIZED VIEW cadastre.cs_couverture_sol AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY cs.ogc_fid,cs._tid,num.numero ASC) AS cid,
			cs.ogc_fid,
			cs._tid,
			cs.origine,
			cs.qualite,
			cs.genre,
			cs.geometrie::geometry(Polygon,2056),
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM fribourg.couverture_du_sol__surfacecs cs
		LEFT OUTER JOIN fribourg.couverture_du_sol__numero_de_batiment num ON cs._tid = num.numero_de_batiment_de
		LEFT OUTER JOIN (SELECT DISTINCT ON(posnumero_de_batiment_de) * FROM fribourg.couverture_du_sol__posnumero_de_batiment) pos ON pos.posnumero_de_batiment_de = num._tid
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY cs.ogc_fid,cs._tid,num.numero ASC) AS cid,
			cs.ogc_fid,
			cs._tid,
			cs.origine,
			cs.qualite,
			cs.genre,
			cs.geometrie::geometry(Polygon,2056),
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM valais.couverture_du_sol__surfacecs cs
		LEFT OUTER JOIN valais.couverture_du_sol__numero_de_batiment num ON cs._tid = num.numero_de_batiment_de
		LEFT OUTER JOIN (SELECT DISTINCT ON(posnumero_de_batiment_de) * FROM valais.couverture_du_sol__posnumero_de_batiment) pos ON pos.posnumero_de_batiment_de = num._tid
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY cs.ogc_fid,cs._tid,num.numero ASC) AS cid,
			cs.ogc_fid,
			cs._tid,
			cs.origine,
			cs.qualite,
			cs.genre,
			cs.geometrie::geometry(Polygon,2056),
			num.numero,
			pos.pos_0 as x,
			pos.pos_1 as y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali,
			pos.vali,
			pos.grandeur
		FROM vaud.couverture_du_sol__surfacecs cs
		LEFT OUTER JOIN (SELECT DISTINCT ON (numero_de_batiment_de) * FROM vaud.couverture_du_sol__numero_de_batiment) num ON cs._tid = num.numero_de_batiment_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (posnumero_de_batiment_de) * FROM vaud.couverture_du_sol__posnumero_de_batiment) pos ON pos.posnumero_de_batiment_de = num._tid
	);
CREATE INDEX cs_cs_geom_idx ON cadastre.cs_couverture_sol USING gist (geometrie);
