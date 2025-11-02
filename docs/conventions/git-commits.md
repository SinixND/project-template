# Commits
Reference: [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)
```
<type>(<optional scope>): <brief summary>
<emptyLine>
<optional body description>
<emptyLine>
<optional footer>
```

## General
- One change per commit

## Types
Same types as for branches
- `fix`: Patches a bug/error
- `feat`: Introduce new functionality
- `build`: Changes to the build system
- `chore`: Changes that 
- `ci`: Changes to the CI (continuous integration) pipeline (eg. github actions, tests, cppcheck)
- `docs`: Changes in the documentation
- `perf`: Performance improvements
- `refactor`: Changes to code that are neither fixes or features
- `style`: Changes that do not change code, eg. formating
- `test`: Changes to tests

## Body
- Imperative: "change X", not "changed X" or "changes X"
- Do not capitalize first letter
- No `.` at the end

## Footer
- `BREAKING CHANGE`: Changes that change user experience or require user intervention side

