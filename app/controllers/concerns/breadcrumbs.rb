module Breadcrumbs
  def breadcrumbs_create(entity)
    @parent = entity.parent

    bread = []
    while @parent.present?
      bread << @parent
      @parent = @parent.parent
    end

    add_breadcrumb 'Корень', root_path

    bread.reverse!.each do |b|
      add_breadcrumb b, category_path(b)
    end
  end
end
