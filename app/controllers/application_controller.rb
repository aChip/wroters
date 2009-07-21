# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include AuthenticatedSystem
  before_filter :set_current_user
  
  protected

  def set_current_user
    if User.count ==0
      user = User.new(:login=>"admin",:password=>"300830",:password_confirmation=>"300830",:email=>"disk@123.com")
      user.save!
      user = User.new(:login=>"chen",:password=>"300830",:password_confirmation=>"300830",:email=>"disk1@123.com")
      user.save!
      user = User.new(:login=>"zhao",:password=>"300830",:password_confirmation=>"300830",:email=>"disk2@123.com")
      user.save!
    end 

    if self.current_user!=nil
      Album.current_user = current_user
    end
  end

  def validate_user(user_id)
      unless user_id == current_user.id
        redirect_to "/"
        yield
      end

  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
