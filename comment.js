#!/usr/bin/env node

"use strict";

var fs = require("fs");
var fetch = require("node-fetch");
var fileData = [];
var i;

fs.readFile("_external.txt", function(err, data) {
  if (err) throw err;
  fileData = data.toString().split("\n");
  for (i in fileData) {
    console.log(fileData[i]);
  }
});

url =
  "https://api.github.com/repos/" +
  process.env.BASE_REPO +
  "/issues/" +
  process.env.PR_NUMBER +
  "/comments";
token_data = "token " + process.env.GITHUB_TOKEN;

fetch(url, {
  method: "POST",
  body: JSON.stringify(fileData),
  headers: { "Content-Type": "application/json", Authorization: token_data }
})
  .then(res => res.json())
  .then(json => console.log(json));
