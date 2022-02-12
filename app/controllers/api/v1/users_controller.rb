class Api::V1::UsersController < ApplicationController
  before_action(:authenticate_user)

  # get /users/current_user
  def show
    render(json: User.first)
  end
end
