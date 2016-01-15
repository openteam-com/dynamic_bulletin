class StringProperty < Property
  def permitted_attributes
    %W(string_value)
  end
end

# == Schema Information
#
# Table name: string_attributes
#
#  id         :integer          not null, primary key
#  max_length :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
