class Api::V1::CommentsController < ApplicationController
  before_action :is_valid_token
  api :POST, '/comments', "댓글을 생성한다."
  description "댓글을 생성한다."
  param :board_id, String, :desc => '글 아이디', :required => true
  param :title, String, :desc => '제목', :required => true
  param :contents, String, :desc => '내용', :required => true
  param :user_id, String, :desc => '사용자 아이디', :required => true
  param :acc_token, String, :desc => 'acc token(액세스 토큰).', :required => true
  param :attachment, ActionDispatch::Http::UploadedFile, :desc => '이미지'
  formats ['json']
  def create
    if comment = Comment.new(create_params)
      comment.attachment = Attachment.new(:file => params[:attachment]) if params.has_key?(:attachment)
      render :json => success(comment.as_json(:include => [:attachment, :user])) if comment.save!
    end
  end

  private 
  def create_params
    params.permit(:board_id, :title, :contents, :user_id)
  end
end
