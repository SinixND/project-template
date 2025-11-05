# Design guideline
The Zen of Python (selection):
> - Explicit is better than implicit.
> - Simple is better than complex.
> - Complex is better than complicated.
> - Flat is better than nested.
> - Sparse (code) is better than dense.
> - Practicality beats purity.
> - Now is better than never.

## Resources
[Noel's blog](https://gamesfromwithin.com/category/c)

## Classes/OOP: 
- PascalCase
- For singular objects, eg. App
```cpp
class C{
private: 
    type member_;

public:
    type member;

public:
    type method();

private: 
    type method();
};
```

## Structs:
- PascalCase
- For many objects eg. Tile
- POD
- Sort members by size

## Namespaces
- PascalCase

## Functions
- camelCase
- should begin with a verb
- Split 2+ parameters in separate lines 
- Always work with least nested parameter type, eg. `Leg` instead of `Dog`
- Try to return modified pointers/references, eg. `P* fn(P* InOut){return ++InOut;}`
- Parameter order: Out > I

## Misc
- Avoid abbreviations (except for very, very(!) common ones, eg. `i` for loop iterator)

## Header file structure
- Start with include guard
- Includes
- Namespace (optional)
- Class / Struct definition
- Forward declare public/API functions

## Source file structure
- Includes
- Forward declare private/non-API functions only used in source file
- Namspaced (optional) API function definitions
- Private funciton definitions