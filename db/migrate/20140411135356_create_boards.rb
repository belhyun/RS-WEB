class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :region_id
      t.integer :route_id
      t.integer :station_id
      t.integer :user_id
      t.integer :hits
      t.text :title
      t.text :contents
      t.timestamps
    end
  end
end
