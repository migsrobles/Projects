SELECT *
FROM spotify;

SELECT track_name, "artist(s)_name"
FROM spotify
WHERE "artist(s)_name" LIKE 'Taylor%';

UPDATE spotify
SET track_name = REGEXP_REPLACE(track_name, '[^\x20-\x7E]', '', 'g') --- I had an encoding error so i had to replace some corrupted special characters
WHERE track_name ~ '[^\x20-\x7E]';

UPDATE spotify
SET "artist(s)_name" = REGEXP_REPLACE("artist(s)_name", '[^\x20-\x7E]', '', 'g') --- I had an encoding error so i had to replace some corrupted special characters
WHERE "artist(s)_name" ~ '[^\x20-\x7E]';

ALTER TABLE spotify 
ADD COLUMN released_date DATE;

UPDATE spotify
SET released_date = TO_DATE(
    CONCAT_WS('-', released_year::TEXT, released_month::TEXT, released_day::TEXT), 
    'YYYY-MM-DD'
);

ALTER TABLE spotify
DROP COLUMN released_year,
DROP COLUMN released_month,
DROP COLUMN released_day;

SELECT DISTINCT "artist(s)_name", SUM(streams) AS total_streams
FROM spotify
WHERE streams IS NOT NULL AND artist_count = 1 AND streams IS NOT NULL 
GROUP BY "artist(s)_name"
ORDER BY total_streams DESC
LIMIT 10;


SELECT DISTINCT "artist(s)_name" AS artist, track_name, streams
FROM spotify
WHERE streams IS NOT NULL
GROUP BY artist, track_name, streams
ORDER BY streams DESC;

SELECT DISTINCT "artist(s)_name", SUM(streams) AS total_streams
WHERE streams IS NOT NULL AND artist_count = 1 AND streams IS NOT NULL 
GROUP BY "artist(s)_name"
ORDER BY total_streams DESC
LIMIT 10;


SELECT "artist(s)_name", track_name, in_spotify_playlists, in_apple_playlists, in_deezer_playlists, streams
FROM spotify
ORDER BY in_spotify_playlists DESC, in_apple_playlists DESC, in_deezer_playlists DESC
