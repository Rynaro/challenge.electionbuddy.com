class Elections::AuditsController < ApplicationController
  before_action :set_election, only: [:index]
  before_action :set_questions, only: [:index]
  before_action :set_voters, only: [:index]
  before_action :set_answers, only: [:index]
  before_action :audit_related, only: [:index]

  def index
  end

  private

  def set_election
    @election = Election.includes(:questions, :voters).find(params[:election_id])
  end

  def set_voters
    @voters = @election.voters
  end

  def set_questions
    @questions = @election.questions
  end

  def set_answers
    @answers = Answer.where(question_id: @questions.map(&:id))
  end

  def audit_related
    election_audit = @election.audits
    voters_audit = @voters.map(&:audits)
    questions_audit = @questions.map(&:audits)
    answers_audit = @answers.map(&:audits)
    @audits = [election_audit, voters_audit, questions_audit, answers_audit].flatten.sort_by { |audit| audit.created_at }
  end
end
