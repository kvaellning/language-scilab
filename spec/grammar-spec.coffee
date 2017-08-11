describe "Scilab grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("scilab-language")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.scilab")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.scilab"

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

  it 'checks \"function Foo()\"', ->
    tokens = grammar.tokenizeLines('function Foo()')

    # function Foo()
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'Foo'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][4].value).toBe ')'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][5]).not.toBeDefined()

  it 'checks \"function Foo(foobar)\"', ->
    tokens = grammar.tokenizeLines('function Foo(foobar)')

    # function Foo(bar)
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'Foo'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][4].value).toBe 'foobar'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[0][5].value).toBe ')'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][6]).not.toBeDefined()

  it 'checks \"function Foo(foobar,baz)\"', ->
    tokens = grammar.tokenizeLines('function Foo(foobar,baz)')

    # function Foo(bar,baz)
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'Foo'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][4].value).toBe 'foobar'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[0][5].value).toBe ','
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.separator.parameter.scilab']

    expect(tokens[0][6].value).toBe 'baz'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[0][7].value).toBe ')'
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][8]).not.toBeDefined()

  it 'checks \"function retVal=Foo(foobar,baz)\"', ->
    tokens = grammar.tokenizeLines('function retVal=Foo(foobar,baz)')

    # function retVal=Foo(bar,baz)
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'retVal'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][3].value).toBe '='
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][4].value).toBe 'Foo'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][5].value).toBe '('
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][6].value).toBe 'foobar'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[0][7].value).toBe ','
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.separator.parameter.scilab']

    expect(tokens[0][8].value).toBe 'baz'
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[0][9].value).toBe ')'
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][10]).not.toBeDefined()

  it 'checks \"function [retVal,retVal] = Foo(foobar,baz)\"', ->
    tokens = grammar.tokenizeLines('function [retVal,retVal] = Foo(foobar,baz)')

    # function [retVal,retVal]=Foo(foobar,baz)
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe '['
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.section.brackets.begin.scilab']

    expect(tokens[0][3].value).toBe 'retVal'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][4].value).toBe ','
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.separator.parameter.scilab']

    expect(tokens[0][5].value).toBe 'retVal'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][6].value).toBe ']'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.section.brackets.end.scilab']

    expect(tokens[0][7].value).toBe ' '
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][8].value).toBe '='
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][9].value).toBe ' '
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][10].value).toBe 'Foo'
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][11].value).toBe '('
    expect(tokens[0][11].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][12].value).toBe 'foobar'
    expect(tokens[0][12].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[0][13].value).toBe ','
    expect(tokens[0][13].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.separator.parameter.scilab']

    expect(tokens[0][14].value).toBe 'baz'
    expect(tokens[0][14].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[0][15].value).toBe ')'
    expect(tokens[0][15].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][16]).not.toBeDefined()

  it 'checks \"function Foo\"', ->
    tokens = grammar.tokenizeLines('function Foo')

    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'Foo'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][3].value).toBe ''
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][4]).not.toBeDefined()

  it 'checks \"function foo = Foo\"', ->
    tokens = grammar.tokenizeLines('function foo = Foo')

    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'foo'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][3].value).toBe ' '
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][4].value).toBe '='
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][6].value).toBe 'Foo'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][7].value).toBe ''
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][8]).not.toBeDefined()

  it 'checks \"function Foo // bar\"', ->
    tokens = grammar.tokenizeLines('function Foo // bar')

    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'Foo'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][3].value).toBe ' '
    expect(tokens[0][3].scopes).toEqual ['source.scilab']

    expect(tokens[0][4].value).toBe '// bar'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[0][5]).not.toBeDefined()


  it 'checks \"function [ret, ...\nval] = Foo // bar\" (with a lot of additional stuff)', ->
    tokens = grammar.tokenizeLines('function [ret, ... foo // bar\n' +
                                   '          val] ... foo // bar\n' +
                                   '          = ... foo // bar\n'  +
                                   '          Foo ... foo // bar\n' +
                                   '          (in, ... foo // bar\n' +
                                   '          val) ... // bar')

    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe '['
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.section.brackets.begin.scilab']

    expect(tokens[0][3].value).toBe 'ret'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][4].value).toBe ','
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.separator.parameter.scilab']

    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab']

    expect(tokens[0][6].value).toBe '...'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.separator.continuation.scilab']

    expect(tokens[0][7].value).toBe ' '
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab']

    expect(tokens[0][8].value).toBe 'foo'
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'invalid.illegal.scilab']

    expect(tokens[0][9].value).toBe ' '
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab']

    expect(tokens[0][10].value).toBe '// bar'
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[0][11]).not.toBeDefined()

    expect(tokens[1][0].value).toBe '          '
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab']

    expect(tokens[1][1].value).toBe 'val'
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[1][2].value).toBe ']'
    expect(tokens[1][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.section.brackets.end.scilab']

    expect(tokens[1][3].value).toBe ' '
    expect(tokens[1][3].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[1][4].value).toBe '...'
    expect(tokens[1][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.separator.continuation.scilab']

    expect(tokens[1][5].value).toBe ' '
    expect(tokens[1][5].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[1][6].value).toBe 'foo'
    expect(tokens[1][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'invalid.illegal.scilab']

    expect(tokens[1][7].value).toBe ' '
    expect(tokens[1][7].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[1][8].value).toBe '// bar'
    expect(tokens[1][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[1][9]).not.toBeDefined()

    expect(tokens[2][0].value).toBe '          '
    expect(tokens[2][0].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[2][1].value).toBe '='
    expect(tokens[2][1].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[2][2].value).toBe ' '
    expect(tokens[2][2].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[2][3].value).toBe '...'
    expect(tokens[2][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.separator.continuation.scilab']

    expect(tokens[2][4].value).toBe ' '
    expect(tokens[2][4].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[2][5].value).toBe 'foo'
    expect(tokens[2][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'invalid.illegal.scilab']

    expect(tokens[2][6].value).toBe ' '
    expect(tokens[2][6].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[2][7].value).toBe '// bar'
    expect(tokens[2][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[2][8]).not.toBeDefined()

    expect(tokens[3][0].value).toBe '          '
    expect(tokens[3][0].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][1].value).toBe 'Foo'
    expect(tokens[3][1].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[3][2].value).toBe ' '
    expect(tokens[3][2].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][3].value).toBe '...'
    expect(tokens[3][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.separator.continuation.scilab']

    expect(tokens[3][4].value).toBe ' '
    expect(tokens[3][4].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][5].value).toBe 'foo'
    expect(tokens[3][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'invalid.illegal.scilab']

    expect(tokens[3][6].value).toBe ' '
    expect(tokens[3][6].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[3][7].value).toBe '// bar'
    expect(tokens[3][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[3][8]).not.toBeDefined()

    expect(tokens[4][0].value).toBe '          '
    expect(tokens[4][0].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[4][1].value).toBe '('
    expect(tokens[4][1].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[4][2].value).toBe 'in'
    expect(tokens[4][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[4][3].value).toBe ','
    expect(tokens[4][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.separator.parameter.scilab']

    expect(tokens[4][4].value).toBe ' '
    expect(tokens[4][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab']

    expect(tokens[4][5].value).toBe '...'
    expect(tokens[4][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.separator.continuation.scilab']

    expect(tokens[4][6].value).toBe ' '
    expect(tokens[4][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab']

    expect(tokens[4][7].value).toBe 'foo'
    expect(tokens[4][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'invalid.illegal.scilab']

    expect(tokens[4][8].value).toBe ' '
    expect(tokens[4][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab']

    expect(tokens[4][9].value).toBe '// bar'
    expect(tokens[4][9].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[4][10]).not.toBeDefined()

    expect(tokens[5][0].value).toBe '          '
    expect(tokens[5][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab']

    expect(tokens[5][1].value).toBe 'val'
    expect(tokens[5][1].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'variable.parameter.input.scilab']

    expect(tokens[5][2].value).toBe ')'
    expect(tokens[5][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[5][3].value).toBe ' '
    expect(tokens[5][3].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[5][4].value).toBe '...'
    expect(tokens[5][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'punctuation.separator.continuation.invalid.illegal.scilab']

    expect(tokens[5][5].value).toBe ' '
    expect(tokens[5][5].scopes).toEqual ['source.scilab']

    expect(tokens[5][6].value).toBe '// bar'
    expect(tokens[5][6].scopes).toEqual ['source.scilab', 'comment.line.double-slash.scilab']

  it 'checks invalid declaration \"functionFoo()\"', ->
    tokens = grammar.tokenizeLines('functionFoo()')

    # functionFoo()
    expect(tokens[0][0].value).toBe 'functionFoo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function-call.scilab']

    expect(tokens[0][1].value).toBe '('
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function-call.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][2].value).toBe ')'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function-call.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][3]).not.toBeDefined()

  it 'checks invalid declaration \"function [retVal=Foo()\"', ->
    tokens = grammar.tokenizeLines('function [retVal=Foo()')

    # function [retVal=Foo()
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe '['
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.section.brackets.begin.scilab']

    expect(tokens[0][3].value).toBe 'retVal'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][4].value).toBe '='
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'keyword.operator.invalid.illegal.scilab']

    expect(tokens[0][5].value).toBe 'Foo'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.invalid.illegal.scilab']

    expect(tokens[0][6].value).toBe '('
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.invalid.illegal.scilab']

    expect(tokens[0][7].value).toBe ')'
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.invalid.illegal.scilab']

    expect(tokens[0][8]).not.toBeDefined()

  it 'checks invalid declaration \"function ret.=Foo()\"', ->
    tokens = grammar.tokenizeLines('function ret.=Foo()')

    # function ret.=Foo()
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'ret'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][3].value).toBe '.'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[0][4].value).toBe '='
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][5].value).toBe 'Foo'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][6].value).toBe '('
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][7].value).toBe ')'
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][8]).not.toBeDefined()

  it 'checks invalid declaration \"function ret. =Foo()\"', ->
    tokens = grammar.tokenizeLines('function ret. =Foo()')

    # function ret. =Foo()
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'ret'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][3].value).toBe '.'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[0][4].value).toBe ' '
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][5].value).toBe '='
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][6].value).toBe 'Foo'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][7].value).toBe '('
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][8].value).toBe ')'
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][9]).not.toBeDefined()

  it 'checks invalid declaration \"function ret.Val=Foo()\"', ->
    tokens = grammar.tokenizeLines('function ret.Val=Foo()')

    # function ret.Val=Foo()
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe 'ret'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.scilab']

    expect(tokens[0][3].value).toBe '.'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[0][4].value).toBe 'Val'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.other.member.scilab']

    expect(tokens[0][5].value).toBe '='
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][6].value).toBe 'Foo'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][7].value).toBe '('
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][8].value).toBe ')'
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][9]).not.toBeDefined()

  it 'checks invalid declaration \"function 123=Foo()\"', ->
    tokens = grammar.tokenizeLines('function 123=Foo()')

    # function 123=Foo()
    expect(tokens[0][0].value).toBe 'function'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'storage.type.function.begin.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.function.scilab']

    expect(tokens[0][2].value).toBe '123'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.return.scilab', 'variable.parameter.output.invalid.illegal.scilab']

    expect(tokens[0][3].value).toBe '='
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][4].value).toBe 'Foo'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'entity.name.function.scilab']

    expect(tokens[0][5].value).toBe '('
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.begin.scilab']

    expect(tokens[0][6].value).toBe ')'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.function.scilab', 'meta.function.parameters.scilab', 'punctuation.definition.parameters.end.scilab']

    expect(tokens[0][7]).not.toBeDefined()

  # it 'checks invalid declaration \"functionFoo(123)\"', ->
  #   tokens = grammar.tokenizeLines('function Foo(123)')
  #
  # it 'checks invalid declaration \"function Foo)\"', ->
  #   tokens = grammar.tokenizeLines('function Foo)')
  #
  # it 'checks invalid declaration \"function Foo(\"', ->
  #   tokens = grammar.tokenizeLines('function Foo(')
  #
   it 'checks assignment \"foo =struct(); //foobar() = 1;\"', ->
    tokens = grammar.tokenizeLines('foo =struct(); //foobar() = 1;')

    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.assignment.scilab']

    expect(tokens[0][1].value).toBe ' '
    expect(tokens[0][1].scopes).toEqual ['source.scilab']

    expect(tokens[0][2].value).toBe '='
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][3].value).toBe 'struct'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.function-call.scilab', 'support.function.scilab']

    expect(tokens[0][4].value).toBe '('
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.function-call.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][5].value).toBe ')'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.function-call.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][6].value).toBe ';'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][7].value).toBe ' '
    expect(tokens[0][7].scopes).toEqual ['source.scilab']

    expect(tokens[0][8].value).toBe '//foobar() = 1;'
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[0][9]).not.toBeDefined()

  it 'checks assignment \"foo(bar(1)) = 1\"', ->
    tokens = grammar.tokenizeLines('foo(bar(1)) = 1')

    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.assignment.scilab']

    expect(tokens[0][1].value).toBe '('
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][2].value).toBe 'bar'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'support.function.scilab']

    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][4].value).toBe '1'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'constant.numeric.scilab']

    expect(tokens[0][5].value).toBe ')'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][6].value).toBe ')'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][7].value).toBe ' '
    expect(tokens[0][7].scopes).toEqual ['source.scilab']

    expect(tokens[0][8].value).toBe '='
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][9].value).toBe ' '
    expect(tokens[0][9].scopes).toEqual ['source.scilab']

    expect(tokens[0][10].value).toBe '1'
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[0][11]).not.toBeDefined()

  it 'checks assignment \"foo.disp=1\"', ->
    tokens = grammar.tokenizeLines('foo.disp=1')

    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab']

    expect(tokens[0][1].value).toBe '.'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][2].value).toBe 'disp'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.other.member.scilab']

    expect(tokens[0][3].value).toBe '='
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][4].value).toBe '1'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[0][5]).not.toBeDefined()

  it "checks assignment \"foo(a)(b)(c)=foo;\"", ->
    tokens = grammar.tokenizeLines('foo(a)(b)(c)=foo;')

    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.assignment.scilab']

    expect(tokens[0][1].value).toBe '('
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][2].value).toBe 'a'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][3].value).toBe ')'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][4].value).toBe '('
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][5].value).toBe 'b'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][6].value).toBe ')'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][7].value).toBe '('
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][8].value).toBe 'c'
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][9].value).toBe ')'
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][10].value).toBe '='
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][11].value).toBe 'foo'
    expect(tokens[0][11].scopes).toEqual ['source.scilab']

    expect(tokens[0][12].value).toBe ';'
    expect(tokens[0][12].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][13]).not.toBeDefined()

  it "checks assignment \"[foo(a)(b)(c)]=foo;\"", ->
    tokens = grammar.tokenizeLines('[foo(a)(b)(c)]=foo;')

    expect(tokens[0][0].value).toBe '['
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.section.brackets.begin.scilab']

    expect(tokens[0][1].value).toBe 'foo'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.assignment.scilab']

    expect(tokens[0][2].value).toBe '('
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][3].value).toBe 'a'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][4].value).toBe ')'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][5].value).toBe '('
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][6].value).toBe 'b'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][7].value).toBe ')'
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][8].value).toBe '('
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][9].value).toBe 'c'
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][10].value).toBe ')'
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][11].value).toBe ']'
    expect(tokens[0][11].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.section.brackets.end.scilab']

    expect(tokens[0][12].value).toBe '='
    expect(tokens[0][12].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][13].value).toBe 'foo'
    expect(tokens[0][13].scopes).toEqual ['source.scilab']

    expect(tokens[0][14].value).toBe ';'
    expect(tokens[0][14].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][15]).not.toBeDefined()

  it "checks assignment \"[foo(a)(b)(c).d]=foo;\"", ->
    tokens = grammar.tokenizeLines('[foo(a)(b)(c).d]=foo;')

    expect(tokens[0][0].value).toBe '['
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.section.brackets.begin.scilab']

    expect(tokens[0][1].value).toBe 'foo'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][2].value).toBe '('
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][3].value).toBe 'a'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][4].value).toBe ')'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][5].value).toBe '('
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][6].value).toBe 'b'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][7].value).toBe ')'
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][8].value).toBe '('
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][9].value).toBe 'c'
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][10].value).toBe ')'
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][11].value).toBe '.'
    expect(tokens[0][11].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][12].value).toBe 'd'
    expect(tokens[0][12].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.other.member.scilab']

    expect(tokens[0][13].value).toBe ']'
    expect(tokens[0][13].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.section.brackets.end.scilab']

    expect(tokens[0][14].value).toBe '='
    expect(tokens[0][14].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][15].value).toBe 'foo'
    expect(tokens[0][15].scopes).toEqual ['source.scilab']

    expect(tokens[0][16].value).toBe ';'
    expect(tokens[0][16].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][17]).not.toBeDefined()

  it "checks structs or tlists (simple access)", ->
    tokens = grammar.tokenizeLines('foo.bar\nfoo2.bar2\nfoo.bar.baz\n' + # valid
                                   'foo.123\nfoo. ')

    # foo.bar
    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab']

    expect(tokens[0][1].value).toBe '.'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][2].value).toBe 'bar'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'variable.other.member.scilab']

    expect(tokens[0][3]).not.toBeDefined()

    # foo2.bar2
    expect(tokens[1][0].value).toBe 'foo2'
    expect(tokens[1][0].scopes).toEqual ['source.scilab']

    expect(tokens[1][1].value).toBe '.'
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[1][2].value).toBe 'bar2'
    expect(tokens[1][2].scopes).toEqual ['source.scilab', 'variable.other.member.scilab']

    expect(tokens[1][3]).not.toBeDefined()

    # foo.bar.baz
    expect(tokens[2][0].value).toBe 'foo'
    expect(tokens[2][0].scopes).toEqual ['source.scilab']

    expect(tokens[2][1].value).toBe '.'
    expect(tokens[2][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[2][2].value).toBe 'bar'
    expect(tokens[2][2].scopes).toEqual ['source.scilab', 'variable.other.member.scilab']

    expect(tokens[2][3].value).toBe '.'
    expect(tokens[2][3].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[2][4].value).toBe 'baz'
    expect(tokens[2][4].scopes).toEqual ['source.scilab', 'variable.other.member.scilab']

    expect(tokens[2][5]).not.toBeDefined()

    # foo.123
    expect(tokens[3][0].value).toBe 'foo'
    expect(tokens[3][0].scopes).toEqual ['source.scilab']

    expect(tokens[3][1].value).toBe '.'
    expect(tokens[3][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[3][2].value).toBe '123'
    expect(tokens[3][2].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[3][3]).not.toBeDefined()

    # foo.123
    expect(tokens[4][0].value).toBe 'foo'
    expect(tokens[4][0].scopes).toEqual ['source.scilab']

    expect(tokens[4][1].value).toBe '.'
    expect(tokens[4][1].scopes).toEqual ['source.scilab', 'punctuation.accessor.invalid.illegal.scilab']

    expect(tokens[4][2].value).toBe ' '
    expect(tokens[4][2].scopes).toEqual ['source.scilab']

    expect(tokens[4][3]).not.toBeDefined()

  it "Checks structs / tlists (using parenthesis)", ->
    tokens = grammar.tokenizeLines('foo(\'foo\')\n' +
                                   'foo(\'a\',b,c)\n')

  it "Checks structs / tlists ( parenthesis)", ->
    tokens = grammar.tokenizeLines('foo(1)(a)\n'    +
                                   'foo(\'foo\')(1)(1)\n' +
                                   'foo(foo(a))(a)\n' +
                                   'foo(a.b)(a)\n'  +
                                   'foo(a.b).foo\n' +
                                   'foo( a(foo)(a(foo).b) )\n'  +
                                   'foo( foo(1)(2)(3)(4))')

  it "Checks invalid structs / tlists", ->
    tokens = grammar.tokenizeLines('.foo\n'
                                   'foo.1\n'
                                   '.foo(1).foo')
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
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'punctuation.definition.string.begin.scilab']

    expect(tokens[0][1].value).toBe '1'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'string.quoted.double.scilab']

    expect(tokens[0][3]).not.toBeDefined()

    # Line 1
    expect(tokens[1][0].value).toBe '2'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'string.quoted.double.scilab']

    expect(tokens[1][1].value).toBe '"'
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'punctuation.definition.string.end.scilab']

    expect(tokens[1][3]).not.toBeDefined()

  it "tokenizes multi-line strings (single)", ->
    tokens = grammar.tokenizeLines('\'1\n2\'')

    # Line 0
    expect(tokens[0][0].value).toBe '\''
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'punctuation.definition.string.begin.scilab']

    expect(tokens[0][1].value).toBe '1'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'string.quoted.single.scilab']

    expect(tokens[0][3]).not.toBeDefined()

    # Line 1
    expect(tokens[1][0].value).toBe '2'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'string.quoted.single.scilab']

    expect(tokens[1][1].value).toBe '\''
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'punctuation.definition.string.end.scilab']

    expect(tokens[1][3]).not.toBeDefined()

  it "checks the patch of 0.6.1", ->
    tokens = grammar.tokenizeLines('execstr( AFunction("if exists(val) then foo(1) = 1; end") );')

    expect(tokens[0][0].value).toBe 'execstr'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'support.function.scilab']

    expect(tokens[0][1].value).toBe '('
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][2].value).toBe ' AFunction'
    expect(tokens[0][2].scopes).toEqual ['source.scilab']

    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.scilab',  'punctuation.brace.round.scilab']

    expect(tokens[0][4].value).toBe '"'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'punctuation.definition.string.begin.scilab']

    expect(tokens[0][5].value).toBe 'if exists(val) then foo(1) = 1; end'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'string.quoted.double.scilab']

    expect(tokens[0][6].value).toBe '"'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'punctuation.definition.string.end.scilab']

    expect(tokens[0][7].value).toBe ')'
    expect(tokens[0][7].scopes).toEqual ['source.scilab',  'punctuation.brace.round.scilab']

    expect(tokens[0][8].value).toBe ' '
    expect(tokens[0][8].scopes).toEqual ['source.scilab']

    expect(tokens[0][9].value).toBe ')'
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][10].value).toBe ';'
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

  it "checks a patch of 0.6.4", ->
    tokens = grammar.tokenizeLines('for ka(me) do ha(me(ha).foo).bar end endfunction')

    expect(tokens[0][0].value).toBe 'for'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'keyword.control.repeat.scilab']

    expect(tokens[0][1].value).toBe ' ka'
    expect(tokens[0][1].scopes).toEqual ['source.scilab']

    expect(tokens[0][2].value).toBe '('
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][3].value).toBe 'me'
    expect(tokens[0][3].scopes).toEqual ['source.scilab']

    expect(tokens[0][4].value).toBe ')'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][5].value).toBe ' '
    expect(tokens[0][5].scopes).toEqual ['source.scilab']

    expect(tokens[0][6].value).toBe 'do'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'keyword.control.repeat.scilab']

    expect(tokens[0][7].value).toBe ' ha'
    expect(tokens[0][7].scopes).toEqual ['source.scilab']

    expect(tokens[0][8].value).toBe '('
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][9].value).toBe 'me'
    expect(tokens[0][9].scopes).toEqual ['source.scilab']

    expect(tokens[0][10].value).toBe '('
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][11].value).toBe 'ha'
    expect(tokens[0][11].scopes).toEqual ['source.scilab']

    expect(tokens[0][12].value).toBe ')'
    expect(tokens[0][12].scopes).toEqual ['source.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][13].value).toBe '.'
    expect(tokens[0][13].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][14].value).toBe 'foo'
    expect(tokens[0][14].scopes).toEqual ['source.scilab', 'variable.other.member.scilab']

    expect(tokens[0][15].value).toBe ')'
    expect(tokens[0][15].scopes).toEqual ['source.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][16].value).toBe '.'
    expect(tokens[0][16].scopes).toEqual ['source.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][17].value).toBe 'bar'
    expect(tokens[0][17].scopes).toEqual ['source.scilab', 'variable.other.member.scilab']

    expect(tokens[0][18].value).toBe ' '
    expect(tokens[0][18].scopes).toEqual ['source.scilab']

    expect(tokens[0][19].value).toBe 'end'
    expect(tokens[0][19].scopes).toEqual ['source.scilab', 'keyword.control.scilab']

    expect(tokens[0][20].value).toBe ' endfunction'
    expect(tokens[0][20].scopes).toEqual ['source.scilab', 'storage.type.function.end.scilab']

    expect(tokens[0][21]).not.toBeDefined()

  it "checks error for code after continuation marks", ->
    tokens = grammar.tokenizeLines('foo ... bar // baz')

    expect(tokens[0][0].value).toBe 'foo '
    expect(tokens[0][0].scopes).toEqual ['source.scilab']

    expect(tokens[0][1].value).toBe '...'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'punctuation.separator.continuation.scilab']

    expect(tokens[0][2].value).toBe ' '
    expect(tokens[0][2].scopes).toEqual ['source.scilab']

    expect(tokens[0][3].value).toBe 'bar'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'invalid.illegal.scilab']

    expect(tokens[0][4].value).toBe ' '
    expect(tokens[0][4].scopes).toEqual ['source.scilab']

    expect(tokens[0][5].value).toBe '// baz'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'comment.line.double-slash.scilab']

    expect(tokens[0][6]).not.toBeDefined()

  # check if this renders the regex engine unresponsive
  it "checks if tokenizing an assignment pattern takes unusual long (0.7.3 bug)", ->
    tokens = grammar.tokenizeLines('if or(foobarbazfoobarbazfoobarbazfoobarbaz) foo [bar] =')

  it "checks if multiple assignments in one line with parenthesis fail", ->
    tokens = grammar.tokenizeLines('foo(\'foo\') = 1; foo(foo(1).foo) = 1;')

    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.assignment.scilab']

    expect(tokens[0][1].value).toBe '('
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][2].value).toBe '\''
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.definition.string.begin.scilab']

    expect(tokens[0][3].value).toBe 'foo'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'string.quoted.single.scilab']

    expect(tokens[0][4].value).toBe '\''
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.definition.string.end.scilab']

    expect(tokens[0][5].value).toBe ')'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][6].value).toBe ' '
    expect(tokens[0][6].scopes).toEqual ['source.scilab']

    expect(tokens[0][7].value).toBe '='
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][8].value).toBe ' '
    expect(tokens[0][8].scopes).toEqual ['source.scilab']

    expect(tokens[0][9].value).toBe '1'
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[0][10].value).toBe ';'
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][11].value).toBe ' '
    expect(tokens[0][11].scopes).toEqual ['source.scilab']

    expect(tokens[0][12].value).toBe 'foo'
    expect(tokens[0][12].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.assignment.scilab']

    expect(tokens[0][13].value).toBe '('
    expect(tokens[0][13].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][14].value).toBe 'foo'
    expect(tokens[0][14].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][15].value).toBe '('
    expect(tokens[0][15].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][16].value).toBe '1'
    expect(tokens[0][16].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'constant.numeric.scilab']

    expect(tokens[0][17].value).toBe ')'
    expect(tokens[0][17].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][18].value).toBe '.'
    expect(tokens[0][18].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][19].value).toBe 'foo'
    expect(tokens[0][19].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.other.member.scilab']

    expect(tokens[0][20].value).toBe ')'
    expect(tokens[0][20].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][21].value).toBe ' '
    expect(tokens[0][21].scopes).toEqual ['source.scilab']

    expect(tokens[0][22].value).toBe '='
    expect(tokens[0][22].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][23].value).toBe ' '
    expect(tokens[0][23].scopes).toEqual ['source.scilab']

    expect(tokens[0][24].value).toBe '1'
    expect(tokens[0][24].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[0][25].value).toBe ';'
    expect(tokens[0][25].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][26]).not.toBeDefined()

  it "checks assignment to a predefined function", ->
    tokens = grammar.tokenizeLines('bar=1;')

    expect(tokens[0][0].value).toBe 'bar'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'support.function.scilab']

    expect(tokens[0][1].value).toBe '='
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][2].value).toBe '1'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[0][3].value).toBe ';'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][4]).not.toBeDefined()

  it "checks assignment to a predefined variable", ->
    tokens = grammar.tokenizeLines('SCI=1;')

    expect(tokens[0][0].value).toBe 'SCI'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'support.constant.scilab']

    expect(tokens[0][1].value).toBe '='
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][2].value).toBe '1'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[0][3].value).toBe ';'
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][4]).not.toBeDefined()

  it "checks the patch of 0.8.1 (infinite backtracking)", ->
    tokens = grammar.tokenizeLines('foo.foobarbaz(foobarbaz.foobarbaz(foobarbaz)) = [];')

    expect(tokens[0][0].value).toBe 'foo'
    expect(tokens[0][0].scopes).toEqual ['source.scilab']

    expect(tokens[0][1].value).toBe '.'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][2].value).toBe 'foobarbaz'
    expect(tokens[0][2].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.other.member.scilab']

    expect(tokens[0][3].value).toBe '('
    expect(tokens[0][3].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][4].value).toBe 'foobarbaz'
    expect(tokens[0][4].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][5].value).toBe '.'
    expect(tokens[0][5].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.accessor.scilab']

    expect(tokens[0][6].value).toBe 'foobarbaz'
    expect(tokens[0][6].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'variable.other.member.scilab']

    expect(tokens[0][7].value).toBe '('
    expect(tokens[0][7].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][8].value).toBe 'foobarbaz'
    expect(tokens[0][8].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab']

    expect(tokens[0][9].value).toBe ')'
    expect(tokens[0][9].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][10].value).toBe ')'
    expect(tokens[0][10].scopes).toEqual ['source.scilab', 'meta.name.assignment.scilab', 'punctuation.brace.round.scilab']

    expect(tokens[0][11].value).toBe ' '
    expect(tokens[0][11].scopes).toEqual ['source.scilab']

    expect(tokens[0][12].value).toBe '='
    expect(tokens[0][12].scopes).toEqual ['source.scilab', 'keyword.operator.assignment.scilab']

    expect(tokens[0][13].value).toBe ' '
    expect(tokens[0][13].scopes).toEqual ['source.scilab']

    expect(tokens[0][14].value).toBe '[]'
    expect(tokens[0][14].scopes).toEqual ['source.scilab', 'support.constant.scilab']

    expect(tokens[0][15].value).toBe ';'
    expect(tokens[0][15].scopes).toEqual ['source.scilab', 'punctuation.terminator.scilab']

    expect(tokens[0][16]).not.toBeDefined()

  it "checks problems with operator dot combination -.1", ->
    tokens = grammar.tokenizeLines('-.1\n'  +
                                   '\\.1\n'  +
                                   '-.a\n'  +
                                   '\\.a')

    expect(tokens[0][0].value).toBe '-'
    expect(tokens[0][0].scopes).toEqual ['source.scilab', 'keyword.operator.arithmetic.scilab']

    expect(tokens[0][1].value).toBe '.1'
    expect(tokens[0][1].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[0][2]).not.toBeDefined()

    expect(tokens[1][0].value).toBe '\\'
    expect(tokens[1][0].scopes).toEqual ['source.scilab', 'keyword.operator.arithmetic.scilab']

    expect(tokens[1][1].value).toBe '.1'
    expect(tokens[1][1].scopes).toEqual ['source.scilab', 'constant.numeric.scilab']

    expect(tokens[1][2]).not.toBeDefined()

    expect(tokens[2][0].value).toBe '-.'
    expect(tokens[2][0].scopes).toEqual ['source.scilab', 'keyword.operator.invalid.illegal.scilab']

    expect(tokens[2][1].value).toBe 'a'
    expect(tokens[2][1].scopes).toEqual ['source.scilab', 'variable.other.member.scilab']

    expect(tokens[2][2]).not.toBeDefined()

    expect(tokens[3][0].value).toBe '\\.'
    expect(tokens[3][0].scopes).toEqual ['source.scilab', 'keyword.operator.invalid.illegal.scilab']

    expect(tokens[3][1].value).toBe 'a'
    expect(tokens[3][1].scopes).toEqual ['source.scilab', 'variable.other.member.scilab']

    expect(tokens[3][2]).not.toBeDefined()
