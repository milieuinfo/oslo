import csv from 'csvtojson';
import fs from "fs";


function separateString(originalString) {
    if (originalString.includes('|')) {
        return originalString.split('|'); // pipe separated string to array
    }
    else {
        return originalString; // is string
    }
}
async function generate_common_voc() {
    const prefixen = JSON.parse(fs.readFileSync('source/prefixen.json', "utf8"));
    const context = JSON.parse(fs.readFileSync('source/context.json', "utf8"));
    console.log("skos generation: csv to jsonld ");
    await csv({
        ignoreEmpty:true,
        flatKeys:true
    })
        .fromFile("main/resources/index.csv")
        .then((jsonObj)=>{
            var new_json = new Array();
            for(var i = 0; i < jsonObj.length; i++){
                const object = {};
                Object.keys(jsonObj[i]).forEach(function(key) {
                    object[key] = separateString(jsonObj[i][key]);
                })
                new_json.push(object)
            }
            let jsonld = {"@graph": new_json, "@context": context} //Object.assign({},context , prefixen)};
            fs.writeFileSync("main/resources/index.jsonld", JSON.stringify(jsonld), null, 4);

        })
}
generate_common_voc()