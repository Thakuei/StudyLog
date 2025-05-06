module Api::V1
  class Api::V1::StudyRecordsController < ApplicationController
    # skip_before_action :verify_authenticity_token

      def start
        user = find_or_create_user_from_slack_params

        study_record = StudyRecord.create!(user_id: user.id, start_time: Time.current)

        render json: { 
          response_type: "in_channel",
          text: "<@#{params[:user_id]}>さんが勉強を開始しました！" 
        }
      end

      def end
        user = find_or_create_user_from_slack_params

        unless user
          render json: { text: "ユーザーが登録されていません。" }, status: :unprocessable_entity
          return
        end

        study_record = user.study_records.order(start_time: :desc).first

        if study_record
          study_record.update!(end_time: Time.current)
          study_time = ((study_record.end_time - study_record.start_time) / 60).round(2)

          render json: { 
            response_type: "in_channel",
            text: "<@#{params[:user_id]}>さんが勉強を終了しました！所要時間 #{study_time}分" 
          }, status: :ok
        else
          render json: { text: "<@#{params[:user_id]}>さんの開式記録が見つかりません！" }, status: :not_found
        end

      end

      private

      def find_or_create_user_from_slack_params
        slack_user_id = params[:user_id]
        user_name = params[:user_name]

        user = User.find_by(slack_id: slack_user_id)

        unless user
          user = User.create!(slack_id: slack_user_id, name: user_name)
        end

        user
      end
  end
end
