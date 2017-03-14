-- *****************
-- NOMS DE RUE

DROP MATERIALIZED VIEW IF EXISTS cadastre.ab_rue;
CREATE MATERIALIZED VIEW cadastre.ab_rue AS
	(
		SELECT
			1000000 + row_number() OVER (ORDER BY rue.troncon_rue_de ASC) AS cid,
			COALESCE(nom.texte_abrege, nom.texte) AS nom_rue,
			--loc.*,
			rue.geometrie
		FROM
		(
			SELECT
				troncon_rue_de,
				ST_Multi(ST_LineMerge(ST_Union(rue.geometrie)))::geometry(MultiLineString,2056) as geometrie
			FROM fribourg.adresses_des_batiments__troncon_rue rue GROUP BY troncon_rue_de
		) rue
		--LEFT OUTER JOIN fribourg.adresses_des_batiments__localisation loc ON loc._tid = rue.troncon_rue_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (nom_localisation_de) * FROM fribourg.adresses_des_batiments__nom_localisation) nom ON nom.nom_localisation_de = rue.troncon_rue_de
	)
	UNION
	(
		SELECT
			2000000 + row_number() OVER (ORDER BY rue.troncon_rue_de ASC) AS cid,
			COALESCE(nom.texte_abrege, nom.texte) AS nom_rue,
			--loc.*,
			rue.geometrie
		FROM
		(
			SELECT
				troncon_rue_de,
				ST_Multi(ST_LineMerge(ST_Union(rue.geometrie)))::geometry(MultiLineString,2056) as geometrie
			FROM valais.adresses_des_batiments__troncon_rue rue GROUP BY troncon_rue_de
		) rue
		--LEFT OUTER JOIN valais.adresses_des_batiments__localisation loc ON loc._tid = rue.troncon_rue_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (nom_localisation_de) * FROM valais.adresses_des_batiments__nom_localisation) nom ON nom.nom_localisation_de = rue.troncon_rue_de
	)
	UNION
	(
		SELECT
			3000000 + row_number() OVER (ORDER BY rue.troncon_rue_de ASC) AS cid,
			COALESCE(nom.texte_abrege, nom.texte) AS nom_rue,
			--loc.*,
			rue.geometrie
		FROM
		(
			SELECT
				troncon_rue_de,
				ST_Multi(ST_LineMerge(ST_Union(rue.geometrie)))::geometry(MultiLineString,2056) as geometrie
			FROM vaud.adresses_des_batiments__troncon_rue rue GROUP BY troncon_rue_de
		) rue
		--LEFT OUTER JOIN vaud.adresses_des_batiments__localisation loc ON loc._tid = rue.troncon_rue_de
		LEFT OUTER JOIN (SELECT DISTINCT ON (nom_localisation_de) * FROM vaud.adresses_des_batiments__nom_localisation) nom ON nom.nom_localisation_de = rue.troncon_rue_de
	)
	;
CREATE INDEX ab_rue_geom_idx ON cadastre.ab_rue USING gist (geometrie);
