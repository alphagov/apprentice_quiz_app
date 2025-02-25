class QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find(params[:id])
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: "Quiz was successfully created."
    else
      render :new
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    @quiz = Quiz.find(params[:id])
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: "Quiz was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy!
    redirect_to quizzes_url, notice: "Quiz was successfully destroyed."
  end

  def take
    @quiz = Quiz.find(params[:id])
    @question = @quiz.questions.find(params[:question_id])
    question_ids = @quiz.questions.order(:id).pluck(:id)
    @question_index = question_ids.index(@question.id) || 0
  end

  def submit
    @quiz = Quiz.find(params[:id])
    current_question = @quiz.questions.find(params[:question_id])
    next_question = @quiz.questions.where("id > ?", current_question.id).first

    if next_question.nil?
      redirect_to results_quiz_path(@quiz)
    else
      redirect_to take_quiz_path(@quiz, next_question.id)
    end
  end

  def results
    @quiz = Quiz.find(params[:id])
  end

private

  def quiz_params
    params.require(:quiz).permit(:title, :description)
  end
end
