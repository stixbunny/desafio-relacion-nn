class AddPriceToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :price, :integer
  end
end
