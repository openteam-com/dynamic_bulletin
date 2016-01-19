class StringProperty < Property
  def permitted_attributes
    %W(string_value)
  end
end

# == Schema Information
#
# Table name: properties
#
#  id          :integer          not null, primary key
#  type        :string
#  title       :string
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  max_length  :integer
#  kind        :string
#
