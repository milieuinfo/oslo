#!/bin/bash

#riot --formatted=turtle $(find ../main/resources/*/. | grep ttl$) > ../main/resources/all.ttl
#sparql --data=../main/resources/all.ttl --query ../sparql/02_index.rq --results=CSV > ../main/resources/index.csv
riot --formatted=turtle /tmp/all.nt > ../main/resources/all.ttl
sparql --data=../main/resources/all.ttl --query ../sparql/02_index.rq --results=CSV > ../main/resources/index.csv
