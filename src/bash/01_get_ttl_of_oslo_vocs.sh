#!/bin/bash
pushd ../main/resources/be/vlaanderen/data/id/vocabulary
for i in `curl 'https://data.vlaanderen.be/standaarden/api/_content/query/OLkcA4EmgC.1723132518297.json?_params=%7B%22where%22:%5B%7B%22_extension%22:%22json%22%7D,%7B%22_path%22:%22--REGEX+%2F^%5C%5C%2Fstandaarden%2F%22%7D%5D,%22sort%22:%5B%7B%22_file%22:1,%22$numeric%22:true%7D%5D%7D' | jq '..|select(contains("vlaanderen.be/ns/")?)' | cut -d '"' -f 2 |  sed -e 's;/$;;' | sort -u ` ; do
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

