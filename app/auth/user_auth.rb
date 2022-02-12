module UserAuth
  class << self
    attr_accessor(
      :token_life_time,
      :token_audience,
      :token_signature_algorithm,
      :token_signature_secret_key,
      :token_access_key,
      :not_found_exception_class
    )

    self.token_life_time = 2.weeks
    self.token_audience = ENV['APP_URL']
    self.token_signature_algorithm = 'HS256'
    self.token_signature_secret_key = Rails.application.credentials.secret_key_base
    self.token_access_key = :access_token
    self.not_found_exception_class = ActiveRecord::RecordNotFound
  end
end