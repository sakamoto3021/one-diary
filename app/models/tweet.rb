class Tweet < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 140 }
  validate :image_size
  mount_uploader :image, ImageUploader

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

  private

  def image_size
    image.size > 5.megabytes
  end
end
