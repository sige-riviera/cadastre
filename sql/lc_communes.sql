-- *****************
-- LIMITES DE COMMUNES

-- Ce script :
-- - fusionne les limites de communes du SIGE pour Vaud, Fribourg et le Valais
-- - élimine les duplicats dans la table des limites de communes de Vaud
-- - élimine les duplicats dans la liste de valeurs des communes de Vaud
-- - élimine les éventuels duplicats dans la table des limites de communes de Fribourg (généralement, il n'y a pas de doublons)
-- - élimine les éventuels duplicats dans la liste de valeurs des communes de Fribourg (généralement, il n'y a pas de doublons)
-- - élimine les éventuels duplicats dans les tables des limites de communes du Valais (généralement, il n'y a pas de doublons)
-- - élimine les éventuels duplicats dans la liste de valeurs des communes du Valais (généralement, il n'y a pas de doublons)
-- - écrit en dur la relation entre la commune de Port-Valais et la liste de valeurs (pas de liens dans les données livrées)

ALTER TABLE valais.limites_commune__limite_commune
ADD COLUMN IF NOT EXISTS limite_commune_de_corrected character varying;

UPDATE valais.limites_commune__limite_commune
SET limite_commune_de_corrected = 100000006428 -- original value limite_commune_de = 100000001290 is wrong
WHERE ogc_fid = 1;

DROP MATERIALIZED VIEW IF EXISTS cadastre.lc_limites_commune;
CREATE MATERIALIZED VIEW cadastre.lc_limites_commune AS
    SELECT 1000000 + row_number() OVER (ORDER BY dups_table.ogc_fid, dups_table._tid) AS cid,
		dups_table.row_table,
		dups_valuelist.row_valuelist,
		dups_valuelist.noofs,
		dups_valuelist.nom,
		dups_table.ogc_fid,
		dups_table._tid,
		dups_table.origine,
		dups_table.limite_commune_de,
		dups_table.geometrie__point_0,
		dups_table.geometrie__point_1,
		dups_table.geom,
		dups_table.geometrie__point
    FROM (
		SELECT limites_commune__limite_commune.ogc_fid,
			limites_commune__limite_commune._tid,
			limites_commune__limite_commune.origine,
			limites_commune__limite_commune.limite_commune_de,
			limites_commune__limite_commune.geometrie__point_0,
			limites_commune__limite_commune.geometrie__point_1,
			limites_commune__limite_commune.geometrie AS geom,
			limites_commune__limite_commune.geometrie__point,
			row_number() OVER (PARTITION BY limites_commune__limite_commune.geometrie ORDER BY limites_commune__limite_commune.ogc_fid) AS "row_table",
			limites_commune__limite_commune.geometrie
		FROM ONLY fribourg.limites_commune__limite_commune) dups_table
		INNER JOIN (SELECT _tid, noofs, nom, row_number() OVER (PARTITION BY limites_commune__commune.noofs ORDER BY limites_commune__commune.ogc_fid) AS "row_valuelist"
                FROM ONLY fribourg.limites_commune__commune) dups_valuelist
                ON limite_commune_de = dups_valuelist._tid
	WHERE row_table = 1 AND row_valuelist = 1
	UNION
	SELECT 2000000 + row_number() OVER (ORDER BY dups_table.ogc_fid, dups_table._tid) AS cid,
		dups_table.row_table,
		dups_valuelist.row_valuelist,
		dups_valuelist.noofs,
		dups_valuelist.nom,
		dups_table.ogc_fid,
		dups_table._tid,
		dups_table.origine,
		dups_table.limite_commune_de_corrected,
		dups_table.geometrie__point_0,
		dups_table.geometrie__point_1,
		dups_table.geom,
		dups_table.geometrie__point
	FROM ( 
		SELECT limites_commune__limite_commune.ogc_fid,
            limites_commune__limite_commune._tid,
            limites_commune__limite_commune.origine,
            limites_commune__limite_commune.limite_commune_de_corrected,
            limites_commune__limite_commune.geometrie__point_0,
            limites_commune__limite_commune.geometrie__point_1,
            limites_commune__limite_commune.geometrie AS geom,
            limites_commune__limite_commune.geometrie__point,
            row_number() OVER (PARTITION BY limites_commune__limite_commune.geometrie ORDER BY limites_commune__limite_commune.ogc_fid) AS "row_table",
            limites_commune__limite_commune.geometrie
		FROM ONLY valais.limites_commune__limite_commune) dups_table
		INNER JOIN (SELECT _tid, noofs, nom, row_number() OVER (PARTITION BY limites_commune__commune.noofs ORDER BY limites_commune__commune.ogc_fid) AS "row_valuelist"
                FROM ONLY valais.limites_commune__commune) dups_valuelist
                ON limite_commune_de_corrected = dups_valuelist._tid
	WHERE row_table = 1 AND row_valuelist = 1
	UNION
	SELECT 3000000 + row_number() OVER (ORDER BY dups_table.ogc_fid, dups_table._tid) AS cid,
		dups_table.row_table,
		dups_valuelist.row_valuelist,
		dups_valuelist.noofs,
		dups_valuelist.nom,
		dups_table.ogc_fid,
		dups_table._tid,
		dups_table.origine,
		dups_table.limite_commune_de,
		dups_table.geometrie__point_0,
		dups_table.geometrie__point_1,
		dups_table.geom,
		dups_table.geometrie__point
        FROM (
                SELECT limites_commune__limite_commune.ogc_fid,
                        limites_commune__limite_commune._tid,
                        limites_commune__limite_commune.origine,
                        limites_commune__limite_commune.limite_commune_de,
                        limites_commune__limite_commune.geometrie__point_0,
                        limites_commune__limite_commune.geometrie__point_1,
                        limites_commune__limite_commune.geometrie AS geom,
                        limites_commune__limite_commune.geometrie__point,
                        row_number() OVER (PARTITION BY limites_commune__limite_commune.geometrie ORDER BY limites_commune__limite_commune.ogc_fid) AS "row_table",
                        limites_commune__limite_commune.geometrie
        FROM ONLY vaud.limites_commune__limite_commune) dups_table
	INNER JOIN (SELECT _tid, noofs, nom, row_number() OVER (PARTITION BY limites_commune__commune.noofs ORDER BY limites_commune__commune.ogc_fid) AS "row_valuelist"
		FROM ONLY vaud.limites_commune__commune) dups_valuelist
		ON limite_commune_de = dups_valuelist._tid
	WHERE row_table = 1 AND row_valuelist = 1
WITH DATA;
