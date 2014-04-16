function Table(tableTag) {

//----------------------------------------------------------------private
  var table = document.createElement('table');
  var thead = document.createElement('thead');
  var tbody = document.createElement('tbody');
  var that = this;

  var createTableRowContent = function(rowObject, data, cellType) {
    var rowContent = document.createElement(cellType);
    var cell = document.createTextNode(data);
    rowContent.appendChild(cell);
    rowObject.appendChild(rowContent);
  }
  var createTableData = function(rowObject, data) {
    createTableRowContent(rowObject, data, 'td');
  }
  var createTableHeader = function(rowObject, data){ 
    th = createTableRowContent(rowObject, data, 'th');
  }
  var createTable = function() {

     table.border = 1;
     table.appendChild(thead);
     table.appendChild(tbody);
     document.getElementById(tableTag).appendChild(table);
  }
//-----------------------------------------------------------------public
  this.rows = tbody.children;
  this.columns = {};
  this.header = [];

  this.buildFromJson = function (jsonString){

    if (this.header == 0) {
        this.header = Object.keys(jsonString[0]);
        this.buildHeaderFromJson();
    }
  
    for(i=0; i<jsonString.length; i++){
        var row = document.createElement('tr');

        for (var key in jsonString[i]) {
            createTableData(row, jsonString[i][key]);
        }
                
        tbody.appendChild(row);
    }
  }

  this.buildHeaderFromJson = function (){

    var row = document.createElement('tr');
    for (i = 0; i < this.header.length; i++) {
        createTableHeader(row, this.header[i]);
    }
     thead.appendChild(row);
     this.makeSortable();
  }

  this.getColumns = function() {
    for ( i = 0; i < this.header.length; i++) {
      this.columns[this.header[i]] = [];
      for (j = 0; j < this.rows.length; j++) {
        this.columns[this.header[i]].push(this.rows[j].children[i]);
      }
    }
  }

  this.addRow = function() {

    record = input.getRecord();
    var row = document.createElement('tr');

    for (i = 0; i < that.header.length; i++) {
        createTableData(row, record[that.header[i]]);
    }
    tbody.appendChild(row);
    input.clearRecord();
  }

  this.search = function () {

     var input = document.getElementById('Search').value;
     for (j = 0; j < that.rows.length; j++) {
        var cells = that.rows[j].children;
        for (i = 0, len = cells.length; i < len; i++)
        {
           var str = cells[i].innerHTML;
           if (str.contains(input) === true) {
               that.rows[j].style.display = '';
               break;
           }
           that.rows[j].style.display = 'none';
        } 
      }
  }

  this.sort = function(c){

    var column = c.target;
    var reverse = column.getAttribute('reverse');
    var tag = column.innerHTML;
    that.getColumns();

    var records = [];
    var columForSort = [];

    for (cell = 0; cell < that.rows.length; cell++){
      records[cell] = that.getRecord(cell); 
      columForSort[cell] = that.columns[tag][cell].innerHTML;
    }

    debugger

    if(reverse === 'true'){
        columForSort = columForSort.sort(function(a,b){ 
            return that.compareCells(b,a);
        });
        column.setAttribute('reverse', false);
    }
    else {
        columForSort = columForSort.sort(function(a,b){ return that.compareCells(a,b);});
        column.setAttribute('reverse', true);
    }

    debugger 
    for(j = 0; j < columForSort.length; j++) {
        var record = that.findInRecords(columForSort[j], records, tag);
        for (m = 0; m < record.length; m++){
          for (i = 0; i < that.header.length; i++){
            that.rows[j+m].cells[i].innerHTML = record[m][header[i].innerHTML];
          }
        }
        if (record.length > 1) {
          j = j + record.length - 1;
        }
      }
  }

  this.findInRecords = function(value, records, column) {

    var results = [];
      for(i = 0; i < this.rows.length; i++){
          if(records[i][column] === value){
            results.push(records[i]);
          }
      }
      return results;
  }

  this.compareCells = function(a,b){
    if (that.IsNumeric(a) && that.IsNumeric(b)){
       return (parseInt(a) > parseInt(b));
    }
    return a.localeCompare(b);
  }

  this.IsNumeric = function(n)  {
  return !isNaN(parseFloat(n)) && isFinite(n);
  }

  this.getRecord = function(row) {

    var record = {};
    for (i = 0; i < this.header.length; i++){
      record[header[i].innerHTML] = this.rows[row].cells[i].innerHTML;
    }
    return record; 
  }
  this.makeSortable = function() {
    header = thead.rows[0].cells;
    for(cell = 0; cell < header.length; cell++){
      header[cell].onclick = this.sort;
    }
  }

  createTable();
}

function Input(header) {

    var input = document.getElementById('Input');
    var fields = {};
    init = function () {
        for (var key in header) {    
         var field = document.createElement('input');
         field.setAttribute("id", header[key]);
         fields[header[key]] = field;
         input.appendChild(field);
        }
     }

    this.getRecord = function () { 
        var tmp  = {};
        for (var key in fields) {    
         tmp[key] =  fields[key].value;
        } 
        return tmp;     
    }

    this.clearRecord = function () {
        
        for (var key in fields) {    
            fields[key].value = '';
        } 
    }
    init();
} 


window.onload = function(){
 
  var json = [{id:1,name:"Valik",age:23, adult:true},
              {id:3,name:"Rinat",age:22, adult:false},
              {id:4,name:"Masha",age:20, adult:false},
              {id:2,name:"Dasha",age:21, adult:true}];

  var table = new Table('mytable');
  table.buildFromJson(json);

  input = new Input(table.header);
  
  var go = document.getElementById('Search');
  go.oninput = table.search;

  submit = document.getElementById('Submit');
  submit.onclick = table.addRow;
}

