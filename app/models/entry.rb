class Entry < ApplicationRecord
  belongs_to :blog
  has_many :comments,dependent: :destroy

  validates :blog_id,presence: true
  validates :title,presence: true
  validates :body,presence: true
end
