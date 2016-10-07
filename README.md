# language-scilab package

This package adds the support of Scilab language in Atom, with syntax highlighting.
This package is roughly based on [language-scilab](https://atom.io/packages/language-scilab) by Jeremy Heleine.

## Changes in respect to the original package
As for the current version (0.3.2) which is based on [language-scilab 0.1.0](https://github.com/JeremyHeleine/language-scilab/tree/f68888450e46ce23e1f8847b85cef49a31bf96fb) nearly everything in the code is altered. [language-scilab](https://atom.io/packages/language-scilab) was originally used as a sceletal implementation for this specific idiom. Since that time, the package has seen a lot of redesigns and specializations, e.g.:

   - including most of the Scilab built-in functions, as best as possible
   - added Scilab constants
   - Markup of errors, as far as they can be reflected by the grammar Definition
   - Snippets for often used Scilab blocks
   - Proper definition of indentation depths
  - *whereami*-compatible line-numbering
   - and many more (and to come!)

## Known issues
  - Scilab functions might be missing
  - multi line definitions are missing (structs, extractions, functions)
  - In general some problems with the continuation mark (e.g. `|...` will be marked as error)
  - Extractions like `foo('a')('a')` will not be included.
    Originally, this feature was planned, but due the high amount of recursion, this feature is set on hold.
  - __Performance of the regular expressions seems not so great.__ In near future, the regular expression have to be revised.

## Planned features
  - matrix scope
  - If necessary, an [autocomplete-plus]() provider.
  - If necessary, linter support
  - Revisit (and if necessary rewrite) grammar-regexp

## Changelog
  - #### 0.4.2
    - #### whereami:
      - increased robustness
      - some performance tweaks
    - #### language pre-defines:
      - operator `/.` (linear system feedback operator)
      - constants `SCIHOME` and `%io`
      - various missing functions
      
  - #### 0.4.1
    - ##### whereami:
      - increase of robustness
      - added option that function anchors should only be updated on save
        (this might increase performance)
    - fixed long name recognization for `function` declarations
    - adds display for invalid parenthesis in function input parameters

  - #### 0.4.0
    - fixed some assignment related stuff (hopefully last time)
    - added *whereami* support
      **Note: This feature is actually treated as experimental and may have slow performance and/or some strange line-numbering issues**

  - #### 0.3.3
    - fixed problems related to `=-` and `=+`
    - fixed indentation for scopes
    - fixed constants assignments
    - adds (some) missing Scilab functions
    - adds struct/tlist accessor recognization (if they can be determined by grammar, not at runtime)
    - adds member scopes
    - fixes problems with equal signs inside of strings
    - includes spec for Unit-Tests (still incomplete)

  - #### 0.3.2
    - fixed error if two or more variable assignments occur
    - fixed error for nested struct/tlist extraction (e.g. `foo(bar)(foo)`)
    - fixed error for vector assignments by introducing a global vector definition
    - added missing symbols `! #` to all variable/function names
    - fixed indent pattern for automatic indentation
    - fixed vector matching problems
    - added coffeelint ignores
    - added punctuation modifier for `structs` and `tlists`

  - #### 0.3.1
    - fixed errors for leading and trailing dot (`.`) operator
    - fixed error in the variable assignment
    - fixed error in the conditions (a ==-1 etc.)

  - #### 0.3.0
    - added invalid operators, operator combinations etc.
    - added snippets
    - added support for function line-break (currently input values only)
    - added Scilab grammar (might be not all)
    - added constants such as %pi and empty matrix
    - added keywords, operators etc.

   - #### 0.2.2
      - Snippets
      - improved grammar
      - improved auto-indent rules
      - more pre-defined `Scilab 5.4.1` functions

   - #### 0.2.1
      - enhanced grammar original
      - auto-indentation definitions
      - comment declaration (useful for block comments)
