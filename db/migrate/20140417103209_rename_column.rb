class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :files, :path, :file
  end
end
