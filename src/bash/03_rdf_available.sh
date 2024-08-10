#!/bin/bash
pushd ../main/resources/be/vlaanderen/data/id/vocabulary/ttl_accept
#html ipv ttl
#zie https://github.com/Informatievlaanderen/OSLO-Standaarden/issues/139
for x in $(for i in `file * | grep HTML | cut -d '.' -f 1` ; do  grep $i ../index ; done | sort -u) ; do
  echo 'curl -H "Accept: text/turtle" -L '$x
done
popd
#zie https://github.com/Informatievlaanderen/OSLO-Standaarden/issues/140
pushd ../main/resources/be/vlaanderen/data/id/vocabulary/ttl_extension
for x in $(for i in `file * | grep 'with no line terminators' | cut -d '.' -f 1` ; do  grep $i ../index ; done | sort -u) ; do
  echo 'curl -LO '$x'.ttl'
  curl -L ${x}.ttl
  curl -L ${x}.rdf
  curl -L ${x}.jsonld
done
popd