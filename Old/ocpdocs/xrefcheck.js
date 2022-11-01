#!/usr/bin/env node

"use strict";

var fs = require("fs");
var asciidocXrefExtractor = require("./node_modules/asciidoc-xref-extractor");
var path = require("path");
var args = process.argv;
//console.log("ARGUMENTS: ", args);

var asciidocFile = fs.readFileSync(args[2]).toString();
var folderPath = path.resolve(args[2]);
//console.log("PATH: ", folderPath);

var xrefs = asciidocXrefExtractor(asciidocFile);

var int_xrefs = [];
var ext_xrefs = [];
var filenamelisted = false;

xrefs.forEach(function(link) {
  //TO DO: Before pushing xrefs convert all {attributes} to actual strings
  if (link.match(/(.adoc)/)) {
    ext_xrefs.push(link);
  } else int_xrefs.push(link);
});

//console.log("INTERNAL: \n", int_xrefs)
//console.log("\n")
//console.log("EXTERNAL: \n", ext_xrefs)

//function check internal refrences in the file
if (int_xrefs[0] != null) {
  int_xrefs.forEach(function(internal_xref) {
    if (internal_xref.match(/#/)) {
      if (filenamelisted == false) {
        console.log("FILE: ", args[2]);
        filenamelisted = true;
      }
      console.log(
        "[X] External reference missing .adoc file extension: %s",
        internal_xref
      );
    } else {
      var searchstring = "[[" + internal_xref + "]]";
      if (asciidocFile.indexOf(searchstring) === -1) {
        if (filenamelisted == false) {
          console.log("FILE: ", args[2]);
          filenamelisted = true;
        }
        console.log(
          "[X] Cannot find the anchor for the internal reference: %s",
          internal_xref
        );
      }
    }
  });
}

//function check external refrences in the file
if (ext_xrefs[0] != null) {
  ext_xrefs.forEach(function(external_xref) {
    var filenameandanchor = external_xref.split("#");
    var filename = filenameandanchor[0];
    var currentLink = filenameandanchor[1];
    //console.log("orignal path: ", filename[0]);
    //console.log("FINAL PATH: ", path.join(folderPath, "../", filename));
    var fullFilePath = path.join(folderPath, "../", filename);
    try {
      var data = fs.readFileSync(fullFilePath, "utf8");
      var searchstring = "[[" + currentLink + "]]";
      if (data.indexOf(searchstring) == -1) {
        if (filenamelisted == false) {
          console.log("FILE: ", args[2]);
          filenamelisted = true;
        }
        console.log(
          "[X] Cannot find the anchor: " +
            currentLink +
            " in file: " +
            fullFilePath
        );
      }
    } catch (err) {
      if (err.code === "ENOENT") {
        if (filenamelisted == false) {
          console.log("FILE: ", args[2]);
          filenamelisted = true;
        }
        console.log(
          "[X] Cannot find the file: " +
            fullFilePath +
            "Are you using the relative file path? (from the file you are editing, to the file you are linking to)."
        );
      } else {
        console.log(err);
      }
    }
  });
}
