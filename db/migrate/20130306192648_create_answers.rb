class CreateAnswers < ActiveRecord::Migration
  def change
    create_table(:answers) do |t|
      t.integer :user_id
      t.integer :result
      t.boolean :answered, default: false
      t.string :secret
      t.date :date
    end
    add_index :answers, :user_id
  end
end
