require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe('GET /api/v1/users/current_users') do
    let(:id) { 1 }
    let(:user) { create(:user, id: id) }
    let(:key) { UserAuth.token_access_key }
    let(:path) { '/api/v1/users/current_user' }

    context('正しいトークンである場合') do
      let(:token) { user.to_token }

      it('authenticate_userメソッド') do
        cookies[key] = token
        get(path)

        expect(response.status).to eq(200)
        expect(json['id']).to eq(id)
      end

      it('ユーザー情報を返す') do
        login(user)
        get(path)

        expect(json['id']).to eq(user.id)
        expect(json['name']).to eq(user.name)
        expect(json['email']).to eq(user.email)
      end
    end

    context('不正なトークンの場合') do
      let(:token) { "#{user.to_token}fff" }

      it('authenticate_userメソッドは401レスポンスを返す') do
        cookies[key] = token
        get('/api/v1/users/current_user')

        expect(response.status).to eq(401)
      end
    end

    context('トークンの有効期限が切れている場合') do
      let(:token) { user.to_token }

      it('authenticate_userメソッドは401レスポンスを返す') do
        cookies[key] = token
        Timecop.travel((2.weeks + 1.day).from_now)
        get('/api/v1/users/current_user')

        expect(response.status).to eq(401)
      end
    end
  end
end
