{CompositeDisposable} = require 'atom'

SciViewWhereAmI = require './whereami-view'
path            = require 'path'

module.exports =
  subscriptions: null
  whereamiView:  null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    # activate whereamiView
    @subscriptions.add atom.workspace.observeTextEditors (@editor)  =>
      if not @editor?
        return
        
      @createWhereAmI()
      
      @subscriptions.add @editor.onDidChangeGrammar (grammar) =>
        
        if grammar.name != 'Scilab'
          
          if @whereamiView?
            @whereamiView.destroy()
            @whereamiView = undefined
            
        else
          @createWhereAmI()
      
    # ------
    # subscribe to grammar change events
    @subscriptions.add atom.config.onDidChange 'scilab-language.languageVersion', =>
      @setUsedBuiltins()
      
    @setUsedBuiltins()

  deactivate: () ->
    @subscriptions?.dispose()
    for editor in atom.workspace.getTextEditors()
      editor.gutterWithName('whereami-scilab')?.view?.destroy()

  # ---------------------------------------------------------------
  # Change the used built-in functions
  setUsedBuiltins: () ->
    atom.grammars.removeGrammarForScopeName('source.scilab.version-specific')

    versionFilePath = undefined

    switch atom.config.get('scilab-language.languageVersion')
      when 'Scilab 5.4.1'
        versionFilePath = path.resolve(__dirname, '../grammars/version', 'scilab-5.4.1.cson')
      when 'Scilab 5.5.2'
        versionFilePath = path.resolve(__dirname, '../grammars/version', 'scilab-5.5.2.cson')
      when 'Scilab 6.0.0'
        versionFilePath = path.resolve(__dirname, '../grammars/version', 'scilab-6.0.0.cson')

    atom.grammars.loadGrammarSync( versionFilePath ) if versionFilePath?

  # ------------------------------------------
  # Create a new element which provides the "where-am-i"-line numbering
  # ------------------------------------------
  createWhereAmI: () ->
    if not @editor.gutterWithName('whereami-scilab') && (@editor.getGrammar().name == 'Scilab')
      @whereamiView = new SciViewWhereAmI(@editor)

    if @whereamiView?
      @whereamiView.updateGutter()
