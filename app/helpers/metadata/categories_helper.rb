module Metadata::CategoriesHelper
  def recursive_children(node)
    return '' unless node.children.present?

    # FIXME: странно, но с нормальными content_tag сходу не заработало. пока так, надо переписать

    content = '<ul>'
    node.children.each do |child|
      content << "<li>#{link_to child, metadata_category_category_path(node, child)}</li>"

      content << recursive_children(child) if child.children.present?
    end
    content << '</ul>'

    content.html_safe
  end
end
