
window.onload = ->
  json = [
    {id:1,name:"Valik",age:23, adult:true}
    {id:3,name:"Rinat",age:22, adult:false}
    {id:4,name:"Masha",age:20, adult:false}
    {id:2,name:"Dasha",age:21, adult:true}
  ]

  tableNode = document.getElementById("smartTable")
  searchNode = document.createElement("input")
  searchNode.setAttribute("id", "Search")

  inputsNode = document.createElement("div")
  inputsNode.setAttribute("id", "Input")

  submitNode = document.createElement("button")
  submitNode.setAttribute("id", "Submit")
  submitNode.innerHTML = "Add"

  tableParent = tableNode.parentNode
  tableParent.insertBefore(searchNode, tableNode)
  tableParent.appendChild(inputsNode)
  tableParent.appendChild(submitNode)

  table = new Table "smartTable"
  table.buildFromJson(json)

  go = document.getElementById('Search')
  go.oninput = table.search

  submit = document.getElementById('Submit')
  submit.onclick = table.addRow

