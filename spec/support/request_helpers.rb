module Requests
  module Helpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def login(user)
      cookies[UserAuth.token_access_key] = user.to_token
    end
  end
end
