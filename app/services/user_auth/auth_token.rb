module UserAuth
  class AuthToken
    attr_reader(
      :token,
      :payload,
      :lifetime
    )

    def initialize(lifetime: nil, payload: {}, token: nil, options: {})
      if token
        # decodeする
        @token = token
        @payload = JWT.decode(token, decode_key, true, decode_options.merge(options))[0]
      else
        # encodeする
        @lifetime = lifetime || UserAuth.token_lifetime
        @payload = claims.merge(payload)
        @token = JWT.encode(@payload, encode_key, algorithm, header_fields)
      end
    end

    def entity_for_user
      User.find(payload['sub'])
    end

    def lifetime_text
      num, unit = lifetime.inspect.split(' ')
      unit.sub!(/s$/, '')
      "#{num}#{I18n.t("datetime.prompts.#{unit}")}間"
    end

    private

    def decode_key
      UserAuth.token_signature_secret_key
    end

    def encode_key
      decode_key
    end

    def algorithm
      UserAuth.token_signature_algorithm
    end

    def token_audience
      UserAuth.token_audience
    end

    def token_lifetime
      @lifetime.from_now.to_i
    end

    def decode_options
      {
        algorithm: algorithm,
        aud: token_audience,
        verify_aud: true
      }
    end

    def claims
      {
        exp: token_lifetime,
        aud: token_audience
      }
    end

    def header_fields
      { typ: 'JWT' }
    end
  end
end
