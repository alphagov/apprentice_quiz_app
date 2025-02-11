Rails.application.routes.draw do
  if Rails.env.development?
    mount GovukPublishingComponents::Engine, at: "/component-guide"
  end

  resources :quizzes do
    resources :questions
  end

  root "quizzes#index"
end
