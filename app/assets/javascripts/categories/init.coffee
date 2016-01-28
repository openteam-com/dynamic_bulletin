@init_select_sublist_items = ->
  console.log 'init'
  $(document).on 'change', '.js-get-list-items-children', ->
    item = $(this)
    selected_item = item.find(':selected').val()

    $.ajax
      type: 'get'
      url: '/my/adverts/get_category_children'
      data: {
        parent_id: selected_item
      }
      success: (data) ->
        item.parent().find('.js-parent-additional-fields').remove()
        item.parent().append("<div class='js-parent-additional-fields'>#{data}</div>")
    return
  return
