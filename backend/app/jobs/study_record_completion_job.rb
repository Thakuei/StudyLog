class StudyRecordCompletionJob < ApplicationJob
  queue_as :default

  def perform(slack_user_id)
    user = User.find_by(slack_id: slack_user_id)
    unless user
      notify_slack("ユーザーが登録されていません。")
      return
    end

    study_record = user.study_records.order(start_time: :desc).first
    unless study_record
      notify_slack("勉強開始記録が見つかりません。")
      return
    end

    if study_record.end_time
      notify_slack("この勉強記録はすでに終了しています。")
      return
    end

    study_record.update!(end_time: Time.current)
    study_time_in_minutes = ((study_record.end_time - study_record.start_time) / 60).to_i

    hours = study_time_in_minutes / 60
    minutes = study_time_in_minutes % 60

    formatted_time = hours > 0 ? "#{hours}時間#{minutes}分" : "#{minutes}分"

    notify_slack("<@#{slack_user_id}>さんが勉強を終了しました！所要時間 #{formatted_time}分。")
  rescue => e
    notify_slack("エラーが発生しました: #{e.message}")
  end

  private

  def notify_slack(message)
    Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"]).ping(message)
  end
end
