Rails.application.routes.draw do
  devise_for :users #これはこれだけでdeviseと対応しているところなので、このまま放置OK 9/21
  get 'prototypes/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "prototypes#index"#0923ここでトップページを決めている
  resources :prototypes, only: [:new, :create, :index, :show]
end
