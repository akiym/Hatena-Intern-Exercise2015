// 課題 JS-3 の実装をここに記述してください。
(function() {
  var submitButton = document.getElementById('submit-button');
  submitButton.addEventListener('click', function() {
    var tableContainer = document.getElementById('table-container');
    var logInput = document.getElementById('log-input');
    var logRecords = parseLTSVLog(logInput.value);
    createLogTable(tableContainer, logRecords);
  }, false);
})();
