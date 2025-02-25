class TakeQuizController < ApplicationController
    def question
      @quiz = Quiz.find(params[:id])
      @question = @quiz.questions.find(params[:question_id])
      question_ids = @quiz.questions.order(:id).pluck(:id)
      @question_index = question_ids.index(@question.id)
    end
  
    def submit
      @quiz = Quiz.find(params[:id])
      current_question = @quiz.questions.find(params[:question_id])
      next_question = @quiz.questions.where("id > ?", current_question.id).first
    
      if next_question
        redirect_to take_quiz_question_quiz_path(@quiz, next_question.id)
      else
        redirect_to results_quiz_quiz_path(@quiz)
      end
    end
    
  
    def results
      @quiz = Quiz.find(params[:id])
    end
  end
  