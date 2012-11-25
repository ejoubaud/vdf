class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user && [ :admin, :editor ].include?(user.role)
        can :manage, :all
    else
        can :read, :all
        #cannot :read, Document
    end
  end
end
