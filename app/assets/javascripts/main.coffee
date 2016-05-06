$ ->
  #поведение иерархичного листа на фильтре. надо бы вынести в модуль
  $(document).on 'change', '.js-get-list-items-parent', ->
    item = $(this)
    selected_item = item.find(':selected').val()
    $.ajax
      type: 'get'
      url: '/categories/get_hierarch_children'
      data: {
        parent_id: selected_item
      }
      success: (data) ->
        children = item.parent().next().find('.js-get-list-items-children')
        children.empty()
        data = JSON.parse(data)
        for item in data
          children.append(
            "<option value='#{item.id}'>#{item.title}"
          )
    return
  return
true
