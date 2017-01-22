# scilab-language package
[![Build Status](https://travis-ci.org/kvaellning/scilab-language.svg?branch=master)](https://travis-ci.org/kvaellning/scilab-language)

This package adds the support of [Scilab](http://www.scilab.org/) language in Atom, with syntax highlighting.
This package is a fork of [language-scilab](https://atom.io/packages/language-scilab) by Jeremy Heleine.

_Contributions are greatly appreciated. Please fork this repository and open a pull request to add snippets, make grammar tweaks, etc._

#### Changes in respect to the original package
This package is based on [language-scilab 0.1.0](https://github.com/JeremyHeleine/language-scilab/tree/f68888450e46ce23e1f8847b85cef49a31bf96fb).
Though based, nearly everything in the code is altered.

### Features
  - *Scilab* (5.4.1 / 5.5.2) built-in functions as defined in the *Scilab* installation
  - added *Scilab* constants
  - Markup of errors, as far as they can be reflected by the grammar Definition
  - Snippets for often used *Scilab* blocks
  - Proper definition of indentation depths
  - *whereami*-compatible line-numbering
  - and many more (and to come!)

### Known issues
  - *Scilab* functions might be missing
  - multi line definitions are missing (structs, extractions)
  - Extractions like `foo('a')('a')` will not be included.
    Originally, this feature was planned, but due the high amount of recursion, this feature is set on hold.

### Planned features
  - Integrate Scilab-Online help
  - If necessary, an [autocomplete-plus]() provider.
    From my experience with another language, this will be a separate package.
  - If necessary, linter support
  - Revisit (and if necessary rewrite) grammar-regex

### About multi-line support
If you have the feeling that something may not be right or something is missing, please check the [About multiline support](https://github.com/kvaellning/scilab-language/wiki/Grammar-multiline-support) about the multiline support of the grammar.

Feel free to try your best resolving the grammar errors if you encounter them in multiline usage.
