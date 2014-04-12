module Api
  module V1
    class BoardsController < ApplicationController
      include ApplicationHelper
      skip_before_filter :verify_authenticity_token
      api :POST, '/boards', "게시글을 생성한다."
      description "게시글을 생성한다. 우선 텍스트만 진행한다."
      param :region_id, Integer, :desc => '지역 아이디', :required => true
      param :route_id, Integer, :desc => '호선 아이디', :required => true
      param :station_id, Integer, :desc => '역 아이디', :required => true
      param :user_id, Integer, :desc => '사용자 아이디', :required => true
      param :title, String, :desc => '제목', :required => true
      param :contents, String, :desc => '게시글', :required => true
      formats ['json']
      def create
       @board = Board.new(create_params)
       respond_to do
         if @board.save
           render :json => @board
         end
       end
      end
      
      private
      def create_params
        params.permit(:region_id, :route_id, :station_id, :user_id, :title, :contents)
      end
    end
  end
end
