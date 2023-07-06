class CreateBudgets < ActiveRecord::Migration[6.1]
  def change
    create_table :budgets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :subcategory, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.text :notes
      t.date :month
      t.timestamps
    end
  end
end
