
const fs = require("fs");

const path = require("path");



const policyPath = path.join("security", "license-policy.yml");

const sbomPath = path.join("security", "out", "repo-sbom.cdx.json");

const reportPath = path.join("security", "out", "license-audit.md");



function parseSimplePolicyYaml(content) {

const policy = {

allowed: [],

review_required: [],

blocked: [],

unknown_license_action: "review_required"

};



let currentKey = null;



for (const rawLine of content.split(/\r?\n/)) {

const line = rawLine.trim();



if (!line || line.startsWith("#")) {

continue;

}



if (line.endsWith(":")) {

currentKey = line.replace(":", "");

if (!policy[currentKey]) {

policy[currentKey] = [];

}

continue;

}



if (line.includes(":") && !line.startsWith("-")) {

const [key, value] = line.split(":").map((part) => part.trim());

policy[key] = value;

currentKey = null;

continue;

}



if (line.startsWith("-") && currentKey) {

policy[currentKey].push(line.replace("-", "").trim());

}

}



return policy;

}



function normalizeLicense(value) {

if (!value) {

return "NOASSERTION";

}



return String(value).trim();

}



function extractLicenseValues(component) {

const values = [];



if (!component.licenses || !Array.isArray(component.licenses)) {

return ["NOASSERTION"];

}



for (const entry of component.licenses) {

if (entry.license && entry.license.id) {

values.push(entry.license.id);

} else if (entry.license && entry.license.name) {

values.push(entry.license.name);

} else if (entry.expression) {

values.push(entry.expression);

}

}



return values.length ? values : ["NOASSERTION"];

}



function tokenizeLicenseExpression(value) {

return normalizeLicense(value)

.replace(/[()]/g, " ")

.split(/\s+/)

.filter((token) => token && !["AND", "OR", "WITH"].includes(token));

}



function classifyLicenses(licenseValues, policy) {

const tokens = licenseValues.flatMap(tokenizeLicenseExpression);

const blocked = tokens.filter((item) => policy.blocked.includes(item));

const review = tokens.filter((item) => policy.review_required.includes(item));

const unknown = tokens.filter(

(item) =>

!policy.allowed.includes(item) &&

!policy.review_required.includes(item) &&

!policy.blocked.includes(item)

);



if (blocked.length > 0) {

return { status: "BLOCKED", blocked, review, unknown };

}



if (review.length > 0 || unknown.length > 0) {

return { status: "REVIEW_REQUIRED", blocked, review, unknown };

}



return { status: "ALLOWED", blocked, review, unknown };

}



function main() {

if (!fs.existsSync(policyPath)) {

console.error(`Missing policy file: ${policyPath}`);

process.exit(2);

}



if (!fs.existsSync(sbomPath)) {

console.error(`Missing SBOM file: ${sbomPath}`);

process.exit(2);

}



const policy = parseSimplePolicyYaml(fs.readFileSync(policyPath, "utf8"));

const sbom = JSON.parse(fs.readFileSync(sbomPath, "utf8"));

const components = Array.isArray(sbom.components) ? sbom.components : [];



const rows = components.map((component) => {

const name = component.name || "unknown-component";

const version = component.version || "unknown-version";

const licenses = extractLicenseValues(component);

const result = classifyLicenses(licenses, policy);



return {

name,

version,

licenses: licenses.join(", "),

status: result.status,

unknown: result.unknown.join(", ")

};

});



const counts = rows.reduce(

(acc, row) => {

acc[row.status] = (acc[row.status] || 0) + 1;

return acc;

},

{}

);



fs.mkdirSync(path.dirname(reportPath), { recursive: true });



const report = [

"# License Audit Report",

"",

`Generated: ${new Date().toISOString()}`,

"",

"## Summary",

"",

`- Allowed components: ${counts.ALLOWED || 0}`,

`- Review required components: ${counts.REVIEW_REQUIRED || 0}`,

`- Blocked components: ${counts.BLOCKED || 0}`,

"",

"## Component License Table",

"",

"| Component | Version | License Evidence | Status | Unknown Tokens |",

"|---|---:|---|---|---|",

...rows.map(

(row) =>

`| ${row.name} | ${row.version} | ${row.licenses} | ${row.status} | ${row.unknown || ""} |`

),

""

].join("\n");



fs.writeFileSync(reportPath, report);



console.log(`License audit report written to ${reportPath}`);

console.log(`Allowed: ${counts.ALLOWED || 0}`);

console.log(`Review required: ${counts.REVIEW_REQUIRED || 0}`);

console.log(`Blocked: ${counts.BLOCKED || 0}`);



if ((counts.BLOCKED || 0) > 0) {

process.exit(1);

}

}



main();

