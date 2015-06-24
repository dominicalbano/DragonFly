class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :tests, :type, :app_type
  end
end
