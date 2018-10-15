# Specifies the abilities for performing any controller actions
class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    if user.present?
      # Board abilities
      can %i[update destroy], Board do |board|
        board.user_id == user.id
      end

      can %i[destroy update], Column, board: { user_id: user.id }

      can %i[create update], ActionItem do |at|
        at.column.user == user
      end

      can :destroy, ActionItem do |at|
        at.user == user
      end

    end
  end

end
