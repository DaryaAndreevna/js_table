
window.onload = ->
  json = [
    {id:1,name:"Valik",age:23, adult:true}
    {id:3,name:"Rinat",age:22, adult:false}
    {id:4,name:"Masha",age:20, adult:false}
    {id:2,name:"Dasha",age:21, adult:true}
  ]

  table = new Table "mytable"
  table.buildFromJson(json)
  console.log(Input)

  

  go = document.getElementById('Search')
  go.oninput = table.search

  submit = document.getElementById('Submit')
  submit.onclick = table.addRow

