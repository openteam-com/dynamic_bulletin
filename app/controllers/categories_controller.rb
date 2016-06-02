# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ancestry        :string
#  ancestry_depth  :integer          default(0)
#  connect_with_id :integer
#

class CategoriesController < ApplicationController
  include Breadcrumbs

  def index
    @categories = Category.roots
  end

  def show
    @category = Category.find(params[:id])
    @adverts = Searchers::AdvertsSearcher.new(adverts_search_params).collection




    #raise adverts_search_params.inspect
    initialize_breadcrumbs
  end

  def initialize_breadcrumbs
    breadcrumbs_create(@category)
    add_breadcrumb  @category
  end

  def get_hierarch_children
    if request.xhr?
      array = []
      HierarchListItem.find(params[:parent_id]).children.each do |child|
        h = {}
        h[:id] = child.id
        h[:title] = child.title

        array << h
      end
      render text: array.to_json and return
    end
  end

  private
  def adverts_search_params
    #raise params.inspect
    param_lists = params.try(:[], :list_items)
    ranges_values = params.try(:[], :ranges)
    ranges_select_values = params.try(:[], :ranges_select)

    if !ranges_values.nil?
      elems = []
      ranges_values.each do |p|
        values = p[1].split(',').map(&:to_i)
        elems << @category.properties.find(p[0].to_i).list_items.select {|l| l.title.to_i >= values[0] && l.title.to_i <= values[1]}.map(&:id).map(&:to_s) if values.size == 2
      end
      param_lists << elems
      param_lists = param_lists.flatten
    end

    if !ranges_select_values.nil?
      elems = []
      values = []
      ranges_select_values.each do |p|

        if p[1][0] != ""
          values[0] = ListItem.find(p[1][0].to_i).title.to_i
        else
          values[0] = @category.properties.find(p[0]).list_items.first.title.to_i
        end

        if p[1][1] != ""
          values[1] = ListItem.find(p[1][1].to_i).title.to_i
        else
          values[1] = @category.properties.find(p[0]).list_items.last.title.to_i
        end

        values.sort!
        elems << @category.properties.find(p[0].to_i).list_items.select {|l| l.title.to_i >= values[0] && l.title.to_i <= values[1]}.map(&:id).map(&:to_s) if values.size == 2
      end
      param_lists << elems
      param_lists = param_lists.flatten
    end

    {
      list_items: param_lists,
      hierarch_list_items: params.try(:[], :hierarch_list_items),
      category_id: @category.id,
      page: params[:page]
    }
  end
end
