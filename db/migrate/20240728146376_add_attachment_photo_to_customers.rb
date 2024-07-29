class AddAttachmentPhotoToCustomers < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :photo_file_name, :string
    add_column :customers, :photo_content_type, :string
    add_column :customers, :photo_file_size, :integer
    add_column :customers, :photo_updated_at, :datetime
  end
end
