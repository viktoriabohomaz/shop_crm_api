class RemovePhotoFieldsFromCustomers < ActiveRecord::Migration[7.1]
  def change
    remove_column :customers, :photo_file_name, :string
    remove_column :customers, :photo_content_type, :string
    remove_column :customers, :photo_file_size, :integer
    remove_column :customers, :photo_updated_at, :datetime
  end
end
