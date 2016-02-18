@init_select_sublist_items = ->
  $(document).on 'change', '.js-get-list-items-parent', ->
    item = $(this)
    selected_item = item.find(':selected').val()

    $.ajax
      type: 'get'
      url: '/my/adverts/get_category_children'
      data: {
        parent_id: selected_item
      }



      success: (data) ->
        console.log data
        children = item.parent().next().find('.js-get-list-items-children')
        children.empty()
        $(children).removeClass('hidden')
        data = JSON.parse(data)
        for item in data
          children.append(
            "<option value='#{item.id}'>#{item.title}"
          )
    return
  return
