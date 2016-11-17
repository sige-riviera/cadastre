DROP MATERIALIZED VIEW IF EXISTS cadastre.bf_immeuble;
CREATE MATERIALIZED VIEW cadastre.bf_immeuble AS
	SELECT * FROM
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY identdn,_tid ASC) AS id,
			*
			FROM
			(
				SELECT
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
			) foo
	) foo2
	;
CREATE INDEX bf_immeuble_geom_idx ON cadastre.bf_immeuble USING gist (geometry);
	
DROP MATERIALIZED VIEW IF EXISTS cadastre.cs_couverture_sol;
CREATE MATERIALIZED VIEW cadastre.cs_couverture_sol AS
	SELECT * FROM valais.couverture_du_sol__surfacecs UNION 
	SELECT * FROM vaud.couverture_du_sol__surfacecs;
CREATE INDEX cs_cs_geom_idx ON cadastre.cs_couverture_sol USING gist (geometrie); 



DROP MATERIALIZED VIEW IF EXISTS cadastre.cs_couverture_sol_2;
CREATE MATERIALIZED VIEW cadastre.cs_couverture_sol_2 AS
	(
		SELECT
			cs.*,
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
			cs.*,
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
CREATE INDEX cs_cs_geom_idx_2 ON cadastre.cs_couverture_sol USING gist (geometrie); 
