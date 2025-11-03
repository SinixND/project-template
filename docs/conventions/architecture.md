# Note
- Logical architecture describes code structure. 
- Physical architecture describes the directory structure.

# Naming conventions 
- Folders: camelCase
- Files: 
  - camelCase if
    - not prefixed
    - not correspond to a struct/class/namespace

# Source directory structure: 
## data
- Persistent data (eg. constants or enums)

## configs/
- Data intended to be changed (by end-user)

## common/ (or util/)
- General source code used in multiple parts of the project

## classes/ 
- c++ classes
- See `code.md`

## structs/
- POD data structures

## structs/entities/
- POD data structures aggregations
- Contains components and other entities

## structs/components/
- POD data structures used in entities
- Does not contain entities or components

## systems/
- Functions that modify entities/components
# Basic
`(Statements <) Functions & Data < Modules < Layers < Architecture`

# Split/Separate/Group code
- Split by dependencies (OS, libraries, hardware, ...)
- Split by layer (app, render, logic, audio, network, ...)- Split if used somewhere else?

# Questions
- Split what? Modules? Layers? 
- When split in new category? 2+ rule?
- Directory structure similar or different? Sort by architecture or type (like all classes, data, configs etc.)
- Bottom-up or Top-down design? Both? Shift later from BU (beginning) to TD (later, once architecture becomes clear?)
