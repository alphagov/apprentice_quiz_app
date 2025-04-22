class LeaderboardsController < ApplicationController
  before_action :set_quiz

  def index
    @entries = @quiz.leaderboard_entries
                    .select("name, MAX(score) AS score")
                    .group(:name)
                    .order("score DESC")
                    .limit(10)
  end

  def create
    answers = session.dig(:quiz_answers, @quiz.id.to_s) || {}
    score = @quiz.calculate_score(answers)

    leaderboard_entry = @quiz.leaderboard_entries.new(
      name: session[:guest_username] || current_user&.email,
      score: score,
    )

    if leaderboard_entry.valid?
      leaderboard_entry.save!
      redirect_to take_quiz_results_path(@quiz.id)
    else
      flash[:alert] = leaderboard_entry.errors.full_messages.to_sentence
      redirect_to take_quiz_results_path(@quiz)
    end
  end

private

  def set_quiz
    quiz_id = params[:quiz_id] || params[:id]
    @quiz = Quiz.find(quiz_id)
  end
end
