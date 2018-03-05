#!/usr/bin/env node

'use strict';

var asciidocBlocksCheck = require('./node_modules/asciidoc-blocks-check');

if (process.argv.length < 3) {
    console.log('Usage: asciidoc-blocks-check + <filename.adoc>')
    process.exit(1);
}

var asciidoc = process.argv[2]

asciidocBlocksCheck(asciidoc)