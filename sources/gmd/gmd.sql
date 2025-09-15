DROP TABLE IF EXISTS "Basel";
SELECT * FROM "Basel";
SELECT * FROM gmd;

CREATE OR REPLACE TABLE gmd AS SELECT * FROM read_csv_auto('/workspaces/global-macro-database/GMD.csv');