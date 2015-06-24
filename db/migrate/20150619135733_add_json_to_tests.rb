class AddJsonToTests < ActiveRecord::Migration
  def change
    add_column :tests, :json, :string
  end
end
