#= require jquery.wysiwyg
#= require file-input-drop-zone

$ ->
  # Insert handler for nested_form's add-nested-fields
  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    $ul = $(link).closest('div').prevAll('ul')
    $(content).appendTo($ul)

  # Drag'n'drop and preview update for the poster
  $('.poster').fileInputDropZone()
  # Hide preview if remove poster is checked
  $('.poster :checkbox').change ->
    $('.poster img').toggle()
  # Unchecks remove and shows preview if image is changed
  $('.poster :file').change ->
    $('.poster :checkbox').prop('checked', false)
    $('.poster img').show()

  # RTE loader
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
