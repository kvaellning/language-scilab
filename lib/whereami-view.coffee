{CompositeDisposable} = require 'atom'

module.exports =

class SciViewWhereAmI

  constructor: (@editor) ->
    if @editor.getGrammar().scopeName.indexOf('source.scilab') == -1
      return

    @subscriptions = new CompositeDisposable()
    @editorView    = atom.views.getView(@editor)
    @editorBuffer  = @editor.buffer

    @lineNumber = @editor.gutterWithName('line-number')

    @gutter = @editor.addGutter
      name:    'whereami-scilab'
      visible: false

    @gutter.view = this

    @anchors   = []

    # match all stuff which
    #   - starts (valid) with "function", or
    #   - ends with "endfunction", or
    #   - has a beginning // for comment, so that we can ignore it furthermore
    @patterns =
      reAnchors:   new RegExp('((?:function(?=\\s|$))|(?:endfunction))', 'g')
      funcBegin:   'function'
      funcEnd:     'endfunction'

    @lineInfo   = [0,false] # array with [lineNumber, hasAnchorElem] used to determine if the contents of the line has changed
    @totalLines = @editor.getLineCount()

    @hasScopeInformation = false # it might be that the grammar is loaded after the anchors there determined. This is used to signal that state.

    @updateWholeGutter = false # used to determine if the whole gutter should be redrawn. This is the case if the anchors have changed.

    @isActive            = atom.config.get('scilab-language.whereami.active')
    @updateAnchorsOnSave = atom.config.get('scilab-language.whereami.updateAnchorsOnSave')

    try
      # ------
      # Subscribe to any change
      @subscriptions.add @editor.onDidChange =>
        # ---------------------------------------------------------
        actTotalLines = @editor.getLineCount()

        if !@hasScopeInformation || ( !@updateAnchorsOnSave && (actTotalLines != @totalLines) ) # number of total lines has changed, so update anchors
          # update anchors if necessary
          @totalLines = actTotalLines

          @UpdateAnchors()

        @UpdateGutter()
        # ---------------------------------------------------------
    catch
      # ------
      # Fallback: Subscribe to initialization and editor changes
      @subscriptions.add @editorView.onDidAttach(@UpdateGutter)
      @subscriptions.add @editor.onDidStopChanging(@UpdateGutter)

    @subscriptions.add @editor.onDidSave(@UpdatePane)

    # ------
    # Subscribe to Scilab whereami flag-changes
    @subscriptions.add atom.config.onDidChange 'scilab-language.whereami.active', =>
      @isActive = atom.config.get('scilab-language.whereami.active')

      if @isActive
        @UpdatePane()
      else
        @Undo()

    # ------
    # Subscribe to changes for the update of anchors on save
    @subscriptions.add atom.config.onDidChange 'scilab-language.whereamiUpdateAnchorsOnSave', =>
      @updateAnchorsOnSave = atom.config.get('scilab-language.whereamiUpdateAnchorsOnSave')

    # ------
    # Subscribe if the user scrolls around
    @subscriptions.add @editorView.onDidChangeScrollTop =>
      if !@hasScopeInformation
        @UpdateAnchors()

      @UpdateGutter()

    # ------
    # Subscribe for cursor position changes
    # Only check if the text changed and if this will affect somewhat the anchors
    @subscriptions.add @editor.onDidChangeCursorPosition(@CheckLine)

    # ------
    # Dispose the subscriptions when the editor is destroyed.
    @subscriptions.add @editor.onDidDestroy =>
      @subscriptions.dispose()

    if @isActive
      @UpdatePane()

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
  UpdatePane: () =>
    if !@isActive
      return

    @UpdateAnchors()
    @UpdateGutter()

  # ---------------------------------------------------------
  # Used to check if the content of the current line will affect the displayed line numbers
  # ---------------------------------------------------------
  CheckLine: (event) =>
    if !@isActive | @updateAnchorsOnSave| @isDirty | @editor.isDestroyed()
      return

    if event.textChanged
      lineNum = @editor.getCursorBufferPosition().row
      line    = [event.newBufferPosition.row, @LineHoldsAnchor(event.newBufferPosition)]

      if !@hasScopeInformation || (line[0] == @lineInfo[0]) && (line[1] != @lineInfo?[1]) # only update if we have previous information about the line and the keyword  has changed
        @UpdateAnchors()

      @lineInfo = line # update to state of actual line

  # ---------------------------------------------------------
  # checks if a line \c lineText holds anchors
  #
  # @param[in]  lineText  String with the line contents which is checked
  # @returns    \c true if the line holds anchors, \c false otherwise
  # ---------------------------------------------------------
  LineHoldsAnchor: (position) =>
    if !(position?)
      return false

    lineText    = @editor.lineTextForBufferRow(position.row)
    lineMatches = @patterns.reAnchors.exec(lineText)

    if lineMatches?

      for m in lineMatches
        if (m.indexOf(@patterns.funcBegin) != -1) || (m.indexOf(@patterns.funcEnd) != -1) # function end
          return true

    return false

  # ---------------------------------------------------------
  # Updates the anchors (stuff need to define the scopes)
  #
  # This will change the global variable \@anchors to a new value.
    # ---------------------------------------------------------
  UpdateAnchors: () =>
    if !@isActive | @editor.isDestroyed()
      return

    searchRange =  [[0, 0], @editor.getEofBufferPosition()] # search for stuff from row zero to the last

    funcStarts = []
    @anchors   = []

    @editor.scanInBufferRange @patterns.reAnchors, searchRange,
      (result) =>

        scopes = @editor.scopeDescriptorForBufferPosition(result.range.start)?.getScopesArray() # scope where the match is found
        return unless scopes?.length

        if scopes.length == 1
         @hasScopeInformation = false
         return

        @hasScopeInformation = true

        if (scopes?[scopes.length-1].indexOf('storage.type.function.end') != -1) && funcStarts[funcStarts.length-1]? # function end
          # The grammar provides the 'storage.type.function.end' for the "endfunction" keyword at the end of the scope array
          anchorRange       = result.range      # work around the issue that "new Range" returns a range from the Window...
          anchorRange.start = funcStarts.pop();

          @anchors[@anchors.length] = anchorRange

        else if scopes?[scopes.length-1].indexOf('storage.type.function.begin') != -1
          # The grammar provides the 'storage.type.function.begin' for the "function" keyword at the end of the scope array
          funcStarts[funcStarts.length] = result.range.start # function begin

    @updateWholeGutter = true


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
    if !@isActive | !@hasScopeInformation | @editor.isDestroyed()
      return

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
  #
  # @returns  new offset
  # ---------------------------------------------------------
  UpdateGutterLine: (lineNumberElement) =>
    # convert to number
    # The row is used to determine the new line number
    row = lineNumberElement.getAttribute('data-buffer-row') * 1

    if isNaN(row)
      return

    if isFinite(lineNumberElement.innerText) # check finite of text. If not finite, then a soft wrap linebreak occured.
      whereami  = @LineNumberFromAnchor(row)
      applyStyle = true

      # leave unchanged if not inside a function-region
      if whereami == -1
        if @updateWholeGutter
          whereami   = row
          applyStyle = false
        else
          return

      whereami    += 1
      whereamiText = @Spacer(@editor.getLineCount(), whereami) + whereami

      if applyStyle
        whereamiText = "<span style=\"font-weight:bolder;\">#{whereamiText}</span>"

      lineNumberElement.innerHTML = "#{whereamiText}<div class=\"icon-right\"></div>"


  # ---------------------------------------------------------
  # Implementation for updating the whole gutter
  # ---------------------------------------------------------
  UpdateGutterImpl: () =>
    lineNumberElements = @editorView.rootElement?.querySelectorAll('.line-number')

    for lineNumberElement in lineNumberElements
      @UpdateGutterLine(lineNumberElement)

    @updateWholeGutter = false


  # ---------------------------------------------------------
  # Undo changes to DOM
  # ---------------------------------------------------------
  Undo: () =>
    totalLines = @editor.getLineCount()
    lineNumberElements = @editorView.rootElement?.querySelectorAll('.line-number')

    for lineNumberElement in lineNumberElements
      row = Number(lineNumberElement.getAttribute('data-buffer-row'))
      absolute = row + 1
      absoluteText = @Spacer(totalLines, absolute) + absolute

      if lineNumberElement.innerHTML.indexOf('•') == -1
        lineNumberElement.innerHTML = "#{absoluteText}<div class=\"icon-right\"></div>"
