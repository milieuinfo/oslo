#!/bin/bash

riot --formatted=turtle ../main/resources/be/vlaanderen/data/id/vocabulary/*/* > ../main/resources/be/vlaanderen/data/id/vocabulary/all.ttl
sparql --data=../main/resources/be/vlaanderen/data/id/vocabulary/all.ttl --query ../sparql/02_index.rq --results=CSV > ../main/resources/be/vlaanderen/data/id/vocabulary/index.csv
