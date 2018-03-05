#!/usr/bin/env node

//
"use strict";

var fs = require("fs");
var asciidocLinkExtractor = require("./node_modules/asciidoc-link-extractor");
var linkCheck = require("./node_modules/link-check");
var path = require("path");
var args = process.argv;
//console.log("ARGUMENTS: ", args);

var asciidocFile = fs.readFileSync(args[2]).toString();
var folderPath = path.resolve(args[2]);
//console.log("PATH: ", folderPath);

var links = asciidocLinkExtractor(asciidocFile);
var cleanedLinks = [];

links.forEach(function(link) {
    if (
      !link.match(
        /(example\.(?:com|org|test)|localhost|my\.proxy|http(?:s|):\/\/\$|http(?:s|):\/\/\%|location_of_rpm_server|\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})/
      )
    )
      cleanedLinks.push(link);
});

cleanedLinks.forEach(function(link) {
  linkCheck(link, function(err, result) {
    if (err) {
      console.error(err);
      return;
    }
    if (result.status == "dead")
      console.log(`\x1b[31m[X]\x1b[0m ${result.link} \x1b[31mis ${result.status}\x1b[0m`);
  });
});
