# munsell-colors

Система цветовых названий ISCC-NBS — три уровня детализации (13 / 29 / 267 терминов)
и их определения в пространстве Манселла, как граф для Neo4j.

## Источники

| Что | Откуда |
| --- | --- |
| Иерархия названий, границы блоков Манселла | NBS Special Publication 440, «Color: Universal Language and Dictionary of Names» (Kelly & Judd, 1976) через [bstreiff/iscc-nbs-colors](https://github.com/bstreiff/iscc-nbs-colors), CC0-1.0 |
| Центроиды в OKLab | `color.js`, перенесено из `plants/hub` |

Уровни, термины и все связи «потомок → родитель» в `color.js` сверены с SP 440
построчно: расхождений нет.

## Файлы

| Файл | Что делает |
| --- | --- |
| `color.cql` | 309 узлов `:ColorCategory` и 296 связей `:BROADER` |
| `munsell.cql` | 932 элементарных блока `:MunsellBlock`, связь `:HAS_BLOCK` с уровнем 3 |
| `color.js` | те же данные для клиента + центроиды OKLab и поиск ближайшего |

## Модель графа

```
(:ColorCategory {level: 3, term: 'VividPink'})
  -[:BROADER]-> (:ColorCategory {level: 2, term: 'Pink'})
  -[:BROADER]-> (:ColorCategory {level: 1, term: 'Pink'})

(:ColorCategory {level: 3})-[:HAS_BLOCK]->(:MunsellBlock)
```

Уровень — **свойство**, а не узел. Отдельный `(:Level)` не хранил бы ничего, кроме
своего номера, зато собрал бы на себе 267 связей: такой суперузел приходится
разворачивать целиком в каждом запросе по уровню 3. Связь же между уровнями
(`1 → 2 → 3`) выводится из числа и не нуждается в рёбрах.

Работать в запросах нужно с другой связью — «термин → его родитель». Именно её даёт
`:BROADER`, и именно она позволяет свернуть наблюдение до любого уровня одним обходом.

### Ключ узла — пара `(level, term)`

`term` сам по себе **не уникален**. `Pink`, `Red`, `Orange`, `Brown`, `Yellow`,
`Olive`, `YellowGreen`, `Green`, `Blue`, `Purple`, `Gray` есть и на уровне 1, и на
уровне 2; `White` и `Black` — на всех трёх. `MERGE` только по `term` склеил бы их
в один узел. То же с `number`: номер ISCC-NBS уникален лишь внутри своего уровня.

### Блоки Манселла

Категория уровня 3 — это объединение своих блоков; невыпуклые области из «Color Name
Charts» разложены на несколько прямоугольников, поэтому у одной категории их бывает
до нескольких десятков. Границы полуоткрытые, `[begin, end)`.

Верхняя граница, уходящая в бесконечность (в источнике `INF`), хранится как
**отсутствующее свойство** — проверяйте `IS NULL` или сворачивайте через
`coalesce(block.chromaEnd, 1e9)`.

Тон задан и меткой чарта (`'1R'`), и позицией на нормированном круге `0..1`
(`hueBeginAmount`). 31 диапазон тонов идёт подряд и замыкается в круг; их порядковый
номер — `hueIndex`, счёт с `1R`. Ровно один диапазон, `4R..6R` (`hueIndex` 1),
пересекает шов `0/1`, из-за чего там `hueBeginAmount > hueEndAmount`. Поэтому
сравнивайте по `hueIndex`, а не по амплитудам, если не готовы обрабатывать переход.

Проверено: 932 блока покрывают тело Манселла без дыр и пересечений — на сетке из
7254 точек каждая попадает ровно в одну категорию.

## Запросы

Название по координатам Манселла:

```cypher
MATCH (level3:ColorCategory {level: 3})-[:HAS_BLOCK]->(block:MunsellBlock)
WHERE block.hueIndex = $hue
  AND block.valueBegin  <= $value  AND $value  < coalesce(block.valueEnd, 1e9)
  AND block.chromaBegin <= $chroma AND $chroma < coalesce(block.chromaEnd, 1e9)
RETURN level3.term
```

Подъём до всех уровней сразу — `*0..2` включает саму категорию:

```cypher
MATCH (level3:ColorCategory {level: 3, term: $term})-[:BROADER*0..2]->(category)
RETURN category.level, category.term
```

Всё, что лежит под широкой категорией:

```cypher
MATCH (:ColorCategory {level: 1, term: 'Green'})<-[:BROADER*1..2]-(category)
RETURN category.level, category.term
```

### Индекс

Сид опирается на `MERGE` по `(level, term)`, так что без индекса он линеен по числу
узлов. Стоит завести:

```cypher
CREATE CONSTRAINT color_category_key IF NOT EXISTS
FOR (category:ColorCategory) REQUIRE (category.level, category.term) IS UNIQUE
```

## Центроиды OKLab

`color.js` держит `ColorCentroid` — по точке OKLab на категорию уровня 3, и
`findColorCentroid` ищет ближайшую. Координаты там **OKLab, не Манселл**: `l` в
`0…1`, `a` и `b` примерно в `-0.4…0.4`. Манселл — происхождение самих *названий*
(через ISCC-NBS), а не этих чисел.

Центроидов 260 из 267. Семи нет, и `findColorCentroid` их никогда не вернёт:
`BrilliantOrange`, `VividOrangeYellow`, `DeepOliveGreen`, `DeepGreen`,
`DeepBluishGreen`, `VividGreenishBlue`, `DeepGreenishBlue`. Все семь —
высокохроматичные цвета за пределами охвата sRGB, что указывает на sRGB-таблицу
центроидов как на исходник.

## Запуск

`.env` рядом с `docker-compose.yaml`:

```
NEO4J_USER=neo4j
NEO4J_PASSWORD=...
```

```sh
docker compose up -d

set -a && . ./.env && set +a
for file in color munsell; do
  docker exec -i munsell-colors-database-1 \
    cypher-shell -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" < "$file.cql"
done
```

`color.cql` должен отработать раньше `munsell.cql` — блоки цепляются к уже
существующим категориям. Оба файла идемпотентны.
