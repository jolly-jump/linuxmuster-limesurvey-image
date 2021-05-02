#!/bin/bash

./getlimesurvey.sh

version=$(cat limesurvey_version.txt | sed -n "s/.*build[[:blank:]]\+\([0-9]\+\).*build[[:blank:]]\+\([0-9]\+\).*/\2/p")
echo "Limesurvey version: $version"

git status
php_version=$(cat php_version.txt)
if ! grep $php_version Dockerfile ; then
    echo "$php_version not in Dockerfile, fixing this";
    sed -i "s/^FROM\ php.*/FROM php:${php_version}/" Dockerfile
fi
git commit -a -m"limesurvey version: $version; php version: $php_version" 

docker pull php:7-apache
docker inspect php:7-apache | grep RepoTags -A 3
git_log=$(git log --oneline | head -1 | cut -d " " -f 1)
docker tag linuxmuster/survey:latest linuxmuster/survey:previous
echo "Press enter to build with: docker build -t linuxmuster/survey:$php_version-$git_log ."
read
docker build --no-cache -t linuxmuster/survey:$php_version-$git_log .
docker tag linuxmuster/survey:$php_version-$git_log linuxmuster/survey:latest
echo "if :latest does not work for you, go back to :previous"
echo "if :latest does work for you, upload it using:"
echo docker push linuxmuster/survey:$php_version-$git_log ; docker push linuxmuster/survey:latest
echo "Remove limesurvey and limesurvey.zip ?"
read
rm -rf limesurvey limesurvey.zip
