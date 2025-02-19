class QuizzesController < ApplicationController
  layout "application"
  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: "Quiz was successfully created."
    else
      render :new
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    @quiz = Quiz.find(params[:id])
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: "Quiz was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy!
    redirect_to quizzes_url, notice: "Quiz was successfully destroyed."
  end

private

  def quiz_params
    params.require(:quiz).permit(:title, :description)
  end
end
