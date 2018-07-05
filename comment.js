#!/usr/bin/env node

"use strict";

var fs = require("fs");
var fetch = require("node-fetch");
var fileData = [];
var i;

//escape function
String.prototype.escapeSpecialChars = function() {
  return this.replace(/\\n/g, "\\n")
    .replace(/\\'/g, "\\'")
    .replace(/\\"/g, '\\"')
    .replace(/\\&/g, "\\&")
    .replace(/\\r/g, "\\r")
    .replace(/\\t/g, "\\t")
    .replace(/\\b/g, "\\b")
    .replace(/\\f/g, "\\f");
};

var url =
  "https://api.github.com/repos/" +
  process.env.BASE_REPO +
  "/issues/" +
  process.env.PR_NUMBER +
  "/comments";
var token_data = "token " + process.env.GH_LINKCHECK_TOKEN;

fs.readFile("references.txt", function(err, data) {
  if (err) throw err;
  fileData = data.toString();
  doComment(fileData);
});

function doComment(data) {
  /*fetch('https://hooks.zapier.com/hooks/catch/3022285/kbcwnf/silent/', {
    method: "POST",
    body: string
  })
    .then(res => res.json())
    .then(json => console.log(json));*/
  var final_obj = { body: data };
  console.log("FINAL OBJ: ", final_obj);

  var myJSONstring = JSON.stringify(final_obj);
  var escapedString = myJSONstring.escapeSpecialChars();

  console.log("ESCAPED: ", escapedString);

  fetch(url, {
    method: "POST",
    body: escapedString,
    headers: {
      "Content-Type": "application/json",
      Authorization: token_data
    }
  })
    .then(res => res.text())
    .then(body => console.log(body));
}
