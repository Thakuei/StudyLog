class StudyRecordCompletionJob < ApplicationJob
  queue_as :default

  def perform(slack_user_id, response_url)
    user = User.find_by(slack_id: slack_user_id)
    unless user
      post_to_slack(response_url, "ユーザーが登録されていません。")
      return
    end

    study_record = user.study_records.order(start_time: :desc).first
    unless study_record
      post_to_slack(response_url, "勉強開始記録が見つかりません。")
      return
    end

    if study_record.end_time
      post_to_slack(response_url, "この勉強記録はすでに終了しています。")
      return
    end

    study_record.update!(end_time: Time.current)
    study_time = ((study_record.end_time - study_record.start_time) / 60).round(2)

    post_to_slack(response_url, "<@#{slack_user_id}>さんが勉強を終了しました！所要時間 #{study_time}分。")
  rescue => e
    post_to_slack(response_url, "エラーが発生しました: #{e.message}")
  end

  private

  def post_to_slack(response_url, message)
    uri = URI.parse(response_url)
    Net::HTTP.post(uri, { text: message }.to_json, "Content-Type" => "application/json")
  end
end
