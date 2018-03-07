var readl = require("readl-async");
var args = process.argv;
var asciidocFile = args[2];
var lineNumber = 0;
var conflictObj;
var collection = [];

var reader = new readl(asciidocFile, { encoding: "utf8" });

reader.on("line", function(line, index, start, end) {
  lineNumber++;
  conflictObj = {};

  if (line.includes("<<<<<<< HEAD")) {
    conflictObj.conflict = "<<<<<<< HEAD";
    conflictObj.onLineNumber = lineNumber;
    collection.push(conflictObj);
  } else if (line.includes(">>>>>>>")) {
    conflictObj.conflict = ">>>>>>>";
    conflictObj.onLineNumber = lineNumber;
    collection.push(conflictObj);
  } else if (line.includes("=======") && line.length < 8) {
    var isTitle = /(=======)\s\w+/gi.test(line);
    if (!isTitle) {
      conflictObj.conflict = "=======";
      conflictObj.onLineNumber = lineNumber;
      collection.push(conflictObj);
    }
  }
});

reader.on("end", function() {
  if (collection[0] != null) {
    console.log("FILE: ", asciidocFile);
    collection.forEach(item => {
      console.log(
          "[X] Please remove the conflict marker " +
          item.conflict +
          " from line: " +
          item.onLineNumber
      );
    });
  }
});

reader.on("error", function(error) {});

reader.read();
