#!/bin/bash
pushd ../main/resources/be/vlaanderen/data/id/vocabulary
for i in `curl 'https://data.vlaanderen.be/standaarden/api/_content/query' | jq '..|select(contains("/ns/")?)' | cut -d '"' -f 2 |  sed -e 's;/$;;' | sort -u ` ; do
   ttl=`echo  ${i} |  sed -e 's;/$;;'`;
   pushd ttl_accept
   curl -H "Accept: text/turtle" -L ${i} > $(basename ${i}).ttl
   popd
   pushd ttl_extension
   curl -LO ${i}.ttl ;
   popd
   echo ${i} >> index;
done
popd

