SciViewWhereAmI       = require './whereami-view'
{CompositeDisposable} = require 'atom'

module.exports =
  config:
    whereami:
      title: 'Where am I?'
      type: 'object'
      properties:
        active:
          title: 'Show \"whereami\"- compatible line-numbering'
          description: '\"Where am I?\" changes the line-numbering inside of functions.<br>Line-counting will start with *1* if a ``function``-keyword and a matching ``endfunction``-keyword is found. This line-numbering helps especially to debug **Scilab** error messages.<br>**Warning: This feature is in development. Deactivate if you experience performance issues.**'
          type: 'boolean'
          default: true

        updateAnchorsOnSave:
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
