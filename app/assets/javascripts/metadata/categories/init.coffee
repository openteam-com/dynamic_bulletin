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
      console.log item_id
      $.ajax
        type: 'put'
        url: path
        dataType: 'json'
        data: {
          category_property_id: item_id
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
  $('.js-link-to-add').on 'ajax:success', (evt, response)->
    $('.js-dialog-to-add').append response
    return

  $('.js-dialog-to-add').on 'ajax:success', (evt, response)->
    if $(response).find('.help-block').length
      $(this).html(response)
    else
      $('.js-children').html(response)
      $(this).empty()
    return

@init_handle_ajax_edit_category_form = ->
  $(document).on 'ajax:success', '.js-link-to-edit', (evt, response)->
    child_id = $(this).data('id')
    $('.js-child[data-id="' + child_id  + '"]').html response
    $('.js-child[data-id="' + child_id  + '"]').addClass "editing"
    return

  $(document).on 'ajax:success', '.editing', (evt, response)->
    if $(response).find('.help-block').length
      $(this).html(response)
    else
      $('.js-children').html(response)
      $(this).removeClass "editing"
    return

@init_handle_ajax_destroy_category = ->
  $(document).on 'ajax:success', '.js-link-to-destroy', (evt, response)->
    $('.js-children').html(response)
    return
  return
