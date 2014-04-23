class CreateUserFollowers < ActiveRecord::Migration
  def change
    create_table :user_followers do |t|
      t.references :user, index: true
      t.integer :follow_id
    end
  end
end
