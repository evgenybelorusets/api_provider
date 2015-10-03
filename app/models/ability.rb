class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [ Post, Comment ]
    can :create, User

    can :manage, :all if user.admin?

    if user.user?
      can :create, [ Post, Comment ]
      can [ :read, :update ], User, id: user.id
      can [ :update, :destroy ], [ Comment, Post ], user_id: user.id
    end
  end
end
