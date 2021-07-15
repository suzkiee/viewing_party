class AddTitleToParty < ActiveRecord::Migration[5.2]
  def change
    add_column :parties, :title, :string 
  end
end
