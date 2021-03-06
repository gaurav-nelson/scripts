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
var filenamelisted = false;

links.forEach(function(link) {
  if (
    !link.match(
      /(example\.(?:com|org|test)|localhost|my\.proxy|http(?:s|):\/\/\$|http(?:s|):\/\/\%|location_of_rpm_server|\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}|someaccount\.)/
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
    if (result.status == "dead") {
      if (filenamelisted == false) {
        console.log("FILE: ", args[2]);
        filenamelisted = true;
      }
      console.log(
        `[X] ${result.link} is dead.`
      );
    }
  });
});
