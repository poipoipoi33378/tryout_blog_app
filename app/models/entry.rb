class Entry < ApplicationRecord
  validates :blog_id,presence: true
  validates :title,presence: true
  validates :body,presence: true
  belongs_to :blog
end
