CREATE CONSTRAINT color_block_number IF NOT EXISTS
FOR (b:ColorBlock) REQUIRE b.number IS UNIQUE;

CREATE CONSTRAINT color_category_key IF NOT EXISTS
FOR (c:ColorCategory) REQUIRE (c.level, c.number) IS UNIQUE;

CREATE CONSTRAINT color_designation_value IF NOT EXISTS
FOR (d:ColorDesignation) REQUIRE d.value IS UNIQUE;

LOAD CSV WITH HEADERS FROM 'file:///iscc-names.csv' AS row

MERGE (d:ColorDesignation {value: row.name})
SET d.abbr = row.abbr

FOREACH (_ IN CASE WHEN row.level = '3' THEN [1] ELSE [] END |
  MERGE (b:ColorBlock:ISCCBlock {number: toInteger(row.number)})
  MERGE (b)-[:HAS_DESIGNATION]->(d)
)

FOREACH (_ IN CASE WHEN row.level <> '3' THEN [1] ELSE [] END |
  MERGE (c:ColorCategory:ISCCCategory {level: toInteger(row.level), number: toInteger(row.number)})
  MERGE (c)-[:HAS_DESIGNATION]->(d)
)
;

LOAD CSV WITH HEADERS FROM 'file:///iscc-names.csv' AS row
WITH row WHERE row.parent IS NOT NULL

FOREACH (_ IN CASE WHEN row.level = '3' THEN [1] ELSE [] END |
  MERGE (child:ColorBlock {number: toInteger(row.number)})
  MERGE (parent:ColorCategory {level: 2, number: toInteger(row.parent)})
  MERGE (child)-[:SUBSET_OF]->(parent)
)

FOREACH (_ IN CASE WHEN row.level = '2' THEN [1] ELSE [] END |
  MERGE (child:ColorCategory {level: 2, number: toInteger(row.number)})
  MERGE (parent:ColorCategory {level: 1, number: toInteger(row.parent)})
  MERGE (child)-[:SUBSET_OF]->(parent)
)
;
