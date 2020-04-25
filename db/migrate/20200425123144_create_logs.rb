class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :query, null: false, index: true
      t.string :answer, null: false, index: true
      t.timestamp :created_at
    end
  end
end
