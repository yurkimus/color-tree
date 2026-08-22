let text = await Bun
  .file(new URL('../sources/all.dat', import.meta.url))
  .text()

let csv = ''
  + 'notation,hueStep,hueFamily,value,chroma,x,y,Y'
  + '\n'
  + text
    .split('\n')
    .slice(1)
    .filter(row => row.trim())
    .map(row => row.trim().split(/\s+/))
    .map(({ 0: H, 1: V, 2: C, 3: x, 4: y, 5: Y }) => {
      let { 1: step, 2: family } = H.match(/^([\d.]+)([A-Z]+)$/)
      return `${step}${family} ${V}/${C},${step},${family},${V},${C},${x},${y},${Y}`
    })
    .join('\n')

console.log(csv)
