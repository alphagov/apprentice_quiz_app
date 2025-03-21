class TakeQuizController < ApplicationController
  before_action :set_quiz
  before_action :ensure_guest_or_signed_in

  def question
    @questions = @quiz.questions.order(:id)
    @question = @questions.find(params[:question_id])
    @question_index = @questions.pluck(:id).index(@question.id)
  end

  def submit
    current_question = @quiz.questions.find(params[:question_id])
    user_answer = params[:answer]
    session[:quiz_answers] ||= {}
    session[:quiz_answers][@quiz.id.to_s] ||= {}
    session[:quiz_answers][@quiz.id.to_s][current_question.id.to_s] = user_answer

    next_question = @quiz.questions.where("id > ?", current_question.id).order(:id).first
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
      user_answer == q.correct_option ? 1 : 0
    end

    # Capture guest username for display, if not signed in.
    @guest_username = session[:guest_username] unless user_signed_in?

    # Clear the guest username from the session (effectively "signing out" the guest).
    session.delete(:guest_username)
  end

private

  def ensure_guest_or_signed_in
    unless user_signed_in? || session[:guest_username].present?
      redirect_to guest_prompt_quiz_path(@quiz), alert: "Please enter your guest username to continue."
    end
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
