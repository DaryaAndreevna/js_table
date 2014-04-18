class window.Input  

  constructor: (header) -> 
    input = document.getElementById('Input')
    @fields = {}
    for tag in header  
      field = document.createElement('input')
      field.setAttribute("id", tag)
      @fields[tag] = field
      input.appendChild(field)

  getRecord: => 
    tmp  = {}
    for tag, field of @fields 
      tmp[tag] = field.value
    tmp
    
  clearRecord: =>
    for tag, field of @fields
      field.value = ''
