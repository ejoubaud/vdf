#= require jquery.wysiwyg

$ ->
  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    $li = $(link).closest('li')
    $(content).insertBefore($li)

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
