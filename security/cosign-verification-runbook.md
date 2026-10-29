
# Cosign Verification Runbook



## Purpose



This runbook defines how a future deployment pipeline will verify that an image was signed by the trusted GitHub Actions workflow.



## Required Inputs



- IMAGE_URI

- Expected certificate identity

- Expected OIDC issuer



## Expected Certificate Identity Format



https://github.com/OWNER/REPOSITORY/.github/workflows/WORKFLOW_NAME@refs/heads/BRANCH_NAME



## Expected OIDC Issuer for GitHub Actions



https://token.actions.githubusercontent.com



## Future Verification Command



cosign verify "$IMAGE_URI" \

--certificate-identity="https://github.com/OWNER/REPOSITORY/.github/workflows/cosign-keyless-signing.yml@refs/heads/main" \

--certificate-oidc-issuer="https://token.actions.githubusercontent.com"



## Professional Rule



A container signature is only valuable when verification is mandatory before deployment.



If verification is optional, attackers can bypass the signature by deploying an unsigned image.

