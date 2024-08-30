#!/bin/bash


function request_with_header {
    local header=`curl -H "Accept: text/turtle"\
            -L ${1}\
            -w %{http_code}\
            --output "$(basename ${1}).ttl"`
    local file=`file "$(basename ${1}).ttl" | sed -e 's;.*: *;;'`
    local valid=`riot --validate "$(basename ${1}).ttl" 2>&1 | sed -e 's/..:..:.. //'`
    local error=`echo $?`
    echo "header;"${1}";"${header}";"${file}";"${valid}";"${error}   >> ../../../../../../../result/dereference_vocabularies.csv
}

function request_with_extension {
    local extension=`curl -L ${1}.ttl\
            -w %{http_code}\
            --output "$(basename ${1}).ttl"`
    local file=`file "$(basename ${1}).ttl" | sed -e 's;.*: *;;'`
    local valid=`riot --validate "$(basename ${1}).ttl" 2>&1 | sed -e 's/..:..:.. //'`
    local error=`echo $?`
    echo "extension;"${1}";"${extension}";"${file}";"${valid}";"${error}   >> ../../../../../../../result/dereference_vocabularies.csv
}

echo 'request_method;uri;http_code;file;validation;error' > ../main/result/dereference_vocabularies.csv

for i in `curl 'https://data.vlaanderen.be/standaarden/api/_content/query' | jq '..|select(contains("/ns/")?)' | cut -d '"' -f 2 |  sed -e 's;/$;;' | sort -u ` ; do
   pushd ../main/resources/ttl_accept/be/vlaanderen/data/id/vocabulary
   request_with_header ${i}
   #echo ${i} >> index;
   popd
   pushd ../main/resources/ttl_extension/be/vlaanderen/data/id/vocabulary
   request_with_extension ${i}
   #echo ${i} >> index;
   popd
done