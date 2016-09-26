{CompositeDisposable} = require 'atom'

module.exports =

class SciViewWhereAmI

  constructor: (@editor) ->
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
      anchors:     new RegExp('((//.*(?:(?:function)|(?:endfunction)))|(?:function(?=\\s|$))|(?:endfunction))', 'g')
      funcBegin:   new RegExp('function')
      funcEnd:     new RegExp('endfunction')
      funcInvalid: new RegExp('//')

    @lineInfo   = undefined # array with [lineNumber, hasAnchorElem] used to determine if the contents of the line has changed
    @totalLines = @editor.getLineCount()

    @whereamiActive = atom.config.get('language-scilab.whereamiCompatible')

    if @whereamiActive
      @UpdateAnchors()

    try
      # subscribe to any change
      @subscriptions.add @editor.onDidChange(@UpdateGutter)
    catch
      # Fallback: subscribe to initialization and editor changes
      @subscriptions.add @editorView.onDidAttach(@UpdateGutter)
      @subscriptions.add @editor.onDidStopChanging(@UpdateGutter)
      @subscriptions.add @editor.onDidSave(@UpdateOnSave)

    # Subscribe to Scilab whereami flag-changes
    @subscriptions.add atom.config.onDidChange 'language-scilab.whereamiCompatible', =>
      @whereamiActive = atom.config.get('language-scilab.whereamiCompatible')

      if @whereamiActive
        @UpdateAnchors()
        @UpdateGutter()
      else
        @Undo()

    # subscribe for cursor position changes
    # Only check if the text changed and if this will affect somewhat the anchors
    @subscriptions.add @editor.onDidChangeCursorPosition(@CheckLine)

    # subscribe if the user scrolls around
    @subscriptions.add @editorView.onDidChangeScrollTop(@UpdateGutter)

    # Dispose the subscriptions when the editor is destroyed.
    @subscriptions.add @editor.onDidDestroy =>
      @subscriptions.dispose()

  destroy: () ->
    @subscriptions.dispose()
    @Undo()
    @gutter.destroy()


  # ---------------------------------------------------------
  # Calculates the amount of soft-wrapping
  # ---------------------------------------------------------
  Spacer: (totalLines, currentIndex) ->
    width = Math.max(0, totalLines.toString().length - currentIndex.toString().length)
    Array(width + 1).join '&nbsp;'

  # ---------------------------------------------------------
  # Updates the gutter on save.
  #
  # If <code>\@editor.onDidChange</code> subscription does not worked,
  # this function is called on every save to update the anchors and the gutter.
  # ---------------------------------------------------------
  UpdateOnSave: () =>
    @UpdateAnchors()
    @UpdateGutter()

  # ---------------------------------------------------------
  # Used to check if the content of the current line will affect the displayed line numbers
  # ---------------------------------------------------------
  CheckLine: (event) =>
    if @editor.isDestroyed()
      return

    if event.textChanged
      actTotalLines = @editor.getLineCount()
      lineNum       = @editor.getCursorBufferPosition().row

      line = [lineNum, @LineHoldsAnchor( @editor.lineTextForBufferRow(lineNum) )]

      if (Math.abs(actTotalLines-@totalLines) ||                                # number of lines has changed
          (line[0] == @lineInfo?[0])  || (line[1] != @lineInfo?[1])) # keyword in a line has changed

        @totalLines = actTotalLines
        @lineInfo   = line

        @UpdateAnchors()


  # ---------------------------------------------------------
  # checks if a line \c lineText holds anchors
  #
  # @param[in]  lineText  String with the line contents which is checked
  # @returns    \c true if the line holds anchors, \c false otherwise
  # ---------------------------------------------------------
  LineHoldsAnchor: (lineText) =>
    if !(lineText?)
      return false

    lineMatches = lineText.match(@regExpressions.anchors)

    if lineMatches?
      for m in lineMatches
        if (m.match(@regExpressions.funcInvalid))? # invalid end (holds a comment descriptor (//) somewhere)
          ;
        else if (m.match(@regExpressions.funcBegin))? || (m.match(@regExpressions.funcEnd))? # function end
          return true

    return false

  # ---------------------------------------------------------
  # Updates the anchors (stuff need to define the scopes)
  #
  # This will change the global variable \@anchors to a new value.
    # ---------------------------------------------------------
  UpdateAnchors: () =>
    if !@whereamiActive
      return

    searchRange =  [[0, 0], @editor.getEofBufferPosition()] # search for stuff from row zero to the last

    funcStarts = []
    @anchors   = []

    @editor.scanInBufferRange @regExpressions.anchors, searchRange,
      (result) =>

        if (result.matchText.match(@regExpressions.funcInvalid))? # invalid end (holds a comment descriptor (//) somewhere)
          ;
        else if (result.matchText.match(@regExpressions.funcEnd))? && funcStarts[funcStarts.length-1]? # function end
          anchorRange       = result.range      # work around the issue that "new Range" returns a range from the Window...
          anchorRange.start = funcStarts.pop();

          @anchors[@anchors.length] = anchorRange

        else if (result.matchText.match(@regExpressions.funcBegin))?
          funcStarts[funcStarts.length] = result.range.start # function begin


  # ---------------------------------------------------------
  # calculate the line number based on the available anchors
  # ---------------------------------------------------------
  LineNumberFromAnchor: (actLine) =>
    functionScope = undefined

    for m in @anchors
      if m.intersectsRow(actLine)
        functionScope = m # the first match has the highest priority, since nested functions will be pushed earlier to the anchor buffer than the enclosing functions
        break

    if functionScope?
      return actLine - functionScope.start.row
    else
      return -1 # do nothing


  # ---------------------------------------------------------
  # Update the line numbers on the editor
  # ---------------------------------------------------------
  UpdateGutter: () =>
    # If the gutter is updated asynchronously, we need to do the same thing
    # otherwise our changes will just get reverted back.
    if @editorView.isUpdatedSynchronously()
      @UpdateGutterImpl()
    else
      atom.views.updateDocument () => @UpdateGutterImpl()


  # ---------------------------------------------------------
  # Updates one line of the line-number gutter
  # @todo: Implement own gutter
  #
  # @param[in]  lineNumberElement  \c Node representing the line number of the gutter
  # @param[in]  offset             Offset which is added to the row number. Useful to comb with wrap signs in the gutter
  #
  # @returns  new offset
  # ---------------------------------------------------------
  UpdateGutterLine: (lineNumberElement, offset) =>
    if @editor.isDestroyed()
      return offset

    # convert to number
    # The row is used to determine the new line number
    row = lineNumberElement.getAttribute('data-screen-row') * 1

    if isNaN(row)
      return offset

    if isFinite(lineNumberElement.innerText) # check finite of text. If not finite, then a soft wrap linebreak occured.
      whereami = @LineNumberFromAnchor(row-offset)

      # leave unchanged if not inside a function-region
      if whereami == -1
        return offset

      whereami    += 1
      whereamiText = @Spacer(@totalLines, whereami) + whereami

      # Keep soft-wrapped lines indicator
      if lineNumberElement.innerHTML.indexOf('â€¢') == -1
        lineNumberElement.innerHTML = "<span style=\"font-weight:bolder\">#{whereamiText}</span><div class=\"icon-right\"></div>"
    else
      return offset + 1

    return offset

  # ---------------------------------------------------------
  # Implementation for updating the whole gutter
  # ---------------------------------------------------------
  UpdateGutterImpl: () =>
    if @editor.isDestroyed()
      return

    lineNumberElements = @editorView.rootElement?.querySelectorAll('.line-number')

    offset = 0

    for lineNumberElement in lineNumberElements
      offset = @UpdateGutterLine(lineNumberElement, offset)


  # ---------------------------------------------------------
  # Undo changes to DOM
  # ---------------------------------------------------------
  Undo: () =>
    UpdateGutter()
    totalLines = @editor.getLineCount()
    lineNumberElements = @editorView.rootElement?.querySelectorAll('.line-number')

    for lineNumberElement in lineNumberElements
      row = Number(lineNumberElement.getAttribute('data-buffer-row'))
      absolute = row + 1
      absoluteText = @Spacer(totalLines, absolute) + absolute

      if lineNumberElement.innerHTML.indexOf('â€¢') == -1
        lineNumberElement.innerHTML = "#{absoluteText}<div class=\"icon-right\"></div>"
