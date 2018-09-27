class User < ApplicationRecord
  #DEVISE CONFIG
  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist

  #RELATIONS
  has_many :job_advert, dependent: :destroy
  has_many :apply, dependent: :destroy

  #TYPES TO DEFINE
  ROLES = ["company", "candidate"]
  enum rol: ROLES

  #ATTRIBUTES VALIDATIONS
  validates :email, uniqueness: true, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, length: { maximum: 254 }
  validates_presence_of :rol

end