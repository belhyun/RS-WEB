module Api
  module V1
    class BoardsController < ApplicationController
      before_action :is_valid_user, only: [:empathy]
      api :POST, '/boards', "게시글을 생성한다."
      description "게시글을 생성한다."
      param :region_id, String, :desc => '지역 아이디', :required => true
      param :route_id, String, :desc => '호선 아이디', :required => true
      param :station_id, String, :desc => '역 아이디', :required => true
      param :user_id, String, :desc => '사용자 아이디', :required => true
      param :title, String, :desc => '제목', :required => true
      param :contents, String, :desc => '게시글', :required => true
      param :friend_public, ["1", "0"], :desc => '친구만 공개 여부'
      param :attachments, Array, :desc => 'attachments[]에 첨부파일을 첨부하여 보낸다.'
      formats ['json']
      def create
        begin
          board = Board.new(create_params)
          params[:attachments].each{|attachment|
            board.attachments << Attachment.get_with_slice_attachment(attachment)
          }
          if board.save!
            render :json => success(board.as_json(:include => :attachments))
          end
        rescue Exception => e
          render :json => fail(e.message)
        end
      end

      api :GET, '/boards/:id/comments', "게시글의 댓글을 반환한다."
      description "게시글의 댓글을 반환한다."
      param :id, String, :desc => 'board_id'
      formats ['json']
      def comments
        render :json => Board.get(comments_params[:id]).comments
      end

      api :GET, '/boards/:id/empathy', "글에 대한 공감을 한다."
      description "인증된 사용자가 글에 대한 공감을 실시한다."
      param :id, String, :desc => 'board_id'
      param :user_id, String, :desc => 'user_id'
      formats ['json']
      def empathy
        if boardEmpathy = BoardEmpathy.find_or_create_by(empathy_params)
          render :json => success(boardEmpathy)
        else
          raise Exception, 'board empathy fail'
        end 
      end

      private
      def create_params
        params.permit(:region_id, :route_id, :station_id, :user_id, :title, :contents, 
                      :friend_public)
      end

      def comments_params
        params.permit(:id)
      end

      def empathy_params
        params.permit(:board_id,:user_id)
      end
    end
  end
end
