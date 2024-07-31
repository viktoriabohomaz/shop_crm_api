class ImageUploadService
  attr_accessor :photo_base64, :file_name

  def initialize(photo_base64:, file_name:)
    @photo_base64 = photo_base64
    @file_name = file_name
  end

  def call
    save_file
  end

  private

  def file_size
    File.size("tmp/#{file_name}")
  end

  def save_file
    byebug
    File.open("tmp/#{file_name}", 'wb') do |f|
      f.write(Base64.decode64(photo_base64.split(',').last))
    end
  end
end
