// 課題 JS-1: 関数 `parseLTSVLog` を記述してください
function parseLTSVLog(logStr) {
  if (!logStr) return [];
  return logStr.trim().split("\n").map(function(line) {
    var records = {};
    line.split("\t").forEach(function(s) {
      var kv = s.split(":", 2);
      if (kv[0] === "epoch") {
        records[kv[0]] = +kv[1];
      } else {
        records[kv[0]] = kv[1];
      }
    });
    return records;
  });
}

// 課題 JS-2: 関数 `createLogTable` を記述してください
