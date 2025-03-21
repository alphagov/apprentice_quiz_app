class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show guest_prompt guest_sign_in]
  before_action :find_quiz, only: %i[show edit update destroy guest_prompt guest_sign_in]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @quizzes = Quiz.all
  end

  def show
    # @quiz is already set in find_quiz
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
    # @quiz is already set in find_quiz
  end

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

  # Guest functionality for users who are not signed in

  def guest_prompt
    # Renders a view prompting for a guest username
  end

  def guest_sign_in
    session[:guest_username] = params[:guest_username]
    redirect_to quiz_path(@quiz)
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
      redirect_to quiz_path(@quiz)
    end
  end

  def quiz_params
    params.require(:quiz).permit(:title, :description)
  end
end
