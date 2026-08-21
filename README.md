**English** · [Русский](README.ru.md)

# color-tree

The repository is named after Munsell's **color tree**. In 1902 Munsell arrived at the
image of a "tree" formed from slices of constant hue, which became the basis of his first
atlas; in the second edition of *A Color Notation* (1913) he presented his
three-dimensional system in exactly this form. The German tradition fixed the image as
**Farbbaum**, the French as *arbre des couleurs*.

How the tree is built:

- **trunk** — the gray (neutral) axis, bottom to top, black to white (Value);
- **branches** — series of colors of a single hue (Hue), growing sideways from the trunk;
- **branch length** — chroma (Chroma), and the branches are of **different lengths**: for
  some hues and values the achievable chroma is greater than for others. This is exactly
  why the Munsell solid is lumpy, not a regular cylinder.

An honest note on the legacy. The very idea of a three-dimensional color solid is **not**
Munsell's invention: before him came Mayer's double pyramid (1758), Lambert's pyramid
(1772), **Runge's sphere (1810)** and Chevreul's hemisphere (1839). Munsell knew his
predecessors (he studied Rood and was influenced by Chevreul) and himself began with a
**sphere** (1900). His own contribution is not the shape as such, but the **principle of
perceptual uniformity** (equal steps for the eye, which is why the shape came out
irregular), the **tree image** as an expression of that irregularity, and the **`H V/C`
notation**. Not from a blank slate, but with an original core.

Sources: [Munsell-Farbsystem (German Wikipedia)](https://de.wikipedia.org/wiki/Munsell-Farbsystem) ·
[Ordering Colour: Albert Henry Munsell — Eclectic Light](https://eclecticlight.co/2018/06/28/ordering-colour-albert-henry-munsell-1858-1918/) ·
[Nickerson. History of the Munsell Color System (JOSA 30)](https://en.wikisource.org/wiki/Journal_of_the_Optical_Society_of_America/Volume_30/Issue_12/History_of_the_Munsell_Color_System)

# Timeline

The Munsell / ISCC-NBS system by date. Each row is tagged with its source type:
**P** — primary source (the paper or publication itself), **A** — archival or
institutional source, **S** — secondary. Disputed points are collected at the end.

The dates of the ISCC-NBS and renotation layers are cross-checked against three primary
sources read in full (kept in [`sources/`](sources/)): RP1239 (Judd & Kelly 1939),
Central Notations (Kelly 1958), and Ellen Carter's ISCC history (after ISCC News #247, 1977).

# Concepts

### `H V/C` — Munsell notation

`5R 4/14` is hue (Hue) 5R, value (Value) 4, chroma (Chroma) 14. The numbers here are
**ordinal** steps of scales laid out by the perception of the eye. Which physically
measurable color the address corresponds to does not follow from the address itself.

### `xyY` — a measurable color value

In 1931 the CIE defined a way to express any color as numbers — from the averaged
response of the eye of 17 observers with normal vision. In the `xyY` notation: `x, y`
give hue and saturation, `Y` gives luminance. `xyY` and `XYZ` are the same data in two
notations.

### Address → `xyY` correspondence

The renotation (40 observers, ~3,000,000 judgments, 1940–1943) assigned each Munsell
address its concrete `xyY` value:

```
5R 4/2    →   x 0.3508   y 0.3200   Y 12.0
5R 4/8    →   x 0.4690   y 0.3209   Y 12.0
5R 4/14   →   x 0.5734   y 0.3057   Y 12.0
5R 4/18   →   x 0.6329   y 0.2881   Y 12.0
```

As chroma grows, `x` grows. The full table is the file `real.dat`, 2734 rows.

The renotation did not change the addresses: `5R 4/14` stayed `5R 4/14`. It assigned the
addresses `xyY` numbers and shifted their positions slightly for even spacing. The
address is Munsell's, the `xyY` number is the renotation's.

### Illuminant C — the light under which the coordinates were measured

The color of a non-self-luminous object depends on the lighting. So `xyY` only makes
sense under a stated light source. The renotation is computed under **CIE Illuminant C**
and the **2° observer** — this is part of the definition of the data; without it `xyY` is
ambiguous.

**Illuminant C** is a standard CIE source (defined in 1931, the same year as `XYZ`),
simulating averaged daylight (~6774 K). Its white-point coordinates:

```
x = 0.31006   y = 0.31616   (2° observer)
```

Formally C is now considered obsolete (the CIE recommends D65), but for this data it is
the only correct one: the renotation is computed in it. All `xyY` coordinates in
`all.dat` / `real.dat` are relative to C.

The **gray (neutral) axis**, absent from the files, comes from the same point: a pure
gray has no hue and no chroma, its chromaticity is exactly the white point C
(`x 0.31006, y 0.31616`), and `Y` is set by value (Value). So the gray addresses
(`N 0/` … `N 10/`) are not measured but computed from point C and a Value → Y function.

## Munsell's space

| Date | Event | Description | Src |
| --- | --- | --- | --- |
| 1898 | Work on the system begins | Munsell works with rotary color mixing, having bought a child's globe for the purpose | P |
| 1900–1902 | A daylight photometer is built | Several units of the instrument are made in these years | P |
| 1901 | The decimal hue circle is chosen | Munsell wavers between a circle of ten and of three; the decimal system is finally adopted | P |
| 1901–1902 | First charts | Painted by visual estimate in Munsell's studio (executed by a Mr. Lyon) | P |
| 1903 | An attempt to measure chroma | Spinning disks in the photometer, value equalized by illumination. The method is judged unsatisfactory and dropped | P |
| 1905 | ***A Color Notation*** | The system is published in full. Three independent dimensions and the `H V/C` notation are defined | P |
| 1910 | A preliminary atlas | Contains two charts: A — the value scale, B — chroma scales for 5 hues | P |
| 1912 | Chroma scales settled | No final decision on chroma existed before this year | P |
| 1913 | Second edition of *A Color Notation* | Under the same title | S |
| 1915 | ***Atlas of the Munsell Color System*** | The full atlas, publisher Wadsworth Howland & Company | P |
| 1929 | ***Munsell Book of Color*** | The atlas re-issued by the company in an altered, re-measured and re-calibrated form; distinguished by name from the *Atlas* | P |

### What was defined in 1905

The three dimensions, as Munsell defined them verbatim:

- **Hue** — "the quality by which we distinguish one color from another, as a red from a yellow, a green, a blue, or a purple";
- **Value** — "the quality by which we distinguish a light color from a dark one";
- **Chroma** — "the quality by which we distinguish a strong color from a weak one".

The stated goal was to replace color names with a measurable notation. Munsell lists
"baby blue, peacock blue, Nile green, apple green, lemon yellow, straw yellow, rose pink,
heliotrope, royal purple, Magenta, Solferino, plum, and automobile" as terms "conveying
different ideas to different persons and utterly failing to define colors", and of the
series "pea green, sea green, olive green, grass green, sage green, evergreen, invisible
green" he writes that they "are not to be trusted in ordering a piece of cloth".

## The arrival of a colorimetric basis

| Date | Event | Description | Src |
| --- | --- | --- | --- |
| 1931 | **CIE 1931** | The eighth CIE session in Cambridge: the XYZ space, the 2° standard observer and standard illuminants A, B, C are adopted | S |
| 1935 | **MacAdam limits** | MacAdam D. L., "Maximum Visual Efficiency of Colored Materials", JOSA **25**, 361–367. Sets the boundary of physically reproducible colors | P |

Before 1931 the `H V/C` notation could not be tied to a measurable quantity: the only
definition of a color remained a physical sample in the atlas.

## ISCC-NBS: names

| Date | Event | Description | Src |
| --- | --- | --- | --- |
| 1930, May 14 | "Color conference" in Washington | Called by Gathercoal (University of Illinois College of Pharmacy) at the decennial revision of the National Formulary of the US Pharmacopoeia: the committee needs color names to describe drugs. The starting point of everything | A |
| 1930, Oct 30 | OSA resolution | The Optical Society of America executive resolves: the need can be met by forming a joint council of societies concerned with the description and specification of color | A |
| 1931, Feb 26 | Preliminary conference | At the Museum of Science and Industry, New York: 47 people, 31 delegates from 14 national associations. This is **not yet the founding of the Council** | A |
| 1931, Sep 21 | **Inter-Society Color Council** formed | The decision to form it is taken at the first meeting. First chairman — E. N. Gathercoal | A |
| 1931 | The problem is posed | On behalf of the US Pharmacopoeial Revision Committee, Gathercoal poses the problem of color designations: usable by science, broad for industry, understood by the public | P |
| 1933 | The system's design, Godlove's committee | The Committee on Measurement and Specification chaired by I. H. Godlove: annual report with a recommended system of designations, including a 20-point division of the hue circle. The names are from Godlove's committee, the boundary method is Munsell's "volumetric approach" | P |
| 1935 | Master standards at NBS | The Munsell Color Co. deposits two sets of master standards at NBS for spectrophotometric anchoring | P |
| 1939 | **Judd, Kelly, "Method of Designating Colors"** | J. Res. NBS **23**, RP1239 (signed July 14, 1939). The method and boundaries. Approved by ballot by 9 member bodies and recommended to the United States Pharmacopoeial Convention | P |

**The 1939 edition had 319 blocks** (314 chromatic + 5 neutral for black, grays and
white), not 267. Today's 267 is already the 1955 revision.

The 1939 block boundaries are given in **the original Munsell Book notations**, not in
the renotation: the renotation did not yet exist.

## Renotation: the numbers

| Date | Event | Description | Src |
| --- | --- | --- | --- |
| 1936, Apr 6 | "Review of the Spacing of the Munsell Colors" | Judd and Nickerson, a six-page memo attached to the Godlove report: a proposal to study the uniformity of Munsell's spacing via a subcommittee | A |
| 1937 → | The project passed to the OSA | The OSA assigns it to its Colorimetry Committee; a subcommittee is formed chaired by Sidney M. Newhall | A |
| 1940 | Preliminary spacing report | The first of the Newhall subcommittee's two reports; visual estimates of the *Munsell Book of Color* samples — the input to the renotation | A/P |
| 1943 | **Kelly, Gibson, Nickerson**, "Tristimulus Specification of the Munsell Book of Color from Spectrophotometric Measurements" | J. Res. NBS **31**, RP1549; also JOSA **33**, 355–376. Spectral reflectance curves of 421 master standards of the Book measured on a General Electric spectrophotometer. The reason is stated outright: the development of ISCC-NBS "made it necessary to specify the master standards of this book in fundamental terms" | P |
| 1943 | **Newhall, Nickerson, Judd**, "Final Report of the O.S.A. Subcommittee on the Spacing of the Munsell Colors" | JOSA **33**(7), 385–418. The final report — the renotation | P |

The renotation is **two reports**: the preliminary one of 1940 and the final one of 1943.

The two 1943 papers are **different**: the first measures what the physical samples are;
the second defines where they should be.

From the renotation abstract, verbatim: a "modified and enlarged Munsell solid" is
obtained, all three dimensions reviewed; the loci of constant hue extended closer to the
extremes of value, the loci of constant chroma extrapolated to the pigment maximum, value
redefined without substantial departure from the Munsell–Sloan–Godlove scale. The goal —
to approach "A. H. Munsell's dual ideal of psychological equispacing and precise
applicability". The result is given in CIE coordinates under illuminant **C**.

## Block revision, centroids, levels

| Date | Event | Description | Src |
| --- | --- | --- | --- |
| 1947 | Subcommittee for boundary revision | Appointed to revise the boundaries of the 1939 report (RP1239) | P |
| 1949, June | New boundaries approved | The revised block boundaries are approved | P |
| 1955 | **NBS Circular 553**, Kelly and Judd | The revised system and dictionary of names. **267 blocks**. The name charts are built **on the renotation**, not on the original Book notations | P |
| 1956 | **Judd, Wyszecki**, "Extension of the Munsell Renotation System to Very Dark Colors" | JOSA **46**(4), 281–284. The renotation extended to values below `1/0` | P |
| 1958 | **Kelly**, "Central Notations for the Revised ISCC-NBS Color-Name Blocks" | J. Res. NBS **61**(5), 427–431. The centroids | P |
| 1960 | Subcommittee for centroid samples | Appointed to prepare printed samples representing the centroids | P |
| 1961 | Merriam-Webster | The 1955 revision is taken as the basis of color definitions in the Merriam-Webster dictionary edition | P |
| c. 1963 | The name "Universal Color Language" appears | The term arises in discussions with the executive secretary of the Color Marketing Group | P |
| 1965, May | **ISCC-NBS color-name charts illustrated with centroid colors** | Supplement to Circular 553: the name charts printed in centroid colors | P |
| 1965 | **Kelly, "A Universal Color Language"** | Color Engineering **3**, 16 (March–April). Six levels of color-designation precision | P |
| 1976 | **Kelly, Judd, "Color: Universal Language and Dictionary of Names"** | NBS **Special Publication 440**. Absorbed the out-of-print Circular 553. The current consolidated document | P |

### The reason for the 1955 revision

Kelly, in his 1958 paper, states outright: the blocks were revised "to accord more
closely with usage in the textile and other fields" (NBS Circular 553). The move to the
renotation is recorded there as a fact — the 1955 charts are built on the renotation, unlike
the 1939 Book notations — but is not stated as the *reason* for the revision. These are
two different claims, and must not be conflated.

## The six levels of the Universal Color Language

Table 1 of SP 440, "Schematic Diagram Illustrating the Six Levels of The Universal Color
Language", p. A-7.

| Level | Divisions | What it is |
| --- | --- | --- |
| 1 | 13 | Generic hue and neutral names |
| 2 | 29 | All hue names and neutrals |
| 3 | 267 | ISCC-NBS blocks with modifiers |
| 4 | 943–7056 | Color-order systems: *Munsell Book of Color* (~1500 samples), Maerz & Paul 1st ed. (7056), Plochere (1248), Ridgway (1115), Color Harmony Manual 3rd ed. (943) |
| 5 | ~100,000 | Munsell notation, visually interpolated |
| 6 | ±5,000,000 | CIE coordinates, instrumental measurement |

There are **six** levels. A seventh is mentioned in SP 440 only as a possibility: the
language "has the open-ended flexibility to add level 7 when a still more accurate
designation of color is needed", and intermediate levels like 2B or 2C between the second
and third are allowed there too. Neither level 7 nor the intermediate ones are defined.

The dictionary of names in SP 440 collates 7500 color names from 11 sets of material
standards.

## What is what

| Layer | Who | Year | Content |
| --- | --- | --- | --- |
| Axes, hue circle, `H V/C` notation, physical samples | Munsell | 1905–1915 | Ordinal addresses, not colorimetry |
| Spectrophotometry of the Book's standards | Kelly, Gibson, Nickerson | 1943 | What the 421 samples physically are |
| Renotation | Newhall, Nickerson, Judd | 1943 | Where the addresses should be; `xyY` coordinates, illuminant C |
| Blocks and names | Godlove's committee; Judd, Kelly | 1933 → 1939, rev. 1955 | Regions of the space and their names (319 blocks in 1939, 267 since 1955) |
| Block centroids | Kelly | 1958 | Volume-weighted center of a region |
| Levels of precision | Kelly | 1965 | The six UCL levels |

The `H V/C` notation is numeric but not colorimetric: `5R 4/14` decomposes into numbers,
but those are ordinal positions on a scale defined by a physical sample. You cannot
compute the reflected light from the address without an external correspondence table.

## Machine-readable datasets

Renotation data from the Munsell Color Science Laboratory, RIT. The format of all three
is identical: Munsell hue, value, chroma, CIE `x`, `y`, `Y`. Coordinates are computed
under illuminant **C** and the CIE 1931 2° observer.

| File | Rows | Content |
| --- | --- | --- |
| `all.dat` | 4995 | All data, including extrapolated; some colors are unreal |
| `real.dat` | 2734 | Real only — lying inside the MacAdam limits. Correspond to the list in the 1943 renotation paper |
| `1929.dat` | — | Only colors physically present in the *Munsell Book of Color* of 1929. These are the input samples of the scaling experiments for the renotation |

`1929.dat` is the closest thing to "Munsell's data" that exists in machine form: the
addresses of the physical samples of his Book. Their coordinates are still the
renotation's.

The `real.dat` grid: 10 hue families, steps 2.5 / 5 / 7.5 / 10 — 40 hues in all; value
integer `1..9`; chroma even `2..38`.

## Disputed and unverified

- **When the number of hues grew from 20 to 40.** German Wikipedia attributes the doubling
  to the 1943 renotation. Some sources attribute it to "around 1950" and to the
  *Book of Color* as a product. Only one thing is firmly established: **the 1943
  renotation dataset contains 40 hue steps**. About the physical atlas — unverified.
- **1898 as the year work began.** Nickerson has a phrase about rotary mixing in 1898,
  but that is not the same as "began the system".
- **The year of the switch to the equal-spacing principle.** I previously dated it to
  1904; no confirmation of that date was found in Nickerson's history. The claim is retracted.
- **CIE 1931** is confirmed only by secondary sources; I have not seen the official CIE
  document.
- **Munsell's dates 1898–1929** are taken from Nickerson's "History of the Munsell Color
  System" (JOSA 30, 1940). The separate three-part Nickerson essay of 1976
  (*Color Research & Application* 1) could not be obtained — that is where the details of
  the Book's transition from 20 to 40 hue charts are.

## Sources

Primary sources:

- [Kelly, Judd. Color: Universal Language and Dictionary of Names. NBS SP 440, 1976 — full text](https://archive.org/stream/coloruniversalla00kell/coloruniversalla00kell_djvu.txt)
- [Munsell A. H. A Color Notation, 1905 — full text](https://www.gutenberg.org/files/26054/26054-h/26054-h.htm)
- [Nickerson D. History of the Munsell Color System. JOSA 30(12)](https://en.wikisource.org/wiki/Journal_of_the_Optical_Society_of_America/Volume_30/Issue_12/History_of_the_Munsell_Color_System)
- [Newhall, Nickerson, Judd. Final Report of the O.S.A. Subcommittee. JOSA 33(7), 385 (1943)](https://opg.optica.org/josa/abstract.cfm?uri=josa-33-7-385)
- [Kelly, Gibson, Nickerson. Tristimulus Specification of the Munsell Book of Color. RP1549 (1943)](https://en.wikisource.org/wiki/Tristimulus_Specification_of_the_Munsell_Book_of_Color_From_Spectrophotometric_Measurements)
- [Judd, Kelly. Method of designating colors. J. Res. NBS 23, 355 (1939)](https://nvlpubs.nist.gov/nistpubs/jres/23/jresv23n3p355_A1b.pdf)
- [Kelly. Central notations for the revised ISCC-NBS color-name blocks. J. Res. NBS 61(5), 427 (1958)](https://archive.org/stream/jresv61n5p427/jresv61n5p427_A1b_djvu.txt)
- [MacAdam. Maximum Visual Efficiency of Colored Materials. JOSA 25, 361 (1935)](https://opg.optica.org/josa/abstract.cfm?uri=josa-25-11-361)
- [Judd, Wyszecki. Extension of the Munsell Renotation System to Very Dark Colors. JOSA 46(4), 281 (1956)](https://www.osapublishing.org/abstract.cfm?uri=josa-46-4-281)
- [NBS Circular 553, 1955](https://archive.org/details/circularofbureau553unse)

Read in full. Two NBS publications — works of the US government, public domain — are kept
in [`sources/`](sources/):

- [`judd-kelly-1939-rp1239.pdf`](sources/judd-kelly-1939-rp1239.pdf) — Judd, Kelly. Method of Designating Colors. J. Res. NBS 23, RP1239 (1939). Taken from [nvlpubs.nist.gov](https://nvlpubs.nist.gov/nistpubs/jres/23/jresv23n3p355_A1b.pdf)
- [`kelly-1958-central-notations.pdf`](sources/kelly-1958-central-notations.pdf) — Kelly. Central Notations for the Revised ISCC-NBS Color-Name Blocks. J. Res. NBS 61(5), 427 (1958). Taken from [nvlpubs.nist.gov](https://nvlpubs.nist.gov/nistpubs/jres/61/jresv61n5p427_A1b.pdf)

A third primary source was also read in full but is **not included in the repository**
(ISCC copyright): Carter E. *Color in Art, Science, and Industry* — a history of the ISCC
(after ISCC News #247, 1977). Available at [iscc.org](https://iscc.org/History).

Data and institutional sources:

- [Munsell Color Science Laboratory, RIT — renotation data](https://www.rit.edu/science/munsell-color-science-lab-educational-resources)
- [Inter-Society Color Council — history](https://iscc.org/History)
- [ISCC-NBS color-name charts illustrated with centroid colors, 1965 — Smithsonian](https://www.si.edu/object/siris_sil_909259)
- [bstreiff/iscc-nbs-colors — transcription of SP 440, CC0-1.0](https://github.com/bstreiff/iscc-nbs-colors)
