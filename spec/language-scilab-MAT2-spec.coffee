describe "Scilab MAT2 grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-scilab-MAT2")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.scilab")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.scilab"

  it "checks the Script-Header", ->
    tokens = grammar.tokenizeLines('/// $BEGIN ScriptHeader\n/// Type\n/// $END ScriptHeader')

    # Line 0
    expect(tokens[0][0].value).toBe '/// $BEGIN ScriptHeader'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'comment.block.scriptheader.scilab', 'comment.block.scriptheader.begin.scilab']

    expect(tokens[0][1]).not.toBeDefined()

    # Line 1
    expect(tokens[1][0].value).toBe '/// Type'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'comment.block.scriptheader.scilab']

    expect(tokens[1][1]).not.toBeDefined()

    # Line 2
    expect(tokens[2][0].value).toBe '/// $END ScriptHeader'
    expect(tokens[2][0].scopes).toEqual ['source.scilab', 'comment.block.scriptheader.scilab', 'comment.block.scriptheader.end.scilab']

    expect(tokens[2][1]).not.toBeDefined()

  it "checks comments", ->
    tokens = grammar.tokenizeLines('// comment\n\n/// comment')

    # Line 0
    expect(tokens[0][0].value).toBe '// comment'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[0][1]).not.toBeDefined()

    expect(tokens[1][0].value).toBe ''
    expect(tokens[1][0].scopes).toEqual ['source.scilab']

    expect(tokens[1][1]).not.toBeDefined()

    # Line 2
    expect(tokens[2][0].value).toBe '/// comment'
    expect(tokens[2][0].scopes).toEqual ['source.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[2][1]).not.toBeDefined()

  it 'checks valid \"function\" declarations', ->
    tokens = grammar.tokenizeLines('function Foo()\n'                   +
                                   'function Foo(foobar)\n'             +
                                   'function Foo(foobar,baz)\n'         +
                                   'function retVal=Foo(foobar,baz)\n'  +
                                   'function [retVal,retVal] = Foo(foobar,baz)\n')

    # function Foo()
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'Foo'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[0][4].value).toBe ')'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][5].value).toBe ''
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[0][6]).not.toBeDefined()

    # function Foo(bar)
    expect(tokens[1][0].value).toBe 'function'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[1][1].value).toBe ' '
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[1][2].value).toBe 'Foo'
    expect(tokens[1][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[1][3].value).toBe '('
    expect(tokens[1][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[1][4].value).toBe 'foobar'
    expect(tokens[1][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.input.scilab']

    expect(tokens[1][5].value).toBe ')'
    expect(tokens[1][5].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[1][6].value).toBe ''
    expect(tokens[1][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[1][7]).not.toBeDefined()

    # function Foo(bar,baz)
    expect(tokens[2][0].value).toBe 'function'
    expect(tokens[2][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[2][1].value).toBe ' '
    expect(tokens[2][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[2][2].value).toBe 'Foo'
    expect(tokens[2][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[2][3].value).toBe '('
    expect(tokens[2][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[2][4].value).toBe 'foobar'
    expect(tokens[2][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.input.scilab']

    expect(tokens[2][5].value).toBe ','
    expect(tokens[2][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.separator.parameters.scilab']

    expect(tokens[2][6].value).toBe 'baz'
    expect(tokens[2][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.input.scilab']

    expect(tokens[2][7].value).toBe ')'
    expect(tokens[2][7].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[2][8].value).toBe ''
    expect(tokens[2][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[2][9]).not.toBeDefined()

    # function retVal=Foo(bar,baz)
    expect(tokens[3][0].value).toBe 'function'
    expect(tokens[3][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[3][1].value).toBe ' '
    expect(tokens[3][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][2].value).toBe 'retVal'
    expect(tokens[3][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.output.scilab']

    expect(tokens[3][3].value).toBe '='
    expect(tokens[3][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[3][4].value).toBe 'Foo'
    expect(tokens[3][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[3][5].value).toBe '('
    expect(tokens[3][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[3][6].value).toBe 'foobar'
    expect(tokens[3][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.input.scilab']

    expect(tokens[3][7].value).toBe ','
    expect(tokens[3][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.separator.parameters.scilab']

    expect(tokens[3][8].value).toBe 'baz'
    expect(tokens[3][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.input.scilab']

    expect(tokens[3][9].value).toBe ')'
    expect(tokens[3][9].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][10].value).toBe ''
    expect(tokens[3][10].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[3][11]).not.toBeDefined()

    # function [retVal,retVal]=Foo(bar,baz)
    expect(tokens[4][0].value).toBe 'function'
    expect(tokens[4][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[4][1].value).toBe ' '
    expect(tokens[4][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[4][2].value).toBe '['
    expect(tokens[4][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.brackets.begin.scilab']

    expect(tokens[4][3].value).toBe 'retVal'
    expect(tokens[4][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.output.scilab']

    expect(tokens[4][4].value).toBe ','
    expect(tokens[4][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.separator.parameters.scilab']

    expect(tokens[4][5].value).toBe 'retVal'
    expect(tokens[4][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.output.scilab']

    expect(tokens[4][6].value).toBe ']'
    expect(tokens[4][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.brackets.end.scilab']

    expect(tokens[4][7].value).toBe ' '
    expect(tokens[4][7].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[4][8].value).toBe '='
    expect(tokens[4][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[4][9].value).toBe ' '
    expect(tokens[4][9].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[4][10].value).toBe 'Foo'
    expect(tokens[4][10].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[4][11].value).toBe '('
    expect(tokens[4][11].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[4][12].value).toBe 'foobar'
    expect(tokens[4][12].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.input.scilab']

    expect(tokens[4][13].value).toBe ','
    expect(tokens[4][13].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.separator.parameters.scilab']

    expect(tokens[4][14].value).toBe 'baz'
    expect(tokens[4][14].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.input.scilab']

    expect(tokens[4][15].value).toBe ')'
    expect(tokens[4][15].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[4][16].value).toBe ''
    expect(tokens[4][16].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[4][17]).not.toBeDefined()

  it 'checks some invalid \"function\" declarations', ->
    tokens = grammar.tokenizeLines('functionFoo()\n'              +
                                   'function [retVal=Foo()\n'     +
                                   'function ret.=Foo()\n'        +
                                   'function ret. =Foo()\n'       +
                                   'function ret.Val=Foo()\n'     +
                                   'function 123=Foo()\n'       +
                                   'function Foo(123)'            +
                                   'function Foo)'                +
                                   'function Foo(')

    # functionFoo()
    expect(tokens[0][0].value).toBe 'functionFoo()'
    expect(tokens[0][0].scopes).toEqual ['source.scilab']

    expect(tokens[0][1]).not.toBeDefined()

    # function [retVal=Foo()
    expect(tokens[1][0].value).toBe 'function'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[1][1].value).toBe ' '
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[1][2].value).toBe '['
    expect(tokens[1][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.brackets.begin.scilab']

    expect(tokens[1][3].value).toBe 'retVal'
    expect(tokens[1][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.output.scilab']

    expect(tokens[1][4].value).toBe '='
    expect(tokens[1][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[1][5].value).toBe 'Foo'
    expect(tokens[1][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[1][6].value).toBe '('
    expect(tokens[1][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[1][7].value).toBe ')'
    expect(tokens[1][7].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[1][8].value).toBe ''
    expect(tokens[1][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[1][9]).not.toBeDefined()

    # function ret.=Foo()
    expect(tokens[2][0].value).toBe 'function'
    expect(tokens[2][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[2][1].value).toBe ' '
    expect(tokens[2][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[2][2].value).toBe 'ret'
    expect(tokens[2][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.output.scilab']

    expect(tokens[2][3].value).toBe '.='
    expect(tokens[2][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.invalid.illegal.scilab']

    expect(tokens[2][4].value).toBe 'Foo'
    expect(tokens[2][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[2][5].value).toBe '('
    expect(tokens[2][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[2][6].value).toBe ')'
    expect(tokens[2][6].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[2][7].value).toBe ''
    expect(tokens[2][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[2][8]).not.toBeDefined()

    # function ret. =Foo()
    expect(tokens[3][0].value).toBe 'function'
    expect(tokens[3][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[3][1].value).toBe ' '
    expect(tokens[3][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][2].value).toBe 'ret'
    expect(tokens[3][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.other.object.scilab']

    expect(tokens[3][3].value).toBe '.'
    expect(tokens[3][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[3][4].value).toBe ' '
    expect(tokens[3][4].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][5].value).toBe '='
    expect(tokens[3][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[3][6].value).toBe 'Foo'
    expect(tokens[3][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[3][7].value).toBe '('
    expect(tokens[3][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[3][8].value).toBe ')'
    expect(tokens[3][8].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][9].value).toBe ''
    expect(tokens[3][9].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[3][10]).not.toBeDefined()

    expect(tokens[3][10]).not.toBeDefined()

    # function ret.Val=Foo()
    expect(tokens[4][0].value).toBe 'function'
    expect(tokens[4][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[4][1].value).toBe ' '
    expect(tokens[4][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[4][2].value).toBe 'ret'
    expect(tokens[4][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.other.object.invalid.illegal.scilab']

    expect(tokens[4][3].value).toBe '.'
    expect(tokens[4][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[4][4].value).toBe 'Val'
    expect(tokens[4][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.other.object.invalid.illegal.scilab']

    expect(tokens[4][5].value).toBe '='
    expect(tokens[4][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[4][6].value).toBe 'Foo'
    expect(tokens[4][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[4][7].value).toBe '('
    expect(tokens[4][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[4][8].value).toBe ')'
    expect(tokens[4][8].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[4][9].value).toBe ''
    expect(tokens[4][9].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[4][10]).not.toBeDefined()

    # function 123=Foo()
    expect(tokens[5][0].value).toBe 'function'
    expect(tokens[5][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.scilab']

    expect(tokens[5][1].value).toBe ' '
    expect(tokens[5][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[5][2].value).toBe '123'
    expect(tokens[5][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'variable.parameter.output.invalid.illegal.scilab']

    expect(tokens[5][3].value).toBe '='
    expect(tokens[5][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[5][4].value).toBe 'Foo'
    expect(tokens[5][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[5][5].value).toBe '('
    expect(tokens[5][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.section.parens.begin.scilab']

    expect(tokens[5][6].value).toBe ')'
    expect(tokens[5][6].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[5][7].value).toBe ''
    expect(tokens[5][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.section.function.begin.scilab']

    expect(tokens[5][8]).not.toBeDefined()

  it "checks structs or tlists", ->
    tokens = grammar.tokenizeLines('foo.bar\nfoo2.bar2\nfoo.bar.baz\n' + # valid
                                   'foo.123\nfoo. ')

    # foo.bar
    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[0][1].value).toBe '.'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][2].value).toBe 'bar'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[0][3]).not.toBeDefined()

    # foo2.bar2
    expect(tokens[1][0].value).toBe 'foo2'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[1][1].value).toBe '.'
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[1][2].value).toBe 'bar2'
    expect(tokens[1][2].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[1][3]).not.toBeDefined()

    # foo.bar.baz
    expect(tokens[2][0].value).toBe 'foo'
    expect(tokens[2][0].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[2][1].value).toBe '.'
    expect(tokens[2][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[2][2].value).toBe 'bar'
    expect(tokens[2][2].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[2][3].value).toBe '.'
    expect(tokens[2][3].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[2][4].value).toBe 'baz'
    expect(tokens[2][4].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[2][5]).not.toBeDefined()

    # foo.123
    expect(tokens[3][0].value).toBe 'foo'
    expect(tokens[3][0].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[3][1].value).toBe '.'
    expect(tokens[3][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[3][2].value).toBe '123'
    expect(tokens[3][2].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[3][3]).not.toBeDefined()

    # foo.123
    expect(tokens[4][0].value).toBe 'foo'
    expect(tokens[4][0].scopes).toEqual ['source.scilab', 'variable.other.object.scilab']

    expect(tokens[4][1].value).toBe '.'
    expect(tokens[4][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[4][2].value).toBe ' '
    expect(tokens[4][2].scopes).toEqual ['source.scilab']

    expect(tokens[4][3]).not.toBeDefined()

  it "tokenizes some invalid signs", ->
    tokens = grammar.tokenizeLines('!\n?\n"\n$\n%\n&\n\\\n/\n(\n)\n[\n]\n=\n+\n-\n*\n^\n~\n\'\n#\n<\n>\n|\n \n:\n;\n,\n.\na\n0\n_')

    expect(tokens[0][0].value).toBe '!'
    expect(tokens[0][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[1][0].value).toBe '?'
    expect(tokens[1][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[2][0].value).toBe '"'
    expect(tokens[2][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[3][0].value).toBe '$'
    expect(tokens[3][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[4][0].value).toBe '%'
    expect(tokens[4][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[5][0].value).toBe '&'
    expect(tokens[5][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[6][0].value).toBe '\\'
    expect(tokens[6][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[7][0].value).toBe '/'
    expect(tokens[7][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[8][0].value).toBe '('
    expect(tokens[8][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[9][0].value).toBe ')'
    expect(tokens[9][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[10][0].value).toBe '['
    expect(tokens[10][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[11][0].value).toBe ']'
    expect(tokens[11][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[12][0].value).toBe '='
    expect(tokens[12][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[13][0].value).toBe '+'
    expect(tokens[13][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[14][0].value).toBe '-'
    expect(tokens[14][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[15][0].value).toBe '*'
    expect(tokens[15][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[16][0].value).toBe '^'
    expect(tokens[16][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[17][0].value).toBe '~'
    expect(tokens[17][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[18][0].value).toBe '\''
    expect(tokens[18][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[19][0].value).toBe '#'
    expect(tokens[19][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[20][0].value).toBe '<'
    expect(tokens[20][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[21][0].value).toBe '>'
    expect(tokens[21][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[22][0].value).toBe '|'
    expect(tokens[22][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[23][0].value).toBe ' '
    expect(tokens[23][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[24][0].value).toBe ':'
    expect(tokens[24][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[25][0].value).toBe ';'
    expect(tokens[25][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[26][0].value).toBe ','
    expect(tokens[26][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[27][0].value).toBe '.'
    expect(tokens[27][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[28][0].value).toBe 'a'
    expect(tokens[28][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[29][0].value).toBe '0'
    expect(tokens[29][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']
    expect(tokens[30][0].value).toBe '_'
    expect(tokens[30][0].scopes).not.toEqual ['source.scilab', 'invalid.illegal.scilab']

  it "tokenizes multi-line strings (double)", ->
    tokens = grammar.tokenizeLines('"1\n2"')

    # Line 0
    expect(tokens[0][0].value).toBe '"'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'string.quoted.double.scilab', 'punctuation.definition.string.begin.scilab']

    expect(tokens[0][1].value).toBe '1'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'string.quoted.double.scilab']

    expect(tokens[0][3]).not.toBeDefined()

    # Line 1
    expect(tokens[1][0].value).toBe '2'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'string.quoted.double.scilab']

    expect(tokens[1][1].value).toBe '"'
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'string.quoted.double.scilab', 'punctuation.definition.string.end.scilab']

    expect(tokens[1][3]).not.toBeDefined()

  it "tokenizes multi-line strings (single)", ->
    tokens = grammar.tokenizeLines('\'1\n2\'')

    # Line 0
    expect(tokens[0][0].value).toBe '\''
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'string.quoted.single.scilab', 'punctuation.definition.string.begin.scilab']

    expect(tokens[0][1].value).toBe '1'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'string.quoted.single.scilab']

    expect(tokens[0][3]).not.toBeDefined()

    # Line 1
    expect(tokens[1][0].value).toBe '2'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'string.quoted.single.scilab']

    expect(tokens[1][1].value).toBe '\''
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'string.quoted.single.scilab', 'punctuation.definition.string.end.scilab']

    expect(tokens[1][3]).not.toBeDefined()
