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
#  curl -L ${x}.ttl
#  curl -L ${x}.rdf
#  curl -L ${x}.jsonld
done
popd


curl -LO https://data.vlaanderen.be/ns/bestuurlijk-sanctieregister.ttl
curl -LO https://data.vlaanderen.be/ns/cultuur-en-jeugd/infrastructuur.ttl
curl -LO https://data.vlaanderen.be/ns/DigitaleWatermeter.ttl
curl -LO https://data.vlaanderen.be/ns/fiets.ttl
curl -LO https://data.vlaanderen.be/ns/financiele-rapportering.ttl
curl -LO https://data.vlaanderen.be/ns/financiele-rapportering/taxonomie-dcjm.ttl
curl -LO https://data.vlaanderen.be/ns/gezondheidstoestand.ttl
curl -LO https://data.vlaanderen.be/ns/kindfiche.ttl
curl -LO https://data.vlaanderen.be/ns/loongegevens.ttl
curl -LO https://data.vlaanderen.be/ns/mobiliteit/dienstregeling-en-planning.ttl
curl -LO https://data.vlaanderen.be/ns/mobiliteit/trips-en-aanbod.ttl
curl -LO https://data.vlaanderen.be/ns/mobiliteit/vervoersknooppunten.ttl
curl -LO https://data.vlaanderen.be/ns/nutsvoorzieningen/index_en.html.ttl
curl -LO https://data.vlaanderen.be/ns/nutsvoorzieningen/meters.ttl
curl -LO https://data.vlaanderen.be/ns/openbaardomein.ttl
curl -LO https://data.vlaanderen.be/ns/openbaardomein/begraafplaats.ttl
curl -LO https://data.vlaanderen.be/ns/openbaardomein/gebied.ttl
curl -LO https://data.vlaanderen.be/ns/openbaardomein/infrastructuur.ttl
curl -LO https://data.vlaanderen.be/ns/openbaardomein/terreindeel.ttl
curl -LO https://data.vlaanderen.be/ns/openbaardomein/vegetatie.ttl
curl -LO https://data.vlaanderen.be/ns/openbaardomein/waterdeel.ttl
curl -LO https://data.vlaanderen.be/ns/overlijdensaangifte.ttl
curl -LO https://data.vlaanderen.be/ns/vastgoed.ttl
curl -LO https://data.vlaanderen.be/ns/verkeersmetingen.ttl
curl -LO https://data.vlaanderen.be/ns/vrachtwagenparkeren.ttl
curl -LO https://purl.eu/ns/consent.ttl
curl -LO https://purl.eu/ns/mobility/timetables-and-planning.ttl
curl -LO https://wegenenverkeer.data.vlaanderen.be/ns/abstracten.ttl
curl -LO https://wegenenverkeer.data.vlaanderen.be/ns/implementatieelement.ttl
curl -LO https://wegenenverkeer.data.vlaanderen.be/ns/installatie.ttl
curl -LO https://wegenenverkeer.data.vlaanderen.be/ns/levenscyclus.ttl
curl -LO https://wegenenverkeer.data.vlaanderen.be/ns/onderdeel.ttl
curl -LO https://wegenenverkeer.data.vlaanderen.be/ns/proefenmeting.ttl
