class User < ApplicationRecord

  # ====================== Devise ========================== #
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable

  # ====================== Associations ==================== #

end
