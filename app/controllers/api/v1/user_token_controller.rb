class Api::V1::UserTokenController < ApplicationController
  before_action(:delete_cookie)
  before_action(:authenticate, only: [:create])

  # POST /login
  def create
    cookies[token_access_key] = cookie_token
    render(json: entity, root: 'user', adapter: :json, meta: { exp: auth.payload[:exp] })
  end

  # DELETE /logout
  def destroy
    head(:ok)
  end

  private

  # ユーザーが存在しないか、パスワードが一致しない時は404レスポンスを返す
  def authenticate
    head(:not_found) if !entity || !entity.authenticate(auth_params[:password])
  end

  # メアドからアクティブなユーザーを返す
  def entity
    @entity ||= User.find_activated(auth_params[:email])
  end

  def auth
    @auth ||= UserAuth::AuthToken.new(payload: { sub: entity.id })
  end

  def cookie_token
    {
      value: auth.token,
      expires: Time.at(auth.payload[:exp]),
      secure: Rails.env.production?,
      http_only: true
    }
  end

  def auth_params
    params[:auth].permit(:email, :password)
  end
end
