class Api::V1::RoutesController < ApplicationController
  include ApplicationHelper
  respond_to :json
  api :GET, '/routes/:id/boards', "호선별 게시글을 반환한다."
  description "지역별 호선 리스트를 반환한다."
  error :code => 0, :desc => '에러시 코드'
  param :page, String, :desc => '페이징'
  param :id, String, :desc => '호선'
  formats ['json']
  def boards
    begin
      boards = Route.get_boards(boards_params[:id] , boards_params[:page]) 
      render :json => success(boards)
    rescue Exception => e
      render :json => fail(e.message)
    end
  end

  private 
  def boards_params
    params.permit(:id, :page)
  end
end
