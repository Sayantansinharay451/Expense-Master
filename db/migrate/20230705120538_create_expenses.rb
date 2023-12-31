# rubocop:disable all
class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :subcategory, foreign_key: true
      t.date :date
      t.integer :month, null: false
      t.integer :year, null: false, default: -> { 'EXTRACT(year FROM CURRENT_TIMESTAMP)' }
      t.decimal :amount, precision: 10, scale: 2
      t.text :notes
      t.string :attachment
      t.integer :status, default: 0, null: false
      t.text :rejection_reason
      t.timestamps
    end

    add_index :expenses, :year
    add_index :expenses, :status
    add_index :expenses, %i[user_id status]
    add_index :expenses, %i[category_id status]
  end
end
