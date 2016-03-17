@init_sortable_properties = ->
  $('.js-sortable-wrapper').sortable
    axis: 'y'
    items: '.js-sortable-item'
    handle: '.js-handle-sortable'

    sort: (e, ui) ->
      ui.item.addClass('active-item-shadow')
    stop: (e, ui) ->
      ui.item.removeClass('active-item-shadow')

    update: (e, ui) ->
      path = $('.js-sortable-wrapper').attr('data-path')
      item_id = ui.item.data('id')
      ui.item.effect('highlight', 1500)
      position = ui.item.index()
      $.ajax
        type: 'get'
        url: path
        dataType: 'json'
        data: {
          id: item_id
          row_order: position
        }

      return
    true
  true

@init_handle_hidden = ->
  $('.js-handle-hidden').click ->
    $(this).toggleClass('glyphicon-plus glyphicon-minus')
    $(this).next('ul').toggle()

    true
  true

@init_handle_ajax_new_category_form = ->
  $('.js-categories').on 'ajax:success', (evt, response)->
    $('.js-dialog').html(response).dialog()

    return

  $('.js-dialog').on 'ajax:success', (evt, response)->
    if $(response).find('.help-block').length
      $(this).html(response).dialog()
    else
      $(this).dialog('close')
      $('.js-children').html(response)

    return
  return
