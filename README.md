# Branch Utils for dbt

## Adding this package as a dependency

Add the following to `packages.yml` at the top level of your dbt project:

```
  - git: https://github.com/branchenergy/branch_utils.git
    revision: 0.3.0
```

Run `dbt deps` locally to make sure that the package installs correctly.
