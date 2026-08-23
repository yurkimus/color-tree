CREATE CONSTRAINT color_space_name IF NOT EXISTS
FOR (s:ColorSpace) REQUIRE s.name IS UNIQUE;

CREATE INDEX munsell_notation IF NOT EXISTS
FOR (m:MunsellPoint) ON (m.notation);

MERGE (munsell:ColorSpace {name: 'Munsell renotation'})
MERGE (cie:ColorSpace {name: 'CIE 1931 xyY'})
SET cie.observer = '2°', cie.illuminant = 'C'
;
