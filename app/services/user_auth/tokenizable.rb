module UserAuth
  module Tokenizable
    extend(ActiveSupport::Concern)

    def to_token
      UserAuth::AuthToken.new(payload: payload).token
    end

    # メール認証やパスワードリセットのためのトークン lifetime = 1.hour
    def to_lifetime_token(lifetime)
      auth = AuthToken.new(payload: payload, lifetime: lifetime)
      { token: auth.token, lifetime_text: auth.lifetime_text }
    end

    private

    def payload
      { sub: id }
    end

    module ClassMethods
      def from_token(token)
        find(id_from_token(token))
      end

      private

      def id_from_token(token)
        AuthToken.new(token: token).payload['sub']
      end
    end
  end
end
