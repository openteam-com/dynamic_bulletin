@init_change_properties_types = ->
  $(document).on 'change', '.js-properties-types', ->
    property = $(this).val()

    $.ajax
      type: 'get'
      url: "/metadata/properties/get_fields_for_subproperties/#{property}"
      success: (partial) ->
        $('.simple_form').append(partial)

      true
  true
