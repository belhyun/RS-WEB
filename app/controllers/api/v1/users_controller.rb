module Api
  module V1
    class UsersController <  ApplicationController
      include ApplicationHelper
      skip_before_filter :verify_authenticity_token
      respond_to :json
      api :POST, '/users/sign_up', "가입 api"
      description "가입 API"
      def signup
        begin
          #User.create(sign_up_params)
          #render :json => sign_up_params
        rescue Exception => e
          render :json => fail(e.message)
        end
      end

      private
      def sign_up_params
        params.require(:users).permit(:email, :password).merge(encrypted_password: params[:users][:password])
      end
    end
  end
end
