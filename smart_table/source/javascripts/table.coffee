class window.Table
  constructor: (tableTag) ->
    @table = document.createElement('table')
    @thead = document.createElement('thead')
    @tbody = document.createElement('tbody')

    @rows = @tbody.children
    @columns = {}
    @header = []
    @input

    @table.border = 1
    @table.appendChild(@thead)
    @table.appendChild(@tbody)
    document.getElementById(tableTag).appendChild(@table)

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
    reverse = column.getAttribute('reverse')
    tag = column.innerHTML
    @getColumns()

    records = []
    columForSort = []

    for cell in [0...@rows.length]
      records[cell] = @getRecord(cell)
      columForSort[cell] = @columns[tag][cell].innerHTML

    if reverse is "true"
      columForSort = columForSort.sort((a,b) =>  @compareCells(b,a))
      column.setAttribute('reverse', false)
    else 
      columForSort = columForSort.sort((a,b) => @compareCells(a,b))
      column.setAttribute('reverse', true)

    numberOfUniqRecords = 1
    for j in [0...columForSort.length] by numberOfUniqRecords
      record = @findInRecords(columForSort[j], records, tag)
      for m in [0...record.length]
        for i in [0...@header.length]
          @rows[j+m].cells[i].innerHTML = record[m][@header[i]]
      if record.length > 1
        numberOfUniqRecords = record.length

  findInRecords: (value, records, tag) ->
    result = []
    result.push(row) for row in records when row[tag] is value
    result

  compareCells: (a,b)  ->
    if @IsNumeric(a) and @IsNumeric(b)
      parseInt(a) > parseInt(b)
    else
      a.localeCompare(b)

  IsNumeric: (n) ->
    result = on if isNaN(parseFloat(n)) isnt off and isFinite(n)

  getRecord: (row) ->
    record = {}
    for i in [0...@header.length]
      record[@header[i]] = @rows[row].cells[i].innerHTML
    record

  getColumns: ->
    for i in [0...@header.length]
      @columns[@header[i]] = []
      for j in [0...@rows.length]
        @columns[@header[i]].push(@rows[j].children[i])

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
        if  str.contains(input) is yes
          row.style.display = ''
          break
        row.style.display = 'none'
