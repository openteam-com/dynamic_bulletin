$(document).on 'ready page:load', ->

  #поведение иерархичного листа на фильтре. надо бы вынести в модуль
  $('.js-slider').each (index, item) ->
    min = $(item).data('min')
    max = $(item).data('max')
    ticks = $(item).data('ticks')
    ticks_labels = $(item).data('ticks-labels')
    value = $(item).data('value')
    $(item).slider({
      min: min,
      max: max,
      value: value,
      ticks: ticks,
      ticks_labels: ticks_labels
    })

  $('.js-range-buttons').find('.form-group').addClass('btn-group').removeClass('check_boxes')
  $('.js-range-buttons').find('.form-group').attr('data-toggle', 'buttons')
  $('div.js-range-buttons label').addClass('btn btn-primary')
  $('span.checkbox').each (index, item) ->
    attr = $(this).find('input').attr('checked')
    if (typeof attr != typeof undefined)
      $(this).find('label').addClass('active')
    $(this).replaceWith(item.children)

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
