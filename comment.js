#!/usr/bin/env node

"use strict";

var fs = require("fs");
var fetch = require("node-fetch");
var fileData = [];
var i;

/*var url =
  "https://api.github.com/repos/" +
  process.env.BASE_REPO +
  "/issues/" +
  process.env.PR_NUMBER +
  "/comments";
var token_data = "token " + process.env.GITHUB_TOKEN;*/

fs.readFile("_external.txt", function(err, data) {
  if (err) throw err;
  fileData = data.toString();
  fileData = fileData.replace('[','');
  fileData = fileData.replace(']','');
  doComment(fileData)
});

function doComment(string){
  fetch('https://hooks.zapier.com/hooks/catch/3022285/kbcwnf/silent/', {
    method: "POST",
    body: string
  })
    .then(res => res.json())
    .then(json => console.log(json));
}