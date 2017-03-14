

-- *****************
-- POINT FIXES

DROP MATERIALIZED VIEW IF EXISTS cadastre.pf_points_fixes;
CREATE MATERIALIZED VIEW cadastre.pf_points_fixes AS
		SELECT
			1000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT _tid, 'PFP1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  fribourg.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFP2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  fribourg.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFP3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int as accessibilite, signe, wkb_geometry FROM  fribourg.points_fixescategorie3__pfp3
				UNION
				SELECT _tid, 'PFA1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  fribourg.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFA2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  fribourg.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFA3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  fribourg.points_fixescategorie3__pfp3
			) fribourg
	UNION
		SELECT
			2000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT _tid, 'PFP1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  valais.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFP2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  valais.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFP3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int as accessibilite, signe, wkb_geometry FROM  valais.points_fixescategorie3__pfp3
				UNION
				SELECT _tid, 'PFA1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  valais.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFA2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  valais.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFA3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  valais.points_fixescategorie3__pfp3
			) valais
	UNION
		SELECT
			3000000 + row_number() OVER (ORDER BY _tid ASC) AS cid,
			*
			FROM
			(
				SELECT _tid, 'PFP1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  vaud.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFP2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, accessibilite, signe, wkb_geometry FROM  vaud.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFP3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int as accessibilite, signe, wkb_geometry FROM  vaud.points_fixescategorie3__pfp3
				UNION
				SELECT _tid, 'PFA1' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  vaud.points_fixescategorie1__pfp1
				UNION
				SELECT _tid, 'PFA2' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  vaud.points_fixescategorie2__pfp2
				UNION
				SELECT _tid, 'PFA3' as genre, origine, identdn, numero, geomalt, precplan, fiabplan, precalt, fiabalt, NULL::int asaccessibilite, NULL::int as signe, wkb_geometry FROM  vaud.points_fixescategorie3__pfp3
			) vaud
	;
CREATE INDEX pf_points_fixes_geom_idx ON cadastre.pf_points_fixes USING gist (wkb_geometry);
