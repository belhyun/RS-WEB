class CreateFiles < ActiveRecord::Migration
  def change
    create_table :files do |t|
      t.integer :board_id
      t.text :path
    end
  end
end
