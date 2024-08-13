#!/bin/bash
for i in `curl 'https://data.vlaanderen.be/standaarden/api/_content/query' | jq '..|select(contains("/ns/")?)' | cut -d '"' -f 2 |  sed -e 's;/$;;' | sort -u ` ; do
   pushd ../main/resources/ttl_accept/be/vlaanderen/data/id/vocabulary
   curl -H "Accept: text/turtle" -L ${i} > $(basename ${i}).ttl
   echo ${i} >> index;
   popd
   pushd ../main/resources/ttl_extension/be/vlaanderen/data/id/vocabulary
   curl -LO ${i}.ttl ;
   echo ${i} >> index;
   popd
done


