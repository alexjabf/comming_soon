class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    @user = User.find_by_id(user.id)
    unless @user.nil?
      if user.role.superadmin == true
        can :manage, :all
      elsif user.role.administrator == true
        can :manage, :all          
      elsif user.role.guess == true
        can [:show, :edit, :update], User, :id => user.id
      end 
    end
  end
end
