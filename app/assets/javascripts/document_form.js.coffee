#= require jquery.wysiwyg

$ ->
  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    $ul = $(link).closest('div').prevAll('ul')
    $(content).appendTo($ul)

  $('.summary textarea').each ->
    $t = $(@)
    $t.wysiwyg
      rmUnusedControls: true
      brIE: false
      rmUnwantedBr: true
      initialContent: '<p>'+$t.prop('placeholder')+'</p>'
      controls:
        bold: { visible : true }
        italic: { visible : true }
        html: { visible : true }
        insertUnorderedList: { visible : true }
        insertOrderedList: { visible : true }
        removeFormat: { visible : true }
