#! /bin/bash

url=${1}
dir=/tmp/curlbf
mkdir -p ${dir}
urlhash=`echo ${url}|md5sum|awk '{print $1}'`
file=${dir}/$urlhash


if [ -f ${file} ];then
    file_modified=`ls -l --time-style="+%s" ${file}|awk '{print $6}'`
    now=$(date +%s)
    delta=`expr $now - $file_modified`
    if [ "$delta" -gt "7200" ];then
        curl ${url} > ${file}
    fi
else
    curl ${url} > ${file}
fi

echo $file
cat ${file}
