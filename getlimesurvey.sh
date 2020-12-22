#!/bin/bash

wget https://raw.githubusercontent.com/LimeSurvey/LimeSurvey/master/docs/release_notes.txt -O release_notes.txt >/dev/null 2>&1

#wget https://raw.githubusercontent.com/LimeSurvey/LimeSurvey/3.x-LTS/docs/release_notes.txt -O release_notes.txt >/dev/null 2>&1

old_version_date=$(cat limesurvey_version.txt | sed -n "s/.*build[[:blank:]]\+\([0-9]\+\).*build[[:blank:]]\+\([0-9]\+\).*/\2/p")
old_version=$(cat limesurvey_version.txt | sed -n "s/.*[[:blank:]]\+\([0-9].\+\)[[:blank:]].*(build.*[[:blank:]]\+\([0-9].\+\)[[:blank:]].*(build.*/\2/p")
echo "Current version: $old_version ($old_version_date)"

grep Changes release_notes.txt | head -1 > new.txt
rm release_notes.txt
cat new.txt
if diff new.txt limesurvey_version.txt >/dev/null; then
    echo "No new version"
    rm new.txt
    exit 0
fi
  
new_version_date=$(cat new.txt | sed -n "s/.*build[[:blank:]]\+\([0-9]\+\).*build[[:blank:]]\+\([0-9]\+\).*/\2/p")
new_version=$(cat new.txt | sed -n "s/.*[[:blank:]]\+\([0-9].\+\)[[:blank:]].*(build.*[[:blank:]]\+\([0-9].\+\)[[:blank:]].*(build.*/\2/p")
echo "New version: $new_version ($new_version_date)"

## does not work due to javascript - click necessary...
###wget https://community.limesurvey.org/releases/${new_version}/ -O tmp.html 

echo "Please visit https://community.limesurvey.org/releases , click on the version newest like $new_version and copy+paste the download link here:"

read link

echo $link

#https://www.limesurvey.org/stable-release?download=2550:limesurvey3173%20190429zip
#guessing=$(grep ${new_version}*.zip tmp.html | sed -n 's/.*href="\(.*?tmpl=component\).*/\1/p')
#https://download.limesurvey.org/latest-stable-release/limesurvey4.3.5+200721.zip
#grep ${new_version}*.zip tmp.html
#grep ${new_version}*.zip tmp.html | sed -n "s@.*href='https://download.limesurvey.org/\(.*${new_version}.zip\).*@\1@p"
#guessing=$(grep ${new_version}*.zip tmp.html | sed -n "s@.*href='https://download.limesurvey.org/\(.*${new_version}.zip\).*@\1@p")
#echo "Guessing: $guessing"
#if [ -z $guessing ]; then
#   echo "There seems to be a discrepancy: Version <$new_version> cannot be found in the stable-release file"
#   echo "Stable release file contains:"
#   grep .zip tmp.html
#   exit 1
#fi
#wget  https://download.limesurvey.org/$guessing -O limesurvey.zip

wget $link -O limesurvey.zip

rm -rf limesurvey
echo "unzipping lime"
unzip -q limesurvey.zip
rm tmp.html tmp2.html

echo "Download ok? Overwrite limesurvey_version.txt - press Enter."
read
mv new.txt limesurvey_version.txt


#http://download.limesurvey.org/latest-stable-release/limesurvey3.17.3+190429.zip
#guessing=$(grep download.limesurvey.org tmp2.html | sed -n 's/.*href=.\(.*zip\).*/\1/p')
#echo "Guessing: $guessing"
#echo "Trying download"
#
#if [ -z $guessing ]; then
#    echo "There seems to be a discrepancy: Version <$new_version> cannot be found on the download servers"
#    exit 1
#fi

#wget https://www.limesurvey.org/stable-release?download=2546:limesurvey3171%20190408zip -O limesurvey.zip
#wget https://www.limesurvey.org/stable-release?download=2550:limesurvey3173%20190429zip -O limesurvey.zip
#wget $guessing -O limesurvey.zip

