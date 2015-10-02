class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [ Post, Comment ]

    can [ :read, :create, :update, :destroy ], :all if user.admin?

    if user.user?
      can :create, [ Post, Comment ]

      can [ :read, :update ], User do |record|
        record.id == user.id
      end

      can [ :update, :destroy ], Post do |record|
        record.user_id == user.id
      end

      can [ :update, :destroy ], Comment do |record|
        record.user_id == user.id
      end
    end
  end
end
