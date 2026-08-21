# munsell-colors

Трёхуровневая таксономия цветовых названий ISCC-NBS (построена поверх системы Манселла)
и координаты центроидов каждой категории уровня 3 в OKLab.

## Файлы

- `color.js` — таксономия, карты родителей, центроиды и функции поиска.
- `color.cql` — та же таксономия как сид для Neo4j.

## color.js

| Экспорт | Что это |
| --- | --- |
| `ColorLevel1` | 13 базовых категорий: `Pink`, `Red`, …, `Black` |
| `ColorLevel2` | 29 промежуточных категорий: `YellowishPink`, `PurplishRed`, … |
| `ColorLevel3` | 267 конечных категорий: `VividPink`, `DarkGrayishOlive`, … |
| `ColorLevel2Parent` | уровень 2 → уровень 1 |
| `ColorLevel3Parent` | уровень 3 → уровень 2 |
| `ColorCentroid` | `{ l, a, b, color }` — 260 записей для категорий уровня 3 |
| `getColorLevel1/2/3` | доступ к категории по ключу |
| `getColorLevel2Parent`, `getColorLevel3Parent` | подъём на уровень выше |
| `colorDistance` | евклидово расстояние между двумя точками OKLab |
| `findColorCentroid` | ближайший центроид к точке OKLab |

Координаты — **OKLab**, не Манселл: `l` в диапазоне `0…1`, `a` и `b` примерно
в `-0.4…0.4`. Манселл здесь — происхождение самих *названий* (через ISCC-NBS),
а не чисел.

У 7 из 267 категорий уровня 3 центроида нет, поэтому `findColorCentroid`
никогда их не вернёт: `BrilliantOrange`, `VividOrangeYellow`, `DeepOliveGreen`,
`DeepGreen`, `DeepBluishGreen`, `VividGreenishBlue`, `DeepGreenishBlue`.

```js
import { findColorCentroid, getColorLevel3Parent } from './color.js'

let { color } = findColorCentroid({ l: 0.6085, a: 0.2237, b: -0.1002 })
// 'VividReddishPurple'

getColorLevel3Parent(color)
// 'ReddishPurple'
```

## color.cql

`UNWIND` списка `{ level, term }` в порядке обхода дерева: запись уровня 1
открывает свою группу, следом идут её записи уровня 2 и 3.
