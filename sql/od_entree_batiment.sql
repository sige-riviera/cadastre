


-- *****************
-- ENTREE BATIMENTS

DROP MATERIALIZED VIEW IF EXISTS cadastre.od_entree_batiment;
CREATE MATERIALIZED VIEW cadastre.od_entree_batiment AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY eb.ogc_fid,eb._tid ASC) AS cid,
			eb.origine,
			eb.entree_batiment_de,
			eb.validite,
			eb.niveau,
			eb.numero_maison,
			eb.dans_batiment,
			eb.regbl_egid,
			eb.regbl_edid,
			eb.wkb_geometry::geometry(Point,2056) as geometry,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur
		FROM fribourg.adresses_des_batiments__entree_batiment eb
		LEFT OUTER JOIN fribourg.adresses_des_batiments__posnumero_maison pos ON eb._tid = pos.posnumero_batiment_de
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY eb.ogc_fid,eb._tid ASC) AS cid,
			eb.origine,
			eb.entree_batiment_de,
			eb.validite,
			eb.niveau,
			eb.numero_maison,
			eb.dans_batiment,
			eb.regbl_egid,
			eb.regbl_edid,
			eb.wkb_geometry::geometry(Point,2056) as geometry,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur
		FROM valais.adresses_des_batiments__entree_batiment eb
		LEFT OUTER JOIN valais.adresses_des_batiments__posnumero_maison pos ON eb._tid = pos.posnumero_batiment_de
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY eb.ogc_fid,eb._tid ASC) AS cid,
			eb.origine,
			eb.entree_batiment_de,
			eb.validite,
			eb.niveau,
			eb.numero_maison,
			eb.dans_batiment,
			eb.regbl_egid,
			eb.regbl_edid,
			eb.wkb_geometry::geometry(Point,2056) as geometry,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori,
			pos.hali as lbl_hali,
			pos.vali as lbl_vali,
			pos.grandeur as lbl_grandeur
		FROM vaud.adresses_des_batiments__entree_batiment eb
		LEFT OUTER JOIN vaud.adresses_des_batiments__posnumero_maison pos ON eb._tid = pos.posnumero_batiment_de
	)
	;
CREATE INDEX od_entree_batiment_geom_idx ON cadastre.od_entree_batiment USING gist (geometry);
