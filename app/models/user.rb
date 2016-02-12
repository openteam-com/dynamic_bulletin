class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :adverts, dependent: :destroy
  has_many :permissions, dependent: :destroy

  # define available roles for User
  Permission.role.values.each do |role|
    define_method "is_#{role}?" do
      self.permissions.map(&:role).include? role
    end
  end
end
