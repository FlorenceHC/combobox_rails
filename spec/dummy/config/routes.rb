Rails.application.routes.draw do
  mount ComboboxRails::Engine => "/combobox_rails"
  resources :tasks, only: [:index]
end
