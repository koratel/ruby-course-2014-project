class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.references :problem, index: true

      t.timestamps null: false
    end
    add_foreign_key :tags, :problems
    add_index :tags, [:problem_id, :name]
  end
end
