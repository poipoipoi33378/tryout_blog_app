class Comment < ApplicationRecord
  belongs_to :entry

  validates :entry_id,presence: true
  validates :body,presence: true
end
