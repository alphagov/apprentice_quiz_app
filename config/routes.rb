Rails.application.routes.draw do
  devise_for :users
  if Rails.env.development?
    mount GovukPublishingComponents::Engine, at: "/component-guide"
  end

  resources :quizzes do
    resources :questions
  end

  scope "/take-quiz/:quiz_id", as: "take_quiz" do
    get "/results", to: "take_quiz#results", as: "results"
    get "/:question_id", to: "take_quiz#question", as: "question"
    post "/:question_id/submit", to: "take_quiz#submit", as: "submit"
  end

  root "quizzes#index"
end
