class User < ApplicationRecord
  include(UserAuth::Tokenizable)
  has_secure_password
  before_validation(:downcase_email)

  validates(:name, presence: true, length: { maximum: 30, allow_blank: true })
  VALID_PASSWORD_REGEXP = /\A[\w-]+\z/.freeze
  validates(
    :password,
    length: { minimum: 8, allow_blank: true, with: :invalid_password },
    format: { with: VALID_PASSWORD_REGEXP, allow_blank: true }
  )
  validates(:email, presence: true, email: { allow_blank: true })

  class << self
    def find_activated(email)
      find_by(email: email, activated: true)
    end
  end

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    other_users = User.where.not(id: id)
    other_users.find_activated(email).present?
  end

  private

  def downcase_email
    email&.downcase!
  end
end
