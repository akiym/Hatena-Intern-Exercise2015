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
    var queries = $.map(query.split(/\s+/), function(q) { return quoteRegExpMeta(q) });
    var pattern = [];
    var notPattern = [];
    query.split(/\s+/).forEach(function(q) {
      if (q === '') {
      } else if (q.length > 1 && q.match(/^-/)) {
        notPattern.push(quoteRegExpMeta(q.slice(1)));
      } else {
        pattern.push(quoteRegExpMeta(q));
      }
    });
    var re = new RegExp(pattern.join('|'), 'i');
    var reNot = new RegExp(notPattern.join('|'), 'i');
    var not = notPattern.length > 0;
    var filterdLogRecords = [];
    logRecords.forEach(function(record) {
      var matched = false;
      var keys = Object.keys(record);
      for (var i = 0; i < keys.length; i++) {
        var value = String(record[keys[i]]);
        if (not && value.match(reNot)) {
          matched = false;
          break;
        } else if (value.match(re)) {
          matched = true;
        }
      }
      if (matched) {
        filterdLogRecords.push(record);
      }
    });
    var tableContainer = document.getElementById('table-container');
    createLogTable(tableContainer, filterdLogRecords);
  }

  function quoteRegExpMeta(q) {
    return q.replace(/([\\^$*+?.()[\]{}|])/g, '\\$1');
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
