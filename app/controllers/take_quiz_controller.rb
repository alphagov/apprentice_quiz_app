class TakeQuizController < ApplicationController
  before_action :set_quiz
  before_action :ensure_guest_or_signed_in, except: %i[guest_prompt set_guest_username]

  def guest_prompt; end

  def set_guest_username
    session[:guest_username] = params[:guest_username]
    redirect_to quiz_path(@quiz)
  end

  def question
    @question = @quiz.questions.find(params[:question_id])
    question_ids = @quiz.questions.order(:id).ids
    @question_index = question_ids.index(@question.id)
  end

  def submit
    current_question = @quiz.questions.find(params[:question_id])
    user_answer = params[:answer]
    session[:quiz_answers] ||= {}
    session[:quiz_answers][@quiz.id.to_s] ||= {}
    session[:quiz_answers][@quiz.id.to_s][current_question.id.to_s] = user_answer

    next_question = @quiz.questions.where("id > ?", current_question.id).first

    if next_question
      redirect_to take_quiz_question_path(@quiz.id, next_question.id)
    else
      redirect_to take_quiz_results_path(@quiz.id)
    end
  end

  def results
    user_answers = session[:quiz_answers]&.[](@quiz.id.to_s) || {}
    @score = @quiz.questions.sum do |q|
      user_answer = user_answers[q.id.to_s]
      next 0 unless user_answer

      user_answer == q.correct_option ? 1 : 0
    end

    @guest_username = session[:guest_username] unless user_signed_in?

    session.delete(:guest_username)
  end

private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def ensure_guest_or_signed_in
    unless user_signed_in? || session[:guest_username].present?
      redirect_to take_quiz_guest_prompt_path(@quiz.id), alert: "Please enter your guest username to continue."
    end
  end
end
