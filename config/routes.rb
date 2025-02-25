Rails.application.routes.draw do
  if Rails.env.development?
    mount GovukPublishingComponents::Engine, at: "/component-guide"
  end

  resources :quizzes do
    resources :questions
    member do
      get "take/:question_id", to: "take_quiz#question", as: :take_quiz_question
      post "submit/:question_id", to: "take_quiz#submit", as: :take_quiz_submit
      get "results", to: "take_quiz#results", as: :results_quiz
    end
  end

  root "quizzes#index"
end
