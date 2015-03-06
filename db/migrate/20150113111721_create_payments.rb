class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user
      t.datetime :paid_at
      t.string :paid_to
      t.float :amount

      t.timestamps
    end
  end
end
