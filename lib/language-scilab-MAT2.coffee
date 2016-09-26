SciViewWhereAmI       = require './whereami-view'
{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null
  whereamiView: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.observeTextEditors (editor) ->
      if !(editor?) || (editor.getGrammar().scopeName != 'source.scilab')
        return

      if not editor.gutterWithName('whereami-scilab')
        @whereamiView = new SciViewWhereAmI(editor)

      #@whereamiView?.UpdateGutter()

  deactivate: () ->
    @subscriptions?.dispose()
    for editor in atom.workspace.getTextEditors()
      editor.gutterWithName('whereami-scilab')?.view?.destroy()
