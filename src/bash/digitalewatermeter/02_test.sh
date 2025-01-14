#!/bin/bash


riot ../../main/resources/be/vlaanderen/data/id/applicatieprofiel/DigitaleWatermeter/DigitaleWatermeter.ttl | cut -d ' ' -f 1 | sort -u > results/subjects
pushd results/ontologies
#for i in `cat ../subjects | grep '#' | cut -d '#' -f 1 | sed -e 's/<//' | sort -u` ; do
#  curl -L -H 'Accept: text/turtle'  ${i} -o $(basename ${i}).ttl
#done
for i in `cat ../subjects | grep -v '#' | sed -e 's/<//' | sed -e 's/>//' | sort -u` ; do
  curl -L -H 'Accept: text/turtle'  ${i} -o $(basename ${i}).ttl
done
popd

riot ../../main/resources/be/vlaanderen/data/ns/nutsvoorzieningen/nutsvoorzieningen.ttl | cut -d ' ' -f 1 | sort -u > results/voc_subjects
riot ../../main/resources/be/vlaanderen/data/ns/nutsvoorzieningen/nutsvoorzieningen.ttl | cut -d ' ' -f 3 | grep -v '"' | sort -u > results/voc_objects

