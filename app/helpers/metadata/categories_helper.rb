module Metadata::CategoriesHelper
  def recursive_children(node)
    return '' unless node.children.present?

    # FIXME: странно, но с нормальными content_tag сходу не заработало. пока так, надо переписать

    content = '<ul class="js-can-hidden can-hidden">'
    node.children.each do |child|
      content << "<li>#{link_to child, metadata_category_category_path(node, child)}"
      content << "<span class='glyphicon glyphicon-plus js-handle-hidden'></span>" if child.children.present?

      content << recursive_children(child) if child.children.present?
      content << "</li>"
    end
    content << '</ul>'

    content.html_safe
  end

  def define_remote(params)
    if params[:remote].present?
      params[:remote] == 'true' ? true : false

      return
    end

    true
  end
end
