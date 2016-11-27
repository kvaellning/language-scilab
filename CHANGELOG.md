- ### 0.4.7
  - implementation of all Scilab 5.4.1 available functions
    <br>(taken from the Scilab configuration)
  - Fix up stuff introduced in `0.4.6`
  - Fixes up a bug which occured in __whereami__ view if a big file was loaded <span style="font-size:8pt">(97b43437)</span>

- ### 0.4.6
  - fixes __whereami__ if language was changed after a file was loaded

- ### 0.4.5
  - fix missing configuration stuff for __whereami__
  - fixed bug with line continuations
  - code improvements

- ### 0.4.4
  - renamed to `scilab-language`

- ### 0.4.3
  - adds new language keywords
  - fixes issues with strings statring with `'`
  - __whereami:__
    - use scope-based function detection<br>
      (*bug:* race-condition since the complete resolved scopes are only available after the anchors are loaded. Next step: serialize state on Atom end and keep the anchors from the last session)

- ### 0.4.2
  - __whereami:__
    - increased robustness
    - some performance tweaks
  - __language pre-defines__:
    - operator `/.` (linear system feedback operator)
    - constants `SCIHOME` and `%io`
    - various missing functions

- ### 0.4.1
  - __whereami:__
    - increase of robustness
    - added option that function anchors should only be updated on save
      (this might increase performance)
  - fixed long name recognization for `function` declarations
  - adds display for invalid parenthesis in function input parameters

- ### 0.4.0
  - fixed some assignment related stuff (hopefully last time)
  - added _whereami_ support
    __Note: This feature is actually treated as experimental and may have slow performance and/or some strange line-numbering issues__

- ### 0.3.3
  - fixed problems related to `=-` and `=+`
  - fixed indentation for scopes
  - fixed constants assignments
  - adds (some) missing Scilab functions
  - adds struct/tlist accessor recognization (if they can be determined by grammar, not at runtime)
  - adds member scopes
  - fixes problems with equal signs inside of strings
  - includes spec for Unit-Tests (still incomplete)

- ### 0.3.2
  - fixed error if two or more variable assignments occur
  - fixed error for nested struct/tlist extraction (e.g. `foo(bar)(foo)`)
  - fixed error for vector assignments by introducing a global vector definition
  - added missing symbols `! #` to all variable/function names
  - fixed indent pattern for automatic indentation
  - fixed vector matching problems
  - added coffeelint ignores
  - added punctuation modifier for `structs` and `tlists`

- ### 0.3.1
  - fixed errors for leading and trailing dot (`.`) operator
  - fixed error in the variable assignment
  - fixed error in the conditions (a ==-1 etc.)

- ### 0.3.0
  - added invalid operators, operator combinations etc.
  - added snippets
  - added support for function line-break (currently input values only)
  - added Scilab grammar (might be not all)
  - added constants such as %pi and empty matrix
  - added keywords, operators etc.

- ### 0.2.2
  - Snippets
  - improved grammar
  - improved auto-indent rules
  - more pre-defined `Scilab 5.4.1` functions

- ### 0.2.1
  - enhanced grammar original
  - auto-indentation definitions
  - comment declaration (useful for block comments)
