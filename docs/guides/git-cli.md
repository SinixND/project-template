# TOC
- [Development cycle](#development-cycle)
- [Best practises](#best-practises)
- [Commands](#commands)
- [Concepts](#concepts)

-----

# Development cycle
Handle local changes
0) [Add](#git-add) change to index
0) [Commit](#git-commit) [index](#index) to [branch](#branch)
0) [Push](#git-push)/Upload local state to git

Sync public to local state
0) (optional) Temporarily [stash](#git-stash)
0) [Fetch](#git-fetch) public state locally
0) Use [Rebase](#git-rebase) to sync [fetched](#fetch) with local state; does not "interrupt" the feature [branch](#branch) by inserting [merge commits](#git-merge)

Integrate changes to the parent branch
0) Use [Merge](#git-merge) [branch](#branch) to parent to keep public%/shared [histories](#history) unchanged

# Best practises
## Default approach to sync changes (ordered by preference)
- To save changes locally before syncing (preferred in teams):
[stash](#git-stash) > [pull](#git-pull) > [stash pop](#git-stash) >

[add](#git-add) > [commit](#git-commit) > [push](#git-push)

- is similar to
[pull --autostash](#git-pull) >

[add](#git-add) > [commit](#git-commit) > [push](#git-push)

- or to save changes in git (ok as solo dev)
[add](#git-add) > [commit](#git-commit) > [pull](#git-pull) > [push](#git-push)

## Branches
Use hierarchical branches

### Main branches (always existing)
#### origin/main
- Latest major release branch
- Only fork to (release) develop or hotfix

#### origin/release (optional)
Latest stable branch 


#### origin/develop
Latest development changes for next release to be merged to `origin/master`

### Supporting branches (temporary)
#### local/feature
Develop new feature/functionality (usually local) to be merged into `origin/develop`

#### origin/hotfix
Forked from main

# Preserve changes to detached HEAD
Create new branch (and possibly merge into previously detached branch)

-----

# Commands 
### git
Basic command. For more info, see man pages (eg. `man git-pull`)

#### Options
| Opt | Desc |
| - | - |
| `--no-pager` | Simply prints whole command to stdout

## Porcelain 
aka. high-level (most relevant)

### git add
[Stage](#staged) changes or files to [index](#index)

#### Options: 
| Opt | Desc 
| - | - 
| `.` | recursively adds all changes below the current directory
| `-A` | all changes as well as file additions and deletions! 
| `-p` | pick changes individually 

### git branch
Creates a new branch

### git checkout 
Can (still) switch to [commits](#commit); Split into [`git restore`](#`git-restore`) and [`git switch`](#`git-switch`) (and [`git switch --detach`](#`git-switch)) 

### git commit
Add a now point in [history](#history) with [indexed](#index) changes to the current [branch](#branch) to document the current status of development

#### Options:
| Opt | Desc 
| - | - 
| `--amend` | Modify last [commit](#commit); Needs forced [push](#push) because it modifies [history](#history)
| `-m "message"`| Add description to [commit](#commit); Omit option for interactive edit (recommended)

### git fetch
Download target [branch](#history)/[history](#history) from git; makes it available locally for further processing

### git init
Create local [repo](#repository)

### git log
Show [commit](#commit) [history](#history)

#### Options
| Opt | Desc
| - | -
| `--oneline` | Better overview by abbreviated descriptions; Good for finding hashes aka. commit-ids
| `--parents` | Backward-lists parent [commits](#commit) the current one is based on
| `--graph` | Visual hierarchy representation
| `-p` | Shows differences

### git merge
No changes to [history](#history); result is a new commit; clear but maybe exhaustive/complicated history, but preserves ability to backtrack (until the merge)

One single conflict has to be solved; good for team level/public [branches](#branch)

Attempts to combine the given [branch](#branch) with the current one.

```
Example:

(@b:child): git merge origin b:parent

A-B-C (b:parent)
 \
  D-E (b:child)


Result: clear [history](#history) with new commit 'F' on parent branch

A-B-C-F (b:parent)
 \   /
  D-E
```

### git pull
Combines [git fetch](#git-fetch) with (config dependent) either [git rebase](#git-rebase) or [git merge](#git-merge)

Both options differ only in the resulting history

### git push
Upload local [history](#history) to git. If [history](#history) was changed, force is needed.

#### Options
| Opt | Desc
| - | -
| `-f` | Always forces push (_not_ recommended)
| `--force-with-lease` | Only allows force if the target [branch](#branch) is known (= equals locally [fetched](#git-fetch) [status](#git-status)) (recommended)
Note: Found a shell command to add `git please` as an alias for this recommended option:

`git config --global alias.please "push --force-with-lease"`

### git rebase
Changes [history](#history) by attaching all [commits](#commit) since the forking [commit](#commit) to the target [branches](#branch) [tip](#tip)

Result is a changed, but straight/cleaned/modified [history](#history)

Never rebase public/shared [branches](#branch) like `main` cause changed [history](#history) causes conflicts for others 

Conflicts are presented one at a time; Good for solo level/feature [branches](#branch)

Shifts the (merge-)base of both [branches](#branch) (point of forking) forward (on parent) to enable a [fast-forward](#fast-forward-pull) [pull](#git-pull); apply source commits onto target branches [tip](#tip)

```
Example:

(@b:child): git rebase origin b:parent

A-B-C (b:parent)
 \
  D-E (b:child)


Result: straight, changed [history](#history)

A-B-C-F
       \
        D-E (b:parent)
```

### git stash
Save/store away local changes without creating a [commit](#commit) to have an unmodified [branch](#branch) for easier update/[pull](#git-pull)

### git status
Report of the current [statuses](#statuses)

### git switch
Switches to [tip](#tip) of given [branch](#branch)

#### Options
| Opt | Desc
| - | -
| `-c` | [`git branch`](#`git-branch`) followed by `git switch`
| `--detach` | switch to [commit](#commit) (aka. detach [HEAD](#head) from [tip](#tip) of [branch](#branch); `git checkout` is shorter

## Plumbing
aka. low-level (less relevant)

### git cat-file -p <hash>
Print commit file human-readable
- Structure:

```
Commit: tree
|- blob: content
```

- `tree hash`: ~= (whole) root directory, `cat-file`-ing prints blobs 
- `blob hash`: ~= file, `cat-file`-ing prints file-content;
- Useful to grep stuff

-----

# Concepts
## Basics
Git lets you modify local copies of file [histories](#history) (including directories and contents). The only interaction with the remote/upstream (often `origin`), shared versions is through [git fetch](#git-fetch) and [git push](#git-push). 

Git is all about, how and in which order to record changes in history (= [commits](#commit))

## Branch
Separate [history](#history) from a certain [commit](#commit) on; is a named pointer to its [tip](#tip)

## Commit
Snapshot of the [repo](#repository) at given time

## Configs
Basically locally/globally stored settings as key/value pairs; Can be modified with commands, put manually editing probably easier

## Fast-Forward Pull
Only possible if no additional [commits](#commit) on parent [branch](#branch) exist after the merge-base/point of forking

## HEAD
Currently active [commit](#commit); usually equals [tip](#tip) if not detached by [`switch --detach`](#git-switch) or [`git checkout`](#git-checkout)

## History
Snapshot of all commits up to given time

## Index
'Prototype-commit': [Staged](#staged) changes  to be included in the next [commit](#commit)

## Repository
Directory contaning files to be synced on demand. Basically equivalent to `.git/`

## Tag
A tag is an _immutable_ pointer to a [commit](#commit), opposite to a [branch](#branch) which is mutable
## Tip
Last [commit](#commit) of a [branch](#branch)

## Statuses
Get current change (or sometimes file) statuses with [`git status`](#git-status)

- ### untracked
Not being tracked by Git, not on the [index](#index)

- ### staged
Aliases: indexed, cached

Marked for inclusion in the next [commit](#commit) / To be [tracked](#commited) / [Added](#git-add) to [index](#index)

- ### commited
Aliases: tracked

Saved in [history](#history)

# Resources
[Git and Github - Full Course](https:/youtube.com/watch?v=rH3zE7VlIMs)

[with time stamp](https://youtu.be/rH3zE7VlIMs?si=grrX865jk9WoaEXm&t=4251)

[nvie.com - A successful git branching model](https://nvie.com/posts/a-successful-git-branching-model)

[dev.to - Beginner friendly git workflow for developers](https://dev.to/ajmal_hasan/beginner-friendly-git-workflow-for-developers-2g3g)

[Beginners guide to proper git workflow](https://medium.com/@anjulapaulus_84798/beginners-guide-to-proper-git-workflow-35a2d967734e)

[datacamp - merge vs rebase](https://www.datacamp.com/blog/git-merge-vs-git-rebase)

[conventional commits](https://conventionalcommits.org/en/v1.0.0/)
