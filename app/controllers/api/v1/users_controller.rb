class Api::V1::UsersController < ApplicationController
  before_action(:authenticate_user)

  # get /users/current_user
  def show
    render(json: current_user, root: 'user', adapter: :json)
  end
end
