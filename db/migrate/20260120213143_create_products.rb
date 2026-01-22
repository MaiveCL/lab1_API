class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name

      t.belongs_to :productable, polymorphic: true

      t.timestamps
    end
  end
end
