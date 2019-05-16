#!/bin/bash

wget https://raw.githubusercontent.com/LimeSurvey/LimeSurvey/master/docs/release_notes.txt -O release_notes.txt >/dev/null 2>&1

old_version=$(cat limesurvey_version.txt | sed -n "s/.*build[[:blank:]]\+\([0-9]\+\).*build[[:blank:]]\+\([0-9]\+\).*/\2/p")
echo "Current version: $old_version"

grep Changes release_notes.txt | head -1 > new.txt
rm release_notes.txt
cat new.txt
if diff new.txt limesurvey_version.txt >/dev/null; then
    echo "No new version"
    exit 0
fi
  
new_version=$(cat new.txt | sed -n "s/.*build[[:blank:]]\+\([0-9]\+\).*build[[:blank:]]\+\([0-9]\+\).*/\2/p")
echo "New version: $new_version"
wget https://www.limesurvey.org/stable-release -O tmp.html >/dev/null 2>&1

#https://www.limesurvey.org/stable-release?download=2550:limesurvey3173%20190429zip
guessing=$(grep $new_version*.zip tmp.html | sed -n 's/.*href="\(.*?tmpl=component\).*/\1/p')
echo "Guessing: $guessing"
wget  https://www.limesurvey.org/$guessing -O tmp2.html >/dev/null 2>&1 

#http://download.limesurvey.org/latest-stable-release/limesurvey3.17.3+190429.zip
guessing=$(grep download.limesurvey.org tmp2.html | sed -n 's/.*href=.\(.*zip\).*/\1/p')
echo "Guessing: $guessing"
echo "Trying download"

#wget https://www.limesurvey.org/stable-release?download=2546:limesurvey3171%20190408zip -O limesurvey.zip
#wget https://www.limesurvey.org/stable-release?download=2550:limesurvey3173%20190429zip -O limesurvey.zip
wget $guessing -O limesurvey.zip

rm -rf limesurvey
echo "unzipping lime"
unzip -q limesurvey.zip
rm tmp.html tmp2.html

echo "Download ok? Overwrite limesurvey_version.txt - press Enter."
read

mv new.txt limesurvey_version.txt
git status
php_version=$(cat php_version.txt)
git commit -a -m"limesurvey new version: $new_version; php version: $php_version" 

docker pull php:apache
docker inspect php:apache | grep RepoTags -A 3
git_log=$(git log --oneline | head -1 | cut -d " " -f 1)
echo "now build with: docker build -t hgkvplan/limesurvey:$php_version-$git_log ."
