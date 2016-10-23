{CompositeDisposable} = require 'atom'

module.exports =

class SciViewWhereAmI
  constructor: (@editor) ->
    if !(@editor?) || @editor.getGrammar().scopeName != 'source.scilab'
      return

    @subscriptions = new CompositeDisposable()
    @editorView    = atom.views.getView(@editor)
    @editorBuffer  = @editor.buffer

    @gutter = @editor.addGutter
      name:    'whereami-scilab'
      visible: false

    @gutter.view = this

    @anchors   = []

    # match all stuff which
    #   - starts (valid) with "function", or
    #   - ends with "endfunction", or
    #   - has a beginning // for comment, so that we can ignore it furthermore
    @regExpressions =
      anchors:        new RegExp('(?:((?:(?:^|[;,])\\s*function))(?:\\s))|(//.*?endfunction)|(endfunction)', 'g')
      funcBegin:      new RegExp('function')
      funcEnd:        new RegExp('endfunction')
      funcEndInvalid: new RegExp('//')

    @lastLine  = undefined # array with [lineNumber, hasAnchorElem] used to determine if the contents of the line has changed
    @lastRange = undefined # used to store the range of the last line

    try
      @subscriptions.add @editorBuffer.onDidChange(@CheckLine)
    catch
      # Subscribe to initialization and editor changes
      @subscriptions.add @editorView.onDidAttach(@CheckLine)
      @subscriptions.add @editor.onDidStopChanging(@CheckLine)

    # Subscribe to Scilab whereami flag-changes
    @subscriptions.add atom.config.onDidChange 'language-kl-scilab.wheramiCompatible', =>
      @whereamiActive = atom.config.get('language-kl-scilab.wheramiCompatible')

      if whereamiActive
        @UpdateAnchors()

      @UpdateView()

    # subscribe for cursor position changes
    @subscriptions.add @editor.onDidChangeCursorPosition(@CheckLine)

    # subscribe if the user scrolls around
    @subscriptions.add @editorView.onDidChangeScrollTop(@UpdateView)

    # Dispose the subscriptions when the editor is destroyed.
    @subscriptions.add @editor.onDidDestroy =>
      @subscriptions.dispose()

    @UpdateAnchors()
    @UpdateView()

  destroy: () ->
    @subscriptions.dispose()
    @Undo()
    @gutter.destroy()

  Spacer: (totalLines, currentIndex) ->
    width = Math.max(0, totalLines.toString().length - currentIndex.toString().length)
    Array(width + 1).join '&nbsp;'

  # Used to check if the content of the current line will affect the displayed line numbers
  CheckLine: () =>
    if @editor.isDestroyed()
      return

    editorLine = @editor.lineTextForBufferRow(@editor.getCursorBufferPosition().row)
    actLine = [editorLine, @LineHoldsAnchor(editorLine)]

    if (actLine[0] != @lastLine?[0]) || (actLine[1] != @lastLine?[1])
      @lastLine = actLine
      @UpdateAnchors()
      @UpdateView()

  # checks if a line \c lineText holds anchors
  #
  # @param[in]  lineText  String with the line contents which is checked
  # @returns    \c true if the line holds anchors, \c false otherwise
  LineHoldsAnchor: (lineText) =>
    if !(lineText?)
      holdsAnchor = false
      return

    lineMatches = lineText.match(@regExpAnchors)

    if lineMatches?
      for m in lineMatches
        if m.match(@regExpFuncEndInvalid) # invalid end (holds a comment descriptor (//) somewhere)
          ;
        else if m.match(@regExpFuncBegin) || result.matchText.match(@regExpFuncEnd) # function end
          holdsAnchor = true
          return

    holdsAnchor = false

  UpdateAnchors: () =>
    searchRange =  [[0, 0], @editor.getEofBufferPosition()] # search for stuff from row zero to the last

    funcRanges = []
    @anchors   = []

    @editor.scanInBufferRange @regExpressions.anchors, searchRange,
      (result) =>

        if result.matchText.match(@regExpressions.funcEndInvalid) # invalid end (holds a comment descriptor (//) somewhere)
          ;
        else if result.matchText.match(@regExpressions.funcBegin)
          funcRanges[funcRanges.length] = new Range(result.range.start) # function begin
        else if result.matchText.match(@regExpressions.funcEnd) && funcRanges[funcRanges.length-1]? # function end
          @anchors[@anchors.length] = funcRanges.pop()
          @anchors[@anchors.length].end = result.range.end

  # calculate the line number based on the available anchors
  LineNumberFromAnchor: (actLine) =>
    if @anchors.length == 0
      retLine = actLine
      return

    if !@lastRange.intersectsRow(actLine)
      @lastRange = undefined
      for m in @anchors
        if m.intersectsRow(actLine)
          @lastRange = m # the first match has the highest priority,
                        # since nested functions will be pushed earlier to the anchor buffer than the enclosing functions
          break

    if @lastRange?
      retLine = actLine - @lastRange.start.row
    else
      retLine = actLine # do nothing

  # Update the line numbers on the editor
  UpdateView: () =>
    # If the gutter is updated asynchronously, we need to do the same thing
    # otherwise our changes will just get reverted back.
    if @editorView.isUpdatedSynchronously()
      @UpdateViewSync()
    else
      atom.views.updateDocument () => @UpdateViewSync()

  UpdateViewSync: () =>
    if @editor.isDestroyed()
      return

    totalLines         = @editor.getLineCount()
    lineNumberElements = @editorView.rootElement?.querySelectorAll('.line-number')

    for lineNumberElement in lineNumberElements
      # "|| 0" is used given data-screen-row is undefined for the first row
      row = Number(lineNumberElement.getAttribute('data-screen-row')) || 0

      whereami  = @LineNumberFromAnchor(row)
      whereami += 1

      whereamiClass = 'relative'

      whereamiText = @Spacer(totalLines, whereami) + whereami

      # Keep soft-wrapped lines indicator
      if lineNumberElement.innerHTML.indexOf('â€¢') == -1
        lineNumberElement.innerHTML = "<span class=\"#{whereamiClass}\">#{whereamiText}</span><div class=\"icon-right\"></div>"

  # Undo changes to DOM
  Undo: () =>
    Update()
    totalLines = @editor.getLineCount()
    lineNumberElements = @editorView.rootElement?.querySelectorAll('.line-number')

    for lineNumberElement in lineNumberElements
      row = Number(lineNumberElement.getAttribute('data-buffer-row'))
      absolute = row + 1
      absoluteText = @Spacer(totalLines, absolute) + absolute

      if lineNumberElement.innerHTML.indexOf('â€¢') == -1
        lineNumberElement.innerHTML = "#{absoluteText}<div class=\"icon-right\"></div>"
