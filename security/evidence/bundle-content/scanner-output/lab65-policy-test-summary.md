
# Lab 65 Policy Test Summary



## Policy Under Test

policies/rego/required-tags.rego



## Fixture

policies/fixtures/service-missing-tag.json



## Query

data.gaming.tags.deny



## Expected Result

OPA should return at least one denial message because the service fixture has no environment tag.



## Actual Result

See security/out/lab65-opa-result.json.



## Security Meaning

The required-tag policy can detect an infrastructure-like service object that is missing the required environment label.

