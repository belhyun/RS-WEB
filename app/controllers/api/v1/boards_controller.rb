module Api
  module V1
    class BoardsController < ApplicationController
      include ApplicationHelper
      skip_before_filter :verify_authenticity_token
      api :POST, '/boards', "게시글을 생성한다."
      description "게시글을 생성한다."
=begin
      param :region_id, String, :desc => '지역 아이디', :required => true
      param :route_id, String, :desc => '호선 아이디', :required => true
      param :station_id, String, :desc => '역 아이디', :required => true
      param :user_id, String, :desc => '사용자 아이디', :required => true
      param :title, String, :desc => '제목', :required => true
      param :contents, String, :desc => '게시글', :required => true
      param :friend_public, ["1", "0"], :desc => '친구만 공개 여부'
      param :added_file_cnt, String, :desc => '첨부파일 개수'
      param :files, Hash, :desc => '첨부파일 file1,file2...로 보낸다.' do
        param :file, String, :desc => '첨부파일 file1, file2'
      end
=end
      formats ['json']
      def create
        Board.new(create_params)
        render :json => create_params
      end
      private
      def create_params
        params.permit(:region_id, :route_id, :station_id, :user_id, :title, :contents, 
                      :friend_public, :files => [])
      end
    end
  end
end
