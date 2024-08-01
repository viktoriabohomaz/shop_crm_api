module Types
  class CustomerType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :photo_url, String, null: true
    field :deleted_at, GraphQL::Types::ISO8601DateTime, null: true
    field :created_by, Types::UserType, null: false, method: :created_by
    field :updated_by, Types::UserType, null: false, method: :updated_by

    def photo_url
      attached_photo_url(object.photo)
    end

    private

    def attached_photo_url(photo)
      return unless photo.attached?

      Rails.application.routes.url_helpers.rails_blob_url(photo, only_path: true)
    end
  end
end
