class CreateStation < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.integer :region_id
      t.integer :route_id
      t.string :name
    end
  end
end
