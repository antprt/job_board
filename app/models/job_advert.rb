class JobAdvert < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, allow_blank: true, length: { maximum: 400 }
end
