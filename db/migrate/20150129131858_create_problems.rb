class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :name
      t.string :url
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :problems, :users
    add_index :problems, [:user_id, :created_at]
  end
end
