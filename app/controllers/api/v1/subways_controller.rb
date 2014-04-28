module Api
  module V1
    class SubwaysController < ApplicationController
      include ApplicationHelper
      skip_before_filter :verify_authenticity_token
      respond_to :json
      api :GET, '/subways/:id/list', "지역별 지하철 노선을 반환한다."
      description "지역별 지하철 노선을 반환한다. :id에 지역이 들어간다.(서울만 일단 테스트로 진행 서울:1)"
      param :id, String, :desc => '지역 아이디', :required => true
      formats ['json']
      def list
        @region = Region.find(:first, :conditions => ["id = ?", list_params[:id]])
        render :json => success(@region.as_json(:include => {:routes => {:include => {:stations => {:except => [:region_id]}}}}))
      end

      private
      def list_params
        params.permit(:id)
      end
    end
  end
end
