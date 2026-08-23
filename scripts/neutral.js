let columns = ['notation', 'hueFamily', 'value', 'chroma', 'x', 'y', 'Y']

Bun
  .file(new URL('../database/import/chromatic.csv', import.meta.url))
  .text()
  .then(text =>
    ''
    + columns
    + '\n'
    + text
      .split('\n')
      .slice(1)
      .filter(row => row.trim())
      .map(row => row.split(','))
      .filter((row, index, array) => array.findIndex(({ 3: value }) => value === row[3]) === index)
      .map(({ 3: value, 7: Y }) => `N ${value}/,N,${value},0,0.31006,0.31616,${Y}`)
      .join('\n')
  )
  .then(console.log)
