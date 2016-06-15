$(document).on 'ready page:load', ->

  $('.js-images').bind 'DOMNodeInserted', ->
    $('.js-image').last().find('.js-file-input').click()
    $('.js-image').last().find('.js-file-input').next().attr('value', '1')
    $('.js-image').last().attr('style', 'display:none')
  $('.js-images').on 'change', 'input', ->
    img = $(this).prev()
    file = $(this).prop('files')[0]
    reader = new FileReader()

    reader.onload = ->
      img.attr('src', reader.result).width(100)
      img.parent().attr('style', '')
      img.next().next().attr('value', 'false')
    reader.readAsDataURL(file)


  init_select_sublist_items()
  true

