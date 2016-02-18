class Ability
  include CanCan::Ability

  # method is_admin?, is_manager? and other see in models/User.rb in define_method block,
  # that creates by Permission.role.values
  def initialize(user, namespace = nil)
    case namespace
    when :my
      can :index, Advert if user.present?

      can :manage, Advert do |advert|
        advert.user == user
      end

    when :metadata
      can :manage, :all if user.is_manager?
    end

    can :manage, :all if user.is_admin?
  end
end
