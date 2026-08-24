let columns = ['level', 'number', 'name', 'abbr', 'parent']

Bun
  .file(new URL('../sources/iscc-nbs.xml', import.meta.url))
  .text()
  .then(text => {
    let names = text.slice(text.indexOf('<names>'), text.indexOf('</names>'))
    let stack = []
    let rows = []
    for (let m of names.matchAll(/<name color="(\d+)" name="([^"]+)" abbr="([^"]+)"\s*(\/?)>|<\/name>/g)) {
      if (m[0] === '</name>') {
        stack.pop()
        continue
      }
      let { 1: number, 2: name, 3: abbr, 4: selfClosing } = m
      rows.push([stack.length + 1, number, name, abbr, stack.at(-1) ?? ''])
      if (!selfClosing) stack.push(number)
    }
    return '' + columns + '\n' + rows.map(row => row.join(',')).join('\n')
  })
  .then(console.log)
