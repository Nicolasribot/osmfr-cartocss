SELECT *
FROM
  (SELECT
     way,
     religion,
     wood,
     coalesce(aeroway, amenity, landuse, leisure, military, "natural", power, tourism, highway, man_made) AS feature
   FROM (
          SELECT
            way,
            wood,
            ('aeroway_' || (CASE WHEN aeroway IN ('apron', 'aerodrome')
              THEN aeroway
                            ELSE NULL END))  AS aeroway,
            ('amenity_' || (CASE WHEN amenity IN
                                      ('parking', 'university', 'college', 'school', 'hospital', 'clinic', 'kindergarten', 'grave_yard', 'recycling', 'place_of_worship', 'public_building', 'townhall', 'courthouse', 'police', 'post_office', 'theatre')
              THEN amenity
                            ELSE NULL END))  AS amenity,
            ('landuse_' || (CASE WHEN landuse IN
                                      ('quarry', 'vineyard', 'orchard', 'cemetery', 'grave_yard', 'residential', 'garages', 'field', 'meadow', 'grass', 'allotments', 'forest', 'farmyard', 'farm', 'farmyard', 'farmland', 'recreation_ground', 'conservation', 'village_green', 'retail', 'industrial', 'railway', 'commercial', 'brownfield', 'landfill', 'greenfield', 'construction', 'wood', 'school', 'harbour', 'salt_pond', 'greenhouse_horticulture')
              THEN landuse
                            ELSE NULL END))  AS landuse,
            ('leisure_' || (CASE WHEN leisure IN
                                      ('swimming_pool', 'playground', 'park', 'recreation_ground', 'common', 'garden', 'golf_course')
              THEN leisure
                            ELSE NULL END))  AS leisure,
            ('military_' || (CASE WHEN military IN ('barracks', 'danger_area')
              THEN military
                             ELSE NULL END)) AS military,
            ('natural_' ||
             (CASE WHEN "natural" IN ('beach', 'desert', 'heath', 'mud', 'grassland', 'wood', 'sand', 'scrub')
               THEN "natural"
              ELSE NULL END))                AS "natural",
            ('power_' || (CASE WHEN power IN ('station', 'sub_station', 'generator', 'substation', 'plant')
              THEN power
                          ELSE NULL END))    AS power,
            ('tourism_' ||
             (CASE WHEN tourism IN ('attraction', 'camp_site', 'caravan_site', 'picnic_site', 'zoo', 'museum')
               THEN tourism
              ELSE NULL END))                AS tourism,
            ('highway_' || (CASE WHEN highway IN ('services', 'rest_area')
              THEN highway
                            ELSE NULL END))  AS highway,
            ('man_made_' || (CASE WHEN man_made IS NOT NULL
              THEN man_made
                             ELSE NULL END)) AS man_made,
            CASE WHEN religion IN ('christian', 'jewish')
              THEN religion
            ELSE 'INT-generic' :: TEXT END   AS religion
          FROM planet_osm_polygon
          WHERE landuse IS NOT NULL
                OR leisure IS NOT NULL
                OR aeroway IN ('apron', 'aerodrome')
                OR amenity IN
                   ('parking', 'university', 'college', 'school', 'hospital', 'clinic', 'kindergarten', 'grave_yard', 'recycling', 'place_of_worship', 'public_building', 'townhall', 'courthouse', 'police', 'post_office', 'theatre')
                OR military IN ('barracks', 'danger_area')
                OR "natural" IN ('beach', 'desert', 'heath', 'mud', 'grassland', 'wood', 'sand', 'scrub')
                OR power IN ('station', 'sub_station', 'generator', 'substation', 'plant')
                OR tourism IN ('attraction', 'camp_site', 'caravan_site', 'picnic_site', 'zoo', 'museum')
                OR highway IN ('services', 'rest_area') OR
                man_made IN ('wastewater_plant', 'clearcut', 'gasometer', 'reservoir_covered', 'water_works', 'works')
          ORDER BY z_order, way_area DESC
        ) AS landcover
  ) AS features;


SELECT *
FROM
  (SELECT way
   FROM planet_osm_line
   WHERE man_made = 'cutline'
  ) AS leisure;

SELECT *
FROM
  (SELECT
     way,
     tracktype
   FROM planet_osm_line
   WHERE highway = 'track' AND coalesce(tunnel, covered) IN ('yes', 'true', '1')) AS tracks;

SELECT *
FROM
  (SELECT
     way,
     highway,
     toll,
     horse,
     foot,
     bicycle,
     junction,
     coalesce(tags -> 'footway', '') AS footway
   FROM planet_osm_line
   WHERE highway IN ('bridleway', 'footway', 'cycleway', 'path') AND coalesce(tunnel, covered) IN ('yes', 'true', '1')
   ORDER BY z_order) AS roads;

SELECT *
FROM
  (SELECT
     way,
     oneway,
     junction,
     toll,
     coalesce(highway, aeroway)      AS highway,
     horse,
     bicycle,
     foot,
     construction,
     coalesce(tags -> 'footway', '') AS footway,
     CASE WHEN coalesce(tunnel, covered) IN ('yes', 'true', '1')
       THEN 'yes' :: TEXT
     ELSE 'no' :: TEXT END           AS tunnel,
     CASE WHEN bridge IN ('yes', 'true', '1', 'viaduct')
       THEN 'yes' :: TEXT
     ELSE 'no' :: TEXT END           AS bridge,
     CASE WHEN railway IN ('spur', 'siding')
               OR (railway = 'rail' AND service IN ('spur', 'siding', 'yard'))
       THEN 'spur-siding-yard' :: TEXT
     ELSE railway END                AS railway,
     CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
       THEN 'INT-minor' :: TEXT
     ELSE 'INT-normal' :: TEXT END   AS service,
     CASE WHEN (z_order < 10 AND z_order > 3 AND
                highway IN ('motorway_link', 'trunk_link', 'primary_link', 'secondary_link', 'tertiary_link'))
       THEN 4 + (z_order / 10)
     WHEN (z_order < 10 AND z_order > 3 AND highway = 'tertiary')
       THEN 5
     ELSE z_order END                AS zz_order
   FROM planet_osm_line
   WHERE (highway IS NOT NULL
          OR aeroway IN ('runway', 'taxiway', 'taxipath', 'parking_position')
          OR railway IN
             ('light_rail', 'narrow_gauge', 'funicular', 'rail', 'subway', 'tram', 'spur', 'siding', 'platform', 'disused', 'abandoned', 'construction', 'miniature', 'turntable'))
         AND coalesce(tunnel, covered, '') IN ('yes', 'true', '1') AND route IS NULL
   ORDER BY zz_order) AS roads;
SELECT *
FROM
  (SELECT
     way,
     highway,
     junction,
     toll
   FROM planet_osm_line
   WHERE highway IN
         ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link', 'residential', 'unclassified')
         AND coalesce(tunnel, covered) IN ('yes', 'true', '1')
   ORDER BY z_order) AS tunnels;
SELECT *
FROM
  (SELECT
     '-1'                            AS oneway,
     CASE WHEN coalesce(tunnel, covered) IN ('yes', 'true', '1')
       THEN 'yes' :: TEXT
     ELSE 'no' :: TEXT END           AS tunnel,
     coalesce(tags -> 'footway', '') AS footway,
     CASE WHEN oneway IN ('yes', 'true', '1') OR junction = 'roundabout'
       THEN ST_Reverse(way)
     ELSE way END                    AS way
   FROM planet_osm_line
   WHERE
     way && !bbox ! AND ((oneway IS NOT NULL AND oneway NOT IN ('no', 'false', '0')) OR (junction = 'roundabout')) AND
     (highway IS NOT NULL OR railway IS NOT NULL OR waterway IS NOT NULL) AND
     (bridge IS NULL OR bridge NOT IN ('yes', 'true', '1', 'viaduct')) AND z_order < 0) AS directions;
SELECT *
FROM
  (SELECT
     way,
     waterway
   FROM planet_osm_line
   WHERE osm_id > 0 AND waterway IN ('stream', 'drain', 'ditch')
         AND (tunnel IS NULL AND covered IS NULL OR
              coalesce(tunnel, covered, '') NOT IN ('yes', 'true', '1', 'building_passage'))
  ) AS water_lines;
SELECT *
FROM
  (SELECT
     way,
     waterway
   FROM planet_osm_roads
   WHERE waterway = 'river' AND osm_id > 0
  ) AS water_lines;
SELECT *
FROM
  (SELECT
     contour,
     ele
   FROM contours) AS contours;
SELECT *
FROM
  (SELECT
     way,
     "natural",
     waterway,
     landuse,
     amenity,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name) AS name,
     tags -> 'basin'                                       AS basin,
     water
   FROM planet_osm_polygon
   WHERE (waterway IN ('dock', 'mill_pond', 'riverbank', 'canal')
          OR landuse IN ('reservoir', 'water', 'basin', 'salt_pond')
          OR "natural" IN ('lake', 'water', 'land', 'glacier', 'mud', 'bayx') OR amenity = 'fountain')
         AND building IS NULL
   ORDER BY z_order, way_area DESC
  ) AS water_areas;
SELECT *
FROM
  (SELECT
     way,
     "natural"
   FROM planet_osm_polygon
   WHERE "natural" IN ('marsh', 'wetland') AND building IS NULL
   ORDER BY z_order, way_area DESC
  ) AS water_areas;
SELECT *
FROM
  (SELECT
     way,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name) AS name,
     way_area
   FROM planet_osm_polygon
   WHERE "natural" = 'glacier' AND building IS NULL
   ORDER BY way_area DESC
  ) AS glaciers;
SELECT *
FROM
  (SELECT
     st_intersection(ST_SetSRID(ST_MakeBox2D(ST_Point(ST_XMin(!bbox !) +! pixel_width !* ((SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'buffer') +
                                                                                          (SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'x_bleed')),
                                                      ST_Ymin(!bbox !) +! pixel_height !* ((SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'y_bleed') +
                                                                                           (SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'buffer'))),
                                             ST_Point(ST_XMax(!bbox !) -! pixel_width !* ((SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'x_bleed') +
                                                                                          (SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'buffer')),
                                                      ST_Ymax(!bbox !) -! pixel_height !* ((SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'y_bleed') +
                                                                                           (SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'buffer')))),
                                900913), way)              AS way,
     waterway,
     disused,
     lock,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name) AS name,
     CASE WHEN coalesce(tunnel, covered) IN ('yes', 'true', '1')
       THEN 'yes' :: TEXT
     ELSE coalesce(tunnel, covered) END                    AS tunnel,
     tags -> 'CEMT'                                        AS cemt,
     CASE WHEN tags -> 'motorboat' = 'yes'
       THEN 'motorboat'
     WHEN tags -> 'boat' = 'yes'
       THEN 'boat'
     ELSE 'no' END                                         AS boat
   FROM planet_osm_line
   WHERE way && !bbox ! AND osm_id > 0 AND
         waterway IN ('weir', 'river', 'canal', 'derelict_canal', 'stream', 'drain', 'ditch', 'wadi')
         AND (bridge IS NULL OR bridge NOT IN ('yes', 'true', '1', 'aqueduct'))
   ORDER BY z_order
  ) AS water_lines;
SELECT *
FROM
  (SELECT
     way,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name) AS name
   FROM planet_osm_line
   WHERE waterway = 'dam') AS dam;
SELECT *
FROM
  (SELECT way
   FROM planet_osm_polygon
   WHERE leisure = 'marina') AS marinas;
SELECT *
FROM
  (SELECT
     way,
     man_made
   FROM planet_osm_polygon
   WHERE man_made IN ('pier', 'breakwater', 'groyne')) AS piers;
SELECT *
FROM
  (SELECT
     way,
     man_made
   FROM planet_osm_line
   WHERE man_made IN ('pier', 'breakwater', 'groyne')) AS piers;
SELECT *
FROM
  (SELECT
     way,
     waterway
   FROM planet_osm_point
   WHERE waterway = 'lock_gate') AS locks;
SELECT *
FROM
  (SELECT
     way,
     leisure,
     CASE WHEN leisure = 'pitch'
       THEN 2
     WHEN leisure = 'track'
       THEN 1
     ELSE 0 END AS prio
   FROM planet_osm_polygon
   WHERE leisure IN ('sports_centre', 'stadium', 'pitch', 'track')
   ORDER BY z_order, prio, way_area DESC
  ) AS sports_grounds;
SELECT *
FROM
  (SELECT
     *,
     abs(a12 - a23)       AS angle_diff,
     (a12 + a23 + 90) / 2 AS angle
   FROM (SELECT
           *,
           st_npoints(way2)                                            AS nb,
           ST_Distance(st_pointn(way2, 1), st_pointn(way2, 2))         AS d12,
           ST_Distance(st_pointn(way2, 3), st_pointn(way2, 2))         AS d23,
           ST_Distance(st_pointn(way2, 1), st_pointn(way2, 3))         AS d13,
           degrees(st_azimuth(st_pointn(way2, 1), st_pointn(way2, 2))) AS a12,
           degrees(st_azimuth(st_pointn(way2, 2), st_pointn(way2, 3))) AS a23
         FROM (SELECT
                 *,
                 st_area(way)                                           AS way_area,
                 ST_ExteriorRing(ST_SimplifyPreserveTopology(way, 100)) AS way2
               FROM (SELECT
                       (st_dump(way)).geom AS way,
                       sport,
                       surface,
                       access
                     FROM planet_osm_polygon
                     WHERE sport IN
                           ('tennis', 'soccer', 'basketball', 'rugby', 'rugby_union', 'rugby_league', 'american_football')
                           AND way && !bbox !) AS dump) AS simplified) AS simplified2) AS sports;
SELECT *
FROM
  (SELECT
     way,
     geo,
     golf,
     ref,
     initcap(name) AS name,
     CASE WHEN golf = 'rough'
       THEN 5
     WHEN golf = 'fairway'
       THEN 10
     WHEN golf = 'green'
       THEN 20
     WHEN golf = 'bunker'
       THEN 30
     WHEN golf IN ('water_hazard', 'lateral_water_hazard')
       THEN 35
     ELSE 40 END   AS prio
   FROM (SELECT
           way,
           tags -> 'golf' AS golf,
           name,
           ref,
           way_area,
           'polygon'      AS geo
         FROM planet_osm_polygon
         WHERE tags ? 'golf' AND way && !bbox !
         UNION SELECT
                 p.way,
                 p.tags -> 'golf'       AS golf,
                 p.name,
                 coalesce(p.ref, l.ref) AS ref,
                 0                      AS way_area,
                 'point'                AS geo
               FROM planet_osm_point p LEFT JOIN planet_osm_line l ON (ST_Intersects(p.way, l.way) AND l.tags ? 'golf')
               WHERE p.tags ? 'golf' AND p.way && !bbox !
         UNION SELECT
                 way,
                 tags -> 'golf' AS golf,
                 name,
                 ref,
                 0              AS way_area,
                 'line'         AS geo
               FROM planet_osm_line
               WHERE tags ? 'golf' AND way && !bbox !) AS golf
   ORDER BY prio) AS golf;
SELECT *
FROM
  (SELECT
     way,
     tags -> 'piste:type'       AS ski_type,
     tags -> 'piste:difficulty' AS ski_difficulty,
     ref,
     name
   FROM planet_osm_line
   WHERE tags ? 'piste:difficulty') AS ski;
SELECT *
FROM
  (SELECT
     way,
     historic
   FROM planet_osm_line
   WHERE historic IN ('citywalls', 'castle_walls')
   UNION SELECT
           way,
           historic
         FROM planet_osm_polygon
         WHERE historic = 'castle_walls') AS citywalls;
SELECT *
FROM
  (SELECT
     way,
     landuse,
     leisure,
     amenity
   FROM planet_osm_polygon
   WHERE (landuse = 'military' OR leisure = 'nature_reserve' OR amenity = 'prison') AND building IS NULL
  ) AS landuse_overlay;
SELECT *
FROM
  (SELECT DISTINCT ON (p.way)
     p.way     AS way,
     l.highway AS int_tc_type
   FROM planet_osm_point p
     JOIN planet_osm_line l
       ON ST_DWithin(p.way, l.way, 0.1)
     JOIN (VALUES
       ('tertiary', 1),
       ('unclassified', 2),
       ('residential', 3),
       ('living_street', 4),
       ('service', 5)
          ) AS v (highway, prio)
       ON v.highway = l.highway
   WHERE p.highway IN ('turning_circle', 'turning_loop')
   ORDER BY p.way, v.prio
  ) AS turning_circle;
SELECT *
FROM
  (SELECT
     way,
     "natural",
     man_made,
     junction
   FROM planet_osm_line
   WHERE "natural" = 'cliff' OR man_made = 'embankment') AS roads;
SELECT *
FROM
  (SELECT
     way,
     barrier,
     "natural"
   FROM planet_osm_polygon
   WHERE barrier IS NOT NULL OR "natural" = 'hedge') AS barriers;
SELECT *
FROM
  (SELECT
     way,
     highway,
     railway,
     toll,
     coalesce(tags -> 'footway', '') AS footway,
     CASE WHEN coalesce(tunnel, covered) IN ('yes', 'true', '1')
       THEN 'yes' :: TEXT
     ELSE 'no' :: TEXT END           AS tunnel,
     junction
   FROM planet_osm_polygon
   WHERE (highway IN
          ('residential', 'unclassified', 'pedestrian', 'service', 'footway', 'track', 'path', 'platform', 'cycleway')
          OR railway = 'platform')
   ORDER BY z_order, way_area DESC) AS highway_area_casing;
SELECT *
FROM
  (SELECT
     way,
     highway,
     junction,
     toll,
     coalesce(tags -> 'footway', '') AS footway,
     CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
       THEN 'INT-minor' :: TEXT
     ELSE 'INT-normal' :: TEXT END   AS service
   FROM planet_osm_line
   WHERE coalesce(tunnel, covered, '') NOT IN ('yes', 'true', '1') AND (highway IN
                                                                        ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link', 'residential', 'unclassified', 'road', 'service', 'pedestrian', 'raceway', 'living_street', 'platform')
                                                                        OR railway = 'platform') AND route IS NULL
   ORDER BY z_order) AS roads;
SELECT *
FROM
  (SELECT
     way,
     highway,
     junction,
     toll,
     railway,
     aeroway,
     coalesce(tags -> 'footway', '') AS footway,
     CASE WHEN coalesce(tunnel, covered) IN ('yes', 'true', '1')
       THEN 'yes' :: TEXT
     ELSE 'no' :: TEXT END           AS tunnel /* ,case when highway in ('motorway','motorway_link') then '1' when highway in ('trunk','trunk_link') then '2' when highway in ('primary','primary_link') then '3' when highway in ('secondary','secondary_link') then '4' when highway in ('tertiary','tertiary_link') then '5' when highway in ('residential','unclassified') then '6' else '7' end as prio */
   FROM planet_osm_polygon
   WHERE highway IN
         ('residential', 'unclassified', 'pedestrian', 'service', 'footway', 'living_street', 'track', 'path', 'platform', 'services', 'cycleway')
         OR railway = 'platform'
         OR aeroway IN ('runway', 'taxiway', 'helipad', 'taxipath', 'parking_position')
   ORDER BY z_order, way_area DESC) AS roads;
SELECT *
FROM
  (SELECT
     way,
     barrier,
     junction
   FROM planet_osm_line
   WHERE barrier IS NOT NULL) AS roads;
SELECT *
FROM
  (SELECT
     way,
     building,
     railway,
     amenity,
     shop
   FROM planet_osm_polygon
   WHERE (railway = 'station' OR building IN ('station', 'supermarket') OR amenity IN
                                                                           ('place_of_worship', 'public_building', 'townhall', 'courthouse', 'police', 'post_office', 'theatre')
          OR shop IN ('mall', 'department_store')) AND way_area < 2000000
   ORDER BY z_order, way_area DESC) AS buildings;
SELECT *
FROM
  (SELECT
     way,
     aeroway,
     amenity,
     tags -> 'heritage' AS heritage,
     CASE WHEN building IN ('residential', 'house', 'garage', 'garages', 'detached', 'terrace', 'apartments')
       THEN 'INT-light' :: TEXT
     ELSE building END  AS building,
     tags -> 'wall'     AS wall
   FROM planet_osm_polygon
   WHERE (building IS NOT NULL AND building NOT IN ('no', 'station', 'supermarket', 'planned') AND
          (railway IS NULL OR railway != 'station') AND (amenity IS NULL OR amenity NOT IN
                                                                            ('place_of_worship', 'public_building', 'townhall', 'courthouse', 'police', 'post_office', 'theatre'))
          OR aeroway = 'terminal') AND way_area < 2000000
   ORDER BY z_order, way_area DESC) AS buildings;
SELECT *
FROM
  (SELECT way
   FROM planet_osm_polygon
   WHERE tags -> 'room' = 'yes' OR tags -> 'indoor' = 'yes') AS indoor;
SELECT *
FROM
  (SELECT
     way,
     tracktype
   FROM planet_osm_line
   WHERE highway = 'track' AND (bridge IS NULL OR bridge IN ('no', 'false', '0')) AND
         (tunnel IS NULL OR tunnel IN ('no', 'false', '0'))) AS tracks;
SELECT *
FROM
  (SELECT
     way,
     oneway,
     junction,
     toll,
     coalesce(highway, aeroway)      AS highway,
     horse,
     bicycle,
     foot,
     construction,
     coalesce(tags -> 'footway', '') AS footway,
     CASE WHEN bridge IN ('yes', 'true', '1', 'viaduct')
       THEN 'yes' :: TEXT
     ELSE 'no' :: TEXT END           AS bridge,
     CASE WHEN railway IN ('spur', 'siding')
               OR (railway = 'rail' AND service IN ('spur', 'siding', 'yard'))
       THEN 'spur-siding-yard' :: TEXT
     ELSE railway END                AS railway,
     CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
       THEN 'INT-minor' :: TEXT
     ELSE 'INT-normal' :: TEXT END   AS service,
     CASE WHEN (z_order < 10 AND z_order > 3 AND
                highway IN ('motorway_link', 'trunk_link', 'primary_link', 'secondary_link', 'tertiary_link'))
       THEN 4 + (z_order / 10)
     WHEN (z_order < 10 AND z_order > 3 AND highway = 'tertiary')
       THEN 5
     ELSE z_order END                AS zz_order
   FROM planet_osm_line
   WHERE coalesce(tunnel, covered, '') NOT IN ('yes', 'true', '1') AND (highway IS NOT NULL
                                                                        OR aeroway IN
                                                                           ('runway', 'taxiway', 'taxipath', 'parking_position')
                                                                        OR railway IN
                                                                           ('light_rail', 'narrow_gauge', 'funicular', 'rail', 'subway', 'tram', 'spur', 'siding', 'platform', 'disused', 'abandoned', 'construction', 'miniature', 'turntable'))
         AND route IS NULL
   ORDER BY zz_order) AS roads;
SELECT *
FROM
  (SELECT DISTINCT ON (p.way)
     p.way     AS way,
     l.highway AS int_tc_type
   FROM planet_osm_point p
     JOIN planet_osm_line l
       ON ST_DWithin(p.way, l.way, 0.1)
     JOIN (VALUES
       ('tertiary', 1),
       ('unclassified', 2),
       ('residential', 3),
       ('living_street', 4),
       ('service', 5)
          ) AS v (highway, prio)
       ON v.highway = l.highway
   WHERE p.highway IN ('turning_circle', 'turning_loop')
   ORDER BY p.way, v.prio
  ) AS turning_circle;
SELECT *
FROM
  (SELECT way
   FROM planet_osm_line
   WHERE route = 'ferry') AS routes;
SELECT *
FROM
  (SELECT
     way,
     aerialway,
     name
   FROM planet_osm_line
   WHERE aerialway IS NOT NULL) AS aerialways;
SELECT *
FROM
  (/* roads */ SELECT
                 way,
                 highway,
                 junction,
                 toll,
                 CASE WHEN railway = 'preserved' AND service IN ('spur', 'siding', 'yard')
                   THEN 'INT-preserved-ssy' :: TEXT
                 ELSE railway END AS railway
               FROM planet_osm_roads
               WHERE coalesce(tunnel, covered, '') NOT IN ('yes', 'true', '1') AND (highway IS NOT NULL OR (
                 railway IS NOT NULL AND railway != 'preserved' AND
                 (service IS NULL OR service NOT IN ('spur', 'siding', 'yard'))) OR railway = 'preserved')
               ORDER BY z_order) AS roads;
SELECT *
FROM
  (SELECT
     st_buffer(st_collect(way), 3) AS way,
     'poly'                        AS type
   FROM planet_osm_point
   WHERE "natural" = 'tree' AND way && !bbox !
   UNION SELECT
           way,
           'point' AS type
         FROM planet_osm_point
         WHERE "natural" = 'tree' AND way && !bbox !
   UNION SELECT
           st_buffer(st_collect(way), 3) AS way,
           'poly'                        AS type
         FROM planet_osm_line
         WHERE "natural" = 'tree_row' AND way && !bbox !) AS trees;
SELECT *
FROM
  (SELECT
     way,
     access,
     highway,
     coalesce(tags -> 'footway', '') AS footway,
     CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
       THEN 'INT-minor' :: TEXT
     ELSE 'INT-normal' :: TEXT END   AS service
   FROM planet_osm_line
   WHERE access IS NOT NULL AND highway IS NOT NULL
         AND (bridge IS NULL OR bridge NOT IN ('yes', 'true', '1', 'viaduct'))
  ) AS access;
SELECT *
FROM
  (SELECT
     '-1'                            AS oneway,
     CASE WHEN coalesce(tunnel, covered) IN ('yes', 'true', '1')
       THEN 'yes' :: TEXT
     ELSE 'no' :: TEXT END           AS tunnel,
     coalesce(tags -> 'footway', '') AS footway,
     CASE WHEN oneway IN ('yes', 'true', '1') OR junction = 'roundabout'
       THEN ST_Reverse(way)
     ELSE way END                    AS way
   FROM planet_osm_line
   WHERE
     way && !bbox ! AND ((oneway IS NOT NULL AND oneway NOT IN ('no', 'false', '0')) OR (junction = 'roundabout')) AND
     (highway IS NOT NULL OR railway IS NOT NULL OR waterway IS NOT NULL) AND
     (bridge IS NULL OR bridge NOT IN ('yes', 'true', '1', 'viaduct')) AND z_order >= 0) AS directions;
SELECT *
FROM
  (SELECT way
   FROM planet_osm_polygon
   WHERE man_made = 'bridge'
   ORDER BY z_order) AS bridge_poly;
SELECT *
FROM
  (SELECT
     way,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name) AS name
   FROM planet_osm_line
   WHERE waterway = 'canal' AND bridge IN ('yes', 'true', '1', 'aqueduct')
   ORDER BY z_order) AS water;
SELECT *
FROM
  (/* layer0 */ SELECT
                  CASE WHEN oneway IN ('yes', 'true', '1')
                    THEN ST_Reverse(way)
                  ELSE way END                    AS way,
                  CASE WHEN oneway IS NOT NULL
                    THEN '-1'
                  ELSE '' END                     AS oneway,
                  access,
                  CASE WHEN bridge IN ('yes', 'true', '1', 'viaduct')
                    THEN 'yes'
                  ELSE 'no' END                   AS bridge,
                  CASE WHEN tunnel IN ('yes', 'true', '1')
                    THEN 'yes'
                  ELSE 'no' END                   AS tunnel,
                  junction,
                  toll,
                  coalesce(highway, aeroway)      AS highway,
                  horse,
                  bicycle,
                  foot,
                  tracktype,
                  coalesce(tags -> 'footway', '') AS footway,
                  CASE WHEN railway IN ('spur', 'siding') OR
                            (railway = 'rail' AND service IN ('spur', 'siding', 'yard'))
                    THEN 'INT-spur-siding-yard' :: TEXT
                  ELSE railway END                AS railway,
                  CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
                    THEN 'INT-minor' :: TEXT
                  ELSE 'INT-normal' :: TEXT END   AS service
                FROM planet_osm_line
                WHERE
                  way && !bbox ! AND bridge IN ('yes', 'true', '1', 'viaduct') AND (layer IS NULL OR layer = '0') AND (
                    highway IS NOT NULL OR aeroway IN ('runway', 'taxiway', 'taxipath', 'parking_position') OR
                    railway IN
                    ('light_rail', 'subway', 'narrow_gauge', 'rail', 'spur', 'siding', 'disused', 'abandoned', 'construction')
                    OR waterway IS NOT NULL)
                ORDER BY z_order) AS layer0;
SELECT *
FROM
  (/* layer1 */ SELECT
                  CASE WHEN oneway IN ('yes', 'true', '1')
                    THEN ST_Reverse(way)
                  ELSE way END                    AS way,
                  CASE WHEN oneway IS NOT NULL
                    THEN '-1'
                  ELSE '' END                     AS oneway,
                  access,
                  CASE WHEN bridge IN ('yes', 'true', '1', 'viaduct')
                    THEN 'yes'
                  ELSE 'no' END                   AS bridge,
                  CASE WHEN tunnel IN ('yes', 'true', '1')
                    THEN 'yes'
                  ELSE 'no' END                   AS tunnel,
                  junction,
                  toll,
                  coalesce(highway, aeroway)      AS highway,
                  horse,
                  bicycle,
                  foot,
                  tracktype,
                  coalesce(tags -> 'footway', '') AS footway,
                  CASE WHEN railway IN ('spur', 'siding') OR
                            (railway = 'rail' AND service IN ('spur', 'siding', 'yard'))
                    THEN 'INT-spur-siding-yard' :: TEXT
                  ELSE railway END                AS railway,
                  CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
                    THEN 'INT-minor' :: TEXT
                  ELSE 'INT-normal' :: TEXT END   AS service
                FROM planet_osm_line
                WHERE way && !bbox ! AND bridge IN ('yes', 'true', '1', 'viaduct') AND layer = '1' AND (
                  highway IS NOT NULL OR aeroway IN ('runway', 'taxiway', 'taxipath', 'parking_position') OR railway IN
                                                                                                             ('light_rail', 'subway', 'narrow_gauge', 'rail', 'spur', 'siding', 'disused', 'abandoned', 'construction')
                  OR waterway IS NOT NULL)
                ORDER BY z_order) AS layer1;
SELECT *
FROM
  (/* layer2 */ SELECT
                  CASE WHEN oneway IN ('yes', 'true', '1')
                    THEN ST_Reverse(way)
                  ELSE way END                    AS way,
                  CASE WHEN oneway IS NOT NULL
                    THEN '-1'
                  ELSE '' END                     AS oneway,
                  access,
                  CASE WHEN bridge IN ('yes', 'true', '1', 'viaduct')
                    THEN 'yes'
                  ELSE 'no' END                   AS bridge,
                  CASE WHEN tunnel IN ('yes', 'true', '1')
                    THEN 'yes'
                  ELSE 'no' END                   AS tunnel,
                  junction,
                  toll,
                  coalesce(highway, aeroway)      AS highway,
                  horse,
                  bicycle,
                  foot,
                  tracktype,
                  coalesce(tags -> 'footway', '') AS footway,
                  CASE WHEN railway IN ('spur', 'siding') OR
                            (railway = 'rail' AND service IN ('spur', 'siding', 'yard'))
                    THEN 'INT-spur-siding-yard' :: TEXT
                  ELSE railway END                AS railway,
                  CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
                    THEN 'INT-minor' :: TEXT
                  ELSE 'INT-normal' :: TEXT END   AS service
                FROM planet_osm_line
                WHERE way && !bbox ! AND bridge IN ('yes', 'true', '1', 'viaduct') AND layer = '2' AND (
                  highway IS NOT NULL OR aeroway IN ('runway', 'taxiway', 'taxipath', 'parking_position') OR railway IN
                                                                                                             ('light_rail', 'subway', 'narrow_gauge', 'rail', 'spur', 'siding', 'disused', 'abandoned', 'construction')
                  OR waterway IS NOT NULL)
                ORDER BY z_order) AS layer2;
SELECT *
FROM
  (/* layer3 */ SELECT
                  CASE WHEN oneway IN ('yes', 'true', '1')
                    THEN ST_Reverse(way)
                  ELSE way END                    AS way,
                  CASE WHEN oneway IS NOT NULL
                    THEN '-1'
                  ELSE '' END                     AS oneway,
                  access,
                  CASE WHEN bridge IN ('yes', 'true', '1', 'viaduct')
                    THEN 'yes'
                  ELSE 'no' END                   AS bridge,
                  CASE WHEN tunnel IN ('yes', 'true', '1')
                    THEN 'yes'
                  ELSE 'no' END                   AS tunnel,
                  junction,
                  toll,
                  coalesce(highway, aeroway)      AS highway,
                  horse,
                  bicycle,
                  foot,
                  tracktype,
                  coalesce(tags -> 'footway', '') AS footway,
                  CASE WHEN railway IN ('spur', 'siding') OR
                            (railway = 'rail' AND service IN ('spur', 'siding', 'yard'))
                    THEN 'INT-spur-siding-yard' :: TEXT
                  ELSE railway END                AS railway,
                  CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
                    THEN 'INT-minor' :: TEXT
                  ELSE 'INT-normal' :: TEXT END   AS service
                FROM planet_osm_line
                WHERE way && !bbox ! AND bridge IN ('yes', 'true', '1', 'viaduct') AND layer = '3' AND (
                  highway IS NOT NULL OR aeroway IN ('runway', 'taxiway', 'taxipath', 'parking_position') OR railway IN
                                                                                                             ('light_rail', 'subway', 'narrow_gauge', 'rail', 'spur', 'siding', 'disused', 'abandoned', 'construction')
                  OR waterway IS NOT NULL)
                ORDER BY z_order) AS layer3;
SELECT *
FROM
  (/* layer4 */ SELECT
                  CASE WHEN oneway IN ('yes', 'true', '1')
                    THEN ST_Reverse(way)
                  ELSE way END                    AS way,
                  CASE WHEN oneway IS NOT NULL
                    THEN '-1'
                  ELSE '' END                     AS oneway,
                  access,
                  CASE WHEN bridge IN ('yes', 'true', '1', 'viaduct')
                    THEN 'yes'
                  ELSE 'no' END                   AS bridge,
                  CASE WHEN tunnel IN ('yes', 'true', '1')
                    THEN 'yes'
                  ELSE 'no' END                   AS tunnel,
                  junction,
                  toll,
                  coalesce(highway, aeroway)      AS highway,
                  horse,
                  bicycle,
                  foot,
                  tracktype,
                  coalesce(tags -> 'footway', '') AS footway,
                  CASE WHEN railway IN ('spur', 'siding') OR
                            (railway = 'rail' AND service IN ('spur', 'siding', 'yard'))
                    THEN 'INT-spur-siding-yard' :: TEXT
                  ELSE railway END                AS railway,
                  CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
                    THEN 'INT-minor' :: TEXT
                  ELSE 'INT-normal' :: TEXT END   AS service
                FROM planet_osm_line
                WHERE way && !bbox ! AND bridge IN ('yes', 'true', '1', 'viaduct') AND layer = '4' AND (
                  highway IS NOT NULL OR aeroway IN ('runway', 'taxiway', 'taxipath', 'parking_position') OR railway IN
                                                                                                             ('light_rail', 'subway', 'narrow_gauge', 'rail', 'spur', 'siding', 'disused', 'abandoned', 'construction')
                  OR waterway IS NOT NULL)
                ORDER BY z_order) AS layer4;
SELECT *
FROM
  (/* layer5 */ SELECT
                  CASE WHEN oneway IN ('yes', 'true', '1')
                    THEN ST_Reverse(way)
                  ELSE way END                    AS way,
                  CASE WHEN oneway IS NOT NULL
                    THEN '-1'
                  ELSE '' END                     AS oneway,
                  access,
                  CASE WHEN bridge IN ('yes', 'true', '1', 'viaduct')
                    THEN 'yes'
                  ELSE 'no' END                   AS bridge,
                  CASE WHEN tunnel IN ('yes', 'true', '1')
                    THEN 'yes'
                  ELSE 'no' END                   AS tunnel,
                  junction,
                  toll,
                  coalesce(highway, aeroway)      AS highway,
                  horse,
                  bicycle,
                  foot,
                  tracktype,
                  coalesce(tags -> 'footway', '') AS footway,
                  CASE WHEN railway IN ('spur', 'siding') OR
                            (railway = 'rail' AND service IN ('spur', 'siding', 'yard'))
                    THEN 'INT-spur-siding-yard' :: TEXT
                  ELSE railway END                AS railway,
                  CASE WHEN service IN ('parking_aisle', 'drive-through', 'driveway')
                    THEN 'INT-minor' :: TEXT
                  ELSE 'INT-normal' :: TEXT END   AS service
                FROM planet_osm_line
                WHERE way && !bbox ! AND bridge IN ('yes', 'true', '1', 'viaduct') AND layer = '5' AND (
                  highway IS NOT NULL OR aeroway IN ('runway', 'taxiway', 'taxipath', 'parking_position') OR railway IN
                                                                                                             ('light_rail', 'subway', 'narrow_gauge', 'rail', 'spur', 'siding', 'disused', 'abandoned', 'construction')
                  OR waterway IS NOT NULL)
                ORDER BY z_order) AS layer5;
SELECT *
FROM
  (SELECT
     osm_id,
     tactile_paving,
     crossing_bollard,
     wheelchair,
     ST_GeometryN(st_union(way), 1) AS way,
     max(angle) - min(angle)        AS angle_diff,
     avg(angle)                     AS angle
   FROM (SELECT
           p.osm_id,
           tactile_paving,
           crossing_bollard,
           wheelchair,
           p.way AS way,
           cast(90 + degrees(ST_Azimuth(st_lineinterpolatepoint(way1, 0), st_lineinterpolatepoint(way1, 1))) AS INTEGER)
           % 180 AS angle
         FROM (SELECT *
               FROM (SELECT
                       p.osm_id,
                       p.way,
                       ST_LineMerge(ST_Intersection(st_buffer(p.way, 0.1), h.way)) AS way1,
                       p.tags -> 'tactile_paving'                                  AS tactile_paving,
                       p.tags -> 'crossing:bollard'                                AS crossing_bollard,
                       coalesce(p.tags -> 'wheelchair', p.tags -> 'sloped_curb')   AS wheelchair
                     FROM planet_osm_point AS p
                       JOIN planet_osm_line h ON (st_intersects(p.way, h.way) AND h.highway IS NOT NULL AND
                                                  h.highway NOT IN
                                                  ('footway', 'cycleway', 'path', 'pedestrian', 'steps', 'service'))
                     WHERE (p.highway = 'crossing' OR p.tags -> 'crossing' IN ('traffic_signals', 'uncontrolled')) AND
                           p.way && !bbox !) AS p
               WHERE ST_GeometryType(way1) = 'ST_LineString') AS p) AS crossing
   GROUP BY osm_id, tactile_paving, crossing_bollard, wheelchair) AS highway_crossings;
SELECT *
FROM
  (SELECT
     way,
     railway,
     bridge
   FROM planet_osm_line
   WHERE railway = 'tram' AND (tunnel IS NULL AND covered IS NULL OR
                               coalesce(tunnel, covered, '') NOT IN ('yes', 'true', '1', 'building_passage'))) AS trams;
SELECT *
FROM
  (SELECT way
   FROM planet_osm_line
   WHERE highway = 'bus_guideway' AND (tunnel IS NULL AND covered IS NULL OR coalesce(tunnel, covered, '') NOT IN
                                                                             ('yes', 'true', '1', 'building_passage'))) AS guideways;
SELECT *
FROM
  (SELECT
     ST_SnapToGrid(way, !pixel_width !/ 2) AS way,
     admin_level,
     tags -> 'maritime'                    AS maritime
   FROM planet_osm_roads
   WHERE
     way && !bbox ! AND boundary = 'administrative' AND admin_level IN ('1', '2', '3', '4', '5', '6') AND osm_id > 0 AND
     ("natural" IS NULL OR "natural" != 'coastline')
   ORDER BY 2 DESC, maritime) AS admin;
SELECT *
FROM
  (SELECT
     way,
     admin_level,
     coalesce(b.tags -> 'maritime', 'no') AS maritime,
     count(r.*)                           AS nb,
     string_agg(id :: TEXT, ',')          AS rels
   FROM planet_osm_roads b LEFT JOIN planet_osm_rels r
       ON (r.parts @> ARRAY [osm_id] AND r.members @> ARRAY ['w' || osm_id] AND
           regexp_replace(r.tags :: TEXT, '[{}]', ',') ~
           format('(,admin_level,%s.*,boundary,administrative|,boundary,administrative.*,admin_level,%s,)', admin_level,
                  admin_level))
   WHERE boundary = 'administrative' AND admin_level IS NOT NULL
   GROUP BY 1, 2, 3
   ORDER BY cast('0' || regexp_replace(admin_level, '[^0-9]', '', 'g') AS INTEGER) DESC, 4) AS admin_boundaries;
SELECT *
FROM
  (SELECT
     way,
     place,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name)                 AS name,
     replace(replace(replace(coalesce(tags -> 'short_name:fr', tags -> 'name:fr', tags -> 'int_name', name), 'Saint-',
                             'Sᵗ-'), 'Sainte-', 'Sᵗᵉ-'), '-sous-', '-ss-') AS nom,
     cast(regexp_replace('0' || population, '[^0-9]', '', 'g') AS BIGINT)  AS pop,
     coalesce(tags -> 'is_capital', (CASE WHEN coalesce(admin_level, capital) = '2'
       THEN 'country'
                                     WHEN tags -> 'importance' = 'international'
                                       THEN 'state'
                                     WHEN coalesce(admin_level, capital) = '4'
                                       THEN 'state'
                                     WHEN tags -> 'importance' = 'national'
                                       THEN 'state'
                                     ELSE NULL END))                       AS is_capital,
     array_length(hstore_to_array(tags), 1) / 2                            AS nbtags
   FROM planet_osm_point
   WHERE
     place IS NOT NULL AND (capital IS NOT NULL OR tags ? 'is_capital') AND (capital IS NOT NULL OR tags ? 'is_capital')
     AND place IN ('city', 'town') AND (
       tags -> 'is_capital' IN ('country', 'state') OR capital IN ('2', '3', '4', '5', '6', '7') OR
       (capital = 'yes' AND admin_level IN ('2', '3', '4', '5', '6', '7')) OR
       tags -> 'importance' IN ('international', 'national') OR array_length(hstore_to_array(tags), 1) / 2 > 20)
   ORDER BY is_capital, coalesce(admin_level, capital, '9'), place, pop DESC) AS placenames;
SELECT *
FROM
  (SELECT
     way,
     cast(st_area(st_convexhull(way)) AS BIGINT)                                                             way_area,
     place,
     coalesce(tags -> 'short_name:fr', tags -> 'name:fr', tags -> 'short_name', tags -> 'int_name', name) AS name
   FROM planet_osm_polygon
   WHERE place IS NOT NULL AND place IN ('archipelago', 'island')
   ORDER BY place, way_area DESC) AS islands;
SELECT *
FROM
  (SELECT
     way,
     place,
     coalesce(tags -> 'short_name:fr', tags -> 'name:fr', tags -> 'short_name', tags -> 'int_name', name) AS name,
     osm_id,
     cast(regexp_replace('0' || population, '[^0-9]', '', 'g') AS BIGINT)                                 AS pop,
     ref,
     0                                                                                                    AS way_area
   FROM planet_osm_point
   WHERE place IS NOT NULL AND place IN ('country', 'state', 'continent') AND NOT tags ? 'disused:admin_level'
   ORDER BY place, pop DESC) AS placenames;
SELECT *
FROM
  (SELECT
     way,
     place,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name)                                       AS name,
     replace(replace(replace(
                         coalesce(tags -> 'short_name:fr', tags -> 'short_name', tags -> 'name:fr', tags -> 'int_name',
                                  name), 'Saint-', 'Sᵗ-'), 'Sainte-', 'Sᵗᵉ-'), '-sous-', '-ss-') AS nom,
     cast(regexp_replace('0' || population, '[^0-9]', '', 'g') AS BIGINT)                        AS pop,
     tags -> 'is_capital'                                                                        AS is_capital,
     0                                                                                           AS nbtags
   FROM planet_osm_point
   WHERE place IS NOT NULL AND place IN ('city', 'town')
   ORDER BY coalesce(admin_level, capital, '9'), place, pop DESC) AS placenames;
SELECT *
FROM
  (SELECT
     way,
     place,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name)                 AS name,
     regexp_replace(regexp_replace(replace(replace(replace(replace(replace(coalesce(tags -> 'short_name:fr',
                                                                                    tags -> 'short_name',
                                                                                    tags -> 'name:fr',
                                                                                    tags -> 'int_name', name), 'Saint-',
                                                                           'Sᵗ-'), 'Sainte-', 'Sᵗᵉ-'), '-sous-',
                                                           '-ss-'), 'Lotissement ', 'Lot. '), 'Résidence ', 'Rés. '),
                                   '^Place ', 'Pl. '), '^Pointe ', 'Pᵗᵉ ') AS nom,
     cast(regexp_replace('0' || population, '[^0-9]', '', 'g') AS BIGINT)  AS pop
   FROM planet_osm_point
   WHERE place IS NOT NULL AND place IN
                               ('suburb', 'neighbourhood', 'quater', 'village', 'large_village', 'hamlet', 'locality', 'isolated_dwelling', 'farm')
   ORDER BY pop DESC) AS placenames;
SELECT *
FROM
  (SELECT
     way,
     coalesce(tags -> 'name:fr', tags -> 'int_name', tags -> 'int_name', name) AS name,
     railway,
     aerialway,
     disused,
     highway,
     amenity,
     coalesce(tags -> 'type:RATP', '')                                         AS type_ratp,
     operator,
     ''                                                                        AS l_operator,
     ''                                                                        AS l_type,
     ''                                                                        AS l_ref1,
     tags -> 'network'                                                         AS network,
     CASE WHEN railway = 'station'
       THEN 2
     WHEN railway = 'halt'
       THEN 1
     ELSE 0 END                                                                AS prio,
     coalesce(tags -> 'usage', '')                                             AS usage,
     coalesce(tags -> 'ele', tags -> 'ele:local')                              AS ele
   FROM planet_osm_polygon
   WHERE railway IN ('station', 'halt', 'tram_stop') OR aerialway = 'station'
   ORDER BY prio DESC) AS stations;
SELECT *
FROM
  (SELECT
     s.way                                                                             AS way,
     coalesce(s.tags -> 'name:fr', s.tags -> 'int_name', s.tags -> 'int_name', s.name) AS name,
     s.railway                                                                         AS railway,
     s.aerialway                                                                       AS aerialway,
     s.disused                                                                         AS disused,
     s.highway                                                                         AS highway,
     s.amenity                                                                         AS amenity,
     coalesce(s.tags -> 'type:RATP', '')                                               AS type_ratp,
     s.operator                                                                        AS operator,
     coalesce(l.operator, '')                                                          AS l_operator,
     l.route                                                                           AS l_type,
     substring(l.ref, 1, 1)                                                            AS l_ref1,
     coalesce(s.tags -> 'network', l.tags -> 'network')                                AS network,
     coalesce(s.tags -> 'type:RATP', CASE WHEN s.railway = 'station'
       THEN '5'
                                     WHEN s.railway = 'halt'
                                       THEN '4'
                                     WHEN s.railway = 'tram_stop'
                                       THEN '3'
                                     WHEN s.amenity = 'bus_station'
                                       THEN '2'
                                     WHEN s.amenity = 'bus_stop'
                                       THEN '1'
                                     ELSE '0' END)                                     AS prio,
     coalesce(s.tags -> 'usage', '')                                                   AS usage,
     coalesce(s.ele, s.tags -> 'ele:local')                                            AS ele
   FROM planet_osm_point s LEFT JOIN planet_osm_rels r
       ON (r.parts @> ARRAY [s.osm_id] AND r.members @> ARRAY ['n' || s.osm_id])
     LEFT JOIN planet_osm_line l ON (l.osm_id = -r.id AND l.route IS NOT NULL)
   WHERE s.way && !bbox ! AND (s.railway IN ('station', 'halt', 'tram_stop', 'subway_entrance')
                               OR s.aerialway = 'station'
                               OR s.highway = 'bus_stop'
                               OR s.amenity = 'bus_station')
   ORDER BY prio DESC, l_operator DESC
  ) AS stations;
SELECT *
FROM
  (SELECT
     *,
     regexp_replace(regexp_replace(coalesce(tags -> 'name:fr', tags -> 'int_name', name),
                                   '^([Aa]éroport|[Aa]érodrome) ([Ii]nternational )?(d''|de la |de |du |)', ''),
                    '^Base [Aa]érienne ', 'B.A. ') AS nom,
     tags -> 'mountain_pass'                       AS mountain_pass,
     coalesce(tags -> 'aerodrome', p.military)     AS aerodrome
   FROM planet_osm_point p
   WHERE aeroway IN ('airport', 'aerodrome', 'helipad', 'military') OR p.military = 'airfield' OR
         barrier IN ('bollard', 'gate', 'lift_gate', 'block', 'toll_booth') OR highway IN ('mini_roundabout', 'gate') OR
         man_made IN ('lighthouse', 'power_wind', 'windmill', 'mast') OR power IN ('sub_station', 'substation', 'plant')
         OR (power = 'generator' AND ("generator:source" = 'wind' OR power_source = 'wind')) OR
         "natural" IN ('peak', 'volcano', 'spring', 'tree', 'cave_entrance') OR
         railway IN ('level_crossing', 'buffer_stop')) AS amenity_symbols;
SELECT *
FROM
  (SELECT
     *,
     replace(regexp_replace(coalesce(tags -> 'name:fr', tags -> 'int_name', name),
                            '^([Aa]éroport|[Aa]érodrome) ([Ii]nternational )?(d''|de la |de |du |)', ''),
             'Base aérienne ', 'B.A. ')        AS nom,
     tags -> 'mountain_pass'                   AS mountain_pass,
     coalesce(tags -> 'aerodrome', p.military) AS aerodrome
   FROM planet_osm_polygon p
   WHERE aeroway IN ('airport', 'aerodrome', 'helipad', 'military') OR p.military = 'airfield' OR
         barrier IN ('bollard', 'gate', 'lift_gate', 'block', 'toll_booth')
         OR highway IN ('mini_roundabout', 'gate')
         OR man_made IN ('lighthouse', 'power_wind', 'windmill', 'mast')
         OR power IN ('sub_station', 'substation', 'plant') OR
         (power = 'generator' AND ("generator:source" = 'wind' OR power_source = 'wind'))
         OR "natural" IN ('peak', 'volcano', 'spring', 'tree', 'cave_entrance')
         OR railway IN ('level_crossing', 'buffer_stop')
  ) AS symbols;
SELECT *
FROM
  (SELECT
     way,
     amenity,
     shop,
     tourism,
     highway,
     man_made,
     access,
     religion,
     waterway,
     lock,
     historic,
     leisure,
     power,
     operator,
     tags -> 'indoor'                                                                                                 AS indoor,
     tags ->
     'network'                                                                                                        AS network,
     tags ->
     'ref:FR:LaPoste'                                                                                                 AS ref_laposte,
     coalesce(tags -> 'emergency', tags ->
                                   'medical')                                                                         AS emergency,
     tags ->
     'entrance'                                                                                                       AS entrance,
     coalesce(tags -> 'conveying', tags ->
                                   'conveyor_dir')                                                                    AS conveying,
     tags ->
     'incline'                                                                                                        AS incline,
     tags ->
     'fuel:lpg'                                                                                                       AS lpg,
     tags ->
     'heritage'                                                                                                       AS heritage,
     coalesce(tags -> 'post_office:type', tags -> 'recycling_type', tags -> 'shelter_type', tags -> 'information',
              '')                                                                                                     AS poi_type,
     substring('******', 1, cast(substr('0' || regexp_replace(tags -> 'stars', '[^0-9]', '', 'g'), 1, 1) AS
                                 INTEGER))                                                                            AS stars,
     tags ->
     'parking'                                                                                                        AS parking,
     way_area,
     name,
     ref,
     tags ->
     'organic'                                                                                                        AS organic,
     regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(replace(replace(replace(replace(replace(
                                                                                                                    replace(
                                                                                                                        replace(
                                                                                                                            replace(
                                                                                                                                replace(
                                                                                                                                    replace(
                                                                                                                                        replace(
                                                                                                                                            replace(
                                                                                                                                                replace(
                                                                                                                                                    replace(
                                                                                                                                                        replace(
                                                                                                                                                            replace(
                                                                                                                                                                replace(
                                                                                                                                                                    replace(
                                                                                                                                                                        replace(
                                                                                                                                                                            replace(
                                                                                                                                                                                replace(
                                                                                                                                                                                    replace(
                                                                                                                                                                                        replace(
                                                                                                                                                                                            replace(
                                                                                                                                                                                                replace(
                                                                                                                                                                                                    replace(
                                                                                                                                                                                                        replace(
                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                                                                            coalesce(
                                                                                                                                                                                                                                                                                                                tags
                                                                                                                                                                                                                                                                                                                ->
                                                                                                                                                                                                                                                                                                                'name:fr',
                                                                                                                                                                                                                                                                                                                tags
                                                                                                                                                                                                                                                                                                                ->
                                                                                                                                                                                                                                                                                                                'int_name',
                                                                                                                                                                                                                                                                                                                name,
                                                                                                                                                                                                                                                                                                                tags
                                                                                                                                                                                                                                                                                                                ->
                                                                                                                                                                                                                                                                                                                'brand'),
                                                                                                                                                                                                                                                                                                            'Avenue ',
                                                                                                                                                                                                                                                                                                            'Av. '),
                                                                                                                                                                                                                                                                                                        'Boulevard ',
                                                                                                                                                                                                                                                                                                        'Bd. '),
                                                                                                                                                                                                                                                                                                    'Faubourg ',
                                                                                                                                                                                                                                                                                                    'Fbg. '),
                                                                                                                                                                                                                                                                                                'Passage ',
                                                                                                                                                                                                                                                                                                'Pass. '),
                                                                                                                                                                                                                                                                                            'Place ',
                                                                                                                                                                                                                                                                                            'Pl. '),
                                                                                                                                                                                                                                                                                        'Promenade ',
                                                                                                                                                                                                                                                                                        'Prom. '),
                                                                                                                                                                                                                                                                                    'Impasse ',
                                                                                                                                                                                                                                                                                    'Imp. '),
                                                                                                                                                                                                                                                                                'Centre Commercial ',
                                                                                                                                                                                                                                                                                'CCial. '),
                                                                                                                                                                                                                                                                            'Immeuble ',
                                                                                                                                                                                                                                                                            'Imm. '),
                                                                                                                                                                                                                                                                        'Lotissement ',
                                                                                                                                                                                                                                                                        'Lot. '),
                                                                                                                                                                                                                                                                    'Résidence ',
                                                                                                                                                                                                                                                                    'Rés. '),
                                                                                                                                                                                                                                                                'Square ',
                                                                                                                                                                                                                                                                'Sq. '),
                                                                                                                                                                                                                                                            'Zone Industrielle ',
                                                                                                                                                                                                                                                            'ZI. '),
                                                                                                                                                                                                                                                        'Adjudant ',
                                                                                                                                                                                                                                                        'Adj. '),
                                                                                                                                                                                                                                                    'Agricole ',
                                                                                                                                                                                                                                                    'Agric. '),
                                                                                                                                                                                                                                                'Arrondissement',
                                                                                                                                                                                                                                                'Arrond.'),
                                                                                                                                                                                                                                            'Aspirant ',
                                                                                                                                                                                                                                            'Asp. '),
                                                                                                                                                                                                                                        'Bâtiment ',
                                                                                                                                                                                                                                        'Bat. '),
                                                                                                                                                                                                                                    'Colonel ',
                                                                                                                                                                                                                                    'Cᵒˡ '),
                                                                                                                                                                                                                                'Commandant ',
                                                                                                                                                                                                                                'Cᵈᵗ '),
                                                                                                                                                                                                                            'Commercial ',
                                                                                                                                                                                                                            'Cial. '),
                                                                                                                                                                                                                        'Coopérative ',
                                                                                                                                                                                                                        'Coop. '),
                                                                                                                                                                                                                    'Division ',
                                                                                                                                                                                                                    'Div. '),
                                                                                                                                                                                                                'Docteur ',
                                                                                                                                                                                                                'Dr. '),
                                                                                                                                                                                                            'Etablissement ',
                                                                                                                                                                                                            'Ets. '),
                                                                                                                                                                                                        'Général ',
                                                                                                                                                                                                        'Gᵃˡ '),
                                                                                                                                                                                                    'Institut ',
                                                                                                                                                                                                    'Inst. '),
                                                                                                                                                                                                'Laboratoire ',
                                                                                                                                                                                                'Labo. '),
                                                                                                                                                                                            'Lieutenant ',
                                                                                                                                                                                            'Lᵗ '),
                                                                                                                                                                                        'Maréchal ',
                                                                                                                                                                                        'Mᵃˡ '),
                                                                                                                                                                                    'Ministère ',
                                                                                                                                                                                    'Min. '),
                                                                                                                                                                                'Monseigneur ',
                                                                                                                                                                                'Mgr. '),
                                                                                                                                                                            'Bibliothèque ',
                                                                                                                                                                            'Bibl. '),
                                                                                                                                                                        'Tribunal ',
                                                                                                                                                                        'Trib. '),
                                                                                                                                                                    'Municipale ',
                                                                                                                                                                    'Mun. '),
                                                                                                                                                                'Municipal ',
                                                                                                                                                                'Mun. '),
                                                                                                                                                            'Observatoire ',
                                                                                                                                                            'Obs. '),
                                                                                                                                                        'Périphérique ',
                                                                                                                                                        'Périph. '),
                                                                                                                                                    'Préfecture ',
                                                                                                                                                    'Préf. '),
                                                                                                                                                'Président ',
                                                                                                                                                'Pdt. '),
                                                                                                                                            'Régiment ',
                                                                                                                                            'Rᵍᵗ '),
                                                                                                                                        'Régional ',
                                                                                                                                        'Rég. '),
                                                                                                                                    'Régionale ',
                                                                                                                                    'Rég. '),
                                                                                                                                'Saint-',
                                                                                                                                'Sᵗ-'),
                                                                                                                            'Sainte-',
                                                                                                                            'Sᵗᵉ-'),
                                                                                                                        'Sergent ',
                                                                                                                        'Sᵍᵗ '),
                                                                                                                    'Université ',
                                                                                                                    'Univ. '),
                                                                                                                'Universitaire ',
                                                                                                                'Univ. '),
                                                                                                        'Centre Hospitalier ',
                                                                                                        'C.H. '),
                                                                                                'Hôpital ', 'Hôp. '),
                                                                                        'Clinique ', 'Clin. '),
                                                                                'Communauté d.[Aa]gglomération',
                                                                                'Comm. d''agglo. '),
                                                                 'Communauté [Uu]rbaine ', 'Comm. urb. '),
                                                  'Communauté de [Cc]ommunes ', 'Comm. comm. '),
                                   'Syndicat d.[Aa]gglomération ', 'Synd. d''agglo. '), '^Chemin ',
                    'Ch. ')                                                                                           AS nom,
     CASE WHEN amenity = 'townhall'
       THEN 2
     WHEN amenity IN ('post_office', 'courthouse', 'police', 'public_building', 'hospital', 'clinic')
       THEN 1
     ELSE 0 END                                                                                                       AS prio
   FROM planet_osm_polygon
   WHERE amenity IS NOT NULL
         OR shop IS NOT NULL
         OR tourism IN
            ('alpine_hut', 'camp_site', 'caravan_site', 'guest_house', 'hostel', 'hotel', 'motel', 'museum', 'viewpoint', 'bed_and_breakfast', 'information', 'chalet', 'zoo')
         OR highway IN ('bus_stop', 'traffic_signals')
         OR man_made IN ('mast', 'water_tower')
         OR historic IN ('memorial', 'archaeological_site', 'castle')
         OR leisure IN ('playground', 'slipway', 'golf_course', 'picnic_table')
         OR power IN ('generator', 'sub_station', 'substation', 'plant') OR tags ? 'emergency' OR tags ? 'medical' OR
         tags ? 'entrance'
   ORDER BY prio DESC, way_area DESC) AS points;
SELECT *
FROM
  (SELECT
     way,
     amenity,
     shop,
     tourism,
     highway,
     man_made,
     access,
     religion,
     waterway,
     lock,
     historic,
     leisure,
     power,
     operator,
     tags -> 'indoor'                                                                                       AS indoor,
     tags -> 'network'                                                                                      AS network,
     tags ->
     'ref:FR:LaPoste'                                                                                       AS ref_laposte,
     coalesce(tags -> 'emergency', tags ->
                                   'medical')                                                               AS emergency,
     tags -> 'entrance'                                                                                     AS entrance,
     tags ->
     'conveying'                                                                                            AS conveying,
     tags -> 'incline'                                                                                      AS incline,
     tags -> 'fuel:lpg'                                                                                     AS lpg,
     tags -> 'heritage'                                                                                     AS heritage,
     coalesce(tags -> 'post_office:type', tags -> 'recycling_type', tags -> 'shelter_type', tags -> 'information',
              '')                                                                                           AS poi_type,
     substring('******', 1, cast('0' || regexp_replace(tags -> 'stars', '[^0-9]', '', 'g') AS INTEGER))     AS stars,
     tags -> 'parking'                                                                                      AS parking,
     0                                                                                                      AS way_area,
     name,
     ref,
     tags -> 'organic'                                                                                      AS organic,
     regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(replace(replace(replace(replace(replace(
                                                                                                                    replace(
                                                                                                                        replace(
                                                                                                                            replace(
                                                                                                                                replace(
                                                                                                                                    replace(
                                                                                                                                        replace(
                                                                                                                                            replace(
                                                                                                                                                replace(
                                                                                                                                                    replace(
                                                                                                                                                        replace(
                                                                                                                                                            replace(
                                                                                                                                                                replace(
                                                                                                                                                                    replace(
                                                                                                                                                                        replace(
                                                                                                                                                                            replace(
                                                                                                                                                                                replace(
                                                                                                                                                                                    replace(
                                                                                                                                                                                        replace(
                                                                                                                                                                                            replace(
                                                                                                                                                                                                replace(
                                                                                                                                                                                                    replace(
                                                                                                                                                                                                        replace(
                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                                                                            coalesce(
                                                                                                                                                                                                                                                                                                                tags
                                                                                                                                                                                                                                                                                                                ->
                                                                                                                                                                                                                                                                                                                'name:fr',
                                                                                                                                                                                                                                                                                                                tags
                                                                                                                                                                                                                                                                                                                ->
                                                                                                                                                                                                                                                                                                                'int_name',
                                                                                                                                                                                                                                                                                                                name,
                                                                                                                                                                                                                                                                                                                tags
                                                                                                                                                                                                                                                                                                                ->
                                                                                                                                                                                                                                                                                                                'brand'),
                                                                                                                                                                                                                                                                                                            'Avenue ',
                                                                                                                                                                                                                                                                                                            'Av. '),
                                                                                                                                                                                                                                                                                                        'Boulevard ',
                                                                                                                                                                                                                                                                                                        'Bd. '),
                                                                                                                                                                                                                                                                                                    'Faubourg ',
                                                                                                                                                                                                                                                                                                    'Fbg. '),
                                                                                                                                                                                                                                                                                                'Passage ',
                                                                                                                                                                                                                                                                                                'Pass. '),
                                                                                                                                                                                                                                                                                            'Place ',
                                                                                                                                                                                                                                                                                            'Pl. '),
                                                                                                                                                                                                                                                                                        'Promenade ',
                                                                                                                                                                                                                                                                                        'Prom. '),
                                                                                                                                                                                                                                                                                    'Impasse ',
                                                                                                                                                                                                                                                                                    'Imp. '),
                                                                                                                                                                                                                                                                                'Centre Commercial ',
                                                                                                                                                                                                                                                                                'CCial. '),
                                                                                                                                                                                                                                                                            'Immeuble ',
                                                                                                                                                                                                                                                                            'Imm. '),
                                                                                                                                                                                                                                                                        'Lotissement ',
                                                                                                                                                                                                                                                                        'Lot. '),
                                                                                                                                                                                                                                                                    'Résidence ',
                                                                                                                                                                                                                                                                    'Rés. '),
                                                                                                                                                                                                                                                                'Square ',
                                                                                                                                                                                                                                                                'Sq. '),
                                                                                                                                                                                                                                                            'Zone Industrielle ',
                                                                                                                                                                                                                                                            'ZI. '),
                                                                                                                                                                                                                                                        'Adjudant ',
                                                                                                                                                                                                                                                        'Adj. '),
                                                                                                                                                                                                                                                    'Agricole ',
                                                                                                                                                                                                                                                    'Agric. '),
                                                                                                                                                                                                                                                'Arrondissement',
                                                                                                                                                                                                                                                'Arrond.'),
                                                                                                                                                                                                                                            'Aspirant ',
                                                                                                                                                                                                                                            'Asp. '),
                                                                                                                                                                                                                                        'Bâtiment ',
                                                                                                                                                                                                                                        'Bat. '),
                                                                                                                                                                                                                                    'Colonel ',
                                                                                                                                                                                                                                    'Cᵒˡ '),
                                                                                                                                                                                                                                'Commandant ',
                                                                                                                                                                                                                                'Cᵈᵗ '),
                                                                                                                                                                                                                            'Commercial ',
                                                                                                                                                                                                                            'Cial. '),
                                                                                                                                                                                                                        'Coopérative ',
                                                                                                                                                                                                                        'Coop. '),
                                                                                                                                                                                                                    'Division ',
                                                                                                                                                                                                                    'Div. '),
                                                                                                                                                                                                                'Docteur ',
                                                                                                                                                                                                                'Dr. '),
                                                                                                                                                                                                            'Etablissement ',
                                                                                                                                                                                                            'Ets. '),
                                                                                                                                                                                                        'Général ',
                                                                                                                                                                                                        'Gᵃˡ '),
                                                                                                                                                                                                    'Institut ',
                                                                                                                                                                                                    'Inst. '),
                                                                                                                                                                                                'Laboratoire ',
                                                                                                                                                                                                'Labo. '),
                                                                                                                                                                                            'Lieutenant ',
                                                                                                                                                                                            'Lᵗ '),
                                                                                                                                                                                        'Maréchal ',
                                                                                                                                                                                        'Mᵃˡ '),
                                                                                                                                                                                    'Ministère ',
                                                                                                                                                                                    'Min. '),
                                                                                                                                                                                'Monseigneur ',
                                                                                                                                                                                'Mgr. '),
                                                                                                                                                                            'Bibliothèque ',
                                                                                                                                                                            'Bibl. '),
                                                                                                                                                                        'Tribunal ',
                                                                                                                                                                        'Trib. '),
                                                                                                                                                                    'Municipale ',
                                                                                                                                                                    'Mun. '),
                                                                                                                                                                'Municipal ',
                                                                                                                                                                'Mun. '),
                                                                                                                                                            'Observatoire ',
                                                                                                                                                            'Obs. '),
                                                                                                                                                        'Périphérique ',
                                                                                                                                                        'Périph. '),
                                                                                                                                                    'Préfecture ',
                                                                                                                                                    'Préf. '),
                                                                                                                                                'Président ',
                                                                                                                                                'Pdt. '),
                                                                                                                                            'Régiment ',
                                                                                                                                            'Rᵍᵗ '),
                                                                                                                                        'Régional ',
                                                                                                                                        'Rég. '),
                                                                                                                                    'Régionale ',
                                                                                                                                    'Rég. '),
                                                                                                                                'Saint-',
                                                                                                                                'Sᵗ-'),
                                                                                                                            'Sainte-',
                                                                                                                            'Sᵗᵉ-'),
                                                                                                                        'Sergent ',
                                                                                                                        'Sᵍᵗ '),
                                                                                                                    'Université ',
                                                                                                                    'Univ. '),
                                                                                                                'Universitaire ',
                                                                                                                'Univ. '),
                                                                                                        'Centre Hospitalier ',
                                                                                                        'C.H. '),
                                                                                                'Hôpital ', 'Hôp. '),
                                                                                        'Clinique ', 'Clin. '),
                                                                                'Communauté d.[Aa]gglomération',
                                                                                'Comm. d''agglo. '),
                                                                 'Communauté [Uu]rbaine ', 'Comm. urb. '),
                                                  'Communauté de [Cc]ommunes ', 'Comm. comm. '),
                                   'Syndicat d.[Aa]gglomération ', 'Synd. d''agglo. '), '^Chemin ', 'Ch. ') AS nom,
     CASE WHEN amenity = 'townhall'
       THEN 2
     WHEN amenity IN ('post_office', 'courthouse', 'police', 'public_building', 'hospital', 'clinic')
       THEN 1
     ELSE 0 END                                                                                             AS prio
   FROM planet_osm_point
   WHERE (amenity IS NOT NULL AND amenity != 'bus_station')
         OR shop IS NOT NULL
         OR tourism IN
            ('alpine_hut', 'camp_site', 'caravan_site', 'guest_house', 'hostel', 'hotel', 'motel', 'museum', 'viewpoint', 'bed_and_breakfast', 'information', 'chalet', 'zoo')
         OR highway IN ('traffic_signals', 'ford')
         OR man_made IN ('mast', 'water_tower')
         OR historic IN ('memorial', 'archaeological_site', 'castle')
         OR waterway = 'lock'
         OR lock = 'yes'
         OR leisure IN ('playground', 'slipway', 'golf_course', 'picnic_table') OR
         power IN ('generator', 'sub_station', 'substation', 'plant') OR tags ? 'emergency' OR tags ? 'medical' OR
         tags ? 'entrance'
   ORDER BY prio DESC, tags -> 'stars' DESC
  ) AS points;
SELECT *
FROM
  (SELECT
     way,
     coalesce(tags -> 'location', '') AS location,
     tags -> 'line'                   AS line
   FROM planet_osm_line
   WHERE "power" = 'line' AND coalesce(tags -> 'line', '') NOT IN ('busbar', 'bay')) AS power_line;
SELECT *
FROM
  (SELECT
     way,
     "power"            AS power_type,
     tags -> 'location' AS location,
     tags -> 'line'     AS line
   FROM planet_osm_line
   WHERE "power" IN ('line', 'minor_line')) AS power_minorline;
SELECT *
FROM
  (SELECT way
   FROM planet_osm_point
   WHERE power = 'tower') AS power_towers;
SELECT *
FROM
  (SELECT way
   FROM planet_osm_point
   WHERE power = 'pole') AS power_poles;
SELECT *
FROM
  (SELECT
     way,
     highway,
     ref,
     char_length(ref) AS length,
     st_length(way)   AS way_len,
     CASE WHEN highway = 'motorway'
       THEN 0
     WHEN highway = 'trunk'
       THEN 2
     WHEN highway = 'primary'
       THEN 3
     WHEN highway = 'secondary'
       THEN 4 END     AS prio
   FROM planet_osm_roads
   WHERE way && !bbox ! AND highway IN ('motorway', 'trunk', 'primary', 'secondary') AND osm_id > 0
         AND ref IS NOT NULL
         AND char_length(ref) BETWEEN 1 AND 8
         AND st_length(way) > 1000
   ORDER BY prio, way_len DESC) AS roads;
SELECT *
FROM
  (SELECT
     way,
     ref,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name)                 AS name,
     replace(replace(replace(coalesce(tags -> 'short_name:fr', tags -> 'short_name', tags -> 'name:fr', name), 'Saint-',
                             'Sᵗ-'), 'Sainte-', 'Sᵗᵉ-'), '-sous-', '-ss-') AS nom,
     coalesce(highway, aeroway)                                            AS type
   FROM planet_osm_point
   WHERE highway = 'motorway_junction'
  ) AS junctions;
SELECT *
FROM
  (SELECT
     st_intersection(ST_SetSRID(ST_MakeBox2D(ST_Point(ST_XMin(!bbox !) +! pixel_width !* ((SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'x_bleed') +
                                                                                          (SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'buffer') + 40),
                                                      ST_Ymin(!bbox !) +! pixel_height !* ((SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'y_bleed') +
                                                                                           (SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'buffer') +
                                                                                           20)),
                                             ST_Point(ST_XMax(!bbox !) -! pixel_width !* ((SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'x_bleed') +
                                                                                          (SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'buffer') + 40),
                                                      ST_Ymax(!bbox !) -! pixel_height !* ((SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'y_bleed') +
                                                                                           (SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'buffer') +
                                                                                           20))), 900913), way) AS way,
     junction,
     coalesce(highway,
              aeroway)                                                                                          AS highway,
     ref,
     char_length(
         ref)                                                                                                   AS length,
     CASE WHEN bridge IN ('yes', 'true', '1')
       THEN 'yes' :: TEXT
     ELSE 'no' :: TEXT END                                                                                      AS bridge
   FROM planet_osm_line
   WHERE way && !bbox ! AND (highway IS NOT NULL OR aeroway IS NOT NULL)
         AND ref IS NOT NULL
         AND (position('GR' IN ref) != 1 AND position('G.R' IN ref) != 1 AND position('G R ' IN ref) != 1)
         AND char_length(ref) BETWEEN 1 AND 8
         AND (tunnel IS NULL AND covered IS NULL OR
              coalesce(tunnel, covered, '') NOT IN ('yes', 'true', '1', 'building_passage'))
  ) AS roads;
SELECT *
FROM
  (SELECT
     st_intersection(ST_SetSRID(ST_MakeBox2D(ST_Point(ST_XMin(!bbox !) +! pixel_width !* ((SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'x_bleed') +
                                                                                          (SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'buffer') + 12),
                                                      ST_Ymin(!bbox !) +! pixel_height !* ((SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'y_bleed') +
                                                                                           (SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'buffer') +
                                                                                           10)),
                                             ST_Point(ST_XMax(!bbox !) -! pixel_width !* ((SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'x_bleed') +
                                                                                          (SELECT num
                                                                                           FROM params
                                                                                           WHERE key = 'buffer') + 12),
                                                      ST_Ymax(!bbox !) -! pixel_height !* ((SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'y_bleed') +
                                                                                           (SELECT num
                                                                                            FROM params
                                                                                            WHERE key = 'buffer') +
                                                                                           10))), 900913),
                     st_linemerge(st_collect(way))) AS way,
     highway,
     name,
     short_name,
     admin_level,
     boundary,
     insee,
     way_type,
     railway,
     tunnel,
     junction,
     nom,
     sum(way_len)                                   AS way_len
   FROM (SELECT
           way,
           highway,
           coalesce(tags -> 'name:fr', tags -> 'int_name', name)                                                  AS name,
           coalesce(tags -> 'short_name:fr', tags ->
                                             'short_name')                                                        AS short_name,
           st_length(
               way)                                                                                               AS way_len,
           admin_level,
           boundary,
           tags ->
           'ref:INSEE'                                                                                            AS insee,
           coalesce(highway, railway, aeroway, route, boundary,
                    '')                                                                                           AS way_type,
           railway,
           tunnel,
           junction,
           oneway,
           regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(replace(replace(replace(replace(
                                                                                                                  replace(
                                                                                                                      replace(
                                                                                                                          replace(
                                                                                                                              replace(
                                                                                                                                  replace(
                                                                                                                                      replace(
                                                                                                                                          replace(
                                                                                                                                              replace(
                                                                                                                                                  replace(
                                                                                                                                                      replace(
                                                                                                                                                          replace(
                                                                                                                                                              replace(
                                                                                                                                                                  replace(
                                                                                                                                                                      replace(
                                                                                                                                                                          replace(
                                                                                                                                                                              replace(
                                                                                                                                                                                  replace(
                                                                                                                                                                                      replace(
                                                                                                                                                                                          replace(
                                                                                                                                                                                              replace(
                                                                                                                                                                                                  replace(
                                                                                                                                                                                                      replace(
                                                                                                                                                                                                          replace(
                                                                                                                                                                                                              replace(
                                                                                                                                                                                                                  replace(
                                                                                                                                                                                                                      replace(
                                                                                                                                                                                                                          replace(
                                                                                                                                                                                                                              replace(
                                                                                                                                                                                                                                  replace(
                                                                                                                                                                                                                                      replace(
                                                                                                                                                                                                                                          replace(
                                                                                                                                                                                                                                              replace(
                                                                                                                                                                                                                                                  replace(
                                                                                                                                                                                                                                                      replace(
                                                                                                                                                                                                                                                          replace(
                                                                                                                                                                                                                                                              replace(
                                                                                                                                                                                                                                                                  replace(
                                                                                                                                                                                                                                                                      replace(
                                                                                                                                                                                                                                                                          replace(
                                                                                                                                                                                                                                                                              replace(
                                                                                                                                                                                                                                                                                  replace(
                                                                                                                                                                                                                                                                                      replace(
                                                                                                                                                                                                                                                                                          replace(
                                                                                                                                                                                                                                                                                              coalesce(
                                                                                                                                                                                                                                                                                                  tags
                                                                                                                                                                                                                                                                                                  ->
                                                                                                                                                                                                                                                                                                  'name:fr',
                                                                                                                                                                                                                                                                                                  tags
                                                                                                                                                                                                                                                                                                  ->
                                                                                                                                                                                                                                                                                                  'int_name',
                                                                                                                                                                                                                                                                                                  name),
                                                                                                                                                                                                                                                                                              'Avenue ',
                                                                                                                                                                                                                                                                                              'Av. '),
                                                                                                                                                                                                                                                                                          'Boulevard ',
                                                                                                                                                                                                                                                                                          'Bd. '),
                                                                                                                                                                                                                                                                                      'Faubourg ',
                                                                                                                                                                                                                                                                                      'Fbg. '),
                                                                                                                                                                                                                                                                                  'Passage ',
                                                                                                                                                                                                                                                                                  'Pass. '),
                                                                                                                                                                                                                                                                              'Place ',
                                                                                                                                                                                                                                                                              'Pl. '),
                                                                                                                                                                                                                                                                          'Promenade ',
                                                                                                                                                                                                                                                                          'Prom. '),
                                                                                                                                                                                                                                                                      'Impasse ',
                                                                                                                                                                                                                                                                      'Imp. '),
                                                                                                                                                                                                                                                                  'Centre Commercial ',
                                                                                                                                                                                                                                                                  'CCial. '),
                                                                                                                                                                                                                                                              'Immeuble ',
                                                                                                                                                                                                                                                              'Imm. '),
                                                                                                                                                                                                                                                          'Lotissement ',
                                                                                                                                                                                                                                                          'Lot. '),
                                                                                                                                                                                                                                                      'Résidence ',
                                                                                                                                                                                                                                                      'Rés. '),
                                                                                                                                                                                                                                                  'Square ',
                                                                                                                                                                                                                                                  'Sq. '),
                                                                                                                                                                                                                                              'Zone Industrielle ',
                                                                                                                                                                                                                                              'ZI. '),
                                                                                                                                                                                                                                          'Adjudant ',
                                                                                                                                                                                                                                          'Adj. '),
                                                                                                                                                                                                                                      'Agricole ',
                                                                                                                                                                                                                                      'Agric. '),
                                                                                                                                                                                                                                  'Arrondissement',
                                                                                                                                                                                                                                  'Arrond.'),
                                                                                                                                                                                                                              'Aspirant ',
                                                                                                                                                                                                                              'Asp. '),
                                                                                                                                                                                                                          'Bâtiment ',
                                                                                                                                                                                                                          'Bat. '),
                                                                                                                                                                                                                      'Colonel ',
                                                                                                                                                                                                                      'Cᵒˡ '),
                                                                                                                                                                                                                  'Commandant ',
                                                                                                                                                                                                                  'Cᵈᵗ '),
                                                                                                                                                                                                              'Commercial ',
                                                                                                                                                                                                              'Cial. '),
                                                                                                                                                                                                          'Coopérative ',
                                                                                                                                                                                                          'Coop. '),
                                                                                                                                                                                                      'Division ',
                                                                                                                                                                                                      'Div. '),
                                                                                                                                                                                                  'Docteur ',
                                                                                                                                                                                                  'Dr. '),
                                                                                                                                                                                              'Etablissement ',
                                                                                                                                                                                              'Ets. '),
                                                                                                                                                                                          'Général ',
                                                                                                                                                                                          'Gᵃˡ '),
                                                                                                                                                                                      'Institut ',
                                                                                                                                                                                      'Inst. '),
                                                                                                                                                                                  'Laboratoire ',
                                                                                                                                                                                  'Labo. '),
                                                                                                                                                                              'Lieutenant ',
                                                                                                                                                                              'Lᵗ '),
                                                                                                                                                                          'Maréchal ',
                                                                                                                                                                          'Mᵃˡ '),
                                                                                                                                                                      'Ministère ',
                                                                                                                                                                      'Min. '),
                                                                                                                                                                  'Monseigneur ',
                                                                                                                                                                  'Mgr. '),
                                                                                                                                                              'Bibliothèque ',
                                                                                                                                                              'Bibl. '),
                                                                                                                                                          'Tribunal ',
                                                                                                                                                          'Trib. '),
                                                                                                                                                      'Municipale ',
                                                                                                                                                      'Mun. '),
                                                                                                                                                  'Municipal ',
                                                                                                                                                  'Mun. '),
                                                                                                                                              'Observatoire ',
                                                                                                                                              'Obs. '),
                                                                                                                                          'Périphérique ',
                                                                                                                                          'Périph. '),
                                                                                                                                      'Préfecture ',
                                                                                                                                      'Préf. '),
                                                                                                                                  'Président ',
                                                                                                                                  'Pdt. '),
                                                                                                                              'Régiment ',
                                                                                                                              'Rᵍᵗ '),
                                                                                                                          'Régional ',
                                                                                                                          'Rég. '),
                                                                                                                      'Régionale ',
                                                                                                                      'Rég. '),
                                                                                                                  'Saint-',
                                                                                                                  'Sᵗ-'),
                                                                                                              'Sainte-',
                                                                                                              'Sᵗᵉ-'),
                                                                                                      'Sergent ',
                                                                                                      'Sᵍᵗ '),
                                                                                              'Université ', 'Univ. '),
                                                                                      'Communauté d.[Aa]gglomération',
                                                                                      'Comm. d''agglo. '),
                                                                       'Communauté [Uu]rbaine ', 'Comm. urb. '),
                                                        'Communauté de [Cc]ommunes ', 'Comm. comm. '),
                                         'Syndicat d.[Aa]gglomération ', 'Synd. d''agglo. '), '^Chemin ', 'Ch. ') AS nom
         FROM planet_osm_line
         WHERE way && !bbox ! AND route IS NULL AND waterway IS NULL AND leisure IS NULL AND landuse IS NULL AND
               name IS NOT NULL AND NOT tags ? 'land_area' AND
               (position('GR' IN name) != 1 AND position('G.R' IN name) != 1 AND position('G R ' IN name) != 1) AND
               (boundary IS NULL OR boundary IN ('administrative', 'maritime'))) AS ways
   GROUP BY highway, name, short_name, admin_level, boundary, insee, way_type, railway, tunnel, junction, nom, oneway
   ORDER BY way_len) AS roads;
SELECT *
FROM
  (SELECT
     way,
     osm_id,
     tags -> 'heritage'                                                                                 AS heritage,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name)                                              AS name,
     CASE WHEN amenity = 'townhall'
       THEN 2
     WHEN amenity IN ('post_office', 'courthouse', 'police', 'public_building')
       THEN 1
     ELSE 0 END                                                                                         AS prio,
     coalesce(tags -> 'post_office:type', tags -> 'recycling_type', tags -> 'shelter_type', tags -> 'information',
              '')                                                                                       AS poi_type,
     regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(
                                                                                                   regexp_replace(
                                                                                                       replace(replace(
                                                                                                                   replace(
                                                                                                                       replace(
                                                                                                                           replace(
                                                                                                                               replace(
                                                                                                                                   replace(
                                                                                                                                       replace(
                                                                                                                                           replace(
                                                                                                                                               replace(
                                                                                                                                                   replace(
                                                                                                                                                       replace(
                                                                                                                                                           replace(
                                                                                                                                                               replace(
                                                                                                                                                                   replace(
                                                                                                                                                                       replace(
                                                                                                                                                                           replace(
                                                                                                                                                                               replace(
                                                                                                                                                                                   replace(
                                                                                                                                                                                       replace(
                                                                                                                                                                                           replace(
                                                                                                                                                                                               replace(
                                                                                                                                                                                                   replace(
                                                                                                                                                                                                       replace(
                                                                                                                                                                                                           replace(
                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                                                           coalesce(
                                                                                                                                                                                                                                                                                                               tags
                                                                                                                                                                                                                                                                                                               ->
                                                                                                                                                                                                                                                                                                               'short_name:fr',
                                                                                                                                                                                                                                                                                                               tags
                                                                                                                                                                                                                                                                                                               ->
                                                                                                                                                                                                                                                                                                               'short_name',
                                                                                                                                                                                                                                                                                                               tags
                                                                                                                                                                                                                                                                                                               ->
                                                                                                                                                                                                                                                                                                               'alt_name',
                                                                                                                                                                                                                                                                                                               tags
                                                                                                                                                                                                                                                                                                               ->
                                                                                                                                                                                                                                                                                                               'name:fr',
                                                                                                                                                                                                                                                                                                               tags
                                                                                                                                                                                                                                                                                                               ->
                                                                                                                                                                                                                                                                                                               'int_name',
                                                                                                                                                                                                                                                                                                               name),
                                                                                                                                                                                                                                                                                                           'Avenue ',
                                                                                                                                                                                                                                                                                                           'Av. '),
                                                                                                                                                                                                                                                                                                       'Boulevard ',
                                                                                                                                                                                                                                                                                                       'Bd. '),
                                                                                                                                                                                                                                                                                                   'Faubourg ',
                                                                                                                                                                                                                                                                                                   'Fbg. '),
                                                                                                                                                                                                                                                                                               'Passage ',
                                                                                                                                                                                                                                                                                               'Pass. '),
                                                                                                                                                                                                                                                                                           'Place ',
                                                                                                                                                                                                                                                                                           'Pl. '),
                                                                                                                                                                                                                                                                                       'Promenade ',
                                                                                                                                                                                                                                                                                       'Prom. '),
                                                                                                                                                                                                                                                                                   'Impasse ',
                                                                                                                                                                                                                                                                                   'Imp. '),
                                                                                                                                                                                                                                                                               'Centre Commercial ',
                                                                                                                                                                                                                                                                               'CCial. '),
                                                                                                                                                                                                                                                                           'Immeuble ',
                                                                                                                                                                                                                                                                           'Imm. '),
                                                                                                                                                                                                                                                                       'Lotissement ',
                                                                                                                                                                                                                                                                       'Lot. '),
                                                                                                                                                                                                                                                                   'Résidence ',
                                                                                                                                                                                                                                                                   'Rés. '),
                                                                                                                                                                                                                                                               'Square ',
                                                                                                                                                                                                                                                               'Sq. '),
                                                                                                                                                                                                                                                           'Zone Industrielle ',
                                                                                                                                                                                                                                                           'ZI. '),
                                                                                                                                                                                                                                                       'Adjudant ',
                                                                                                                                                                                                                                                       'Adj. '),
                                                                                                                                                                                                                                                   'Agricole ',
                                                                                                                                                                                                                                                   'Agric. '),
                                                                                                                                                                                                                                               'Arrondissement',
                                                                                                                                                                                                                                               'Arrond.'),
                                                                                                                                                                                                                                           'Aspirant ',
                                                                                                                                                                                                                                           'Asp. '),
                                                                                                                                                                                                                                       'Bâtiment ',
                                                                                                                                                                                                                                       'Bat. '),
                                                                                                                                                                                                                                   'Colonel ',
                                                                                                                                                                                                                                   'Col. '),
                                                                                                                                                                                                                               'Commandant ',
                                                                                                                                                                                                                               'Cdt. '),
                                                                                                                                                                                                                           'Commercial ',
                                                                                                                                                                                                                           'Cial. '),
                                                                                                                                                                                                                       'Coopérative ',
                                                                                                                                                                                                                       'Coop. '),
                                                                                                                                                                                                                   'Division ',
                                                                                                                                                                                                                   'Div. '),
                                                                                                                                                                                                               'Docteur ',
                                                                                                                                                                                                               'Dr. '),
                                                                                                                                                                                                           'Etablissement ',
                                                                                                                                                                                                           'Ets. '),
                                                                                                                                                                                                       'Général ',
                                                                                                                                                                                                       'Gal. '),
                                                                                                                                                                                                   'Institut ',
                                                                                                                                                                                                   'Inst. '),
                                                                                                                                                                                               'Faculté ',
                                                                                                                                                                                               'Fac. '),
                                                                                                                                                                                           'Laboratoire ',
                                                                                                                                                                                           'Labo. '),
                                                                                                                                                                                       'Lieutenant ',
                                                                                                                                                                                       'Lt. '),
                                                                                                                                                                                   'Maréchal ',
                                                                                                                                                                                   'Mal. '),
                                                                                                                                                                               'Ministère ',
                                                                                                                                                                               'Min. '),
                                                                                                                                                                           'Monseigneur ',
                                                                                                                                                                           'Mgr. '),
                                                                                                                                                                       'Bibliothèque ',
                                                                                                                                                                       'Bibl. '),
                                                                                                                                                                   'Tribunal ',
                                                                                                                                                                   'Trib. '),
                                                                                                                                                               'Municipale ',
                                                                                                                                                               'Mun. '),
                                                                                                                                                           'Municipal ',
                                                                                                                                                           'Mun. '),
                                                                                                                                                       'Observatoire ',
                                                                                                                                                       'Obs. '),
                                                                                                                                                   'Périphérique ',
                                                                                                                                                   'Périph. '),
                                                                                                                                               'Préfecture ',
                                                                                                                                               'Préf. '),
                                                                                                                                           'Président ',
                                                                                                                                           'Pdt. '),
                                                                                                                                       'Régiment ',
                                                                                                                                       'Rgt. '),
                                                                                                                                   'Régional ',
                                                                                                                                   'Rég. '),
                                                                                                                               'Régionale ',
                                                                                                                               'Rég. '),
                                                                                                                           'Saint-',
                                                                                                                           'Sᵗ-'),
                                                                                                                       'Sainte-',
                                                                                                                       'Sᵗᵉ-'),
                                                                                                                   'Sergent ',
                                                                                                                   'Sgt. '),
                                                                                                               'Université ',
                                                                                                               'Univ. '),
                                                                                                       'Communauté d.[Aa]gglomération',
                                                                                                       'Comm. d''agglo. '),
                                                                                                   'Communauté [Uu]rbaine ',
                                                                                                   'Comm. urb. '),
                                                                                               'Communauté de [Cc]ommunes ',
                                                                                               'Comm. comm. '),
                                                                                'Syndicat d.[Aa]gglomération ',
                                                                                'Synd. d''agglo. '), '^Chemin ',
                                                                 'Ch. '), '^Institut ', 'Inst. '),
                                   'Zone d.[Aa]ctivité.? ', 'Z.A. '), 'Zone [Ii]ndustrielle ', 'Z.I. ') AS nom,
     aeroway,
     shop,
     access,
     amenity,
     leisure,
     landuse,
     man_made,
     "natural",
     place,
     tourism,
     substring('******', 1, cast('0' || regexp_replace(tags -> 'stars', '[^0-9]', '', 'g') AS INTEGER)) AS stars,
     cast('0' || substring(coalesce(tags -> 'ele', tags -> 'ele:local') FROM '\d+') AS INTEGER)         AS ele,
     tags ->
     'mountain_pass'                                                                                    AS mountain_pass,
     ref,
     military,
     waterway,
     historic,
     'no' :: TEXT                                                                                       AS point,
     way_area,
     NULL                                                                                               AS way_len,
     initcap(replace(replace(replace(replace(tags -> 'school:FR', 'maternelle', 'école mat.'), 'élémentaire', 'école'),
                             'primaire', 'école'), 'secondaire', 'collège-Lycée'))                      AS ecole,
     power
   FROM planet_osm_polygon
   WHERE amenity IS NOT NULL AND amenity NOT IN ('townhall')
         OR shop IS NOT NULL
         OR leisure IS NOT NULL
         OR landuse IS NOT NULL
         OR tourism IS NOT NULL
         OR ("natural" IS NOT NULL AND tags -> 'water' != 'river')
         OR man_made IN ('lighthouse', 'windmill')
         OR place = 'island'
         OR military = 'danger_area'
         OR historic IN ('memorial', 'archaeological_site', 'castle') OR aeroway = 'gate' OR
         power IN ('generator', 'substation', 'sub_station', 'plant')
   UNION
   SELECT
     way,
     osm_id,
     tags -> 'heritage'                                                                                 AS heritage,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name)                                              AS name,
     CASE WHEN amenity = 'townhall'
       THEN 2
     WHEN amenity IN ('post_office', 'courthouse', 'police', 'public_building')
       THEN 1
     ELSE 0 END                                                                                         AS prio,
     coalesce(tags -> 'post_office:type', tags -> 'recycling_type', tags -> 'shelter_type', tags -> 'information',
              '')                                                                                       AS poi_type,
     regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(
                                                                                                   regexp_replace(
                                                                                                       regexp_replace(
                                                                                                           regexp_replace(
                                                                                                               replace(
                                                                                                                   replace(
                                                                                                                       replace(
                                                                                                                           replace(
                                                                                                                               replace(
                                                                                                                                   replace(
                                                                                                                                       replace(
                                                                                                                                           replace(
                                                                                                                                               replace(
                                                                                                                                                   replace(
                                                                                                                                                       replace(
                                                                                                                                                           replace(
                                                                                                                                                               replace(
                                                                                                                                                                   replace(
                                                                                                                                                                       replace(
                                                                                                                                                                           replace(
                                                                                                                                                                               replace(
                                                                                                                                                                                   replace(
                                                                                                                                                                                       replace(
                                                                                                                                                                                           replace(
                                                                                                                                                                                               replace(
                                                                                                                                                                                                   replace(
                                                                                                                                                                                                       replace(
                                                                                                                                                                                                           replace(
                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                                                               coalesce(
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'short_name:fr',
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'short_name',
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'alt_name',
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'name:fr',
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'int_name',
                                                                                                                                                                                                                                                                                                                   name),
                                                                                                                                                                                                                                                                                                               'Avenue ',
                                                                                                                                                                                                                                                                                                               'Av. '),
                                                                                                                                                                                                                                                                                                           'Boulevard ',
                                                                                                                                                                                                                                                                                                           'Bd. '),
                                                                                                                                                                                                                                                                                                       'Faubourg ',
                                                                                                                                                                                                                                                                                                       'Fbg. '),
                                                                                                                                                                                                                                                                                                   'Passage ',
                                                                                                                                                                                                                                                                                                   'Pass. '),
                                                                                                                                                                                                                                                                                               'Place ',
                                                                                                                                                                                                                                                                                               'Pl. '),
                                                                                                                                                                                                                                                                                           'Promenade ',
                                                                                                                                                                                                                                                                                           'Prom. '),
                                                                                                                                                                                                                                                                                       'Impasse ',
                                                                                                                                                                                                                                                                                       'Imp. '),
                                                                                                                                                                                                                                                                                   'Centre Commercial ',
                                                                                                                                                                                                                                                                                   'CCial. '),
                                                                                                                                                                                                                                                                               'Immeuble ',
                                                                                                                                                                                                                                                                               'Imm. '),
                                                                                                                                                                                                                                                                           'Lotissement ',
                                                                                                                                                                                                                                                                           'Lot. '),
                                                                                                                                                                                                                                                                       'Résidence ',
                                                                                                                                                                                                                                                                       'Rés. '),
                                                                                                                                                                                                                                                                   'Square ',
                                                                                                                                                                                                                                                                   'Sq. '),
                                                                                                                                                                                                                                                               'Zone Industrielle ',
                                                                                                                                                                                                                                                               'ZI. '),
                                                                                                                                                                                                                                                           'Adjudant ',
                                                                                                                                                                                                                                                           'Adj. '),
                                                                                                                                                                                                                                                       'Agricole ',
                                                                                                                                                                                                                                                       'Agric. '),
                                                                                                                                                                                                                                                   'Arrondissement',
                                                                                                                                                                                                                                                   'Arrond.'),
                                                                                                                                                                                                                                               'Aspirant ',
                                                                                                                                                                                                                                               'Asp. '),
                                                                                                                                                                                                                                           'Bâtiment ',
                                                                                                                                                                                                                                           'Bat. '),
                                                                                                                                                                                                                                       'Colonel ',
                                                                                                                                                                                                                                       'Col. '),
                                                                                                                                                                                                                                   'Commandant ',
                                                                                                                                                                                                                                   'Cdt. '),
                                                                                                                                                                                                                               'Commercial ',
                                                                                                                                                                                                                               'Cial. '),
                                                                                                                                                                                                                           'Coopérative ',
                                                                                                                                                                                                                           'Coop. '),
                                                                                                                                                                                                                       'Division ',
                                                                                                                                                                                                                       'Div. '),
                                                                                                                                                                                                                   'Docteur ',
                                                                                                                                                                                                                   'Dr. '),
                                                                                                                                                                                                               'Etablissement ',
                                                                                                                                                                                                               'Ets. '),
                                                                                                                                                                                                           'Général ',
                                                                                                                                                                                                           'Gal. '),
                                                                                                                                                                                                       'Institut ',
                                                                                                                                                                                                       'Inst. '),
                                                                                                                                                                                                   'Faculté ',
                                                                                                                                                                                                   'Fac. '),
                                                                                                                                                                                               'Laboratoire ',
                                                                                                                                                                                               'Labo. '),
                                                                                                                                                                                           'Lieutenant ',
                                                                                                                                                                                           'Lt. '),
                                                                                                                                                                                       'Maréchal ',
                                                                                                                                                                                       'Mal. '),
                                                                                                                                                                                   'Ministère ',
                                                                                                                                                                                   'Min. '),
                                                                                                                                                                               'Monseigneur ',
                                                                                                                                                                               'Mgr. '),
                                                                                                                                                                           'Bibliothèque ',
                                                                                                                                                                           'Bibl. '),
                                                                                                                                                                       'Tribunal ',
                                                                                                                                                                       'Trib. '),
                                                                                                                                                                   'Municipale ',
                                                                                                                                                                   'Mun. '),
                                                                                                                                                               'Municipal ',
                                                                                                                                                               'Mun. '),
                                                                                                                                                           'Observatoire ',
                                                                                                                                                           'Obs. '),
                                                                                                                                                       'Périphérique ',
                                                                                                                                                       'Périph. '),
                                                                                                                                                   'Préfecture ',
                                                                                                                                                   'Préf. '),
                                                                                                                                               'Président ',
                                                                                                                                               'Pdt. '),
                                                                                                                                           'Régiment ',
                                                                                                                                           'Rgt. '),
                                                                                                                                       'Régional ',
                                                                                                                                       'Rég. '),
                                                                                                                                   'Régionale ',
                                                                                                                                   'Rég. '),
                                                                                                                               'Saint-',
                                                                                                                               'Sᵗ-'),
                                                                                                                           'Sainte-',
                                                                                                                           'Sᵗᵉ-'),
                                                                                                                       'Sergent ',
                                                                                                                       'Sgt. '),
                                                                                                                   'Université ',
                                                                                                                   'Univ. '),
                                                                                                               '^Mont ',
                                                                                                               'Mᵗ '),
                                                                                                           '^Montagne ',
                                                                                                           'Mont. '),
                                                                                                       'Communauté d.[Aa]gglomération',
                                                                                                       'Comm. d''agglo. '),
                                                                                                   'Communauté [Uu]rbaine ',
                                                                                                   'Comm. urb. '),
                                                                                               'Communauté de [Cc]ommunes ',
                                                                                               'Comm. comm. '),
                                                                                'Syndicat d.[Aa]gglomération ',
                                                                                'Synd. d''agglo. '), '^Chemin ',
                                                                 'Ch. '), '^Institut ', 'Inst. '),
                                   'Zone d.[Aa]ctivité.? ', 'Z.A. '), 'Zone [Ii]ndustrielle ', 'Z.I. ') AS nom,
     aeroway,
     shop,
     access,
     amenity,
     leisure,
     landuse,
     man_made,
     "natural",
     place,
     tourism,
     substring('******', 1, cast('0' || regexp_replace(tags -> 'stars', '[^0-9]', '', 'g') AS INTEGER)) AS stars,
     cast('0' || substring(coalesce(ele, tags -> 'ele:local') FROM '\d+') AS INTEGER)                   AS ele,
     tags ->
     'mountain_pass'                                                                                    AS mountain_pass,
     ref,
     military,
     waterway,
     historic,
     'yes' :: TEXT                                                                                      AS point,
     0                                                                                                  AS way_area,
     NULL                                                                                               AS way_len,
     initcap(replace(replace(replace(replace(tags -> 'school:FR', 'maternelle', 'école mat.'), 'élémentaire', 'école'),
                             'primaire', 'école'), 'secondaire', 'collège-Lycée'))                      AS ecole,
     power
   FROM planet_osm_point
   WHERE amenity IS NOT NULL AND amenity NOT IN ('townhall')
         OR shop IS NOT NULL
         OR leisure IS NOT NULL
         OR landuse IS NOT NULL
         OR tourism IS NOT NULL
         OR "natural" IS NOT NULL
         OR man_made IN ('lighthouse', 'windmill')
         OR place = 'island'
         OR military = 'danger_area'
         OR historic IN ('memorial', 'archaeological_site', 'castle') OR aeroway = 'gate' OR
         tags -> 'mountain_pass' = 'yes' OR power IN ('generator', 'substation', 'sub_station', 'plant')
   ORDER BY prio DESC, way_area DESC
  ) AS text;
SELECT *
FROM
  (/* admin_boundaries_text */ SELECT
                                 st_intersection(
                                     ST_SetSRID(ST_MakeBox2D(ST_Point(ST_XMin(!bbox !) +! pixel_width !* ((SELECT num
                                                                                                           FROM params
                                                                                                           WHERE key =
                                                                                                                 'buffer')
                                                                                                          + (SELECT num
                                                                                                             FROM params
                                                                                                             WHERE key =
                                                                                                                   'x_bleed')),
                                                                      ST_Ymin(!bbox !) +! pixel_height !* ((SELECT num
                                                                                                            FROM params
                                                                                                            WHERE key =
                                                                                                                  'y_bleed')
                                                                                                           + (SELECT num
                                                                                                              FROM
                                                                                                                params
                                                                                                              WHERE
                                                                                                                key =
                                                                                                                'buffer'))),
                                                             ST_Point(ST_XMax(!bbox !) -! pixel_width !* ((SELECT num
                                                                                                           FROM params
                                                                                                           WHERE key =
                                                                                                                 'x_bleed')
                                                                                                          + (SELECT num
                                                                                                             FROM params
                                                                                                             WHERE key =
                                                                                                                   'buffer')),
                                                                      ST_Ymax(!bbox !) -! pixel_height !* ((SELECT num
                                                                                                            FROM params
                                                                                                            WHERE key =
                                                                                                                  'y_bleed')
                                                                                                           + (SELECT num
                                                                                                              FROM
                                                                                                                params
                                                                                                              WHERE
                                                                                                                key =
                                                                                                                'buffer')))),
                                                900913),
                                     ST_Simplify(ST_Boundary((ST_Dumprings(ST_ForceRHR((ST_Dump(way)).geom))).geom),
                                                 !pixel_width !/ 2))                                    AS way,
                                 cast('0' || regexp_replace(admin_level, '[^0-9]', '', 'g') AS INTEGER) AS admin_level,
                                 coalesce(tags -> 'name:fr', tags -> 'int_name', name)                  AS name,
                                 tags -> 'ref:INSEE'                                                    AS insee,
                                 regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(replace(
                                                                                                                replace(
                                                                                                                    replace(
                                                                                                                        replace(
                                                                                                                            replace(
                                                                                                                                replace(
                                                                                                                                    replace(
                                                                                                                                        replace(
                                                                                                                                            replace(
                                                                                                                                                replace(
                                                                                                                                                    replace(
                                                                                                                                                        replace(
                                                                                                                                                            replace(
                                                                                                                                                                replace(
                                                                                                                                                                    replace(
                                                                                                                                                                        replace(
                                                                                                                                                                            replace(
                                                                                                                                                                                replace(
                                                                                                                                                                                    replace(
                                                                                                                                                                                        replace(
                                                                                                                                                                                            replace(
                                                                                                                                                                                                replace(
                                                                                                                                                                                                    replace(
                                                                                                                                                                                                        replace(
                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                                    replace(
                                                                                                                                                                                                                                                                                        replace(
                                                                                                                                                                                                                                                                                            replace(
                                                                                                                                                                                                                                                                                                replace(
                                                                                                                                                                                                                                                                                                    coalesce(
                                                                                                                                                                                                                                                                                                        tags
                                                                                                                                                                                                                                                                                                        ->
                                                                                                                                                                                                                                                                                                        'name:fr',
                                                                                                                                                                                                                                                                                                        tags
                                                                                                                                                                                                                                                                                                        ->
                                                                                                                                                                                                                                                                                                        'int_name',
                                                                                                                                                                                                                                                                                                        name),
                                                                                                                                                                                                                                                                                                    'Avenue ',
                                                                                                                                                                                                                                                                                                    'Av. '),
                                                                                                                                                                                                                                                                                                'Boulevard ',
                                                                                                                                                                                                                                                                                                'Bd. '),
                                                                                                                                                                                                                                                                                            'Faubourg ',
                                                                                                                                                                                                                                                                                            'Fbg. '),
                                                                                                                                                                                                                                                                                        'Passage ',
                                                                                                                                                                                                                                                                                        'Pass. '),
                                                                                                                                                                                                                                                                                    'Place ',
                                                                                                                                                                                                                                                                                    'Pl. '),
                                                                                                                                                                                                                                                                                'Promenade ',
                                                                                                                                                                                                                                                                                'Prom. '),
                                                                                                                                                                                                                                                                            'Impasse ',
                                                                                                                                                                                                                                                                            'Imp. '),
                                                                                                                                                                                                                                                                        'Centre Commercial ',
                                                                                                                                                                                                                                                                        'CCial. '),
                                                                                                                                                                                                                                                                    'Immeuble ',
                                                                                                                                                                                                                                                                    'Imm. '),
                                                                                                                                                                                                                                                                'Lotissement ',
                                                                                                                                                                                                                                                                'Lot. '),
                                                                                                                                                                                                                                                            'Résidence ',
                                                                                                                                                                                                                                                            'Rés. '),
                                                                                                                                                                                                                                                        'Square ',
                                                                                                                                                                                                                                                        'Sq. '),
                                                                                                                                                                                                                                                    'Zone Industrielle ',
                                                                                                                                                                                                                                                    'ZI. '),
                                                                                                                                                                                                                                                'Adjudant ',
                                                                                                                                                                                                                                                'Adj. '),
                                                                                                                                                                                                                                            'Agricole ',
                                                                                                                                                                                                                                            'Agric. '),
                                                                                                                                                                                                                                        'Arrondissement',
                                                                                                                                                                                                                                        'Arrond.'),
                                                                                                                                                                                                                                    'Aspirant ',
                                                                                                                                                                                                                                    'Asp. '),
                                                                                                                                                                                                                                'Bâtiment ',
                                                                                                                                                                                                                                'Bat. '),
                                                                                                                                                                                                                            'Colonel ',
                                                                                                                                                                                                                            'Col. '),
                                                                                                                                                                                                                        'Commandant ',
                                                                                                                                                                                                                        'Cdt. '),
                                                                                                                                                                                                                    'Commercial ',
                                                                                                                                                                                                                    'Cial. '),
                                                                                                                                                                                                                'Coopérative ',
                                                                                                                                                                                                                'Coop. '),
                                                                                                                                                                                                            'Division ',
                                                                                                                                                                                                            'Div. '),
                                                                                                                                                                                                        'Docteur ',
                                                                                                                                                                                                        'Dr. '),
                                                                                                                                                                                                    'Etablissement ',
                                                                                                                                                                                                    'Ets. '),
                                                                                                                                                                                                'Général ',
                                                                                                                                                                                                'Gal. '),
                                                                                                                                                                                            'Institut ',
                                                                                                                                                                                            'Inst. '),
                                                                                                                                                                                        'Laboratoire ',
                                                                                                                                                                                        'Labo. '),
                                                                                                                                                                                    'Lieutenant ',
                                                                                                                                                                                    'Lt. '),
                                                                                                                                                                                'Maréchal ',
                                                                                                                                                                                'Mal. '),
                                                                                                                                                                            'Ministère ',
                                                                                                                                                                            'Min. '),
                                                                                                                                                                        'Monseigneur ',
                                                                                                                                                                        'Mgr. '),
                                                                                                                                                                    'Bibliothèque ',
                                                                                                                                                                    'Bibl. '),
                                                                                                                                                                'Tribunal ',
                                                                                                                                                                'Trib. '),
                                                                                                                                                            'Municipale ',
                                                                                                                                                            'Mun. '),
                                                                                                                                                        'Municipal ',
                                                                                                                                                        'Mun. '),
                                                                                                                                                    'Observatoire ',
                                                                                                                                                    'Obs. '),
                                                                                                                                                'Préfecture ',
                                                                                                                                                'Préf. '),
                                                                                                                                            'Président ',
                                                                                                                                            'Pdt. '),
                                                                                                                                        'Régiment ',
                                                                                                                                        'Rgt. '),
                                                                                                                                    'Régional ',
                                                                                                                                    'Rég. '),
                                                                                                                                'Régionale ',
                                                                                                                                'Rég. '),
                                                                                                                            'Saint-',
                                                                                                                            'Sᵗ-'),
                                                                                                                        'Sainte-',
                                                                                                                        'Sᵗᵉ-'),
                                                                                                                    'Sergent ',
                                                                                                                    'Sgt. '),
                                                                                                                'Université ',
                                                                                                                'Univ. '),
                                                                                                            'Communauté d.[Aa]gglomération',
                                                                                                            'Comm. d''agglo. '),
                                                                                             'Communauté [Uu]rbaine ',
                                                                                             'Comm. urb. '),
                                                                              'Communauté de [Cc]ommunes ',
                                                                              'Comm. comm. '), '^Chemin ', 'Ch. '),
                                                'Syndicat d.[Aa]gglomération ', 'Synd. d''agglo. ')     AS nom
                               FROM planet_osm_polygon p
                               WHERE ST_Intersects(p.way, !bbox !) AND NOT ST_Covers(p.way, !bbox !) AND
                                     boundary = 'administrative'
                               ORDER BY 2 DESC) AS admin_boundaries_text;
SELECT *
FROM
  (SELECT
     p.osm_id,
     p.leisure,
     p.boundary,
     p.way_area,
     coalesce(p.landuse, p.natural)                                                                     AS landuse,
     coalesce(p.amenity, p.shop)                                                                        AS amenity_shop,
     p.tags -> 'heritage'                                                                               AS heritage,
     p.building,
     ST_Centroid(p.way)                                                                                 AS way,
     coalesce(p.tags -> 'name:fr', p.name)                                                              AS name,
     regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(
                                                                                                   regexp_replace(
                                                                                                       replace(replace(
                                                                                                                   replace(
                                                                                                                       replace(
                                                                                                                           replace(
                                                                                                                               replace(
                                                                                                                                   replace(
                                                                                                                                       replace(
                                                                                                                                           replace(
                                                                                                                                               replace(
                                                                                                                                                   replace(
                                                                                                                                                       replace(
                                                                                                                                                           replace(
                                                                                                                                                               replace(
                                                                                                                                                                   replace(
                                                                                                                                                                       replace(
                                                                                                                                                                           replace(
                                                                                                                                                                               replace(
                                                                                                                                                                                   replace(
                                                                                                                                                                                       replace(
                                                                                                                                                                                           replace(
                                                                                                                                                                                               replace(
                                                                                                                                                                                                   replace(
                                                                                                                                                                                                       replace(
                                                                                                                                                                                                           replace(
                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                                                       coalesce(
                                                                                                                                                                                                                                                                                                           p.tags
                                                                                                                                                                                                                                                                                                           ->
                                                                                                                                                                                                                                                                                                           'short_name:fr',
                                                                                                                                                                                                                                                                                                           p.tags
                                                                                                                                                                                                                                                                                                           ->
                                                                                                                                                                                                                                                                                                           'short_name',
                                                                                                                                                                                                                                                                                                           p.tags
                                                                                                                                                                                                                                                                                                           ->
                                                                                                                                                                                                                                                                                                           'alt_name',
                                                                                                                                                                                                                                                                                                           p.tags
                                                                                                                                                                                                                                                                                                           ->
                                                                                                                                                                                                                                                                                                           'name:fr',
                                                                                                                                                                                                                                                                                                           p.name),
                                                                                                                                                                                                                                                                                                       'Avenue ',
                                                                                                                                                                                                                                                                                                       'Av. '),
                                                                                                                                                                                                                                                                                                   'Boulevard ',
                                                                                                                                                                                                                                                                                                   'Bd. '),
                                                                                                                                                                                                                                                                                               'Faubourg ',
                                                                                                                                                                                                                                                                                               'Fbg. '),
                                                                                                                                                                                                                                                                                           'Passage ',
                                                                                                                                                                                                                                                                                           'Pass. '),
                                                                                                                                                                                                                                                                                       'Place ',
                                                                                                                                                                                                                                                                                       'Pl. '),
                                                                                                                                                                                                                                                                                   'Promenade ',
                                                                                                                                                                                                                                                                                   'Prom. '),
                                                                                                                                                                                                                                                                               'Impasse ',
                                                                                                                                                                                                                                                                               'Imp. '),
                                                                                                                                                                                                                                                                           'Centre Commercial ',
                                                                                                                                                                                                                                                                           'CCial. '),
                                                                                                                                                                                                                                                                       'Immeuble ',
                                                                                                                                                                                                                                                                       'Imm. '),
                                                                                                                                                                                                                                                                   'Lotissement ',
                                                                                                                                                                                                                                                                   'Lot. '),
                                                                                                                                                                                                                                                               'Résidence ',
                                                                                                                                                                                                                                                               'Rés. '),
                                                                                                                                                                                                                                                           'Square ',
                                                                                                                                                                                                                                                           'Sq. '),
                                                                                                                                                                                                                                                       'Zone Industrielle ',
                                                                                                                                                                                                                                                       'ZI. '),
                                                                                                                                                                                                                                                   'Adjudant ',
                                                                                                                                                                                                                                                   'Adj. '),
                                                                                                                                                                                                                                               'Agricole ',
                                                                                                                                                                                                                                               'Agric. '),
                                                                                                                                                                                                                                           'Arrondissement',
                                                                                                                                                                                                                                           'Arrond.'),
                                                                                                                                                                                                                                       'Aspirant ',
                                                                                                                                                                                                                                       'Asp. '),
                                                                                                                                                                                                                                   'Bâtiment ',
                                                                                                                                                                                                                                   'Bat. '),
                                                                                                                                                                                                                               'Colonel ',
                                                                                                                                                                                                                               'Col. '),
                                                                                                                                                                                                                           'Commandant ',
                                                                                                                                                                                                                           'Cdt. '),
                                                                                                                                                                                                                       'Commercial ',
                                                                                                                                                                                                                       'Cial. '),
                                                                                                                                                                                                                   'Coopérative ',
                                                                                                                                                                                                                   'Coop. '),
                                                                                                                                                                                                               'Division ',
                                                                                                                                                                                                               'Div. '),
                                                                                                                                                                                                           'Docteur ',
                                                                                                                                                                                                           'Dr. '),
                                                                                                                                                                                                       'Etablissement ',
                                                                                                                                                                                                       'Ets. '),
                                                                                                                                                                                                   'Général ',
                                                                                                                                                                                                   'Gal. '),
                                                                                                                                                                                               'Institut ',
                                                                                                                                                                                               'Inst. '),
                                                                                                                                                                                           'Laboratoire ',
                                                                                                                                                                                           'Labo. '),
                                                                                                                                                                                       'Lieutenant ',
                                                                                                                                                                                       'Lt. '),
                                                                                                                                                                                   'Maréchal ',
                                                                                                                                                                                   'Mal. '),
                                                                                                                                                                               'Ministère ',
                                                                                                                                                                               'Min. '),
                                                                                                                                                                           'Monseigneur ',
                                                                                                                                                                           'Mgr. '),
                                                                                                                                                                       'Bibliothèque ',
                                                                                                                                                                       'Bibl. '),
                                                                                                                                                                   'Tribunal ',
                                                                                                                                                                   'Trib. '),
                                                                                                                                                               'Municipale ',
                                                                                                                                                               'Mun. '),
                                                                                                                                                           'Municipal ',
                                                                                                                                                           'Mun. '),
                                                                                                                                                       'Observatoire ',
                                                                                                                                                       'Obs. '),
                                                                                                                                                   'Périphérique ',
                                                                                                                                                   'Périph. '),
                                                                                                                                               'Préfecture ',
                                                                                                                                               'Préf. '),
                                                                                                                                           'Président ',
                                                                                                                                           'Pdt. '),
                                                                                                                                       'Régiment ',
                                                                                                                                       'Rgt. '),
                                                                                                                                   'Régional ',
                                                                                                                                   'Rég. '),
                                                                                                                               'Régionale ',
                                                                                                                               'Rég. '),
                                                                                                                           'Saint-',
                                                                                                                           'Sᵗ-'),
                                                                                                                       'Sainte-',
                                                                                                                       'Sᵗᵉ-'),
                                                                                                                   'Sergent ',
                                                                                                                   'Sgt. '),
                                                                                                               'Université ',
                                                                                                               'Univ. '),
                                                                                                       'Communauté d.[Aa]gglomération',
                                                                                                       'Comm. d''agglo. '),
                                                                                                   'Communauté [Uu]rbaine ',
                                                                                                   'Comm. urb. '),
                                                                                               'Communauté de [Cc]ommunes ',
                                                                                               'Comm. comm. '),
                                                                                'Syndicat d.[Aa]gglomération ',
                                                                                'Synd. d''agglo. '), '^Chemin ',
                                                                 'Ch. '), '^Institut ', 'Inst. '),
                                   'Zone d.[Aa]ctivité.? ', 'Z.A. '), 'Zone [Ii]ndustrielle ', 'Z.I. ') AS nom
   FROM planet_osm_polygon p LEFT JOIN planet_osm_rels r ON (r.id = -p.osm_id AND r.members @> ARRAY ['admin_centre'])
   WHERE p.way && !bbox ! AND r.id IS NULL AND coalesce(p.tags -> 'name:fr', p.name) IS NOT NULL AND
         coalesce(p.waterway, p.water, p.aeroway, p.boundary, p.landuse, p."natural", p.building, p.leisure, p.aeroway,
                  '') NOT IN ('', 'river', 'riverbank', 'aerodrome') AND coalesce(p.tourism, p.power, p.place) IS NULL
         AND coalesce(p.boundary, p.amenity, '') IN
             ('', 'administrative', 'protected_area', 'national_park', 'maritime', 'school', 'kindergarten', 'townhall', 'public_building', 'hospital', 'clinic', 'courthouse')
   ORDER BY p.way_area DESC) AS text;
SELECT *
FROM
  (SELECT
     way,
     place,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name)                 AS name,
     replace(replace(replace(coalesce(tags -> 'short_name:fr', tags -> 'name:fr', tags -> 'int_name', name), 'Saint-',
                             'Sᵗ-'), 'Sainte-', 'Sᵗᵉ-'), '-sous-', '-ss-') AS nom,
     cast(regexp_replace('0' || population, '[^0-9]', '', 'g') AS BIGINT)  AS pop,
     coalesce(tags -> 'is_capital', (CASE WHEN coalesce(admin_level, capital) = '2'
       THEN 'country'
                                     WHEN tags -> 'importance' = 'international'
                                       THEN 'state'
                                     WHEN coalesce(admin_level, capital) = '4'
                                       THEN 'state'
                                     WHEN tags -> 'importance' = 'national'
                                       THEN 'state'
                                     ELSE NULL END))                       AS is_capital,
     array_length(hstore_to_array(tags), 1) / 2                            AS nbtags
   FROM planet_osm_point
   WHERE place IS NOT NULL AND place IN ('city', 'town') AND (
     tags -> 'is_capital' IN ('country', 'state') OR capital IN ('2', '4') OR
     (capital = 'yes' AND admin_level IN ('2', '4')) OR tags -> 'importance' IN ('international', 'national') OR
     array_length(hstore_to_array(tags), 1) / 2 > 20)
   ORDER BY is_capital, coalesce(admin_level, capital, '9'), place, pop DESC) AS placenames;
SELECT *
FROM
  (SELECT
     way,
     place,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name)                 AS name,
     regexp_replace(regexp_replace(replace(replace(replace(replace(replace(coalesce(tags -> 'short_name:fr',
                                                                                    tags -> 'short_name',
                                                                                    tags -> 'name:fr',
                                                                                    tags -> 'int_name', name), 'Saint-',
                                                                           'Sᵗ-'), 'Sainte-', 'Sᵗᵉ-'), '-sous-',
                                                           '-ss-'), 'Lotissement ', 'Lot. '), 'Résidence ', 'Rés. '),
                                   '^Place ', 'Pl. '), '^Pointe ', 'Pᵗᵉ ') AS nom,
     cast(regexp_replace('0' || population, '[^0-9]', '', 'g') AS BIGINT)  AS pop
   FROM planet_osm_point
   WHERE place IS NOT NULL AND place IN
                               ('suburb', 'neighbourhood', 'quater', 'village', 'large_village', 'hamlet', 'locality', 'isolated_dwelling', 'farm')
   ORDER BY pop DESC, osm_id) AS placenames;
SELECT *
FROM
  (SELECT way
   FROM planet_osm_line
   WHERE "addr:interpolation" IS NOT NULL) AS interpolation;
SELECT *
FROM
  (SELECT
     way,
     "addr:housenumber",
     NULL AS entrance
   FROM planet_osm_polygon
   WHERE "addr:housenumber" IS NOT NULL AND building IS NOT NULL
   UNION
   SELECT
     way,
     "addr:housenumber",
     tags -> 'entrance' AS entrance
   FROM planet_osm_point
   WHERE "addr:housenumber" IS NOT NULL
  ) AS housenumbers;
SELECT *
FROM
  (SELECT
     geo,
     num
   FROM bano) AS bano;
SELECT *
FROM
  (SELECT
     way,
     "addr:housename"
   FROM planet_osm_polygon
   WHERE "addr:housename" IS NOT NULL AND building IS NOT NULL
   UNION
   SELECT
     way,
     "addr:housename"
   FROM planet_osm_point
   WHERE "addr:housename" IS NOT NULL
  ) AS housenames;
SELECT *
FROM
  (SELECT
     way,
     way_area,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name) AS name,
     boundary
   FROM planet_osm_polygon
   WHERE boundary = 'national_park' AND building IS NULL) AS boundary;
SELECT *
FROM
  (SELECT
     way,
     coalesce(tags -> 'name:fr', tags -> 'int_name', name) AS name,
     tourism
   FROM planet_osm_polygon
   WHERE tourism = 'theme_park') AS theme_park;
SELECT *
FROM
  (SELECT
     way,
     0                                                                                                     AS way_area,
     cast('0' || regexp_replace(coalesce(tags -> 'capacity:disabled', '0'), '[^0-9]', '', 'g') AS INTEGER) AS capacity
   FROM planet_osm_point
   WHERE amenity = 'parking_space' AND (tags -> 'wheelchair' = 'yes' OR
                                        (tags ? 'capacity:disabled' AND tags -> 'capacity:disabled' NOT IN ('0', 'no')))
   UNION SELECT
           way,
           way_area,
           cast('0' || regexp_replace(coalesce(tags -> 'capacity:disabled', '0'), '[^0-9]', '', 'g') AS
                INTEGER) AS capacity
         FROM planet_osm_polygon
         WHERE amenity = 'parking_space' AND (tags -> 'wheelchair' = 'yes' OR (tags ? 'capacity:disabled' AND
                                                                               tags -> 'capacity:disabled' NOT IN
                                                                               ('0', 'no')))) AS park;
SELECT *
FROM
  (SELECT
     way,
     highway,
     coalesce(tags -> 'conveying', tags -> 'conveyor_dir') AS conveying,
     tags -> 'incline'                                     AS incline,
     tags -> 'wheelchair'                                  AS wheelchair,
     tags -> 'ramp:wheelchair'                             AS ramp_wheelchair
   FROM planet_osm_point
   WHERE (highway IN ('steps', 'footway', 'elevator', 'conveyor') OR tags ? 'ramp:wheelchair') AND way && !bbox !
   UNION SELECT
           ST_LineInterpolatePoint(way, 0.5)                     AS way,
           highway,
           coalesce(tags -> 'conveying', tags -> 'conveyor_dir') AS conveying,
           tags -> 'incline'                                     AS incline,
           tags -> 'wheelchair'                                  AS wheelchair,
           tags -> 'ramp:wheelchair'                             AS ramp_wheelchair
         FROM planet_osm_line
         WHERE (highway IN ('steps', 'footway', 'elevator', 'conveyor') OR tags ? 'ramp:wheelchair') AND way && !bbox !
   UNION SELECT
           way,
           highway,
           coalesce(tags -> 'conveying', tags -> 'conveyor_dir') AS conveying,
           tags -> 'incline'                                     AS incline,
           tags -> 'wheelchair'                                  AS wheelchair,
           tags -> 'ramp:wheelchair'                             AS ramp_wheelchair
         FROM planet_osm_polygon
         WHERE (highway IN ('steps', 'footway', 'elevator', 'conveyor') OR tags ? 'ramp:wheelchair') AND
               way && !bbox !) AS pmr;
SELECT *
FROM
  (SELECT
     way,
     name,
     regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(
                                                                                                   regexp_replace(
                                                                                                       replace(replace(
                                                                                                                   replace(
                                                                                                                       replace(
                                                                                                                           replace(
                                                                                                                               replace(
                                                                                                                                   replace(
                                                                                                                                       replace(
                                                                                                                                           replace(
                                                                                                                                               replace(
                                                                                                                                                   replace(
                                                                                                                                                       replace(
                                                                                                                                                           replace(
                                                                                                                                                               replace(
                                                                                                                                                                   replace(
                                                                                                                                                                       replace(
                                                                                                                                                                           replace(
                                                                                                                                                                               replace(
                                                                                                                                                                                   replace(
                                                                                                                                                                                       replace(
                                                                                                                                                                                           replace(
                                                                                                                                                                                               replace(
                                                                                                                                                                                                   replace(
                                                                                                                                                                                                       replace(
                                                                                                                                                                                                           replace(
                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                                               replace(
                                                                                                                                                                                                                                                                                                   replace(
                                                                                                                                                                                                                                                                                                       replace(
                                                                                                                                                                                                                                                                                                           replace(
                                                                                                                                                                                                                                                                                                               coalesce(
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'short_name:fr',
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'short_name',
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'alt_name',
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'name:fr',
                                                                                                                                                                                                                                                                                                                   tags
                                                                                                                                                                                                                                                                                                                   ->
                                                                                                                                                                                                                                                                                                                   'int_name',
                                                                                                                                                                                                                                                                                                                   name),
                                                                                                                                                                                                                                                                                                               'Avenue ',
                                                                                                                                                                                                                                                                                                               'Av. '),
                                                                                                                                                                                                                                                                                                           'Boulevard ',
                                                                                                                                                                                                                                                                                                           'Bd. '),
                                                                                                                                                                                                                                                                                                       'Carrefour ',
                                                                                                                                                                                                                                                                                                       'Carref. '),
                                                                                                                                                                                                                                                                                                   'Faubourg ',
                                                                                                                                                                                                                                                                                                   'Fbg. '),
                                                                                                                                                                                                                                                                                               'Passage ',
                                                                                                                                                                                                                                                                                               'Pass. '),
                                                                                                                                                                                                                                                                                           'Place ',
                                                                                                                                                                                                                                                                                           'Pl. '),
                                                                                                                                                                                                                                                                                       'Promenade ',
                                                                                                                                                                                                                                                                                       'Prom. '),
                                                                                                                                                                                                                                                                                   'Impasse ',
                                                                                                                                                                                                                                                                                   'Imp. '),
                                                                                                                                                                                                                                                                               'Centre Commercial ',
                                                                                                                                                                                                                                                                               'CCial. '),
                                                                                                                                                                                                                                                                           'Immeuble ',
                                                                                                                                                                                                                                                                           'Imm. '),
                                                                                                                                                                                                                                                                       'Lotissement ',
                                                                                                                                                                                                                                                                       'Lot. '),
                                                                                                                                                                                                                                                                   'Résidence ',
                                                                                                                                                                                                                                                                   'Rés. '),
                                                                                                                                                                                                                                                               'Square ',
                                                                                                                                                                                                                                                               'Sq. '),
                                                                                                                                                                                                                                                           'Zone Industrielle ',
                                                                                                                                                                                                                                                           'ZI. '),
                                                                                                                                                                                                                                                       'Adjudant ',
                                                                                                                                                                                                                                                       'Adj. '),
                                                                                                                                                                                                                                                   'Agricole ',
                                                                                                                                                                                                                                                   'Agric. '),
                                                                                                                                                                                                                                               'Arrondissement',
                                                                                                                                                                                                                                               'Arrond.'),
                                                                                                                                                                                                                                           'Aspirant ',
                                                                                                                                                                                                                                           'Asp. '),
                                                                                                                                                                                                                                       'Bâtiment ',
                                                                                                                                                                                                                                       'Bat. '),
                                                                                                                                                                                                                                   'Colonel ',
                                                                                                                                                                                                                                   'Col. '),
                                                                                                                                                                                                                               'Commandant ',
                                                                                                                                                                                                                               'Cdt. '),
                                                                                                                                                                                                                           'Commercial ',
                                                                                                                                                                                                                           'Cial. '),
                                                                                                                                                                                                                       'Coopérative ',
                                                                                                                                                                                                                       'Coop. '),
                                                                                                                                                                                                                   'Division ',
                                                                                                                                                                                                                   'Div. '),
                                                                                                                                                                                                               'Docteur ',
                                                                                                                                                                                                               'Dr. '),
                                                                                                                                                                                                           'Etablissement ',
                                                                                                                                                                                                           'Ets. '),
                                                                                                                                                                                                       'Général ',
                                                                                                                                                                                                       'Gal. '),
                                                                                                                                                                                                   'Institut ',
                                                                                                                                                                                                   'Inst. '),
                                                                                                                                                                                               'Faculté ',
                                                                                                                                                                                               'Fac. '),
                                                                                                                                                                                           'Laboratoire ',
                                                                                                                                                                                           'Labo. '),
                                                                                                                                                                                       'Lieutenant ',
                                                                                                                                                                                       'Lt. '),
                                                                                                                                                                                   'Maréchal ',
                                                                                                                                                                                   'Mal. '),
                                                                                                                                                                               'Ministère ',
                                                                                                                                                                               'Min. '),
                                                                                                                                                                           'Monseigneur ',
                                                                                                                                                                           'Mgr. '),
                                                                                                                                                                       'Bibliothèque ',
                                                                                                                                                                       'Bibl. '),
                                                                                                                                                                   'Tribunal ',
                                                                                                                                                                   'Trib. '),
                                                                                                                                                               'Municipale ',
                                                                                                                                                               'Mun. '),
                                                                                                                                                           'Municipal ',
                                                                                                                                                           'Mun. '),
                                                                                                                                                       'Observatoire ',
                                                                                                                                                       'Obs. '),
                                                                                                                                                   'Périphérique ',
                                                                                                                                                   'Périph. '),
                                                                                                                                               'Préfecture ',
                                                                                                                                               'Préf. '),
                                                                                                                                           'Président ',
                                                                                                                                           'Pdt. '),
                                                                                                                                       'Régiment ',
                                                                                                                                       'Rgt. '),
                                                                                                                                   'Régional ',
                                                                                                                                   'Rég. '),
                                                                                                                               'Régionale ',
                                                                                                                               'Rég. '),
                                                                                                                           'Saint-',
                                                                                                                           'Sᵗ-'),
                                                                                                                       'Sainte-',
                                                                                                                       'Sᵗᵉ-'),
                                                                                                                   'Sergent ',
                                                                                                                   'Sgt. '),
                                                                                                               'Université ',
                                                                                                               'Univ. '),
                                                                                                       'Communauté d.[Aa]gglomération',
                                                                                                       'Comm. d''agglo. '),
                                                                                                   'Communauté [Uu]rbaine ',
                                                                                                   'Comm. urb. '),
                                                                                               'Communauté de [Cc]ommunes ',
                                                                                               'Comm. comm. '),
                                                                                'Syndicat d.[Aa]gglomération ',
                                                                                'Synd. d''agglo. '), '^Chemin ',
                                                                 'Ch. '), '^Institut ', 'Inst. '),
                                   'Zone d.[Aa]ctivité.? ', 'Z.A. '), 'Zone [Ii]ndustrielle ', 'Z.I. ') AS nom,
     highway
   FROM planet_osm_point
   WHERE (junction = 'yes' OR highway = 'traffic_signals') AND name IS NOT NULL) AS crossroad_names;
SELECT *
FROM
  /* cycleway */ (SELECT
                    way,
                    highway,
                    route,
                    tags -> 'cycleway'       AS cycleway,
                    tags -> 'cycleway:left'  AS cycleway_l,
                    tags -> 'cycleway:right' AS cycleway_r,
                    bicycle,
                    tags -> 'bicycle:lanes'  AS bicycle_lanes
                  FROM planet_osm_line
                  WHERE (tags ? 'cycleway' OR tags ? 'cycleway:left' OR tags ? 'cycleway:right' OR
                         highway IN ('cycleway', 'path', 'footway') OR bicycle IN ('yes', 'designated') OR
                         route = 'bicycle' OR tags ? 'bicycle:lanes') AND
                        (route IS NULL OR route = 'bicycle' OR route != 'train') AND railway IS NULL) AS cycleway;
SELECT *
FROM
  /* cycliste-poi */ (SELECT
                        way,
                        amenity,
                        shop,
                        highway,
                        tags -> 'bicycle' AS bicycle
                      FROM planet_osm_point
                      WHERE amenity IN ('bicycle_parking', 'fuel') OR shop = 'bicycle' OR tags -> 'bicycle' = 'no' OR
                            highway = 'steps') AS cycliste;
SELECT *
FROM
  (SELECT
     contour,
     ele
   FROM contours) AS contours;
SELECT *
FROM
  (SELECT st_astext(rue.way) AS way
   FROM (SELECT st_intersection(r1.way, r2.way) AS way
         FROM planet_osm_line r1
           JOIN planet_osm_line r2
             ON (ST_Intersects(r1.way, r2.way) AND r2.highway IS NOT NULL AND r1.osm_id != r2.osm_id)
         WHERE r1.highway IS NOT NULL AND r1.way && !bbox !) AS inter
     JOIN planet_osm_line rue
       ON (st_intersects(inter.way, rue.way) AND rue.highway IS NOT NULL AND rue.way && inter.way)) AS addresses;
SELECT *
FROM
  (SELECT
     way,
     ref
   FROM planet_osm_polygon
   WHERE boundary = 'administrative' AND admin_level = '6') AS masque;