{CompositeDisposable} = require 'atom'

SciViewWhereAmI = require './whereami-view'
path            = require 'path'

module.exports =
  subscriptions: null
  whereamiView: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    # activate whereamiView
    @subscriptions.add atom.workspace.observeTextEditors (editor) ->
      if !(editor?)
        return

      if not editor.gutterWithName('whereami-scilab')
        @whereamiView = new SciViewWhereAmI(editor)

      @whereamiView?.updateGutter()

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
