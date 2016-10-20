This package adds the support of Scilab language in Atom, with syntax highlighting.
This package is roughly based on [language-scilab](https://atom.io/packages/language-scilab) by Jeremy Heleine.

## Changes in respect to the original package
As for the current version (0.3.1) which is based on [language-scilab 0.2.0](https://github.com/JeremyHeleine/language-scilab/tree/d3c7248d7ff840c9b7f10902d4e5886200fd4e5b) nearly everything in the code is altered. [language-scilab](https://atom.io/packages/language-scilab) was originally used as a sceletal implementation for this specific idiom. Since that time, the package has seen a lot of redesigns and specializations, e.g.:

   - including most of the Scilab built-in functions, as best as possible
   - added Scilab constants
   - Markup of errors, as far as they can be reflected by the grammar Definition
   - Snippets for often used Scilab blocks
   - Proper definition of indentation depths
   - and many more (and to come!)

## Known issues
   - Scilab functions might be missing
   - Definition of <code>function</code> might lead to errors if the continuation mark <code>...</code> is used for/after return values
   - In general some problems with the continuation mark (e.g. <code>|...</code> will be marked as error)

## Planned features
   - *wherami* compatible line numbering
   - [GIT](https://git-scm.com/) support

## Changelog
   - #### 0.3.1
      - fixed errors for leading and trailing dot (<code>.</code>) operator
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
