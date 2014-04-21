class window.Table
  constructor: (tableTag) ->
    @table = document.getElementById(tableTag)
    @thead = document.createElement('thead')
    @tbody = document.createElement('tbody')

    @rows = @tbody.children
    @header = []
    @records = {}
    @input

    @table.border = 1
    @table.appendChild(@thead)
    @table.appendChild(@tbody)

  createTableRowContent: (rowObject, data, cellType) ->
    rowContent = document.createElement(cellType)
    cell = document.createTextNode(data)
    rowContent.appendChild(cell)
    rowObject.appendChild(rowContent)

  createTableData: (rowObject, data) ->
    @createTableRowContent(rowObject, data, 'td')

  createTableHeader: (rowObject, data) -> 
    th = @createTableRowContent(rowObject, data, 'th')

  buildFromJson: (jsonString) =>
    if @header.length == 0
      @header = Object.keys(jsonString[0])
      @buildHeaderFromJson()
    for i in [0...jsonString.length]
      row = document.createElement('tr')
      for key,value of jsonString[i]
        @createTableData(row, value)
      @records[row.innerHTML] = jsonString[i]
      @tbody.appendChild(row)

  buildHeaderFromJson: =>
    row = document.createElement('tr')
    for tag in @header
      @createTableHeader(row, tag)
    @thead.appendChild(row)
    @input = new Input @header
    @makeSortable()

  makeSortable: ->
    header = @thead.rows[0].cells
    for cell in header
      cell.onclick = this.sort

  sort: (c) =>
    column = c.target
    tag = column.innerHTML
    reverse = column.getAttribute('reverse')

    columForSort = []

    for tr, json of @records
      columForSort.push(value) for key, value of json when key is tag
      
    if reverse is "true"
      columForSort = columForSort.sort(@compareCells)
      columForSort.reverse()
      column.setAttribute('reverse', false)
    else
      columForSort = columForSort.sort(@compareCells)
      column.setAttribute('reverse', true)

    numberOfUniqRecords = 1
    for j in [0...columForSort.length] by numberOfUniqRecords
      record = @findInRecords(columForSort[j], tag)
      for m in [0...record.length]
        @rows[j+m].innerHTML = record[m]
      if record.length > 1
        numberOfUniqRecords = record.length

  findInRecords: (valueFromSort, tag) ->
    result = []
    for tr, json of @records
       for key, value of json when key is tag and value is valueFromSort
          result.push(tr) 
    result

  compareCells: (a,b)  ->
    if typeof(a) == "number" or typeof(b) == "number"
      parseInt(a) > parseInt(b)
    else
      String(a).localeCompare(String(b))

  getRecord: (row) ->
    record = {}
    for i in [0...@header.length]
      record[@header[i]] = @rows[row].cells[i].innerHTML
    record

  addRow: =>
    record = @input.getRecord()
    row = document.createElement('tr')

    for tag in @header
      @createTableData(row, record[tag])
    @tbody.appendChild(row)
    @input.clearRecord()

  search: =>
    input = document.getElementById('Search').value
    for row in @rows
      cells = row.children
      for cell in cells
        str = cell.innerHTML
        if  str.indexOf(input) >= 0
          row.style.display = ''
          break
        row.style.display = 'none'
