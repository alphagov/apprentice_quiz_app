Rails.application.routes.draw do
  if Rails.env.development?
    mount GovukPublishingComponents::Engine, at: "/component-guide"
  end

  resources :quizzes do
    get 'take', to: 'quiz_sessions#new', as: 'take'
    post 'submit', to: 'quiz_sessions#create', on: :member, as: 'submit'
    resources :questions
  end

  root "quizzes#index"
end
