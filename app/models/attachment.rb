class Attachment < ActiveRecord::Base
  belongs_to :board
  belongs_to :comment
  mount_uploader :file, FileUploader

  def self.get_with_slice_attachment(attachments)
    Attachment.new({:file => attachments})
  end
end
