import { validateIri, IriValidationStrategy } from 'validate-iri'
import path from "path";
import { glob } from 'glob';
import fs from "fs";
import {RoxiReasoner} from "roxi-js";

const reasoner = RoxiReasoner.new();
const dir = path.join(process.cwd(), 'main/resources')
const ttl_files = await glob('**/*.ttl', {
    cwd: dir
})
ttl_files.forEach(file => {
    console.log(path.join(dir, file))
    reasoner.add_abox(fs.readFileSync(path.join(dir, file), 'utf8').toString());
})
const yourIri = 'https://data.vlaanderen.be/ns/ldes#^lid'
const val = validateIri(yourIri, IriValidationStrategy.Strict)
console.log(val.message)
console.log(val.name)