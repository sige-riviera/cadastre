
-- ADD CANTON COLUMN TO CREATE UNIQUE RECORDS
DO $$
DECLARE
	areas text[] := array['valais', 'vaud'];
	area text;
	tname text;
	query text;
BEGIN
	FOREACH area IN ARRAY areas
		LOOP
		RAISE NOTICE '%', area;
		query:= format('SELECT table_name FROM information_schema.tables WHERE table_schema = ''%1$s'';', area);
		FOR tname IN EXECUTE query
		LOOP
			-- RAISE NOTICE ' %', tname;
			-- ADD CANTON
			--EXECUTE format('ALTER TABLE %1$I.%2$I ADD COLUMN canton VARCHAR(10) DEFAULT ''%1$s'';', area, tname);
		END LOOP;
		-- CREATE VIEW for bf_posimmeuble
		EXECUTE format('DROP VIEW IF EXISTS %1$I.vw_bf_posimmeuble;', area);
		EXECUTE format('CREATE VIEW %1$I.vw_bf_biens_fonds AS
					SELECT 	
						pos.ogc_fid, 
						imm._tid,
						imm.numero,
						imm.genre,
						pos.pos_0 as lbl_x,
						pos.pos_1 as lbl_y,
						90-180.0/200.0*pos.ori AS ori, 
						pos.hali as lbl_hali, 
						pos.vali as lbl_vali, 
						pos.grandeur as lbl_grandeur, 
						bf.geometrie::geometry(Point,2056) as geometry
					FROM %1$I.biens_fonds__biens_fonds bf
					INNER JOIN %1$I.biens_fonds__posimmeuble pos
					INNER JOIN %1$I.biens_fonds__immeuble imm ON pos.posimmeuble_de = imm._tid;',
				area);
		-- CREATE VIEW for cs_batiment
		EXECUTE format('DROP VIEW IF EXISTS %1$I.vw_cs_numero_batiment;', area);
		EXECUTE format('CREATE VIEW %1$I.vw_cs_numero_batiment AS
					SELECT 	
						pos.ogc_fid, 
						num._tid,
						num.numero,
						pos.pos_0 as x,
						pos.pos_1 as y,
						90-180.0/200.0*pos.ori AS ori, 
						pos.hali, 
						pos.vali, 
						pos.grandeur, 
						wkb_geometry::geometry(Point,2056) as geometry
					FROM %1$I.couverture_du_sol__posnumero_de_batiment pos
					INNER JOIN %1$I.couverture_du_sol__numero_de_batiment num ON pos.posnumero_de_batiment_de = num._tid;',
				area);

	END LOOP;
END;
$$;


-- COPY DATA TO SINGLE SCHEMA

DROP SCHEMA IF EXISTS cadastre CASCADE; 
CREATE SCHEMA cadastre;


CREATE VIEW cadastre.bf_immeuble AS
	SELECT * 
	FROM
	(
		SELECT geometrie, bien_fonds_de AS fk_immeuble FROM vaud.biens_fonds__biens_fonds
		UNION
		SELECT geometrie, ddp_de AS fk_immeuble FROM vaud.biens_fonds__ddp
	) AS bf
	JOIN vaud.biens_fonds__immeuble imm ON bf.fk_immeuble = imm._tid;

CREATE TABLE cadastre.bf_biens_fonds AS
	SELECT * FROM valais.biens_fonds__bien_fonds UNION 
	SELECT * FROM vaud.biens_fonds__bien_fonds;
CREATE INDEX bf_bf_geom_idx ON cadastre.bf_biens_fonds USING gist (geometrie); 

CREATE TABLE cadastre.bf_posimmeuble AS
	SELECT * FROM valais.vw_bf_posimmeuble UNION 
	SELECT * FROM vaud.vw_bf_posimmeuble;
CREATE INDEX bf_pi_geom_idx ON cadastre.bf_posimmeuble USING gist (geometry); 

CREATE TABLE cadastre.cs_couverture_sol AS
	SELECT * FROM valais.couverture_du_sol__surfacecs UNION 
	SELECT * FROM vaud.couverture_du_sol__surfacecs;
CREATE INDEX cs_cs_geom_idx ON cadastre.cs_couverture_sol USING gist (geometrie); 
	
CREATE TABLE cadastre.cs_numero_batiment AS
	SELECT * FROM valais.vw_cs_numero_batiment UNION 
	SELECT * FROM vaud.vw_cs_numero_batiment;
CREATE INDEX cs_nb_geom_idx ON cadastre.cs_numero_batiment USING gist (geometry);
