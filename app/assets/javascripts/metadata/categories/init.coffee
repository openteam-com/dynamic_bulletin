@init_add_list_item = ->
  $('.js-plus-list-item').on 'click', ->
    count = $('.container-list-items').attr('data')
    $('.container-list-items').append '<div class="fields"><div class="form-group string optional property_list_items_title"><label class="string optional control-label" for="property_list_items_attributes_' + count + '_title">Title</label><input class="string optional form-control" type="text" name="property[list_items_attributes][' + count + '][title]" id="property_list_items_attributes_' + count + '_title"></div>
        </div>'
    countInt = parseInt(count)
    countInt++
    $('.container-list-items').attr('data', countInt)
    true
  true

@init_delete_list_item = ->
  $('.js-minus-list-item').on 'click', ->
    count = $('.container-list-items').attr('data')
    $('.container-list-items .fields').last().remove()
    countInt = parseInt(count)
    countInt--
    $('.container-list-items').attr('data', countInt)
    true
  true

