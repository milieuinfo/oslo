import { rdfDereferencer } from "rdf-dereference" ;
import N3 from 'n3';
import request from "request";
import jp from 'jsonpath';
import fs from "fs";
import path from "path";



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
                var re = new RegExp(".*\/ns\/.*");
                if (re.test(element)){
                    my_uris.push(element);
                    //console.log(element)
                }
            });
            deref(my_uris)
        };
    });
}

async function deref(uris) {
    const prefixen = JSON.parse(fs.readFileSync('source/prefixen.json', "utf8"));
    for (let uri of uris) {
        const domain = uri.split('/')[2].split('.').reverse().join('/');
        const pad = uri.split('/ns/')[1]
        const turtle = [['main/resources', domain, 'ns', pad, path.basename(pad)].join('/'), 'ttl'].join('.')
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
            const text = [['main/error', domain, 'ns', pad, path.basename(pad)].join('/'), 'txt'].join('.')
            if (!fs.existsSync(path.dirname(text))){
                fs.mkdirSync(path.dirname(text), { recursive: true });
            }
            fs.writeFileSync(text, error.message)
        }
    }
}
get_uris();