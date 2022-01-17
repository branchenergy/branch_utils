# Branch Utils for dbt

## Adding this package as a dependency

Add the following to `packages.yml` at the top level of your dbt project:

```
  - git: "https://{{env_var('DBT_GITLAB_USER')}}:{{env_var('DBT_ENV_SECRET_GITLAB')}}@gitlab.com/branchenergy/data/dbt/branch_utils.git"
    revision: 0.1.1
```

Update the [Environment Variables](https://docs.getdbt.com/docs/dbt-cloud/using-dbt-cloud/cloud-environment-variables/)
in dbt Cloud to add `DBT_GITLAB_USER` and `DBT_ENV_SECRET_GITLAB`; the values of which you'll
find in LastPass. Make sure the same variables are in your shell.

Run `dbt deps` locally to make sure that the package installs correctly.
