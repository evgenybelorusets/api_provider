class CreateClientApplications < ActiveRecord::Migration
  def change
    create_table :client_applications do |t|
      t.string :key
      t.string :secret

      t.timestamps null: false
    end
  end
end
