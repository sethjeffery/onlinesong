class Previewer
  $previewer: null
  fontSize: 16
  $fontUp: null
  $fontDown: null

  init: ->
    @$previewer = $('#previewer')
    @$fontUp = $('#previewer-font-up')
    @$fontDown = $('#previewer-font-down')
    @bindToolbarButtons()
    @updateFontSize()

  update: ->
    @updateWith(window.editor.$editor.val())

  bindToolbarButtons: ->
    @$fontUp.click =>
      @fontSize+=2
      @updateFontSize()

    @$fontDown.click =>
      @fontSize-=2
      @updateFontSize()

  updateFontSize: ->
      @$previewer.css(fontSize: @fontSize + 'px')
      if @fontSize <= 10 then @$fontDown.attr('disabled', 'disabled') else @$fontDown.removeAttr('disabled')
      if @fontSize >= 20 then @$fontUp.attr('disabled', 'disabled') else @$fontUp.removeAttr('disabled')

  updateWith: (html) =>
    @$previewer.html('')
    @$previewer.append(@format(html))
    @styleSpaces()

  format: (text) ->
    html = text
    chordReg = /\[([^\]]+)\]([ \[])?/g
    while(chord = chordReg.exec(html))
      space_class = if chord[2]? then 'spaced' else ''
      space = if chord[2]? then "<span class='space'></span>#{chord[2]}" else ''
      html = html.substring(0, chord.index) + "<span class='chord #{space_class}'>#{chord[1]}</span>#{space}" + html.substring(chord.index + chord[0].length, html.length)

    html = html.replace(/\n\n+/g, "</div></div><div class='section'><div class='line'>")
               .replace(/\n/g, "</div><div class='line'>")

    $html = $("<div><div class='section'><div class='line'>#{html}</div></div></div>")

    $('.line', $html).each ->
      $line = $(@)
      $line.addClass('without-chords')

      $line.children('.chord').each ->
        $chord = $(@)
        $chord.parents('.section').addClass('with-chords')
        $chord.parent().addClass('with-chords')
        $line.removeClass('without-chords').addClass('with-chords')

    $('.section:not(.with-chords)', $html).each ->
      html = $(@).addClass('without-chords')[0].innerHTML
      if (html.indexOf("   ") > -1 && html.indexOf("<span class='chord'>") == -1) then $(@).addClass('monospace')

    return $html


  styleSpaces: ->
    $('.line > .chord', @$previewer).each ->
      $chord = $(@)

      if $chord.hasClass('spaced')
        $chord.next('.space').css(width: $chord.outerWidth() + 10)

      $prevChord = $(@).prevAll('.chord:first')

      if $prevChord.length > 0 && $prevChord.offset().left + $prevChord.outerWidth() + 10 > $chord.offset().left
        $space = $chord.before("<span class='space'></span>").prev()
        $space.css(width: $prevChord.offset().left + $prevChord.outerWidth() + 10 - $chord.offset().left)

$ =>
  @previewer = new Previewer()
  @previewer.init()
