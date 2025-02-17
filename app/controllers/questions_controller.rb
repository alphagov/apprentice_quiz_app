class QuestionsController < ApplicationController
  before_action :find_quiz
  before_action :find_question, only: [:edit, :update, :destroy]

  def new
    @question = @quiz.questions.build
  end

  def create
    @question = @quiz.questions.build(question_params)
    if @question.save
      redirect_to quiz_path(@quiz), notice: "Question was successfully created."
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @question.update(question_params)
      redirect_to quiz_path(@quiz), notice: "Question was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to quiz_path(@quiz), notice: "Question was successfully deleted."
  end

private

  def find_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def find_question
    @question = @quiz.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content, :correct_answer)
  end
end
