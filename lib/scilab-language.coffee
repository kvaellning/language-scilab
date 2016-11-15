SciViewWhereAmI       = require './whereami-view'
{CompositeDisposable} = require 'atom'

module.exports =
  config:
    title: 'whereami'

    whereamiActive:
      title: 'Show \"whereami\"- compatible line numbering'
      description: 'If activated, this option will display the line numbers **Scilab**. Typically, this means that every ``function``-Tag will start a relative line numbering beginning at 1.<br>**Warning: This feature is in development. Deactivate if you experience performance issues.**'
      type: 'boolean'
      default: true

    whereamiUpdateAnchorsOnSave:
      title: 'Update anchors at save'
      description: 'If checked, the anchors (``function``/``endfunction`` blocks) are only updated on save.<br>**Check if you experience performance issues.**'
      type: 'boolean'
      default: false

  subscriptions: null
  whereamiView: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.workspace.observeTextEditors (editor) ->
      if !(editor?)
        return

      if not editor.gutterWithName('whereami-scilab')
        @whereamiView = new SciViewWhereAmI(editor)

      @whereamiView?.UpdateGutter()

  deactivate: () ->
    @subscriptions?.dispose()
    for editor in atom.workspace.getTextEditors()
      editor.gutterWithName('whereami-scilab')?.view?.destroy()
