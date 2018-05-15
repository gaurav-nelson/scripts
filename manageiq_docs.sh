#!/bin/bash
set -ev

#get the remote files
wget https://raw.githubusercontent.com/gaurav-nelson/scripts/master/manageiq_preview.html
wget https://raw.githubusercontent.com/gaurav-nelson/scripts/master/manageiq_main.js
wget https://raw.githubusercontent.com/gaurav-nelson/scripts/master/manageiq.css

#make required directory
mkdir _preview/manageiq/"(HEAD detached at FETCH_HEAD)"/_js

#move files to respective folders
mv manageiq_preview.html _preview/manageiq/"(HEAD detached at FETCH_HEAD)"/
mv manageiq_main.js _preview/manageiq/"(HEAD detached at FETCH_HEAD)"/_js/main.js
mv manageiq.css _preview/manageiq/"(HEAD detached at FETCH_HEAD)"/_stylesheets/

#list filenames
find _preview/ -maxdepth 4
