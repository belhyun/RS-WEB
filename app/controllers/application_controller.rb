class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  skip_before_filter :verify_authenticity_token
  #before_action :is_valid_token 
  rescue_from(Exception) do |e|
    render :json => fail(e.message)
  end
  rescue_from(Apipie::ParamMissing) do |parameter_missing_exception|
    error = {}
    error[parameter_missing_exception.param] = ['parameter is required']
    render :json => fail(error)
  end

  def is_valid_user
    raise Exception, 'not authorized user' if !User.is_valid_user(params[:user_id])
  end

  def is_valid_token
    raise 'invalid acc token' if Token.is_valid(params[:acc_token]).blank?
  end
end
