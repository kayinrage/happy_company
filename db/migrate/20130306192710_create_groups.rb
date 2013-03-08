class CreateGroups < ActiveRecord::Migration
  def change
    create_table(:groups) do |t|
      t.string :name
      t.integer :parent_group_id
    end
    add_index :groups, :parent_group_id
  end
end
