class CreateParentGroups < ActiveRecord::Migration
  def change
    create_table(:parent_groups) do |t|
      t.string :name
    end
  end
end
