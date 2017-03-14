
-- *****************
-- POINT LIMITES

DROP MATERIALIZED VIEW IF EXISTS cadastre.bf_point_limite;
CREATE MATERIALIZED VIEW cadastre.bf_point_limite AS
		SELECT
			1000000 + row_number() OVER (ORDER BY ogc_fid,_tid ASC) AS cid,
			origine,
			identification,
			precplan,
			fiabplan,
			signe,
			defini_exactement,
			anc_borne_speciale,
			wkb_geometry::geometry(Point,2056) as geometry
		FROM fribourg.biens_fonds__point_limite
	UNION
		SELECT
			2000000 + row_number() OVER (ORDER BY ogc_fid,_tid ASC) AS cid,
			origine,
			identification,
			precplan,
			fiabplan,
			signe,
			defini_exactement,
			anc_borne_speciale,
			wkb_geometry::geometry(Point,2056) as geometry
		FROM valais.biens_fonds__point_limite
	UNION
		SELECT
			3000000 + row_number() OVER (ORDER BY ogc_fid,_tid ASC) AS cid,
			origine,
			identification,
			precplan,
			fiabplan,
			signe,
			defini_exactement,
			anc_borne_speciale,
			wkb_geometry::geometry(Point,2056) as geometry
		FROM vaud.biens_fonds__point_limite
	;
CREATE INDEX bf_point_limite_geom_idx ON cadastre.bf_point_limite USING gist (geometry);
