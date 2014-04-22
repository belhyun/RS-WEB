class BoardEmpathy < ActiveRecord::Base
  belongs_to :user
  belongs_to :board
end
