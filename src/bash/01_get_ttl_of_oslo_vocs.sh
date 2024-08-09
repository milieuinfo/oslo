#!/bin/bash
pushd ../main/resources/be/vlaanderen/data/id/vocabulary
for i in `curl 'https://data.vlaanderen.be/standaarden/api/_content/query/OLkcA4EmgC.1723132518297.json?_params=%7B%22where%22:%5B%7B%22_extension%22:%22json%22%7D,%7B%22_path%22:%22--REGEX+%2F^%5C%5C%2Fstandaarden%2F%22%7D%5D,%22sort%22:%5B%7B%22_file%22:1,%22$numeric%22:true%7D%5D%7D' --compressed -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br, zstd' -H 'Referer: https://data.vlaanderen.be/standaarden/' -H 'Connection: keep-alive' -H 'Cookie: VOGANONUSER=rB/ONWa2TYZoFgAZF+utAg==' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Priority: u=0' -H 'TE: trailers'| jq .| grep '/ns/' | cut -d '"' -f 4 | sort -u ` ; do
   ttl=`echo  ${i} |  sed -e 's;/$;;'`;
   curl -O  ${ttl}.ttl ;
   echo ${ttl}.ttl >> index;
done
popd

