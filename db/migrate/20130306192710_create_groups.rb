class CreateGroup < ActiveRecord::Migration
  def change
    create_table(:groups) do |t|
      t.integer :parent_group_id
      t.string :name
      t.date :date
    end
    add_index :groups, :parent_group_id
  end
end
