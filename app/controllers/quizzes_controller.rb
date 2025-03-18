class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_quiz, only: %i[edit update destroy]
  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.joins(:user).find(params[:id])

    unless user_signed_in? && @quiz.user == current_user
      if @quiz.questions.any?
        redirect_to take_quiz_question_path(@quiz.id, @quiz.questions.first.id)
      else
        flash[:alert] = "This quiz is not available because it has no questions."
        redirect_to quizzes_path
      end
    end
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

  def find_quiz
    @quiz = Quiz.find_by!(id: params[:id], user: current_user)
  end

  def quiz_params
    params.expect(quiz: %i[title description])
  end
end
