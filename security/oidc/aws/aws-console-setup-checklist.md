
# AWS Console Setup Checklist for GitHub OIDC



## Create the GitHub OIDC Identity Provider



1. Open the AWS Console.

2. In the top search bar, type `IAM`.

3. Click **IAM**.

4. In the left navigation menu, click **Identity providers**.

5. Click **Add provider**.

6. Under **Provider type**, select **OpenID Connect**.

7. In **Provider URL**, enter `https://token.actions.githubusercontent.com`.

8. In **Audience**, enter `sts.amazonaws.com`.

9. Click **Add provider**.



## Create the IAM Role



1. In the left navigation menu, click **Roles**.

2. Click **Create role**.

3. Under **Trusted entity type**, select **Web identity**.

4. Under **Identity provider**, select **token.actions.githubusercontent.com**.

5. Under **Audience**, select **sts.amazonaws.com**.

6. Click **Next**.

7. On **Add permissions**, attach only the minimum policy needed for the future deployment target.

8. Click **Next**.

9. In **Role name**, enter `game-security-lab-deploy`.

10. Click **Create role**.



## Replace the Trust Policy



1. Open **IAM**.

2. Click **Roles**.

3. Click **game-security-lab-deploy**.

4. Click **Trust relationships**.

5. Click **Edit trust policy**.

6. Replace the generated trust policy with the edited version of `security/oidc/aws/trust-policy.template.json`.

7. Replace `AWS_ACCOUNT_ID`, `ORG_NAME`, and `REPO_NAME` with real values.

8. Click **Update policy**.



## Safety Rules



- Do not use wildcard-only repository trust.

- Do not allow every branch unless there is a documented reason.

- Do not grant administrator permissions to the role.

- Do not paste cloud access keys into GitHub repository secrets.

- Do not print OIDC tokens or temporary credentials in logs.

