
# Lab 37 Production Environment Protection Evidence



## Environment

production



## Controls Enabled

- Required reviewers for production deployments

- Protected branches only

- Environment-scoped variable: DEPLOY_TARGET

- Optional placeholder environment secret for training only



## Security Purpose

Production deployment must require explicit human approval before any protected job can access production-scoped secrets or variables.



## Rollback

Delete the production environment if the configuration blocks training progress:

gh api repos/:owner/:repo/environments/production -X DELETE

