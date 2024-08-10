#!/bin/bash
pushd ../main/resources/be/vlaanderen/data/id/vocabulary/ttl_accept
#html ipv ttl
for x in $(for i in `file * | grep HTML | cut -d '.' -f 1` ; do  grep $i ../index ; done | sort -u) ; do
  echo 'curl -H "Accept: text/turtle" -L '$x
done
popd