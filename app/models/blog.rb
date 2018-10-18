class Blog < ApplicationRecord
  has_many :entries, dependent: :destroy

  validates :title,presence: true
  after_save :save_comments

  def save_comments
    # TODO エントリーとコメントの数が増えた時どうなる？
    self.entries.each do |entry|
      entry.comments.each(&:save)
    end
  end
end
