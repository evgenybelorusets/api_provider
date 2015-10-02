class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :role
      t.string :uid
      t.references :client_application, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
