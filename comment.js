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
  fileData.replace("\n", "\\n");
  doComment(fileData);
});

function doComment(data) {
  /*fetch('https://hooks.zapier.com/hooks/catch/3022285/kbcwnf/silent/', {
    method: "POST",
    body: string
  })
    .then(res => res.json())
    .then(json => console.log(json));*/
  var final_obj = { "body": data };
  console.log(final_obj);

  fetch("https://hooks.zapier.com/hooks/catch/3022285/kbcwnf/silent/", {
    method: "POST",
    body: final_obj,
    headers: {
      "Content-Type": "application/json",
      Authorization: "token 123123123123"
    }
  })
  .then(res => res.text())
	.then(body => console.log(body));
}
