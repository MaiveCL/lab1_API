class Product < ApplicationRecord
    # has_one_attached :featured_image #non, il y a un intermédiaire maintenant : ImageDescription
    has_rich_text :description
    validates :name, presence: true
    belongs_to :productable, polymorphic: true

    has_one :image_description, as: :imageable, dependent: :destroy
    accepts_nested_attributes_for :image_description

    validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }

    def description_text
      description.to_s
    end

    # déplacement dans le module :
    include Notifications
  # has_many :subscribers, dependent: :destroy
  # after_update_commit :notify_subscribers, if: :back_in_stock?

  # def back_in_stock?
  #     inventory_count_previously_was.zero? && inventory_count.positive?
  # end

  # def notify_subscribers
  #   subscribers.each do |subscriber|
  #     ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_later
  #   end
  # end
end
# le polymorphisme relie les données, mais ne donne pas directement acces aux méthodes tel que la création
