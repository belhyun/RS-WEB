class CreateToken < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token
      t.integer :usn
      t.datetime :expires
    end
  end
end
