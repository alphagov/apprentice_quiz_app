class QuestionsController < ApplicationController
  before_action :find_quiz

  def new
    @question = @quiz.questions.build
  end

  def create
    @question = @quiz.questions.build(question_params)
    if @question.save
      redirect_to quiz_path(@quiz)
    else
      render :new
    end
  end

private

  def find_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def question_params
    params.require(:question).permit(:content, :correct_answer)
  end
end
