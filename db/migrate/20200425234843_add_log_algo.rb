class AddLogAlgo < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :algo, :integer
  end
end
