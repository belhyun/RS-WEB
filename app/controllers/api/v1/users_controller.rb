module Api
  module V1
    class UsersController <  ApplicationController
      include ApplicationHelper
      skip_before_filter :verify_authenticity_token
      respond_to :json
      api :POST, '/users/sign_up', "가입 api"
      description "가입 API(성공 시 {code:1, msg:'success', body:{acc_token:acc_token, usn: usn, expires: timestamp}}을 반환한다.)"
      param :user, Array, :desc => 'sign up info' , :required => true do
        param :email, String, :desc => '가입 email', :required => true
        param :password, String, :desc => '가입 비밀번호', :required => true
      end
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def signup
        begin
          @user = User.new(sign_up_params)
          if !@user.valid?
            render :json => fail(@user.errors)
          else
            render :json => success({:acc_token => @user.token.token,
            :usn => @user.id, :expires => @user.token.expires.to_time.to_i}) if @user.build_token && @user.save
          end
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
