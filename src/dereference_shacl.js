import { rdfDereferencer } from "rdf-dereference" ;
import N3 from 'n3';
import request from "request";
import jp from 'jsonpath';
import fs from "fs";
import path from "path";
import fetch from 'node-fetch';


async function get_uris() {
    console.log('');
    let url = 'https://data.vlaanderen.be/standaarden/api/_content/query'
    let options = {json: true};
    request(url, options, (error, res, body) => {
        if (error) {
            return  console.log(error)
        };
        if (!error && res.statusCode == 200) {
            let my_uris = new Array();
            var resourceReferences = jp.query(body, '$..resourceReference');
            resourceReferences.forEach((element, index, array) => {
                //var re = new RegExp(".*\/doc\/applicatieprofiel.*|.*\/id\/applicatieprofiel.*");
                var re = new RegExp(".*\/doc\/applicatieprofiel.*|.*\/id\/applicatieprofiel.*");
                if (re.test(element)){
                    my_uris.push(element);
                    //console.log(element)
                }
            });
            scrape(my_uris)
        };
    });
}

async function scrape(uris){
    for (let uri of uris) {
        const response = await fetch(uri);
        const body = await response.text();

        var anchors = /<a\s[^>]*?href=(["']?)([^\s]+?)\1[^>]*?>/ig;
        var links = [];
        body.replace(anchors, function (_anchor, _quote, url) {
            var re = new RegExp(".*SHACL.*");
            var re2 = new RegExp("http.*SHACL.*");
            if (re.test(url)){
                if (re2.test(url)){
                    links.push(url);
                }
                else {
                    const domain = uri.split('/')[2];
                    links.push('https://' + domain + url);
                }
            }
        });
        deref(links, uri);
        //console.log(links);
        //console.log(body);
    }
}
async function deref(uris, base_url) {
    const prefixen = JSON.parse(fs.readFileSync('source/prefixen.json', "utf8"));
    for (let uri of uris) {
        const domain = uri.split('/')[2].split('.').reverse().join('/');
        const pad = uri.split('/doc/')[1].split('.')[0]
        const turtle = [['main/resources', domain, 'id', pad, path.basename(pad)].join('/'), 'ttl'].join('.')
        try {
            const { data } = await rdfDereferencer.dereference(uri);
            const ttl_writer = new N3.Writer({ format: 'text/turtle', prefixes: Object.assign({}, prefixen) });
            data.on('data', (quad) => ttl_writer.addQuad(quad))
                .on('error', (error) => console.error(error))
                .on('end', () => {
                    if (!fs.existsSync(path.dirname(turtle))){
                        fs.mkdirSync(path.dirname(turtle), { recursive: true });
                    }
                    ttl_writer.end((error, result) => fs.writeFileSync(turtle, result));
                });
        }
        catch(error) {
            const text = [['main/error', domain, 'id', pad, path.basename(pad)].join('/'), 'txt'].join('.')
            if (!fs.existsSync(path.dirname(text))){
                fs.mkdirSync(path.dirname(text), { recursive: true });
            }
            fs.writeFileSync(text, base_url + '\n' + uri + '\n' + error.message)
        }
    }
}
get_uris();