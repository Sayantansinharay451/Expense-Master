class CreateSubcategories < ActiveRecord::Migration[6.1]
  def change
    create_table :subcategories do |t|
      t.string :name
      t.references :subcategory, foreign_key: true
      t.timestamps
    end
  end
end