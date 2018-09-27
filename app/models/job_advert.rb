class JobAdvert < ApplicationRecord
  #RELATIONS AND ITS VALIDATIONS
  belongs_to :user
  validate :user, :company_present
  has_many :apply

  #ATTRIBUTES VALIDATIONS
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, allow_blank: true, length: { maximum: 400 }

  #CUSTOM VALIDATIONS
  def company_present
    if user.rol != "company"
      errors.add(:user_id, "El usuario no es una compañía")
    end
  end
end
