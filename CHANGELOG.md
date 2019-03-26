#### 0.12.0
  - add ``d`` and ``D`` constant for exponential notation

#### 0.11.0
  - add ``{}`` constant and accept optional whitespace in between
  - refine language specific handling of empty matrices / cells (``[]``, ``{}``)
  - refine language specific handling of string quotes (``"``, ``'``)

#### 0.10.0
  - support Scilab 6.0.1 function & constant predefines (may be incomplete)

#### 0.9.3
  - fix an error with the gutter element for ``where-am-i``

#### 0.9.2
  - fix an issue that functions like ``hex2dec`` were not recognized as builtin<br>
    (Issue introduced in ``0.9.1``.)

#### 0.9.1
  - add matrix based arithmetic operators
  - fix a bug that the number delimiter in constants was recognized as error in assignments
  - support independent ``where-am-i``-views<br>
    To use this feature, you can pass a ``configKey`` representing the name of the option in the ``config.json``, as well as name a gutter name which is used to identify your instance.

### 0.9.0
  - wherami-implementation accepts now also custom configuration keys

<hr>

### 0.8.7
  - refix an assignment error introduced in patch ``0.8.5``

### 0.8.6
  - fix an error in the function patterns
  - fix an error with assignments, matrices and strings

### 0.8.5
  - add bitwise and logical ``and``/``or`` to Scilab 6.0.0 language

### 0.8.4
  - delete deprecated usage of ``rootElement`` from Atom 1.19.0

### 0.8.3
  - fix a few problems with "invalid operators" (ruleset was to harsh)

### 0.8.2
  This version only improves Scilab 6 language support.
  - exclude 24 character restriction
  - allow multi-line comments
  - add missing predefines which are not listed in the *primitives.txt* and *macros.txt*

### 0.8.1
  - changed an assignment pattern which lead to catastrophic backtrcking in the Regex-Engine
  - fix online version change
  - distinguish operator erro between Scilab 6 and Scilab 5

### 0.8.0
  - support Scilab 6.0.0 predefined functions
  - add curly braces (``{}``) to the allowed symbols
  - Throw out:
    - "function-call" pattern (since it costs time and is not helpful)
    - "parentheses"   pattern (same as "function-call"-pattern)
  - fix problem with ``!!`` (which is a valid variable name in Scilab).

<hr>

### 0.7.5
  - fix a minor issue that assigning a member with the same name as a built-in function/constant will be displayed as built-in
  - add invalid closing parenthesis detection

### 0.7.4
  - fix problems with multiple assignments in one line
  - predefined functions and constants are now displayed for assignments

### 0.7.3
  - fix a problem which rendered the editor unresponsible if a certain assignment pattern is used<br>
    Using a distinct assignment pattern has led to high computation load on the Regex-Engine of the grammar, which rendered the editor unusable. This problem was introduced in release __0.7.0__

### 0.7.2
  - fix problems for return values and trailing equals<br>
    For function ``[retval]=Foo()``, ``Foo`` was not recognized as part of the function

### 0.7.1
  - Travis CI build test
  - fixes comment problems in:
    - function declarations in between ``] =``
    - function-call patterns
    - parenthesis pattern
  - avoid matching of function-call pattern if a leading dot is present

### 0.7.0
  - mark error for code after continuation marks
  - support of multiline function definitions
  - support assignments based on recursion

<hr>

### 0.6.4
  - adds a pattern for determining function-like accessors<br>
    Since basically everything done with parenthesis is something like a function call, this is a nice pattern which might come handy in future use.<br>
    This will grab stuff like
      - ``Foo(something)``
      - ``Foo(2).a``
      - ``Foo(1:2)`` <br>etc. ...
  - deleted code to determine struct/tlist base-variable<br>
    This was done to avoid the ever going on problems with the parenthesis and so on.
    Now, only the members are specifically marked.
  - renamed some snippets

### 0.6.3
  - fix struct/tlist resolvement introduced with __0.6.1__
  - fix snippet indent
  - throw out ``global`` from the list of built-in functions (because it doesn't feel like a function)

### 0.6.2
  - re-activated spec
  - simplified return value regexp
  - adds ``disp``-snippet to automatically add both variable and variable name

### 0.6.1
  Fix a bug which caused broken scopes for constructs like ``execstr( FunctionA("if exists(val) then foo(1) = 1; end") );``

### 0.6.0
  Includes Pre-defined functions for Scilab 5.4.1 and 5.5.2 (can be switched via Preferences)

<hr>

### 0.5.0:
- delete invisible chars in "m" and "u" built-ins, which avoided highlighting of built-in functions such as `mean` or `uicontrol`
- deleted option to only update anchors on save<br>
  After lot of usage on different PCs, I have encountered no performance issues, so this option will be deleted.<br>
  If you need it, please create an issue and I will re-activate it.

<hr>

### 0.4.7
- implementation of all Scilab 5.4.1 available functions
  <br>(taken from the Scilab configuration)
- Fix up stuff introduced in `0.4.6`
- Fixes up a bug which occured in __whereami__ view if a big file was loaded <span style="font-size:8pt">(97b43437)</span>

### 0.4.6
fixes __whereami__ if language was changed after a file was loaded

### 0.4.5
- fix missing configuration stuff for __whereami__
- fixed bug with line continuations
- code improvements

### 0.4.4
renamed to `scilab-language`

### 0.4.3
- adds new language keywords
- fixes issues with strings statring with `'`
- __whereami:__
  - use scope-based function detection<br>
    (*bug:* race-condition since the complete resolved scopes are only available after the anchors are loaded. Next step: serialize state on Atom end and keep the anchors from the last session)

### 0.4.2
- __whereami:__
  - increased robustness
  - some performance tweaks
- __language pre-defines__:
  - operator `/.` (linear system feedback operator)
  - constants `SCIHOME` and `%io`
  - various missing functions

### 0.4.1
- __whereami:__
  - increase of robustness
  - added option that function anchors should only be updated on save
    (this might increase performance)
- fixed long name recognization for `function` declarations
- adds display for invalid parenthesis in function input parameters

### 0.4.0
- fixed some assignment related stuff (hopefully last time)
- added _whereami_ support<br>
  __Note: This feature is actually treated as experimental and may have slow performance and/or some strange line-numbering issues__

<hr>

### 0.3.3
- fixed problems related to `=-` and `=+`
- fixed indentation for scopes
- fixed constants assignments
- adds (some) missing Scilab functions
- adds struct/tlist accessor recognization (if they can be determined by grammar, not at runtime)
- adds member scopes
- fixes problems with equal signs inside of strings
- includes spec for Unit-Tests (still incomplete)

### 0.3.2
- fixed error if two or more variable assignments occur
- fixed error for nested struct/tlist extraction (e.g. `foo(bar)(foo)`)
- fixed error for vector assignments by introducing a global vector definition
- added missing symbols `! #` to all variable/function names
- fixed indent pattern for automatic indentation
- fixed vector matching problems
- added coffeelint ignores
- added punctuation modifier for `structs` and `tlists`

### 0.3.1
- fixed errors for leading and trailing dot (`.`) operator
- fixed error in the variable assignment
- fixed error in the conditions (a ==-1 etc.)

### 0.3.0
- added invalid operators, operator combinations etc.
- added snippets
- added support for function line-break (currently input values only)
- added Scilab grammar (might be not all)
- added constants such as %pi and empty matrix
- added keywords, operators etc.

<hr>

### 0.2.2
- Snippets
- improved grammar
- improved auto-indent rules
- more pre-defined `Scilab 5.4.1` functions

### 0.2.1
- enhanced grammar original
- auto-indentation definitions
- comment declaration (useful for block comments)
