module Api::V1
  class Api::V1::StudyRecordsController < ApplicationController
    # skip_before_action :verify_authenticity_token
    def start
      render json: { 
        response_type: "in_channel",
        text: "<@#{params[:user_id]}>さんが勉強を開始しました！" 
      }

      StudyRecordCreationJob.perform_later(params[:user_id], params[:user_name])
    end

    def end
      render json: { 
        response_type: "in_channel",
        text: "<@#{params[:user_id]}>さんが勉強を終了しました!" 
      }, status: :ok

      StudyRecordCompletionJob.perform_later(params[:user_id])
    end
  end
end
