require 'rails_helper'

RSpec.describe 'Api::V1::UserToken', type: :request do
  describe('POST /api/v1/login') do
    let(:path) { '/api/v1/login' }
    let(:user) { create(:user) }

    context('有効なメールアドレスとパスワードの場合') do
      let(:params) { { auth: { email: user.email, password: user.password } } }

      it('クッキーが保存されている') do
        Timecop.freeze(Time.now)
        post(path, params: params)

        cookie = cookies[UserAuth.token_access_key.to_s]
        expect(cookie.present?).to eq(true)
        expect(cookie['value']).to eq(user.to_token)
        expect(cookie['expires']).to eq(Time.now)
        expect(cookie['secure']).to eq(false)
        expect(cookie['http_only']).to eq(true)
      end
    end
  end
end
