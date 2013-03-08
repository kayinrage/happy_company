class CreateMemberships < ActiveRecord::Migration
  def change
    create_table(:memberships) do |t|
      t.integer :user_id
      t.integer :group_id
    end
    add_index :memberships, :user_id
    add_index :memberships, :group_id
  end
end