Rails.application.routes.draw do
  get 'populations', to: 'populations#index'
  get 'the_logz', to: 'the_logz#index'
end
