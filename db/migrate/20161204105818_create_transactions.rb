class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.date :accounted_on
      t.text :explanation
      t.text :type
      t.integer :amount

      t.timestamps
    end
  end
end
