$(document).on 'ready page:load', ->

  $('.js-images').bind 'DOMSubtreeModified', ->
    $('.js-image').last().find('input').click()
  $('.js-images').on 'change', 'input', ->
    img = $(this).prev()
    console.log img
    file = $(this).prop('files')[0]
    reader = new FileReader()
    reader.onload = ->
      img.attr('src', reader.result).width(100)
    reader.readAsDataURL(file)

  init_select_sublist_items()
  true

