class AddBoardsCountToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :board_count, :integer
  end
end
