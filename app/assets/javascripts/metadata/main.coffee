$ ->
  init_sortable_properties()
  init_handle_hidden() if $('.js-handle-hidden').length
  init_handle_ajax_new_category_form() if $('.js-link-to-add').length
  init_handle_ajax_edit_category_form() if $('.js-link-to-edit').length
  init_handle_ajax_destroy_category() if $('.js-link-to-destroy').length

  true
