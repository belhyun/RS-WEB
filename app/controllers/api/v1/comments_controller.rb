class Api::V1::CommentsController < ApplicationController
  api :POST, '/comments', "댓글을 생성한다."
  description "댓글을 생성한다."
  param :board_id, String, :desc => '글 아이디', :required => true
  param :title, String, :desc => '제목', :required => true
  param :contents, String, :desc => '내용', :required => true
  param :user_id, String, :desc => '사용자 아이디', :required => true
  formats ['json']
  def create
    begin
      if comment = Comment.create(create_params)
        render :json => success(comment)
      end
    rescue Exception => e
      render :json => fail(e.message)
    end
  end

  private 
  def create_params
    params.permit(:board_id, :title, :contents, :user_id)
  end
end
