Rails.application.routes.draw do
  resources :quizzes do
    resources :questions
  end
  root "quizzes#index"
end