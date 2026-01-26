class Product < ApplicationRecord
    # has_one_attached :featured_image #non, il y a un intermédiaire maintenant : ImageDescription 
    has_rich_text :description
    validates :name, presence: true
    belongs_to :productable, polymorphic: true
    
    has_one :image_description, as: :imageable, dependent: :destroy
    accepts_nested_attributes_for :image_description
end
# le polymorphisme relie les données, mais ne donne pas directement acces aux méthodes tel que la création