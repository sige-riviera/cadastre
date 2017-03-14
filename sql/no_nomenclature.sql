-- *****************
-- LIEUX DITS

DROP MATERIALIZED VIEW IF EXISTS cadastre.no_nomenclature;
CREATE MATERIALIZED VIEW cadastre.no_nomenclature AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT
					nl_pos._tid,
					nl.origine,
					nl.nom,
					nl_pos.pos_0 as lbl_x,
					nl_pos.pos_1 as lbl_y,
					90-180.0/200.0*nl_pos.ori AS ori,
					nl_pos.hali as lbl_hali,
					nl_pos.vali as lbl_vali,
					nl_pos.grandeur as lbl_grandeur,
					nl_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM fribourg.nomenclature__posnom_local nl_pos
				LEFT OUTER JOIN fribourg.nomenclature__nom_local nl ON nl_pos.posnom_local_de = nl._tid
				WHERE nom NOT LIKE 'Lac Léman'
				UNION
				SELECT
					ld_pos._tid,
					ld.origine,
					ld.nom,
					ld_pos.pos_0 as lbl_x,
					ld_pos.pos_1 as lbl_y,
					90-180.0/200.0*ld_pos.ori AS ori,
					ld_pos.hali as lbl_hali,
					ld_pos.vali as lbl_vali,
					ld_pos.grandeur as lbl_grandeur,
					ld_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM fribourg.nomenclature__poslieudit ld_pos
				LEFT OUTER JOIN fribourg.nomenclature__lieudit ld ON ld_pos.poslieudit_de = ld._tid
				WHERE nom NOT LIKE 'Lac Léman'
			) fribourg
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT
					nl_pos._tid,
					nl.origine,
					nl.nom,
					nl_pos.pos_0 as lbl_x,
					nl_pos.pos_1 as lbl_y,
					90-180.0/200.0*nl_pos.ori AS ori,
					nl_pos.hali as lbl_hali,
					nl_pos.vali as lbl_vali,
					nl_pos.grandeur as lbl_grandeur,
					nl_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM valais.nomenclature__posnom_local nl_pos
				LEFT OUTER JOIN valais.nomenclature__nom_local nl ON nl_pos.posnom_local_de = nl._tid
				WHERE nom NOT LIKE 'Lac Léman'
				UNION
				SELECT
					ld_pos._tid,
					ld.origine,
					ld.nom,
					ld_pos.pos_0 as lbl_x,
					ld_pos.pos_1 as lbl_y,
					90-180.0/200.0*ld_pos.ori AS ori,
					ld_pos.hali as lbl_hali,
					ld_pos.vali as lbl_vali,
					ld_pos.grandeur as lbl_grandeur,
					ld_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM valais.nomenclature__poslieudit ld_pos
				LEFT OUTER JOIN valais.nomenclature__lieudit ld ON ld_pos.poslieudit_de = ld._tid
				WHERE nom NOT LIKE 'Lac Léman'
			) valais
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT
					nl_pos._tid,
					nl.origine,
					nl.nom,
					nl_pos.pos_0 as lbl_x,
					nl_pos.pos_1 as lbl_y,
					90-180.0/200.0*nl_pos.ori AS ori,
					nl_pos.hali as lbl_hali,
					nl_pos.vali as lbl_vali,
					nl_pos.grandeur as lbl_grandeur,
					nl_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM vaud.nomenclature__posnom_local nl_pos
				LEFT OUTER JOIN vaud.nomenclature__nom_local nl ON nl_pos.posnom_local_de = nl._tid
				WHERE nom NOT LIKE 'Lac Léman'
				UNION
				SELECT
					ld_pos._tid,
					ld.origine,
					ld.nom,
					ld_pos.pos_0 as lbl_x,
					ld_pos.pos_1 as lbl_y,
					90-180.0/200.0*ld_pos.ori AS ori,
					ld_pos.hali as lbl_hali,
					ld_pos.vali as lbl_vali,
					ld_pos.grandeur as lbl_grandeur,
					ld_pos.wkb_geometry::geometry(Point,2056) as geometry
				FROM vaud.nomenclature__poslieudit ld_pos
				LEFT OUTER JOIN vaud.nomenclature__lieudit ld ON ld_pos.poslieudit_de = ld._tid
				WHERE nom NOT LIKE 'Lac Léman'
			) vaud
	)
	;
CREATE INDEX no_nomenclature_geom_idx ON cadastre.no_nomenclature USING gist (geometry);
