class Apply < ApplicationRecord
  #RELATIONS AND ITS VALIDATIONS
  belongs_to :user
  validate :user, :candidate_present
  belongs_to :job_advert
  validates_uniqueness_of :job_advert_id, scope: %i[user_id job_advert_id]

  #TYPES TO DEFINE
  STATUSES = ["pending", "hire", "reject"]
  enum status: STATUSES, _prefix: :apply

  #ATTRIBUTES VALIDATIONS
  validates_presence_of :status

  #CUSTOM VALIDATIONS
  def candidate_present
    if user.rol != "candidate"
      errors.add(:user_id, "El usuario no es un candidato")
    end
  end

  #SCOPES
  scope :job_advert_from_company, -> (user) {
    Apply.where(job_advert_id: user.job_advert.pluck(:id))
  }

end
