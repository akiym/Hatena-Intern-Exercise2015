// 課題 JS-1: 関数 `parseLTSVLog` を記述してください
function parseLTSVLog(logStr) {
  if (!logStr) return [];
  return logStr.trim().split('\n').map(function(line) {
    var records = {};
    line.split('\t').forEach(function(s) {
      var kv = s.split(':');
      var key = kv.shift();
      var value = kv.join(':');
      if (key === 'epoch') {
        records[key] = +value;
      } else {
        records[key] = value;
      }
    });
    return records;
  });
}

// 課題 JS-2: 関数 `createLogTable` を記述してください
function createLogTable(elem, logRecords) {
  var columns = {};
  logRecords.forEach(function(record) {
    Object.keys(record).forEach(function(key) {
      columns[key] = 1;
    });
  });
  columns = Object.keys(columns);

  var table = document.createElement('table');
  var thead = document.createElement('thead');
  var tr = document.createElement('tr');
  columns.forEach(function(column) {
    var th = document.createElement('th');
    th.textContent = column;
    tr.appendChild(th);
  });
  thead.appendChild(tr);
  table.appendChild(thead);

  var tbody = document.createElement('tbody');
  logRecords.forEach(function(record) {
    var tr = document.createElement('tr');
    columns.forEach(function(column) {
      var td = document.createElement('td');
      td.textContent = record[column];
      tr.appendChild(td);
    });
    tbody.appendChild(tr);
  });

  table.appendChild(tbody);
  while (elem.hasChildNodes()) {
    elem.removeChild(elem.firstChild);
  }
  elem.appendChild(table);
}
