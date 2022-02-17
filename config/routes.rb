Rails.application.routes.draw do
  namespace(:api) do
    namespace(:v1) do
      resources(:users, only: []) do
        get(:current_user, action: :show, on: :collection)
      end

      post(:login, action: :create, controller: :user_token)
      delete(:logout, action: :destroy, controller: :user_token)

      resources(:projects, only: :index)
    end
  end
end
