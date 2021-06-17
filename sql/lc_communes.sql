-- *****************
-- LIMITES DE COMMUNES

DROP MATERIALIZED VIEW IF EXISTS cadastre.lc_limites_commune;
CREATE MATERIALIZED VIEW cadastre.lc_limites_commune AS
    SELECT 1000000 + row_number() OVER (ORDER BY dups.ogc_fid, dups._tid) AS cid,
		dups.ogc_fid,
		dups._tid,
		dups.origine,
		dups.limite_commune_de,
		dups.geometrie__point_0,
		dups.geometrie__point_1,
		dups.geom,
		dups.geometrie__point
    FROM (
		SELECT limites_commune__limite_commune.ogc_fid,
			limites_commune__limite_commune._tid,
			limites_commune__limite_commune.origine,
			limites_commune__limite_commune.limite_commune_de,
			limites_commune__limite_commune.geometrie__point_0,
			limites_commune__limite_commune.geometrie__point_1,
			limites_commune__limite_commune.geometrie AS geom,
			limites_commune__limite_commune.geometrie__point,
			row_number() OVER (PARTITION BY limites_commune__limite_commune.geometrie ORDER BY limites_commune__limite_commune.ogc_fid) AS "row",
			limites_commune__limite_commune.geometrie
		FROM ONLY fribourg.limites_commune__limite_commune) dups
	WHERE dups."row" = 1
	UNION
	SELECT 2000000 + row_number() OVER (ORDER BY dups.ogc_fid, dups._tid) AS cid,
		dups.ogc_fid,
		dups._tid,
		dups.origine,
		dups.limite_commune_de,
		dups.geometrie__point_0,
		dups.geometrie__point_1,
		dups.geom,
		dups.geometrie__point
	FROM ( 
		SELECT limites_commune__limite_commune.ogc_fid,
            limites_commune__limite_commune._tid,
            limites_commune__limite_commune.origine,
            limites_commune__limite_commune.limite_commune_de,
            limites_commune__limite_commune.geometrie__point_0,
            limites_commune__limite_commune.geometrie__point_1,
            limites_commune__limite_commune.geometrie AS geom,
            limites_commune__limite_commune.geometrie__point,
            row_number() OVER (PARTITION BY limites_commune__limite_commune.geometrie ORDER BY limites_commune__limite_commune.ogc_fid) AS "row",
            limites_commune__limite_commune.geometrie
		FROM ONLY valais.limites_commune__limite_commune) dups
	WHERE dups."row" = 1
	UNION
	SELECT 3000000 + row_number() OVER (ORDER BY dups.ogc_fid, dups._tid) AS cid,
		dups.ogc_fid,
		dups._tid,
		dups.origine,
		dups.limite_commune_de,
		dups.geometrie__point_0,
		dups.geometrie__point_1,
		dups.geom,
		dups.geometrie__point
	FROM ( 
		SELECT limites_commune__limite_commune.ogc_fid,
			limites_commune__limite_commune._tid,
			limites_commune__limite_commune.origine,
			limites_commune__limite_commune.limite_commune_de,
			limites_commune__limite_commune.geometrie__point_0,
			limites_commune__limite_commune.geometrie__point_1,
			limites_commune__limite_commune.geometrie AS geom,
			limites_commune__limite_commune.geometrie__point,
			row_number() OVER (PARTITION BY limites_commune__limite_commune.geometrie ORDER BY limites_commune__limite_commune.ogc_fid) AS "row",
			limites_commune__limite_commune.geometrie
	FROM ONLY vaud.limites_commune__limite_commune) dups
	WHERE dups."row" = 1
WITH DATA;
