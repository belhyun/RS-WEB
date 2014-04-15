module Api
  module V1
    class UsersController <  ApplicationController
      include ApplicationHelper
      skip_before_filter :verify_authenticity_token
      respond_to :json
      api :POST, '/users/sign_up', "가입 api"
      description "가입 API(성공 시 {code:1, msg:'success', body:{acc_token:acc_token, usn: usn, expires: datetime}}을 반환한다.)"
      param :user, Hash, :desc => 'sign up info', :required => true do
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
            :usn => @user.id, :expires => @user.token.expires.to_time}) if @user.build_token && @user.save
          end
        rescue Exception => e
          render :json => fail(e.message)
        end
      end

      api :POST, '/users/sign_in', "로그인 api"
      description "로그인 API, 토큰과 만료시간을 갱신하고 로그인 횟수를 재 갱신한다.(성공 시 {code:1, msg:'success', body:{acc_token:acc_token, usn: usn, expires: datetime}}을 반환한다.)"
      param :user, Hash, :desc => 'sign in info', :required => true do
        param :email, String, :desc => '로그인 email', :required => true
        param :password, String, :desc => '로그인 비밀번호', :required => true
      end
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def signin
        begin
          @user = User.new(sign_in_params)
          if !@user.valid?
            render :json => fail(@user.errors)
          else
            @user = @user.signIn
            #render :json => success({:acc_token => @user.token.token,
            #:usn => @user.id, :expires => @user.token.expires.to_time})
            render :json => @user.token
          end
        rescue Exception => e
          render :json => fail(e.message)
        end
      end

      api :POST, '/users/email', "이메일 검증 api"
      description "이메일 검증 api, uniqueness를 검사한다."
      param :email, String, :desc => '검증 email', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def email 
        begin
          @user = User.getUserWithToken(:email, email_params[:email])
          if !@user.blank?
            raise 'user login required(token not exists)' if @user.token.blank?
            render :json => success({:acc_token => @user.token.token || nil,
                                       :usn => @user.id, :expires => @user.token.nil? ? nil :  @user.token.expires.to_time})
          else
            raise ActiveRecord::RecordNotFound, 'not exists email'
          end
        rescue Exception => e
          render :json => fail(e.message)
        end
      end

      api :POST, '/users/sign_out', "로그아웃 api"
      description "로그아웃 api."
      param :usn, String, :desc => 'user serial number(user id)', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def signout 
        begin
          @user = User.getUserWithToken(:id, signout_params[:usn])
          if !@user.blank?
            raise 'user login required(token not exists)' if @user.token.blank?
            User.find_by_id(signout_params[:usn], :include => [:token]).token.update_attributes(:expires => DateTime::now - 999.days)
            render :json => success({:acc_token => @user.token.token || nil,
                                       :usn => @user.id, :expires => @user.token.nil? ? nil :  @user.token.expires.to_time})
          else
            raise ActiveRecord::RecordNotFound, 'user not exists'
          end
        rescue Exception => e
          render :json => fail(e.message)
        end
      end

      
      private
      def sign_up_params
        params.require(:user).permit(:email, :password, :route).merge(encrypted_password: params[:user][:password])
      end
      def sign_in_params
        params.require(:user).permit(:email, :password).merge(encrypted_password: params[:user][:password])
      end
      def email_params
        params.permit(:email)
      end
      def signout_params
        params.permit(:usn)
      end
    end
  end
end
