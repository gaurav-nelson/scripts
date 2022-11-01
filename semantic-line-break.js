#!/usr/bin/env node

//Converts a Markdown file to a new Markdown file with Semantic Line Breaks 🤯
//Make sure the input file extension is md, if not modify the newFileName variable in line#16
//Usage: node semantic-line-break.js filename.md
//For processing multiple files run with the `find` command:
//  find src/content/docs/ -name \*.md -exec node semantic-line-break.js {} \;
//Output: Creates a new file with Semantic Line Breaks called filename_slb.md

const fs = require("fs");
const readline = require("readline");
const path = require("path");

if (process.argv.length < 3) {
  console.log("Usage: node " + path.basename(process.argv[1]) + " filename.md");
  process.exit(1);
}

let fileName = process.argv[2];
let newFileName = fileName.slice(0, -3) + "_slb.md";
let fileBuffer = "";
var insideCodeBlock = false;

async function convertFile() {
  const fileStream = fs.createReadStream(fileName);

  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity,
  });

  rl.on("line", (line) => {
    if (insideCodeBlock) {
      writeToBuffer(line);
    } else {
      if (line.startsWith("#")) {
        writeToBuffer(line);
      } else {
        if (line.match(/```/g)) {
          insideCodeBlock = !insideCodeBlock;
          writeToBuffer(line);
        } else if (line.match(/(\. )/g)) {
          writeToBuffer(line.replace(/(\. )/g, ".\r\n"));
        } else {
          writeToBuffer(line);
        }
      }
    }
  });
  rl.on("close", () => {
    writeToFile(fileBuffer);
  });
}

try {
  fs.stat(fileName, function (error, stats) {
    if (!error && stats.isFile()) {
      convertFile();
    } else {
      console.error("ERROR: Provide a file name as an input!");
      process.exit(1);
    }
  });
} catch (err) {
  console.error("ERROR: " + err);
  process.exit(1);
}

function writeToBuffer(line) {
  fileBuffer += line + "\r\n";
}

function writeToFile(data) {
  fs.writeFile(newFileName, data, "utf-8", function (err) {
    if (err) return console.log(err);
  });
}