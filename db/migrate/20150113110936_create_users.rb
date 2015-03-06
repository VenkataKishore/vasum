class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :mobile
      t.text :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.text :about
      t.attachment :profile_pic

      t.timestamps
    end
  end
end
