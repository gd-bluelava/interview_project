Rails.application.routes.draw do
  get 'populations', to: 'populations#index'
  get 'the_logz', to: 'the_logz#index'
  get 'exact_queries', to: 'the_logz#exact_queries'
  get 'update_population_queries', to: 'the_logz#update_population_queries'
end
