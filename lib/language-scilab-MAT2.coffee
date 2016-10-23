SciViewWhereAmI       = require './whereami-view'
{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.observeTextEditors (editor) ->
      if not editor.gutterWithName('whereami-scilab')
        new SciViewWhereAmI(editor)

  deactivate: () ->
    @subscriptions.dispose()
    for editor in atom.workspace.getTextEditors()
      editor.gutterWithName('whereami-scilab').view?.destroy()
