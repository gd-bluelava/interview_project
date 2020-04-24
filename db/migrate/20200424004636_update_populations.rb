class UpdatePopulations < ActiveRecord::Migration[5.2]
  def change
    rename_column :populations, :year, :year_old
    add_column :populations, :year, :integer
    Population.order(:year_old).each do |p|
      p.update_column(:year, p.year_old.year)
    end
    remove_column :populations, :year_old
    remove_column :populations, :created_at
    remove_column :populations, :updated_at
    add_index :populations, :year
  end
end
