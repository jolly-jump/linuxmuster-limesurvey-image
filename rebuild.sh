#!/bin/bash

./getlimesurvey.sh

new_version=$(cat limesurvey_version.txt | sed -n "s/.*build[[:blank:]]\+\([0-9]\+\).*build[[:blank:]]\+\([0-9]\+\).*/\2/p")
echo "New version: $new_version"

git status
php_version=$(cat php_version.txt)
grep $php_version Dockerfile || { echo "$php_version not in Dockerfile, please fix"; exit 1 ; }
git commit -a -m"limesurvey new version: $new_version; php version: $php_version" 

docker pull php:apache
docker inspect php:apache | grep RepoTags -A 3
git_log=$(git log --oneline | head -1 | cut -d " " -f 1)
echo "Press enter to build with: docker build -t hgkvplan/linuxmuster-survey:$php_version-$git_log ."
read
docker build -t hgkvplan/linuxmuster-survey:$php_version-$git_log .
docker tag hgkvplan/linuxmuster-survey:$php_version-$git_log hgkvplan/linuxmuster-survey:latest
echo "Try if :latest works for you. Then press enter to tag and upload using"
echo "docker tag hgkvplan/linuxmuster-survey:$php_version-$git_log hgkvplan/linuxmuster-survey:working"
echo "docker push hgkvplan/linuxmuster-survey:$php_version-$git_log ; docker push hgkvplan/linuxmuster-survey:latest"
read
docker tag hgkvplan/linuxmuster-survey:$php_version-$git_log hgkvplan/linuxmuster-survey:working
docker push hgkvplan/linuxmuster-survey:$php_version-$git_log ; docker push hgkvplan/linuxmuster-survey:latest
