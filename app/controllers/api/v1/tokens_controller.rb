module Api
  module V1
    class TokensController <  ApplicationController
      include ApplicationHelper
      skip_before_filter :verify_authenticity_token
      respond_to :json
      api :POST, '/tokens/valid', "토큰 검증 api"
      description "토큰 검증 API(성공 시 {code:1, msg:'success'}을 반환한다.)"
      param :acc_token, String, :desc => '액세스 토큰', :required => true
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def valid
        begin
          if Token.find(:first, :conditions => ["token = ? AND expires >= CURTIME()", valid_params[:acc_token]]).blank?
            raise ActiveRecord::RecordNotFound , 'invalid token' 
          else
            render :json => success(nil)
          end
        rescue Exception => e
          render :json => fail(e.message)
        end
      end
      private
      def valid_params
        params.permit(:acc_token)
      end
    end
  end
end
