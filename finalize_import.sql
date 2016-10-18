
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
			EXECUTE format('ALTER TABLE %1$I.%2$I ADD COLUMN canton VARCHAR(10) DEFAULT ''%1$s'';', area, tname);
		END LOOP;
		-- CREATE VIEW for bf_posimmeuble
		EXECUTE format('CREATE VIEW %1$I.vw_bf_posimmeuble AS
					SELECT 	pos.ogc_fid, imm._tid, imm.numero, pos.pos_0 as x, pos.pos_1 as y,
						pos.ori, pos.hali, pos.vali, pos.grandeur, pos::geometry(Point,2056) as geometry
					FROM cadastre.biens_fonds__posimmeuble pos
					INNER JOIN cadastre.biens_fonds__immeuble imm ON pos.posimmeuble_de = imm._tid;',
				area);
	END LOOP;
END;
$$;


-- COPY DATA TO SINGLE SCHEMA

DROP SCHEMA IF EXISTS cadastre CASCADE; 
CREATE SCHEMA cadastre;

CREATE TABLE cadastre.bf_biens_fonds AS
	SELECT * FROM valais.biens_fonds__bien_fonds UNION 
	SELECT * FROM vaud.biens_fonds__bien_fonds;
CREATE INDEX bf_bf_geom_idx ON cadastre.bf_biens_fonds USING gist (geometrie); 

CREATE TABLE cadastre.bf_posimmeuble AS
	SELECT * FROM valais.vw_bf_posimmeuble UNION 
	SELECT * FROM vaud.vw_bf_posimmeuble;
