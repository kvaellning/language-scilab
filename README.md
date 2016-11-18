# scilab-language package

This package adds the support of Scilab language in Atom, with syntax highlighting.
This package is a fork of [language-scilab](https://atom.io/packages/language-scilab) by Jeremy Heleine.

_Contributions are greatly appreciated. Please fork this repository and open a pull request to add snippets, make grammar tweaks, etc._

#### Changes in respect to the original package
This package is based on [language-scilab 0.1.0](https://github.com/JeremyHeleine/language-scilab/tree/f68888450e46ce23e1f8847b85cef49a31bf96fb).
Though based, nearly everything in the code is altered.

### Features
  - including most of the Scilab (5.4.1) built-in functions, as best as possible
  - added Scilab constants
  - Markup of errors, as far as they can be reflected by the grammar Definition
  - Snippets for often used Scilab blocks
  - Proper definition of indentation depths
  - *whereami*-compatible line-numbering
  - and many more (and to come!)

### Known issues
  - Scilab functions might be missing
  - multi line definitions are missing (structs, extractions, functions)
  - Extractions like `foo('a')('a')` will not be included.
    Originally, this feature was planned, but due the high amount of recursion, this feature is set on hold.

### Planned features
  - matrix scope
  - If necessary, an [autocomplete-plus]() provider.
  - If necessary, linter support
  - Revisit (and if necessary rewrite) grammar-regexp
  - Dynamic Support of the Scilab language:
    - 5.4.1
    - 5.5.2
    - 6.x.x (distant future)
