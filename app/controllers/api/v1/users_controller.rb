module Api
  module V1
    class UsersController <  ApplicationController
      before_action :is_valid_token, only: [:routes,:create,:follow,:change_nick,:profile,:signout,:show,:get_routes,:follows,:followers]
      respond_to :json
      api :POST, '/users/sign_up', "가입 api"
      description "가입 API"
      param :user, Hash, :desc => 'sign up info', :required => true do
        param :email, String, :desc => '가입 email', :required => true
        param :password, String, :desc => '가입 비밀번호', :required => true
        param :nick, String, :desc => '닉네임', :required => true
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
            :usn => @user.id, :expires => @user.token.expires}) if @user.build_token && @user.save
          end
        rescue Exception => e
          render :json => fail(e.message)
        end
      end

      api :POST, '/users/sign_in', "로그인 api"
      description "로그인 API, 토큰과 만료시간을 갱신하고 로그인 횟수를 재 갱신한다."
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
            render :json => success(@user.token.as_json(except: [:id]))
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
        @user = User.getUserWithToken(:email, email_params[:email])
        if !@user.blank?
          raise 'user login required(token not exists)' if @user.token.blank?
          #render :json => success({:acc_token => @user.token.token || nil,
          #                           :usn => @user.id, :expires => @user.token.nil? ? nil :  @user.token.expires.to_time})
          render :json => success(nil)
        else
          raise ActiveRecord::RecordNotFound, 'not exists email'
        end
      end

      api :POST, '/users/nick', "닉네임 검증 api, 존재할 경우 1 존재하지 않을 경우 0 반환"
      description "닉네임 검증 api, uniqueness를 검사한다."
      param :nick, String, :desc => '검증 닉네임(url encode)', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def nick 
        @user = User.where(["nick = ?", URI::decode(params[:nick])])
        if !@user.blank?
          render :json => success(nil)
        else
          raise ActiveRecord::RecordNotFound, 'not exists nick'
        end
      end


      api :POST, '/users/sign_out', "로그아웃 api"
      description "로그아웃 api."
      param :user_id, String, :desc => 'user_id', :required => true
      param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def signout 
        @user = User.getUserWithToken(:id, signout_params[:user_id])
        if !@user.blank?
          raise 'user login required(token not exists)' if @user.token.blank?
          User.find_by_id(signout_params[:user_id], :include => [:token]).token.update_attributes(:expires => DateTime::now - 999.days)
          render :json => success(nil)
        else
          raise ActiveRecord::RecordNotFound, 'user not exists'
        end
      end

      api :POST, '/users/:id', "유저정보를 반환한다."
      description "유저정보를 반환한다."
      param :id, String, :desc => 'user_id', :required => true
      param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def show
        user  = User.find_by_id(params[:id])
        if user.nil?
          raise 'user not found'
        else
          render :json => user.as_json(:include => [:follows,:boards])
        end
      end

      api :POST, '/users/:user_id/routes', "즐겨찾는 호선정보 추가하기"
      description "즐겨찾는 호선정보를 저장한다.(나의 즐겨찾는 호선)"
      param :user_id, String, :desc => 'user_id', :required => true
      param :region_id, String, :desc => '지역 id', :required => true
      param :route_id, String, :desc => '지하철 호선 id', :required => true
      param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def routes
        if userRoute = UserRoute.find_or_create_by(routes_params)
          render :json => success(userRoute.as_json(:include => [:user, :route]))
        else
          raise Exception, 'user routes fail'
        end 
      end

      api :GET, '/users/:user_id/routes', "즐겨찾기 한 호선 정보를 가져온다."
      description "즐겨찾기 한 호선 정보를 가져온다."
      param :user_id, String, :desc => 'user_id', :required => true
      param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def get_routes
        render :json => success(User.find_by_id(get_routes_param[:user_id]).routes)
      end

      api :POST, '/users/:user_id/profile', "유저의 프로필 이미지를 업데이트 한다."
      description "유저의 프로필 이미지 업로드하기"
      param :image, ActionDispatch::Http::UploadedFile, :desc => '이미지', :required => true
      param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def profile
        @user = User.find(:first, :conditions => ["id =?", profile_params[:user_id]])
        @user.update_attributes(profile_params.slice(:image))
        @user.save!
        render :json => success(@user)
      end

      api :POST, '/users/:user_id/follow', "팔로잉 한다."
      description ":id는 사용자의 user_id를 나타낸다."
      param :user_id, String, :desc => '팔로잉할 사람 아이디', :required => true
      param :follow_id, String, :desc => '팔로잉하는 사람 아이디', :required => true
      param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def follow
        if follow_params[:user_id] === follow_params[:follow_id]
          raise 'same user'
        end
        @follow = Follow.find_or_create_by(follow_params)
        render :json => success(@follow.as_json(:include => :user))
      end

      api :GET, '/users/:user_id/follows', "팔로잉 리스트를 반환한다."
      description ":id는 사용자의 user_id를 나타낸다."
      param :user_id, String, :desc => '유저 아이디', :required => true
      param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def follows
        unless (@user = User.find_by_id(follows_params[:user_id])).blank?
          render :json => success(@user.as_json(:include => :follows))
        else
          render :json => success({})
        end
      end

      api :GET, '/users/:user_id/followers', "팔로워 리스트를 반환한다."
      description ":id는 사용자의 user_id를 나타낸다."
      param :user_id, String, :desc => '유저 아이디', :required => true
      param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def followers
        unless (followers = User.followers(followers_params[:user_id])).blank?
          render :json => success(followers.as_json)
        else
          render :json => success({})
        end
      end

      api :POST, '/users/:user_id/nick', "닉네임을 변경한다."
      description ":id는 사용자의 user_id를 나타낸다."
      param :user_id, String, :desc => '유저 아이디', :required => true
      param :nick, String, :desc => '변경 닉네임, url encode 하여 보낸다.', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def change_nick
        if user = User.update(change_nick_params[:user_id], nick: URI.unescape(change_nick_params[:nick])) 
          render :json => success(user)
        end
      end
      
      private
      def change_nick_params
        params.permit(:user_id, :nick)
      end
      def followers_params
        params.permit(:user_id)
      end
      def follow_params
        params.permit(:user_id, :follow_id)
      end
      def follows_params
        params.permit(:user_id)
      end
      def sign_up_params
        params.require(:user).permit(:email, :password, :route, :nick).merge(encrypted_password: params[:user][:password])
      end
      def sign_in_params
        params.require(:user).permit(:email, :password).merge(encrypted_password: params[:user][:password])
      end
      def email_params
        params.permit(:email)
      end
      def signout_params
        params.permit(:user_id)
      end
      def routes_params
        params.permit(:user_id, :region_id, :route_id)
      end
      def get_routes_param
        params.permit(:user_id)
      end
      def profile_params
        params.permit(:image, :user_id)
      end
    end
  end
end
