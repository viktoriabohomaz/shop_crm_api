class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :provider
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.boolean :is_admin, default: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :users, :deleted_at
  end
end
