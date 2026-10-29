# Conftest Command Reference

Lab 66 runs policy checks with:

```bash
./scripts/conftest.sh
```

Default target:

`policies/fixtures/service-missing-tag.json`

Default policy directory:

`policies/rego`

The script uses `--all-namespaces` because the policy package is `gaming.tags`, not `main`.
