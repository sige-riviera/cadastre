-- *****************
-- IMMEUBLE


DROP MATERIALIZED VIEW IF EXISTS cadastre.bf_immeuble;
CREATE MATERIALIZED VIEW cadastre.bf_immeuble AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY imm.ogc_fid,imm._tid ASC) AS cid,
			imm.IdentDN,
			imm._tid,
			imm.numero,
			imm.genre,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori, 
			pos.hali as lbl_hali, 
			pos.vali as lbl_vali, 
			pos.grandeur as lbl_grandeur,
			bf.geometry IS NOT NULL as has_geometry,
			CASE
				WHEN bf.geometry IS NULL THEN ST_SetSRID(ST_MakeBox2D(ST_MakePoint(pos.pos_0-.1,pos.pos_1-.1),ST_MakePoint(pos.pos_0+.1,pos.pos_1+.1)),2056)::geometry(Polygon,2056) 
				ELSE bf.geometry::geometry(Polygon,2056) 
			END AS geometry
		FROM valais.biens_fonds__immeuble imm
		LEFT OUTER JOIN
		(
			SELECT _tid, geometrie::geometry(Polygon,2056) AS geometry, bien_fonds_de AS fk_immeuble FROM vaud.biens_fonds__bien_fonds
			UNION
			SELECT _tid, CASE WHEN ST_IsEmpty(wkb_geometry) THEN NULL::geometry(Polygon,2056) ELSE ST_CurveToLine(wkb_geometry)::geometry(Polygon,2056) END AS geometry, ddp_de AS fk_immeuble FROM vaud.biens_fonds__ddp
		) AS bf ON bf.fk_immeuble = imm._tid
		LEFT OUTER JOIN valais.biens_fonds__posimmeuble pos ON pos.posimmeuble_de = imm._tid
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY imm.ogc_fid,imm._tid ASC) AS cid,
			imm.IdentDN,
			imm._tid,
			imm.numero,
			imm.genre,
			pos.pos_0 as lbl_x,
			pos.pos_1 as lbl_y,
			90-180.0/200.0*pos.ori AS ori, 
			pos.hali as lbl_hali, 
			pos.vali as lbl_vali, 
			pos.grandeur as lbl_grandeur,
			bf.geometry IS NOT NULL as has_geometry,
			CASE
				WHEN bf.geometry IS NULL THEN ST_SetSRID(ST_MakeBox2D(ST_MakePoint(pos.pos_0-.1,pos.pos_1-.1),ST_MakePoint(pos.pos_0+.1,pos.pos_1+.1)),2056)::geometry(Polygon,2056) 
				ELSE bf.geometry::geometry(Polygon,2056) 
			END AS geometry
		FROM vaud.biens_fonds__immeuble imm
		LEFT OUTER JOIN
		(
			SELECT _tid, geometrie::geometry(Polygon,2056) AS geometry, bien_fonds_de AS fk_immeuble FROM vaud.biens_fonds__bien_fonds
			UNION
			SELECT _tid, CASE WHEN ST_IsEmpty(wkb_geometry) THEN NULL::geometry(Polygon,2056) ELSE ST_CurveToLine(wkb_geometry)::geometry(Polygon,2056) END AS geometry, ddp_de AS fk_immeuble FROM vaud.biens_fonds__ddp
		) AS bf ON bf.fk_immeuble = imm._tid
		LEFT OUTER JOIN vaud.biens_fonds__posimmeuble pos ON pos.posimmeuble_de = imm._tid
	)
	;
CREATE INDEX bf_immeuble_geom_idx ON cadastre.bf_immeuble USING gist (geometry);
	
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
		FROM valais.couverture_du_sol__surfacecs cs
		LEFT OUTER JOIN valais.couverture_du_sol__numero_de_batiment num ON cs._tid = num.numero_de_batiment_de
		LEFT OUTER JOIN valais.couverture_du_sol__posnumero_de_batiment pos ON pos.posnumero_de_batiment_de = num._tid
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
		FROM vaud.couverture_du_sol__surfacecs cs
		LEFT OUTER JOIN vaud.couverture_du_sol__numero_de_batiment num ON cs._tid = num.numero_de_batiment_de
		LEFT OUTER JOIN vaud.couverture_du_sol__posnumero_de_batiment pos ON pos.posnumero_de_batiment_de = num._tid
	);
CREATE INDEX cs_cs_geom_idx ON cadastre.cs_couverture_sol USING gist (geometrie); 


-- *****************
-- NOMS DE RUE

DROP MATERIALIZED VIEW IF EXISTS cadastre.ab_rue;
CREATE MATERIALIZED VIEW cadastre.ab_rue AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY rue.ogc_fid,rue._tid ASC) AS cid,
			nom.texte,
			rue.geometrie::geometry(MultiLineString,2056)
		FROM valais.adresses_des_batiments__troncon_rue rue
		LEFT OUTER JOIN valais.adresses_des_batiments__nom_localisation nom ON nom.nom_localisation_de = rue.troncon_rue_de
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY rue.ogc_fid,rue._tid ASC) AS cid,
			nom.texte,
			rue.geometrie::geometry(MultiLineString,2056)
		FROM vaud.adresses_des_batiments__troncon_rue rue
		LEFT OUTER JOIN vaud.adresses_des_batiments__nom_localisation nom ON nom.nom_localisation_de = rue.troncon_rue_de	)
	;
CREATE INDEX ab_rue_geom_idx ON cadastre.ab_rue USING gist (geometrie);
