module Api
  module V1
    class VersionsController < ApplicationController
      include ApplicationHelper
      skip_before_filter :verify_authenticity_token
      respond_to :json
      api :GET, '/versions', "version info api"
      description "version 정보를 반환한다."
      error :code => 0, :desc => '에러시 코드'
      formats ['json']
      def index
        version = {:major => 1.0, :minor => 0.0}
        render :json => success(version)
      end
    end
  end
end
