$ ->
  window.nestedFormEvents.insertFields = (content, assoc, link) ->
    $li = $(link).closest('li')
    $(content).insertBefore($li)
