class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :app_type
      t.string :app_name
      t.string :choose_test

      t.timestamps null: false
    end
  end
end
