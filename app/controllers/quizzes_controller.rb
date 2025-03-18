class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_quiz, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]
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
    @quiz = current_user.quizzes.build(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: "Quiz was successfully created."
    else
      render :new, status: :unprocessable_entity
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
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy!
    redirect_to quizzes_path, notice: "Quiz was successfully deleted."
  end

private

  def quiz_params
    params.require(:quiz).permit(:title, :description)
  end

  def find_quiz
    @quiz = Quiz.find(params[:id])
  end

  def authorize_user!
    unless @quiz.user == current_user
      flash[:alert] = "You are not authorised to perform that action."
      redirect_to quiz_path
    end
  end

  def quiz_params
    params.require(:quiz).permit(:title, :description)
  end
end
