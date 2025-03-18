class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_quiz

  def new
    @question = @quiz.questions.build
  end

  def create
    @question = @quiz.questions.build(question_params)
    if @question.save
      redirect_to quiz_path(@quiz)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @question = @quiz.questions.find(params[:id])
  end

  def update
    @question = @quiz.questions.find(params[:id])
    if @question.update(question_params)
      redirect_to quiz_path(@quiz)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question = @quiz.questions.find(params[:id])
    @question.destroy!
    redirect_to quiz_path(@quiz)
  end

private

  def find_quiz
    @quiz = Quiz.find_by!(id: params[:quiz_id], user: current_user)
  end

  def question_params
    params.expect(question: %i[content option_a option_b option_c option_d correct_option])
  end
end
