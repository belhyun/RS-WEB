class CreateUserRoutes < ActiveRecord::Migration
  def change
    create_table :user_routes do |t|
      t.references :user, index: true
      t.references :route, index: true
      t.references :region, index: true
    end
  end
end
