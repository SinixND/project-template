# Branches
## Mandatory
### Persistent
#### main
- Latest stable release branch. Merges to this branch need to build without erros (enforced by github-actions).

#### develop
- Latest development changes for next release to be merged to `main`. Merges to this branch need to build without errors (enforced by github-actions).

### Temporary
- Branch off and merge back to persistant branches
- Lowercase and hyphen-separated naming
- Prefix branchname with type, eg. `feature/name`

#### types
- `feature`: Develop new feature
- `bugfix`: Fix bug in `develop` branch
- `hotfix`: Fix bug in `main` branch
- `release`: Preparation of a new release; branch off `develop`, merge to `main`

Additionally, branches could use commit types

## Optional
- Feel free to add additional branches as you see fit, eg. `hotfix` or `release`

# Workflow
## Sync
- `rebase` from parent branch
- `merge` (squashed?) history to parent branch

# Resources
[nvie.com - A successful git branching model](https://nvie.com/posts/a-successful-git-branching-model)

[dev.to - Beginner friendly git workflow for developers](https://dev.to/ajmal_hasan/beginner-friendly-git-workflow-for-developers-2g3g)
