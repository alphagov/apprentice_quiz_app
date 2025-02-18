class QuizSessionsController < ApplicationController
  def new
    @quiz = Quiz.find(params[:quiz_id])
  end

  def create
    @quiz = Quiz.find(params[:quiz_id])
    redirect_to quiz_path(@quiz), notice: "Quiz submitted! (Result evaluation pending)"
  end
end
