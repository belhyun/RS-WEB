class CreateBoardEmpathies < ActiveRecord::Migration
  def change
    create_table :board_empathies do |t|

      t.timestamps
    end
  end
end
