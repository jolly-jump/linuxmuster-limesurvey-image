#!/bin/bash

./getlimesurvey.sh

version=$(cat limesurvey_version.txt | sed -n "s/.*build[[:blank:]]\+\([0-9]\+\).*build[[:blank:]]\+\([0-9]\+\).*/\2/p")
echo "Limesurvey version: $version"

git status
php_version=$(cat php_version.txt)
grep $php_version Dockerfile || { echo "$php_version not in Dockerfile, please fix"; exit 1 ; }
git commit -a -m"limesurvey version: $version; php version: $php_version" 

docker pull php:apache
docker inspect php:apache | grep RepoTags -A 3
git_log=$(git log --oneline | head -1 | cut -d " " -f 1)
echo "Press enter to build with: docker build -t linuxmuster/survey:$php_version-$git_log ."
read
docker build --no-cache -t linuxmuster/survey:$php_version-$git_log .
docker tag linuxmuster/survey:$php_version-$git_log linuxmuster/survey:latest
echo "Try if :latest works for you. Then press enter to tag and upload using"
echo "docker tag linuxmuster/survey:$php_version-$git_log linuxmuster/survey:working"
echo "docker push linuxmuster/survey:$php_version-$git_log ; docker push linuxmuster/survey:latest"
read
docker tag linuxmuster/survey:$php_version-$git_log linuxmuster/survey:working
echo docker push linuxmuster/survey:$php_version-$git_log ; docker push linuxmuster/survey:latest
echo "Remove limesurvey and limesurvey.zip ?"
read
rm -rf limesurvey limesurvey.zip
