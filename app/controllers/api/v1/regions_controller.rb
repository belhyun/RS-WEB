class Api::V1::RegionsController < ApplicationController
  respond_to :json
  api :GET, '/regions/list', "지역 리스트 api"
  description "지역 리스트를 반환한다."
  error :code => 0, :desc => '에러시 코드'
  formats ['json']
  def list
    render :json => success(Region.all)
  end

  respond_to :json
  api :GET, '/regions/list', "지역별 노선 리스트 api"
  description "지역별 호선 리스트를 반환한다."
  error :code => 0, :desc => '에러시 코드'
  formats ['json']
  def routes
    render :json => success(Region.find(:all, :include => [:routes]).as_json(:include => :routes))
  end
end
