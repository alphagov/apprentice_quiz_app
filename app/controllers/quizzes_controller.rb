class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_quiz, only: %i[show edit update destroy]

  def index
    @quizzes = Quiz.all
  end

  def show; end

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

  def edit; end

  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: "Quiz was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quiz.destroy!
    redirect_to quizzes_path, notice: "Quiz was successfully deleted."
  end

private

  def quiz_params
    params.expect(quiz: %i[title description])
  end

  def find_quiz
    @quiz = if %w[edit update destroy].include?(action_name)
              current_user.quizzes.find(params[:id])
            else
              Quiz.find(params[:id])
            end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "You are not authorised to perform that action."
    redirect_to quiz_path(params[:id])
  end
end
