class Tweet < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 140 }

  scope :created_after, -> (time) {
    time = time.to_time
    where('created_at > ?', time)
  }
  scope :created_before, -> (time) {
    time = time.to_time
    where('created_at < ?', time)
  }

  class << self
    def ransackable_scopes(auth_object = nil)
      [:created_after, :created_before]
    end
  end
end
