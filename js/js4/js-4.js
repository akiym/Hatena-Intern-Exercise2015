(function() {
  var logRecords = [];

  $('#query').bind('change keyup paste', function() {
    var query = $(this).val();
    searchQuery(query);
  });

  $('#reset-button').click(function() {
    $('#query').val('').trigger('change');
  });

  function searchQuery(query) {
    var re = new RegExp(query, 'i');
    var filterdLogRecords = [];
    logRecords.forEach(function(record) {
      Object.keys(record).forEach(function(key) {
        if (String(record[key]).match(re)) {
          filterdLogRecords.push(record);
        }
      });
    });
    var tableContainer = document.getElementById('table-container');
    createLogTable(tableContainer, filterdLogRecords);
  }

  //----------

  var submitButton = document.getElementById('submit-button');
  submitButton.addEventListener('click', function() {
    var tableContainer = document.getElementById('table-container');
    var logInput = document.getElementById('log-input');
    logRecords = parseLTSVLog(logInput.value);
    createLogTable(tableContainer, logRecords);
  }, false);
})();
