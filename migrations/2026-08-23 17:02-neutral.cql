MATCH (munsell:ColorSpace {name: 'Munsell renotation'})
MATCH (cie:ColorSpace {name: 'CIE 1931 xyY'})

WITH munsell, cie
LOAD CSV WITH HEADERS FROM 'file:///neutral.csv' AS row

CREATE (m:ColorPoint:MunsellPoint {
  notation: row.notation,
  hueFamily: row.hueFamily,
  value: toFloat(row.value),
  chroma: toFloat(row.chroma)
})
CREATE (c:ColorPoint:CIEPoint {x: toFloat(row.x), y: toFloat(row.y), Y: toFloat(row.Y)})
CREATE (m)-[:HAS_COORDINATES]->(c)
CREATE (m)-[:IN_SPACE]->(munsell)
CREATE (c)-[:IN_SPACE]->(cie)
;
