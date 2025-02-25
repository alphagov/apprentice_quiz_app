Rails.application.routes.draw do
  if Rails.env.development?
    mount GovukPublishingComponents::Engine, at: "/component-guide"
  end

  resources :quizzes do
    resources :questions
    member do
      get "take/:question_id", action: :take, as: :take
      post "submit"
      get "results"
    end
  end

  root "quizzes#index"
end
