module Api::V1
  class Api::V1::StudyRecordsController < ApplicationController
    # skip_before_action :verify_authenticity_token
    def start
      StudyRecordCreationJob.perform_later(params[:user_id], params[:user_name])
      head :ok
    end

    def end
      StudyRecordCompletionJob.perform_later(params[:user_id])
      head :ok
    end
  end
end
