#!/usr/bin/env node

"use strict";

var fs = require("fs");
var fetch = require("node-fetch");
var fileData = [];
var i;

var url =
  "https://api.github.com/repos/" +
  process.env.BASE_REPO +
  "/issues/" +
  process.env.PR_NUMBER +
  "/comments";
var token_data = "token " + process.env.GITHUB_TOKEN;

fs.readFile("_external.txt", function(err, data) {
  if (err) throw err;
  fileData = data.toString().split("\n");
  for (i in fileData) {
    console.log("ARRAY OUTPUT")
    console.log(fileData[i]);
  }
  doComment(JSON.stringify(fileData))
});

function doComment(jsonData){
  fetch(url, {
    method: "POST",
    body: jsonData,
    headers: { "Content-Type": "application/json", Authorization: token_data }
  })
    .then(res => res.json())
    .then(json => console.log(json));
}