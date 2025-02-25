Rails.application.routes.draw do
  if Rails.env.development?
    mount GovukPublishingComponents::Engine, at: "/component-guide"
  end

  resources :quizzes do
    resources :questions
    member do
      get "take/:question_id", action: :take, as: :take
      post "submit", action: :submit
      get "results", action: :results, as: :results
    end
  end

  root "quizzes#index"
end
