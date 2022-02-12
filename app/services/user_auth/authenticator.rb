module UserAuth
  module Authenticator
    def current_user
      return if token.blank?

      @current_user ||= fetch_entity_from_token
    end

    def authenticate_user
      current_user || unauthorized_user
    end

    def delete_cookie
      return if cookies[token_access_key].blank?

      cookies.delete(token_access_key)
    end

    def token_access_key
      UserAuth.token_access_key
    end

    private

    def fetch_entity_from_token
      AuthToken.new(token: token).entity_for_user
    rescue JWT::EncodeError, JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end

    def token
      token_from_request_headers || cookies[token_access_key]
    end

    def token_from_request_headers
      request.headers['Authorization']&.split&.last
    end

    def unauthorized_user
      head(:unauthorized) && delete_cookie
    end
  end
end
