class TakeQuizController < ApplicationController
  before_action :set_quiz

  def question
    @question = @quiz.questions.find(params[:question_id])
    question_ids = @quiz.questions.order(:id).ids
    @question_index = question_ids.index(@question.id)
  end

  def submit
    current_question = @quiz.questions.find(params[:question_id])
    user_answer = params[:answer]
    session[:quiz_answers] ||= {}
    session[:quiz_answers][@quiz.id] ||= {}
    session[:quiz_answers][@quiz.id][current_question.id] = user_answer

    next_question = @quiz.questions.where("id > ?", current_question.id).first

    if next_question
      redirect_to take_quiz_question_path(@quiz.id, next_question.id)
    else
      redirect_to take_quiz_results_path(@quiz.id)
    end
  end

  def results
    user_answers = (session[:quiz_answers] && session[:quiz_answers][@quiz.id]) || {}
    @score = @quiz.questions.sum do |q|
      user_answer = user_answers[q.id]
      next 0 unless user_answer

      user_answer == q.correct_option ? 1 : 0
    end
  end

private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
