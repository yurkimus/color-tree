CREATE CONSTRAINT color_space_name IF NOT EXISTS
FOR (s:ColorSpace) REQUIRE s.name IS UNIQUE;

CREATE INDEX munsell_notation IF NOT EXISTS
FOR (m:MunsellPoint) ON (m.notation);

MERGE (munsell:ColorSpace {name: 'Munsell renotation'})
MERGE (cie:ColorSpace {name: 'CIE 1931 xyY'})
SET cie.observer = '2°', cie.illuminant = 'C'

WITH munsell, cie
LOAD CSV WITH HEADERS FROM 'file:///munsell.csv' AS row

CREATE (m:ColorPoint:MunsellPoint {
  notation: row.notation,
  hueStep: toFloat(row.hueStep),
  hueFamily: row.hueFamily,
  value: toFloat(row.value),
  chroma: toFloat(row.chroma)
})
CREATE (c:ColorPoint:CIEPoint {x: toFloat(row.x), y: toFloat(row.y), Y: toFloat(row.Y)})
CREATE (m)-[:HAS_COORDINATES]->(c)
CREATE (m)-[:IN_SPACE]->(munsell)
CREATE (c)-[:IN_SPACE]->(cie)
;
