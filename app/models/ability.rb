# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    can :read, User, is_blocked: false
    can :read, Campaign do |campaign|
      !campaign.pending?
    end
    can :read, Comment
    can :read, Donation

    return if user.nil? || user.is_blocked?

    if user.has_role? :user
      can :manage, User, id: user.id
      can :manage, [Campaign, Donation, Comment], user_id: user.id
    end

    can :manage, :all if user.has_role? :admin
  end
end
