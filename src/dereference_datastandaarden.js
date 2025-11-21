import { rdfDereferencer } from "rdf-dereference" ;
import N3 from 'n3';
import fs from "fs";
import path from "path";
import rdfDataset from "@rdfjs/dataset";
import factory  from '@rdfjs/data-model'




/**
 * @param {import('@rdfjs/types').DatasetCore | import('@rdfjs/types').Dataset} dataset - Volledige dataset met alle triples
 * @param {import('@rdfjs/data-model').factory.NamedNode} predicate - uri van het predicaat
 * @throws {TypeError} If dataset is not a rdfDataset.
 * @returns {Array<string>} Een lijst met alle dcterm types.
 */
function get_objects( dataset, predicate){
    if (dataset.constructor.name !== "Dataset" && dataset.constructor.name !== "DatasetCore"){
        throw new TypeError('Expected a Dataset');
    }
    const quads = dataset.match(null, predicate, null)
    const set = new Set
    for (const quad of quads) {
        set.add(quad.object.value)
    }
    return Array.from(set)
}

/**
 * @param {import('@rdfjs/types').DatasetCore | import('@rdfjs/types').Dataset} dataset - Volledige dataset met alle triples
 * @throws {TypeError} If dataset is not a rdfDataset.
 * @returns {Array<string>} Een lijst met alle dcterm types.
 */
function filter_uris( dataset){
    if (dataset.constructor.name !== "Dataset" && dataset.constructor.name !== "DatasetCore"){
        throw new TypeError('Expected a Dataset');
    }
    const predicate = factory.namedNode('http://purl.org/dc/terms/type')

    const objects = get_objects(dataset, predicate)
    for (const obj of objects) {
        const object = factory.namedNode(obj)
        const quads = dataset.match(null, predicate, object)
        const set = new Set
        for (const quad of quads) {
            set.add(quad.subject.value)
            //console.log(quad.subject.value, quad.object.value)
        }
        deref(Array.from(set))
    }
}


async function get_uris() {

    // const { data } = await rdfDereferencer.dereference(
    //     'https://data.vlaanderen.be/doc/applicatieprofiel/loongegevens',
    //     {
    //         xmlParserOptions: { preserveScripts: false },
    //         scriptHandler: () => {}
    //     }
    // );
    console.log('');
    try {
        const { data } = await rdfDereferencer.dereference(
            'https://data.vlaanderen.be/standaarden',
            {
                xmlParserOptions: { preserveScripts: false },
                scriptHandler: () => {}
            }
        );
        const dataset = rdfDataset.dataset();
        data.on('data', (quad) => dataset.add(quad))
            .on('error', (error) => console.error(error))
            .on('end', () => {
                console.log();
                filter_uris(dataset)
            });
    } catch(error) {
        console.log('Error');
    }
}

async function deref(uris) {
    const prefixen = JSON.parse(fs.readFileSync('source/prefixen.json', "utf8"));
    for (let ur of uris) {
        const uri = ur.replace(/\/$/, "")
        const domain = uri.split('/')[2].split('.').reverse().join('/');
        let pad = null
        let turtle = null
        var re = new RegExp(".*\/ns\/.*");
        var re2 = new RegExp(".*\/doc\/.*");
        var re3 = new RegExp(".*\/doc\/.*");
        if (re.test(uri)){
            pad = uri.split('/ns/')[1]
            turtle = [['main/resources', domain, 'ns', pad, path.basename(pad)].join('/'), 'ttl'].join('.')
        } else if (re2.test(uri)){
            pad = uri.split('/doc/')[1]
            turtle = [['main/resources', domain, 'id', pad, path.basename(pad)].join('/'), 'ttl'].join('.')
        } else if (re3.test(uri)){
            pad = uri.split('/id/')[1]
            turtle = [['main/resources', domain, 'id', pad, path.basename(pad)].join('/'), 'ttl'].join('.')
        }else {
            console.log(uri);
        }
        console.log(uri);
        try {
            const { data, metadata, headers, url, mediaType } = await rdfDereferencer.dereference(uri, {
                xmlParserOptions: { preserveScripts: false },
                scriptHandler: () => {}
            });
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
            fs.writeFileSync(text, error.message)
        }
    }
}
//console.log(await latestVersion('rdf-dereference'));



await get_uris();