class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.boolean :approved,default: false
      t.references :entry, foreign_key: true

      t.timestamps
    end
  end
end
