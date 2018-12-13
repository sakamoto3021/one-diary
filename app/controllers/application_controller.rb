class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    tweets_path
  end

  private

  def sign_in_required
    redirect_to root_url unless user_signed_in?
  end
end
