Rails.application.routes.draw do
  get 'welcome/index'

  # transaction
  resources :transactions

  # zaim operations
  match 'zaim', controller: :zaim, via: :get
  match 'zaim/accounts', controller: :zaim, via: :get
  match 'zaim/genres', controller: :zaim, via: :get
  match 'zaim/transactions', controller: :zaim, via: :get
  match 'zaim/common_account_transactions', controller: :zaim, via: :get

  root 'welcome#index'
end
