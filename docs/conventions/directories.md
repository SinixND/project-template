# Directory layout: Pitchfork 
References: [Pitchfork](https://api.csswg.org/bikeshed/?force=1&url=https://raw.githubusercontent.com/vector-of-bool/pitchfork/develop/data/spec.bs#intro.dirs)

## .github/workflows
- Configuration files for GitHub actions

## bin/
- Final binaries

## build/
- Intermediate files 
- Automatically created during build process
- Untracked by version control

## data/
- Non-code files used in project
- Example: textures, sprites, favicon

## docs/	
- Documentation 
- Examples: coding guidelines, images

## examples/
- Sample/Example files

## external/	(aka. third_party)
- External projects/dependencies (possibly git submodules)

## extra/ (like `libs/` but optional)
- Optional submodules
- Replaces `src/` and `include/`
- For modular directory structure

## include/ 
- Public, project independent headers
- For non-modular directory structure

## libs/ (like `extra/`, but default)
- Main/Default submodules
- Replaces `src/` and `include/`
- For modular directory structure

## src/
- Source files; merged header placement
- For non-modular directory structure

## tests/
- Test files
- Exmaples: unit tests

## tools/	
- Development related stuff
- Examples: scripts, configs, binaries

